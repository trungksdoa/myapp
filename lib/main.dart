import 'package:flutter/material.dart';
import 'package:myapp/route/app_router.dart';

void main() {
  runApp(const MyApp());
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
