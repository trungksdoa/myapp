import 'package:flutter/material.dart';
import 'package:myapp/core/network/dio_service.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/core/utils/app_performance.dart';
import 'package:myapp/route/app_router.dart';
import 'package:myapp/service/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/core/utils/image_cache.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Web-specific CORS handling
  if (kIsWeb) {
    print('[WEB] Running in web mode - CORS restrictions may apply');
    print(
      '[WEB] If you encounter network errors, please use mobile app for full functionality',
    );
  }

  // Initialize performance monitoring (only in debug mode)
  if (kDebugMode) {
    AppPerformance.initialize();
  }

  // Set image cache limits to avoid too many decoded images living in engine memory
  ImageCacheManager.initialize(maxItems: 50, maxBytes: 100 * 1024 * 1024);

  // AuthService is now initialized through ServiceLocator

  // Request photo permission (skip on web)
  if (!kIsWeb) {
    var imageStorage = await Permission.photos.status;
    if (!imageStorage.isGranted) {
      await Permission.photos.request();
    }
  }

  // Initialize Notification Service
  await NotificationService().initNotification();

  //Initialize baseUrl
  // await DioClient.g.initialize('http://192.168.110.178');

  var cart = FlutterCart();
  await cart.initializeCart(isPersistenceSupportEnabled: true);
  // cart.clearCart();
  runApp(
    MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => CartService())],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'CareNest',
      routerConfig: AppRouter.router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// HomeScreen mặc định
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(child: Text('Home Screen'));
  }
}
