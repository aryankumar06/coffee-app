import 'package:flutter/material.dart';

import 'screens/qr_scanner_screen.dart';
import 'screens/digital_menu_screen.dart';
import 'screens/staff_dashboard_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Coffee App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFF24A0D)),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatelessWidget {
  const MainNavigationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Coffee App Screens'),
        backgroundColor: const Color(0xFFF24A0D),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildNavButton(
              context, 
              title: '1. QR Scanner', 
              icon: Icons.qr_code_scanner, 
              screen: const QrScannerScreen(),
            ),
            const SizedBox(height: 20),
            _buildNavButton(
              context, 
              title: '2. Digital Menu', 
              icon: Icons.restaurant_menu, 
              screen: const DigitalMenuScreen(),
            ),
            const SizedBox(height: 20),
            _buildNavButton(
              context, 
              title: '3. Staff Dashboard', 
              icon: Icons.dashboard, 
              screen: const StaffDashboardScreen(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavButton(BuildContext context, {required String title, required IconData icon, required Widget screen}) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        minimumSize: const Size(250, 60),
        backgroundColor: const Color(0xFFF24A0D),
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        elevation: 4,
      ),
      icon: Icon(icon, size: 28),
      label: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => screen),
        );
      },
    );
  }
}
