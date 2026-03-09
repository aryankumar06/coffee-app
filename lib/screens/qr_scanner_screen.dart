import 'package:flutter/material.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true); // Bounce up and down
    
    _animation = Tween<double>(begin: 0, end: 240).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFFF24A0D);
    const bgLight = Color(0xFFF8F6F5);

    return Scaffold(
      backgroundColor: Colors.black, // Simulating camera background
      body: Stack(
        children: [
          // Simulated Camera View (just a dark gradient for now)
          Container(
            decoration: const BoxDecoration(
              gradient: RadialGradient(
                colors: [Color(0xFF2C3E50), Colors.black],
                radius: 1.5,
              ),
            ),
          ),
          
          // QR Mask (Dark Overlay with a transparent hole)
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.6),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    backgroundBlendMode: BlendMode.dstOut,
                  ),
                ),
                Center(
                  child: Container(
                    width: 280,
                    height: 280,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Viewfinder Elements
          Center(
            child: SizedBox(
              width: 280,
              height: 280,
              child: Stack(
                children: [
                  // Corner brackets
                  _buildCorner(Alignment.topLeft, primaryColor),
                  _buildCorner(Alignment.topRight, primaryColor),
                  _buildCorner(Alignment.bottomLeft, primaryColor),
                  _buildCorner(Alignment.bottomRight, primaryColor),
                  
                  // Animated Scan Line
                  AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Positioned(
                        top: _animation.value,
                        left: 14,
                        right: 14,
                        child: Container(
                          height: 3,
                          decoration: BoxDecoration(
                            color: primaryColor,
                            boxShadow: [
                              BoxShadow(
                                color: primaryColor.withOpacity(0.8),
                                blurRadius: 15,
                                spreadRadius: 3,
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Top Header
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const Text(
                    'Scan Table QR',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Help clicked!')),
                      );
                    },
                    icon: const Icon(Icons.help_outline, color: Colors.white),
                  ),
                ],
              ),
            ),
          ),

          // Action Buttons
          Positioned(
            bottom: 200,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildCircularButton(Icons.image, Colors.white.withOpacity(0.2)),
                const SizedBox(width: 32),
                _buildCircularButton(Icons.qr_code_scanner, primaryColor, size: 80, iconSize: 40, onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Scanning...')),
                  );
                }),
                const SizedBox(width: 32),
                _buildCircularButton(Icons.flashlight_on, Colors.white.withOpacity(0.2)),
              ],
            ),
          ),

          // Bottom Sheet / Instructions
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 160,
              decoration: const BoxDecoration(
                color: bgLight,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Align QR Code',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Scan the QR code on your table to\nview the menu and start ordering.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 16),
                  
                  // Bottom Nav
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildNavItem(Icons.home_outlined, 'Home', false, primaryColor),
                      _buildNavItem(Icons.qr_code_2, 'Scan', true, primaryColor),
                      _buildNavItem(Icons.receipt_long_outlined, 'Orders', false, primaryColor),
                      _buildNavItem(Icons.person_outline, 'Profile', false, primaryColor),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(Alignment alignment, Color color) {
    double top = (alignment == Alignment.topLeft || alignment == Alignment.topRight) ? 0 : 240;
    double left = (alignment == Alignment.topLeft || alignment == Alignment.bottomLeft) ? 0 : 240;
    
    return Positioned(
      top: top,
      left: left,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(color: alignment.y < 0 ? color : Colors.transparent, width: 4),
            bottom: BorderSide(color: alignment.y > 0 ? color : Colors.transparent, width: 4),
            left: BorderSide(color: alignment.x < 0 ? color : Colors.transparent, width: 4),
            right: BorderSide(color: alignment.x > 0 ? color : Colors.transparent, width: 4),
          ),
          borderRadius: BorderRadius.only(
            topLeft: alignment == Alignment.topLeft ? const Radius.circular(16) : Radius.zero,
            topRight: alignment == Alignment.topRight ? const Radius.circular(16) : Radius.zero,
            bottomLeft: alignment == Alignment.bottomLeft ? const Radius.circular(16) : Radius.zero,
            bottomRight: alignment == Alignment.bottomRight ? const Radius.circular(16) : Radius.zero,
          ),
        ),
      ),
    );
  }

  Widget _buildCircularButton(IconData icon, Color bgColor, {double size = 48, double iconSize = 24, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap ?? () {},
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: bgColor,
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white.withOpacity(0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: iconSize),
      ),
    );
  }

  Widget _buildNavItem(IconData icon, String label, bool isActive, Color primaryColor) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (isActive)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: primaryColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Icon(icon, color: primaryColor),
                Text(label, style: TextStyle(color: primaryColor, fontSize: 12, fontWeight: FontWeight.bold)),
              ],
            ),
          )
        else
          Column(
            children: [
              Icon(icon, color: Colors.black38),
              Text(label, style: const TextStyle(color: Colors.black38, fontSize: 12)),
            ],
          ),
      ],
    );
  }
}
