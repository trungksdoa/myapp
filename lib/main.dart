import 'package:flutter/material.dart';
import 'package:myapp/features/shop/logic/shop_logic.dart';
import 'package:myapp/service/auth_factory.dart';
import 'package:myapp/core/utils/app_performance.dart';
import 'package:myapp/route/app_router.dart';
import 'package:myapp/service/auth_service.dart';
import 'package:myapp/service/notification_service.dart';
import 'package:myapp/data/service_locator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:flutter_cart/flutter_cart.dart';
import 'package:flutter/foundation.dart';
import 'package:myapp/core/utils/image_cache.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize performance monitoring (only in debug mode)
  if (kDebugMode) {
    AppPerformance.initialize();
  }

  // Initialize Service Locator
  ServiceLocator().initialize();

  // Set image cache limits to avoid too many decoded images living in engine memory
  ImageCacheManager.initialize(maxItems: 50, maxBytes: 100 * 1024 * 1024);

  // Initialize AuthService
  await AuthService().initialize();

  // Request photo permission (skip on web)
  if (!kIsWeb) {
    var imageStorage = await Permission.photos.status;
    if (!imageStorage.isGranted) {
      await Permission.photos.request();
    }
  }

  // Initialize Notification Service
  await NotificationService().initNotification();

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
    return ChangeNotifierProvider.value(
      value: AuthFactory.instance,
      child: MaterialApp.router(
        title: 'CareNest',
        routerConfig: AppRouter.router,
        debugShowCheckedModeBanner: false,
      ),
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
