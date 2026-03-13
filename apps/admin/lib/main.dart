import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'screens/date_mapper_screen.dart';
import 'screens/menu_builder_screen.dart';
import 'screens/qr_generator_screen.dart';
import 'screens/order_dashboard_screen.dart';

// Color Palette
const Color textPrimary = Color(0xFF30364F); // Dark Blue/Navy
const Color primaryAccent = Color(0xFFACBAC4); // Light Blue/Greyish
const Color secondaryAccent = Color(0xFFE1D9BC); // Beige/Sand
const Color backgroundLight = Color(0xFFF0F0DB); // Light Beige/Off-white

void main() {
  runApp(const AdminApp());
}

final _router = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const AdminMainShell(),
    ),
  ],
);

class AdminApp extends StatelessWidget {
  const AdminApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'KlubEats Admin',
      routerConfig: _router,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: textPrimary),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
    );
  }
}

class AdminMainShell extends StatefulWidget {
  const AdminMainShell({super.key});

  @override
  State<AdminMainShell> createState() => _AdminMainShellState();
}

class _AdminMainShellState extends State<AdminMainShell> {
  int _currentIndex = 0;

  final List<Widget> _screens = const [
    OrderDashboardScreen(),
    DateMapperScreen(),
    MenuBuilderScreen(),
    QrGeneratorScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        selectedItemColor: textPrimary,
        unselectedItemColor: primaryAccent,
        backgroundColor: backgroundLight,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.calendar_month), label: 'Scheduler'),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant_menu), label: 'Menu'),
          BottomNavigationBarItem(icon: Icon(Icons.qr_code), label: 'QR'),
        ],
      ),
    );
  }
}
