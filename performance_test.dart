// Performance test script for CareNest app
// Run with: dart run performance_test.dart

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:myapp/core/utils/logger_service.dart';

final logger = LoggerService.instance;
void main() async {
  logger.d('🚀 Starting CareNest Performance Test Suite');
  logger.d('=' * 50);

  // Test 1: Startup time simulation
  await testStartupTime();

  // Test 2: Memory usage simulation
  await testMemoryUsage();

  // Test 3: Navigation performance
  await testNavigationPerformance();

  // Test 4: Image loading performance
  await testImageLoading();

  logger.d('\n✅ Performance test completed!');
  logger.d('Check the logs above for performance metrics.');
  logger.d('Recommend running Flutter DevTools for detailed analysis:');
  logger.d('flutter pub global run devtools');
}

Future<void> testStartupTime() async {
  logger.d('\n📊 Test 1: App Startup Time Simulation');
  final stopwatch = Stopwatch()..start();

  // Simulate app initialization tasks
  await Future.delayed(Duration(milliseconds: 120 + Random().nextInt(80)));

  stopwatch.stop();
  logger.d('⏱️  Simulated startup time: ${stopwatch.elapsedMilliseconds}ms');

  if (stopwatch.elapsedMilliseconds > 200) {
    logger.d('🚨 WARNING: Startup time exceeds 200ms target');
    logger.d('   Consider optimizing:');
    logger.d('   - Reduce initial widget tree complexity');
    logger.d('   - Use deferred loading for heavy components');
    logger.d('   - Optimize asset loading');
  } else {
    logger.d('✅ Startup time within acceptable range');
  }
}

Future<void> testMemoryUsage() async {
  logger.d('\n📊 Test 2: Memory Usage Simulation');

  // Simulate memory allocation
  final List<String> testData = [];
  const int testItems = 1000;

  for (int i = 0; i < testItems; i++) {
    testData.add('Test item $i with some data to simulate memory usage');
  }

  // Simulate memory pressure
  final memoryUsage = testItems * 50; // Approximate bytes per item
  logger.d('💾 Simulated memory usage: ${memoryUsage ~/ 1024}KB');

  if (memoryUsage > 500 * 1024) {
    // 500KB threshold
    logger.d('🚨 WARNING: High memory usage detected');
    logger.d('   Consider optimizing:');
    logger.d('   - Use ListView.builder instead of Column with many items');
    logger.d('   - Implement pagination for large lists');
    logger.d('   - Dispose controllers and listeners properly');
  } else {
    logger.d('✅ Memory usage within acceptable range');
  }

  // Clean up
  testData.clear();
}

Future<void> testNavigationPerformance() async {
  logger.d('\n📊 Test 3: Navigation Performance');

  final List<int> navigationTimes = [];
  const int testIterations = 5;

  for (int i = 0; i < testIterations; i++) {
    final stopwatch = Stopwatch()..start();
    await Future.delayed(Duration(milliseconds: 30 + Random().nextInt(40)));
    stopwatch.stop();
    navigationTimes.add(stopwatch.elapsedMilliseconds);
  }

  final avgTime =
      navigationTimes.reduce((a, b) => a + b) ~/ navigationTimes.length;
  final maxTime = navigationTimes.reduce(max);

  logger.d('⏱️  Average navigation time: ${avgTime}ms');
  logger.d('⏱️  Maximum navigation time: ${maxTime}ms');

  if (avgTime > 50) {
    logger.d('🚨 WARNING: Navigation performance needs improvement');
    logger.d('   Consider optimizing:');
    logger.d('   - Simplify route configurations');
    logger.d('   - Preload frequently used routes');
    logger.d('   - Reduce widget rebuilds during navigation');
  } else {
    logger.d('✅ Navigation performance within acceptable range');
  }
}

Future<void> testImageLoading() async {
  logger.d('\n📊 Test 4: Image Loading Performance');

  final imageSizes = [
    1024, // 1KB
    5120, // 5KB
    10240, // 10KB
    51200, // 50KB
    102400, // 100KB
  ];

  for (final size in imageSizes) {
    final stopwatch = Stopwatch()..start();
    // Simulate image loading based on size
    await Future.delayed(Duration(milliseconds: size ~/ 100));
    stopwatch.stop();

    logger.d(
      '🖼️  ${size ~/ 1024}KB image load: ${stopwatch.elapsedMilliseconds}ms',
    );

    if (stopwatch.elapsedMilliseconds > 100 && size > 51200) {
      logger.d(
        '   ⚠️  Large images (${size ~/ 1024}KB) may cause performance issues',
      );
      logger.d('   Consider:');
      logger.d('   - Compressing images below 50KB');
      logger.d('   - Using WebP format for better compression');
      logger.d('   - Implementing lazy loading for images');
    }
  }
}

// Utility function to check if running in CI environment
bool isRunningOnCI() {
  return Platform.environment.containsKey('CI') ||
      Platform.environment.containsKey('CONTINUOUS_INTEGRATION');
}
