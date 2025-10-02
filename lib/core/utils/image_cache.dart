// Image caching utility for CareNest app
import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Robust image cache manager with LRU eviction and disk caching backed by Dio.
/// Goals:
/// - Limit number of decoded images kept in memory to avoid Android ImageReader_JNI buffer overflow
/// - Evict least-recently-used images when limits are exceeded
/// - Provide a disk cache for network images (downloaded with Dio)
/// - Limit concurrent preloads to reduce pressure on image decoding
class ImageCacheManager {
  // Memory cache (LRU): LinkedHashMap keeps insertion order; we re-insert on access for LRU behavior
  static final LinkedHashMap<String, ImageProvider> _memoryCache =
      LinkedHashMap();
  static final Map<String, DateTime> _cacheTimestamps = {};

  // Tunable limits
  static int maxCachedItems = 50; // Maximum entries kept in memory
  static int maxDiskCacheFiles = 200; // Maximum files kept on disk
  static int maxDiskCacheBytes = 100 * 1024 * 1024; // 100 MB disk cache
  static const Duration diskCacheTTL = Duration(days: 30);

  // Preload concurrency
  static int _maxConcurrentPreloads = 3;
  static int _activePreloads = 0;

  // Dio client used for network downloads
  static final Dio _dio = Dio();

  // Disk cache folder name
  static const String _diskCacheFolder = 'image_cache';

  // Approximate estimate for memory usage (KB per item) for reporting only
  static const int _approxKbPerImage = 150;

  /// Core API retained: returns an [ImageProvider] for asset or network URL.
  /// If [maxWidth]/[maxHeight] are provided, a [ResizeImage] wrapper is returned to reduce memory footprint.
  static ImageProvider getCachedImage(
    String path, {
    int? maxWidth,
    int? maxHeight,
  }) {
    final key = _cacheKey(path, maxWidth: maxWidth, maxHeight: maxHeight);

    // Return from memory cache if present, and mark used
    if (_memoryCache.containsKey(key)) {
      final provider = _memoryCache.remove(
        key,
      )!; // remove to re-insert and mark most-recently-used
      _memoryCache[key] = provider;
      _cacheTimestamps[key] = DateTime.now();
      return provider;
    }

    ImageProvider provider;
    if (path.startsWith('http://') || path.startsWith('https://')) {
      // Network image -> file backed provider
      provider = FileImage(File(_getDiskPathForUrl(path)));
    } else {
      // Asset image; wrap with ResizeImage if requested
      final asset = AssetImage(path);
      provider = (maxWidth != null || maxHeight != null)
          ? ResizeImage(asset, width: maxWidth, height: maxHeight)
          : asset;
    }

    // Insert into memory cache and manage eviction
    _addToMemoryCache(key, provider);

    return provider;
  }

  /// Downloads a network image using Dio and returns a File-backed [ImageProvider].
  /// Uses disk cache and LRU eviction to limit disk usage.
  static Future<ImageProvider> getCachedNetworkImage(
    String url, {
    int? maxWidth,
    int? maxHeight,
  }) async {
    final cacheKey = _cacheKey(url, maxWidth: maxWidth, maxHeight: maxHeight);

    // If in memory cache already, return it
    if (_memoryCache.containsKey(cacheKey)) {
      final provider = _memoryCache.remove(cacheKey)!;
      _memoryCache[cacheKey] = provider;
      _cacheTimestamps[cacheKey] = DateTime.now();
      return provider;
    }

    // Resolve disk filename
    final filePath = await _ensureDiskCacheFile(url);
    ImageProvider provider = FileImage(File(filePath));
    if (maxWidth != null || maxHeight != null) {
      provider = ResizeImage(provider, width: maxWidth, height: maxHeight);
    }

    _addToMemoryCache(cacheKey, provider);
    return provider;
  }

  /// Preload images but limit concurrent decoding operations to avoid ImageReader_JNI overflow
  /// Provides small safety throttle and optional resize parameters to minimize memory use.
  static Future<void> preloadImages(
    BuildContext context,
    List<String> paths, {
    int? maxWidth,
    int? maxHeight,
    int maxPreload = 10,
  }) async {
    final toPreload = paths.take(maxPreload).toList();

    await Future.forEach<String>(toPreload, (path) async {
      // Throttle concurrent preloads
      while (_activePreloads >= _maxConcurrentPreloads) {
        await Future.delayed(const Duration(milliseconds: 50));
      }

      _activePreloads++;
      try {
        ImageProvider provider;
        if (path.startsWith('http://') || path.startsWith('https://')) {
          provider = await getCachedNetworkImage(
            path,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
          );
        } else {
          final img = getCachedImage(
            path,
            maxWidth: maxWidth,
            maxHeight: maxHeight,
          );
          provider = img;
        }

        // Only precache if we have a valid context
        if (context.mounted) {
          await precacheImage(provider, context);
        }
      } catch (_) {
        // Ignore preload errors - failure to preload shouldn't crash the app
      } finally {
        _activePreloads--;
      }
    });
  }

  /// Ensures that a network image is downloaded to disk cache and returns the absolute file path.
  static Future<String> _ensureDiskCacheFile(String url) async {
    final dir = await _getDiskCacheDirectory();
    final fname = _hashedFileName(url);
    final file = File(p.join(dir.path, fname));

    if (await file.exists()) {
      return file.path;
    }

    // Download with Dio into a temp file and move
    final tmpFile = File(p.join(dir.path, '$fname.tmp'));

    try {
      final response = await _dio.get<List<int>>(
        url,
        options: Options(responseType: ResponseType.bytes),
      );
      if (response.statusCode == 200 && response.data != null) {
        await tmpFile.writeAsBytes(response.data!, flush: true);
        await tmpFile.rename(file.path);

        // Maintain disk cache limits
        await _evictDiskCacheIfNeeded(dir);
        return file.path;
      }
    } catch (e) {
      // Network error - rethrow as IO exception to let caller fallback if needed
      if (await tmpFile.exists()) await tmpFile.delete();
      rethrow;
    }

    throw Exception('Failed to download $url');
  }

  /// Compute path where disk cache lives
  static Future<Directory> _getDiskCacheDirectory() async {
    final base = await getApplicationSupportDirectory();
    final dir = Directory(p.join(base.path, _diskCacheFolder));
    if (!(await dir.exists())) {
      await dir.create(recursive: true);
    }
    return dir;
  }

  /// Evict old files until we're under limits (max files and max size)
  static Future<void> _evictDiskCacheIfNeeded(Directory dir) async {
    try {
      final files = await dir
          .list()
          .where((e) => e is File && !e.path.endsWith('.tmp'))
          .cast<File>()
          .toList();
      if (files.isEmpty) return;

      files.sort(
        (a, b) => a.statSync().modified.compareTo(b.statSync().modified),
      ); // oldest first

      // Compute total size
      int totalBytes = 0;
      for (final f in files) {
        totalBytes += f.lengthSync();
      }

      // Remove oldest until under limits
      while (files.length > maxDiskCacheFiles ||
          totalBytes > maxDiskCacheBytes) {
        final f = files.removeAt(0);
        try {
          final removedBytes = f.lengthSync();
          await f.delete();
          totalBytes -= removedBytes;
        } catch (_) {}
      }

      // Optionally remove very old files past TTL
      final ttlCutoff = DateTime.now().subtract(diskCacheTTL);
      for (final f in files.toList()) {
        try {
          if (f.statSync().modified.isBefore(ttlCutoff)) {
            final removedBytes = f.lengthSync();
            await f.delete();
            totalBytes -= removedBytes;
            files.remove(f);
          }
        } catch (_) {}
      }
    } catch (e) {
      // Silently ignore eviction errors - don't crash app
    }
  }

  /// Adds provider into memory cache and evicts least-recently-used entries if necessary.
  static void _addToMemoryCache(String key, ImageProvider provider) {
    // Avoid duplicates - remove older entry to re-insert and mark MRU
    if (_memoryCache.containsKey(key)) {
      _memoryCache.remove(key);
    }

    _memoryCache[key] = provider;
    _cacheTimestamps[key] = DateTime.now();

    // Evict if we exceeded the memory cache size
    while (_memoryCache.length > maxCachedItems) {
      final oldestKey = _memoryCache.keys.first;
      final oldestProvider = _memoryCache.remove(oldestKey)!;
      _cacheTimestamps.remove(oldestKey);

      // Evict from Flutter engine cache as well
      try {
        PaintingBinding.instance.imageCache.evict(oldestProvider);
      } catch (_) {}
    }
  }

  /// Programmatically evict a specific image from both memory and Flutter engine caches
  static Future<void> evictImage(
    String path, {
    int? maxWidth,
    int? maxHeight,
  }) async {
    final key = _cacheKey(path, maxWidth: maxWidth, maxHeight: maxHeight);
    final provider = _memoryCache.remove(key);
    _cacheTimestamps.remove(key);
    if (provider != null) {
      try {
        await PaintingBinding.instance.imageCache.evict(provider);
      } catch (_) {}
    }

    // Also remove disk cache file (safe best-effort)
    if (path.startsWith('http://') || path.startsWith('https://')) {
      final fname = _hashedFileName(path);
      try {
        final dir = await _getDiskCacheDirectory();
        final file = File(p.join(dir.path, fname));
        if (await file.exists()) await file.delete();
      } catch (_) {}
    }
  }

  /// Clear in-memory and on-disk caches
  static Future<void> clearCache({bool clearDisk = false}) async {
    // Evict engine cache
    try {
      PaintingBinding.instance.imageCache.clear();
    } catch (_) {}

    _memoryCache.clear();
    _cacheTimestamps.clear();

    if (clearDisk) {
      try {
        final dir = await _getDiskCacheDirectory();
        if (await dir.exists()) {
          await dir.delete(recursive: true);
        }
      } catch (_) {}
    }
  }

  /// Helper to compute consistent cache keys
  static String _cacheKey(String path, {int? maxWidth, int? maxHeight}) {
    if (maxWidth == null && maxHeight == null) return path;
    return '$path|w=${maxWidth ?? 0}|h=${maxHeight ?? 0}';
  }

  static String _hashedFileName(String url) {
    final bytes = utf8.encode(url);
    final digest = md5.convert(bytes);
    final ext = p.extension(url).split('?').first;
    final safeExt = ext.isEmpty ? '.img' : ext;
    return '${digest.toString()}$safeExt';
  }

  static String _getDiskPathForUrl(String url) {
    // Synchronous path build; actual file may not exist until downloaded
    final tempDir = Directory.systemTemp.path; // fallback
    // Try to compute a stable cache dir synchronously (best-effort)
    try {
      // We avoid awaiting here; callers that need the real file should call _ensureDiskCacheFile
      final dir = p.join(Directory.systemTemp.path, _diskCacheFolder);
      final fname = _hashedFileName(url);
      return p.join(dir, fname);
    } catch (_) {
      final fname = _hashedFileName(url);
      return p.join(tempDir, fname);
    }
  }

  /// Provide cache stats for debugging
  static Map<String, dynamic> getCacheStats() {
    return {
      'memoryCachedItems': _memoryCache.length,
      'estimatedMemoryKB': _memoryCache.length * _approxKbPerImage,
      'diskCacheMaxFiles': maxDiskCacheFiles,
      'diskCacheMaxBytes': maxDiskCacheBytes,
      'diskCacheFolder': _diskCacheFolder,
      'activePreloads': _activePreloads,
    };
  }

  /// Initialize runtime limits on Flutter engine image cache. Call once early in app startup.
  static void initialize({int? maxItems, int? maxBytes}) {
    if (maxItems != null) maxCachedItems = maxItems;
    if (maxBytes != null) maxDiskCacheBytes = maxBytes;

    try {
      // Set engine-side limits to avoid too many decoded bitmaps kept by Flutter
      PaintingBinding.instance.imageCache.maximumSize = maxCachedItems;
      PaintingBinding.instance.imageCache.maximumSizeBytes =
          maxCachedItems * _approxKbPerImage * 1024;
    } catch (_) {
      // Ignore if binding not initialized yet
    }
  }
}

/// Optimized cached image widget that uses ImageCacheManager for both assets and network URLs.
class CachedImage extends StatelessWidget {
  final String assetPath;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget? errorWidget;

  const CachedImage({
    super.key,
    required this.assetPath,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.placeholder,
    this.errorWidget,
  });

  @override
  Widget build(BuildContext context) {
    // Synchronously get provider if file exists in disk cache; otherwise we will attempt to download asynchronously
    if (assetPath.startsWith('http://') || assetPath.startsWith('https://')) {
      return FutureBuilder<ImageProvider>(
        future: ImageCacheManager.getCachedNetworkImage(
          assetPath,
          maxWidth: width?.toInt(),
          maxHeight: height?.toInt(),
        ),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done &&
              snapshot.hasData) {
            return Image(
              image: snapshot.data!,
              width: width,
              height: height,
              fit: fit,
            );
          }

          if (snapshot.hasError) {
            return errorWidget ?? _defaultErrorWidget();
          }

          return placeholder ?? _defaultPlaceholder();
        },
      );
    }

    // Asset path - return provider synchronously
    final provider = ImageCacheManager.getCachedImage(
      assetPath,
      maxWidth: width?.toInt(),
      maxHeight: height?.toInt(),
    );
    return Image(
      image: provider,
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSync) {
        if (wasSync) return child;
        return frame != null ? child : (placeholder ?? _defaultPlaceholder());
      },
      errorBuilder: (context, error, stackTrace) =>
          errorWidget ?? _defaultErrorWidget(),
    );
  }

  Widget _defaultPlaceholder() {
    return Container(
      color: const Color(0xFFEEEEEE),
      child: const Center(
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }

  Widget _defaultErrorWidget() {
    return Container(
      color: const Color(0xFFEEEEEE),
      child: const Center(
        child: Icon(Icons.broken_image, size: 20, color: Colors.grey),
      ),
    );
  }
}
