/*
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

  final List<Widget> _screens = [
    const HomeScreen(),
    const Center(child: Text('Dispatches Screen', style: TextStyle(fontFamily: 'Inter'))),
    const NotificationsScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: LoopitColors.background,
      extendBody: true, // Crucial for floating nav bar to overlay content seamlessly
      body: Stack(
        children: [
          // Main content screens
          IndexedStack(
            index: _currentIndex,
            children: _screens,
          ),

          // Floating Glassmorphism Pill Nav Bar
          Positioned(
            left: 24,
            right: 24,
            bottom: 32, // Floating slightly above the bottom edge
            child: ClipRRect(
              borderRadius: BorderRadius.circular(40), // Pill shape
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15), // Glassmorphism blur
                child: Container(
                  height: 72,
                  decoration: BoxDecoration(
                    color: LoopitColors.white.withValues(alpha: 0.75), // Semi-transparent white
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(
                      color: LoopitColors.black.withValues(alpha: 0.08), // Clear defined border
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
                        onTap: () => setState(() => _currentIndex = 0),
                      ),
                      _NavBarItem(
                        icon: Icons.inventory_2_outlined,
                        label: 'Dispatches',
                        isSelected: _currentIndex == 1,
                        onTap: () => setState(() => _currentIndex = 1),
                      ),
                      _NavBarItem(
                        icon: Icons.notifications_none_outlined,
                        label: 'Notifications',
                        isSelected: _currentIndex == 2,
                        onTap: () => setState(() => _currentIndex = 2),
                      ),
                      _NavBarItem(
                        icon: Icons.person_outline,
                        label: 'Profile',
                        isSelected: _currentIndex == 3,
                        onTap: () => setState(() => _currentIndex = 3),
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

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? LoopitColors.black : LoopitColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}
*/





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
            left: 24,
            right: 24,
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

  const _NavBarItem({
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
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
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
              color: isSelected ? LoopitColors.black : LoopitColors.grey500,
            ),
          ),
        ],
      ),
    );
  }
}