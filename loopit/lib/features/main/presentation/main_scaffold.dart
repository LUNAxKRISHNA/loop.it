import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:loopit_ui/loopit_ui.dart';
import '../../home/presentation/home_screen.dart';
import '../../notifications/presentation/notifications_screen.dart';
import '../../profile/presentation/profile_screen.dart';

class MainScaffold extends StatefulWidget {
  const MainScaffold({super.key});

  @override
  State<MainScaffold> createState() => _MainScaffoldState();
}

class _MainScaffoldState extends State<MainScaffold> {
  int _currentIndex = 0;
  late final PageController _pageController;

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(
        child: Text('Dispatches Screen', style: TextStyle(fontFamily: 'Inter'))),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onNavTabTapped(int index) {
    setState(() => _currentIndex = index);
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  void _showQrCodePopup(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return Container(
          decoration: const BoxDecoration(
            color: LoopitColors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Drag Handle
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: LoopitColors.grey300,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              // Title & Subtitle
              const Text(
                "QR Verification",
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: LoopitColors.black,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                "Scan dispatch packages or show your pass QR code for verification.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: "Inter",
                  fontSize: 13,
                  color: LoopitColors.grey500,
                ),
              ),

              const SizedBox(height: 24),

              // Option 1: Scan Barcode/QR
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tileColor: LoopitColors.grey50,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: LoopitColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.qr_code_scanner_rounded,
                    color: LoopitColors.white,
                    size: 20,
                  ),
                ),
                title: const Text(
                  "Scan QR Code",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: LoopitColors.black,
                  ),
                ),
                subtitle: const Text(
                  "Scan dispatch package or delivery slip",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 12,
                    color: LoopitColors.grey500,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: LoopitColors.grey500,
                ),
                onTap: () {
                  Navigator.pop(context); // Close the bottom sheet first
                  
                  // Navigate to the camera scanner interface
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const QrScannerScreen(),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              // Option 2: Show Digital Pass
              ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                tileColor: LoopitColors.grey50,
                leading: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: LoopitColors.black,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.qr_code_rounded,
                    color: LoopitColors.white,
                    size: 20,
                  ),
                ),
                title: const Text(
                  "Show Authorization QR",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                    color: LoopitColors.black,
                  ),
                ),
                subtitle: const Text(
                  "Display digital driver authorization pass",
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 12,
                    color: LoopitColors.grey500,
                  ),
                ),
                trailing: const Icon(
                  Icons.chevron_right_rounded,
                  color: LoopitColors.grey500,
                ),
                onTap: () {
                  Navigator.pop(context);
                  // TODO: Show generated driver QR dialog
                },
              ),

              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoopitColors.background,
      extendBody: true,
      body: Stack(
        children: [
          // Native PageView with strict 1-page snapping
          PageView(
            controller: _pageController,
            physics: const PageScrollPhysics(),
            onPageChanged: (index) {
              setState(() => _currentIndex = index);
            },
            children: _screens,
          ),

          // Floating Glassmorphism Pill Nav Bar
          Positioned(
            left: 20,
            right: 20,
            bottom: 32,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: LoopitColors.white.withValues(alpha: 0.75),
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: LoopitColors.black.withValues(alpha: 0.08),
                      width: 1.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: LoopitColors.black.withValues(alpha: 0.05),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _NavBarItem(
                        icon: Icons.home_filled,
                        label: 'Home',
                        isSelected: _currentIndex == 0,
                        onTap: () => _onNavTabTapped(0),
                      ),
                      _NavBarItem(
                        icon: Icons.inventory_2_outlined,
                        label: 'Dispatches',
                        isSelected: _currentIndex == 1,
                        onTap: () => _onNavTabTapped(1),
                      ),
                      
                      // --- Inverted QR Code Item ---
                      _NavBarItem(
                        icon: Icons.qr_code_scanner_rounded,
                        label: 'QR Code',
                        isSelected: false,
                        invertColors: true, // Turns it into a primary action button
                        onTap: () => _showQrCodePopup(context),
                      ),

                      _NavBarItem(
                        icon: Icons.notifications_none_outlined,
                        label: 'Notifications',
                        isSelected: _currentIndex == 2,
                        onTap: () => _onNavTabTapped(2),
                      ),
                      _NavBarItem(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        isSelected: _currentIndex == 3,
                        onTap: () => _onNavTabTapped(3),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _NavBarItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;
  final bool invertColors; 

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
    this.invertColors = false, 
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Inverted Color Logic applied here
          if (invertColors)
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: LoopitColors.black, 
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: LoopitColors.white, 
                size: 22,
              ),
            )
          else
            Icon(
              icon,
              color: isSelected ? LoopitColors.black : LoopitColors.grey500,
              size: 24,
            ),
            
          const SizedBox(height: 4),
          
          Text(
            label,
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 10,
              fontWeight: (isSelected || invertColors) ? FontWeight.w600 : FontWeight.w500,
              color: invertColors 
                  ? LoopitColors.black 
                  : (isSelected ? LoopitColors.black : LoopitColors.grey500),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// QR Scanner Camera Interface Screen
// ---------------------------------------------------------------------------
class QrScannerScreen extends StatelessWidget {
  const QrScannerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // 1. Placeholder for the actual Camera View (e.g., mobile_scanner)
          Positioned.fill(
            child: Container(
              color: const Color(0xFF1E293B), // Dark slate placeholder background
              child: const Center(
                child: Icon(
                  Icons.videocam_outlined,
                  color: Colors.white24,
                  size: 100,
                ),
              ),
            ),
          ),

          // 2. Dimmed Overlay to focus on the center square
          ColorFiltered(
            colorFilter: ColorFilter.mode(
              Colors.black.withValues(alpha: 0.7),
              BlendMode.srcOut,
            ),
            child: Stack(
              children: [
                Container(
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Container(
                      width: 280,
                      height: 280,
                      decoration: BoxDecoration(
                        color: Colors.black, // This creates the "cutout" effect
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // 3. Scanner Border Highlights
          Center(
            child: Container(
              width: 280,
              height: 280,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: Colors.blueAccent,
                  width: 2.5,
                ),
              ),
            ),
          ),

          // 4. Header with Back Button
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  const Text(
                    "Scan Dispatch QR",
                    style: TextStyle(
                      fontFamily: "Inter",
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(width: 48), // Balance for centering
                ],
              ),
            ),
          ),

          // 5. Flashlight & Instructions at the bottom
          Positioned(
            bottom: 60,
            left: 0,
            right: 0,
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    // TODO: Toggle flashlight logic
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.black.withValues(alpha: 0.4),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.flashlight_on_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                const Text(
                  "Align the QR code within the frame\nto scan dispatch details",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Inter",
                    fontSize: 14,
                    color: Colors.white70,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}