import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'screens/customer_menu_screen.dart';
import 'screens/cart_screen.dart';

// Color Palette
const Color textPrimary = Color(0xFF30364F); // Dark Blue/Navy
const Color primaryAccent = Color(0xFFACBAC4); // Light Blue/Greyish
const Color secondaryAccent = Color(0xFFE1D9BC); // Beige/Sand
const Color backgroundLight = Color(0xFFF0F0DB); // Light Beige/Off-white

void main() {
  runApp(
    const ProviderScope(
      child: CustomerApp(),
    ),
  );
}

final _router = GoRouter(
  initialLocation: '/order',
  routes: [
    GoRoute(
      path: '/order',
      builder: (context, state) {
        // Mock extracting deep link params: ?cafe=123&table=5
        // (In reality, GoRouter extracts these from state.uri.queryParameters)
        final String cafeId = state.uri.queryParameters['cafe'] ?? 'demo_cafe_123';
        final int tableNum = int.tryParse(state.uri.queryParameters['table'] ?? '1') ?? 1;

        return CustomerMenuScreen(cafeId: cafeId, tableNumber: tableNum);
      },
    ),
    GoRoute(
      path: '/cart',
      builder: (context, state) => const CartScreen(),
    ),
  ],
);

class CustomerApp extends StatelessWidget {
  const CustomerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KlubEats Customer',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: textPrimary),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}
