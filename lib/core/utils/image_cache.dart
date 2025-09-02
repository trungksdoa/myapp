// Image caching utility for CareNest app
import 'package:flutter/material.dart';

class ImageCacheManager {
  static final Map<String, ImageProvider> _memoryCache = {};
  static final Map<String, DateTime> _cacheTimestamps = {};
  static const Duration _cacheDuration = Duration(minutes: 10);

  /// Get cached image or load new one
  static ImageProvider getCachedImage(String assetPath) {
    // Check if image is in memory cache and not expired
    if (_memoryCache.containsKey(assetPath)) {
      final timestamp = _cacheTimestamps[assetPath];
      if (timestamp != null &&
          DateTime.now().difference(timestamp) < _cacheDuration) {
        return _memoryCache[assetPath]!;
      } else {
        // Remove expired cache
        _memoryCache.remove(assetPath);
        _cacheTimestamps.remove(assetPath);
      }
    }

    // Load new image and cache it
    final image = AssetImage(assetPath);
    _memoryCache[assetPath] = image;
    _cacheTimestamps[assetPath] = DateTime.now();

    return image;
  }

  /// Preload images to cache - requires BuildContext
  static Future<void> preloadImages(
    BuildContext context,
    List<String> assetPaths,
  ) {
    return Future.wait(
      assetPaths.map((path) {
        final image = getCachedImage(path);
        if (image is AssetImage) {
          return precacheImage(image, context);
        }
        return Future.value();
      }),
    );
  }

  /// Clear cache
  static void clearCache() {
    _memoryCache.clear();
    _cacheTimestamps.clear();
  }

  /// Get cache statistics
  static Map<String, dynamic> getCacheStats() {
    return {
      'cachedItems': _memoryCache.length,
      'memoryUsage': _memoryCache.length * 100, // Approximate KB per image
      'oldestItem': _cacheTimestamps.values.isNotEmpty
          ? _cacheTimestamps.values.reduce((a, b) => a.isBefore(b) ? a : b)
          : null,
    };
  }
}

/// Optimized cached image widget
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
    return Image(
      image: ImageCacheManager.getCachedImage(assetPath),
      width: width,
      height: height,
      fit: fit,
      frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
        if (wasSynchronouslyLoaded) {
          return child;
        }
        return frame != null ? child : placeholder ?? _defaultPlaceholder();
      },
      errorBuilder: (context, error, stackTrace) {
        return errorWidget ?? _defaultErrorWidget();
      },
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
