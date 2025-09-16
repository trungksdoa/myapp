import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class ImageCacheWidget extends StatefulWidget {
  const ImageCacheWidget({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    required this.fit,
    this.placeholder,
    this.errorWidget,
    this.onRetry,
    this.maxRetries = 3,
    this.retryDelay = const Duration(seconds: 1),
  });

  final String imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final Widget? placeholder;
  final Widget Function(BuildContext context, Object error)? errorWidget;
  final VoidCallback? onRetry;
  final int maxRetries;
  final Duration retryDelay;

  @override
  State<ImageCacheWidget> createState() => _ImageCacheWidgetState();
}

class _ImageCacheWidgetState extends State<ImageCacheWidget> {
  int _retryCount = 0;
  bool _isRetrying = false;

  void _handleRetry() {
    if (_retryCount < widget.maxRetries && !_isRetrying) {
      setState(() {
        _isRetrying = true;
        _retryCount++;
      });

      Future.delayed(widget.retryDelay, () {
        if (mounted) {
          setState(() {
            _isRetrying = false;
          });
        }
      });

      widget.onRetry?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: widget.imageUrl,
      width: widget.width,
      height: widget.height,
      fit: widget.fit,
      placeholder: (context, url) {
        if (_isRetrying) {
          return const Center(child: CircularProgressIndicator());
        }
        return widget.placeholder ??
            const Center(child: CircularProgressIndicator());
      },
      errorWidget: (context, url, error) {
        if (widget.errorWidget != null) {
          return widget.errorWidget!(context, error);
        } else {
          return Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error, color: Colors.red, size: 24),
                const SizedBox(height: 8),
                Text(
                  'Failed to load image',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  textAlign: TextAlign.center,
                ),
                if (_retryCount < widget.maxRetries) ...[
                  const SizedBox(height: 8),
                  TextButton(
                    onPressed: _isRetrying ? null : _handleRetry,
                    child: Text(
                      _isRetrying
                          ? 'Retrying...'
                          : 'Retry ($_retryCount/${widget.maxRetries})',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ],
              ],
            ),
          );
        }
      },
    );
  }
}
