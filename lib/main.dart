import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/product_detail_screen.dart';
import 'screens/home_screen.dart';


final _router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      path: '/product/:id',
      builder: (context, state) => ProductDetailScreen(
        productId: state.pathParameters['id']!,
      ),
    ),
  ],
);
void main() {
  runApp(const MiniMarketApp());
}

class MiniMarketApp extends StatelessWidget {
  const MiniMarketApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Mini Market',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
          centerTitle: true,
          elevation: 0,
        ),
        // Every text field in the app gets the same rounded outline.
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 14,
            vertical: 12,
          ),
        ),
      ),
      routerConfig: _router,
    );
  }
}
