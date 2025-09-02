// App performance integration for CareNest
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'performance_monitor.dart';

class AppPerformance {
  static void initialize() {
    if (kReleaseMode) return;

    // Ensure binding is initialized before accessing WidgetsBinding
    WidgetsFlutterBinding.ensureInitialized();

    // Track app lifecycle events
    WidgetsBinding.instance.addObserver(_AppLifecycleObserver());

    // Log initial performance metrics
    PerformanceMonitor.logMemoryUsage();
    debugPrint('🚀 APP PERFORMANCE: Monitoring initialized');
  }

  /// Wrap your app with performance monitoring
  static Widget wrapWithMonitoring(Widget app) {
    if (kReleaseMode) return app;

    return PerformanceWidget(name: 'AppRoot', child: app);
  }

  /// Track navigation performance
  static void trackNavigation(String routeName) {
    PerformanceMonitor.start('Navigation to $routeName');

    // Auto-stop after a reasonable time (navigation should be fast)
    Future.delayed(const Duration(milliseconds: 500), () {
      PerformanceMonitor.stop(
        'Navigation to $routeName',
        details: 'Navigation completed or timed out',
      );
    });
  }

  /// Track API call performance - returns a callback to stop tracking
  static VoidCallback trackApiCall(
    String endpoint, {
    Map<String, dynamic>? params,
  }) {
    final callId = 'API: $endpoint';
    PerformanceMonitor.start(callId);

    return () {
      PerformanceMonitor.stop(
        callId,
        details: params != null ? 'Params: $params' : null,
      );
    };
  }
}

class _AppLifecycleObserver with WidgetsBindingObserver {
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    PerformanceMonitor.start('AppLifecycle: $state');

    Future.delayed(const Duration(milliseconds: 100), () {
      PerformanceMonitor.stop('AppLifecycle: $state');
    });

    if (state == AppLifecycleState.resumed) {
      PerformanceMonitor.logMemoryUsage();
    }
  }
}

/// Performance-aware navigation extension
extension PerformanceNavigation on BuildContext {
  void goWithPerformance(String path, {Object? extra}) {
    AppPerformance.trackNavigation(path);
    GoRouter.of(this).go(path, extra: extra);
  }

  void pushWithPerformance(String path, {Object? extra}) {
    AppPerformance.trackNavigation(path);
    GoRouter.of(this).push(path, extra: extra);
  }
}
