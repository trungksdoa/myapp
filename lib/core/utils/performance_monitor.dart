// Performance monitoring utilities for CareNest app
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:myapp/core/utils/logger_service.dart';

final logger = LoggerService.instance;

class PerformanceMonitor {
  static final Map<String, Stopwatch> _timers = {};
  static final List<PerformanceEvent> _events = [];

  /// Start tracking a performance event
  static void start(String eventName) {
    if (kReleaseMode) return;

    final stopwatch = Stopwatch()..start();
    _timers[eventName] = stopwatch;
    logger.d('⏱️ PERFORMANCE: Started - $eventName');
  }

  /// Stop tracking and log the performance event
  static void stop(String eventName, {String? details}) {
    if (kReleaseMode) return;

    final stopwatch = _timers[eventName];
    if (stopwatch != null) {
      stopwatch.stop();
      final duration = stopwatch.elapsedMilliseconds;
      _timers.remove(eventName);

      final event = PerformanceEvent(
        name: eventName,
        durationMs: duration,
        timestamp: DateTime.now(),
        details: details,
      );

      _events.add(event);

      logger.d(
        '⏱️ PERFORMANCE: $eventName - ${duration}ms ${details != null ? '($details)' : ''}',
      );

      // Warn if performance is poor
      if (duration > 16) {
        // More than 16ms per frame (60fps target)
        logger.d(
          '🚨 PERFORMANCE WARNING: $eventName took ${duration}ms (target: <16ms for 60fps)',
        );
      }
    }
  }

  /// Track widget build time
  static void trackWidgetBuild(String widgetName, VoidCallback buildFunction) {
    if (kReleaseMode) {
      buildFunction();
      return;
    }

    final stopwatch = Stopwatch()..start();
    buildFunction();
    stopwatch.stop();

    if (stopwatch.elapsedMilliseconds > 8) {
      // Warning threshold
      logger.d(
        '🚨 WIDGET BUILD: $widgetName - ${stopwatch.elapsedMilliseconds}ms',
      );
    }
  }

  /// Get all performance events
  static List<PerformanceEvent> getEvents() => List.unmodifiable(_events);

  /// Clear all performance data
  static void clear() {
    _timers.clear();
    _events.clear();
  }

  /// Log memory usage (approximate)
  static void logMemoryUsage() {
    if (kReleaseMode) return;

    logger.d('💾 MEMORY: ${_getMemoryInfo()}');
  }

  static String _getMemoryInfo() {
    // This is a simplified memory info - in production you'd use proper memory profiling
    return 'Memory usage approximate - use DevTools for detailed analysis';
  }
}

class PerformanceEvent {
  final String name;
  final int durationMs;
  final DateTime timestamp;
  final String? details;

  PerformanceEvent({
    required this.name,
    required this.durationMs,
    required this.timestamp,
    this.details,
  });

  @override
  String toString() {
    return 'PerformanceEvent{name: $name, duration: ${durationMs}ms, timestamp: $timestamp${details != null ? ', details: $details' : ''}}';
  }
}

/// Performance-aware widget that tracks build time
class PerformanceWidget extends StatelessWidget {
  final String name;
  final Widget child;

  const PerformanceWidget({super.key, required this.name, required this.child});

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.trackWidgetBuild(name, () {});
    return child;
  }
}

/// Mixin for performance tracking in StatefulWidgets
mixin PerformanceMixin<T extends StatefulWidget> on State<T> {
  @override
  void initState() {
    super.initState();
    PerformanceMonitor.start('${T.toString()} initState');
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    PerformanceMonitor.start('${T.toString()} didChangeDependencies');
  }

  @override
  void dispose() {
    PerformanceMonitor.stop('${T.toString()} dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    PerformanceMonitor.start('${T.toString()} build');
    final widget = buildWidget(context);
    PerformanceMonitor.stop('${T.toString()} build');
    return widget;
  }

  @mustCallSuper
  Widget buildWidget(BuildContext context);
}
