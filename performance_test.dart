// Performance test script for CareNest app
// Run with: dart run performance_test.dart

import 'dart:async';
import 'dart:io';
import 'dart:math';

void main() async {
  print('🚀 Starting CareNest Performance Test Suite');
  print('=' * 50);

  // Test 1: Startup time simulation
  await testStartupTime();

  // Test 2: Memory usage simulation
  await testMemoryUsage();

  // Test 3: Navigation performance
  await testNavigationPerformance();

  // Test 4: Image loading performance
  await testImageLoading();

  print('\n✅ Performance test completed!');
  print('Check the logs above for performance metrics.');
  print('Recommend running Flutter DevTools for detailed analysis:');
  print('flutter pub global run devtools');
}

Future<void> testStartupTime() async {
  print('\n📊 Test 1: App Startup Time Simulation');
  final stopwatch = Stopwatch()..start();

  // Simulate app initialization tasks
  await Future.delayed(Duration(milliseconds: 120 + Random().nextInt(80)));

  stopwatch.stop();
  print('⏱️  Simulated startup time: ${stopwatch.elapsedMilliseconds}ms');

  if (stopwatch.elapsedMilliseconds > 200) {
    print('🚨 WARNING: Startup time exceeds 200ms target');
    print('   Consider optimizing:');
    print('   - Reduce initial widget tree complexity');
    print('   - Use deferred loading for heavy components');
    print('   - Optimize asset loading');
  } else {
    print('✅ Startup time within acceptable range');
  }
}

Future<void> testMemoryUsage() async {
  print('\n📊 Test 2: Memory Usage Simulation');

  // Simulate memory allocation
  final List<String> testData = [];
  const int testItems = 1000;

  for (int i = 0; i < testItems; i++) {
    testData.add('Test item $i with some data to simulate memory usage');
  }

  // Simulate memory pressure
  final memoryUsage = testItems * 50; // Approximate bytes per item
  print('💾 Simulated memory usage: ${memoryUsage ~/ 1024}KB');

  if (memoryUsage > 500 * 1024) {
    // 500KB threshold
    print('🚨 WARNING: High memory usage detected');
    print('   Consider optimizing:');
    print('   - Use ListView.builder instead of Column with many items');
    print('   - Implement pagination for large lists');
    print('   - Dispose controllers and listeners properly');
  } else {
    print('✅ Memory usage within acceptable range');
  }

  // Clean up
  testData.clear();
}

Future<void> testNavigationPerformance() async {
  print('\n📊 Test 3: Navigation Performance');

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

  print('⏱️  Average navigation time: ${avgTime}ms');
  print('⏱️  Maximum navigation time: ${maxTime}ms');

  if (avgTime > 50) {
    print('🚨 WARNING: Navigation performance needs improvement');
    print('   Consider optimizing:');
    print('   - Simplify route configurations');
    print('   - Preload frequently used routes');
    print('   - Reduce widget rebuilds during navigation');
  } else {
    print('✅ Navigation performance within acceptable range');
  }
}

Future<void> testImageLoading() async {
  print('\n📊 Test 4: Image Loading Performance');

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

    print(
      '🖼️  ${size ~/ 1024}KB image load: ${stopwatch.elapsedMilliseconds}ms',
    );

    if (stopwatch.elapsedMilliseconds > 100 && size > 51200) {
      print(
        '   ⚠️  Large images (${size ~/ 1024}KB) may cause performance issues',
      );
      print('   Consider:');
      print('   - Compressing images below 50KB');
      print('   - Using WebP format for better compression');
      print('   - Implementing lazy loading for images');
    }
  }
}

// Utility function to check if running in CI environment
bool isRunningOnCI() {
  return Platform.environment.containsKey('CI') ||
      Platform.environment.containsKey('CONTINUOUS_INTEGRATION');
}
