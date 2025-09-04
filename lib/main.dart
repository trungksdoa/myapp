import 'package:flutter/material.dart';
import 'package:myapp/auth_factory.dart';
import 'package:myapp/core/utils/app_performance.dart';
import 'package:myapp/route/app_router.dart';
import 'package:myapp/service/auth_service.dart';
import 'package:myapp/service/notification_service.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

void main() async {
  // Ensure Flutter binding is initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize performance monitoring
  AppPerformance.initialize();

  // Initialize AuthService
  await AuthService().initialize();

  var imageStorage = await Permission.photos.status;

  if (!imageStorage.isGranted) {
    await Permission.photos.request();
  }

  // Initialize Notification Service
  await NotificationService().initNotification();

  runApp(const MyApp());
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
