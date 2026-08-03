import 'dart:math';
import 'package:flutter/material.dart';
import 'package:loopit_ui/loopit_ui.dart';
import '../../auth/presentation/login_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  // Phase 1: Logo fades and scales in
  late final AnimationController _logoController;
  late final Animation<double> _logoOpacity;
  late final Animation<double> _logoScale;

  // Phase 2: White radial burst reveals login screen
  late final AnimationController _revealController;
  late final Animation<double> _revealProgress;

  @override
  void initState() {
    super.initState();

    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _logoOpacity = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeIn,
    );
    _logoScale = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeOutBack),
    );

    _revealController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 650),
    );
    _revealProgress = CurvedAnimation(
      parent: _revealController,
      curve: Curves.easeInOut,
    );

    _runSequence();
  }

  Future<void> _runSequence() async {
    // 1. Reveal logo
    await _logoController.forward();
    
    // Hold logo on screen for 1 second
    await Future.delayed(const Duration(seconds: 1));
    
    // 2. Play radial reveal transition
    await _revealController.forward();
    
    // 3. Navigate to login screen
    if (mounted) {
      Navigator.of(context).pushReplacement(
        PageRouteBuilder(
          pageBuilder: (_, __, ___) => const LoginScreen(),
          transitionDuration: Duration.zero,
        ),
      );
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _revealController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final screenCenter = Offset(size.width / 2, size.height / 2);

    // Max radius for the radial reveal to fill the whole screen
    final maxRadius = sqrt(pow(size.width / 2, 2) + pow(size.height / 2, 2)) * 1.1;

    return Scaffold(
      backgroundColor: LoopitColors.black,
      body: Stack(
        children: [
          // ── Phase 1: White logo fades and scales in ──
          AnimatedBuilder(
            animation: Listenable.merge([_logoOpacity, _logoScale]),
            builder: (context, _) {
              return Center(
                child: Opacity(
                  opacity: _logoOpacity.value,
                  child: Transform.scale(
                    scale: _logoScale.value,
                    child: Image.asset(
                      'assets/images/loopit.png',
                      width: 260.0,
                      color: LoopitColors.white,
                      colorBlendMode: BlendMode.srcIn,
                      errorBuilder: (_, __, ___) => const Icon(
                        Icons.all_inclusive,
                        color: LoopitColors.white,
                        size: 80,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),

          // ── Phase 2: White radial reveal transition ──
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _revealProgress,
              builder: (context, _) {
                if (_revealProgress.value == 0) return const SizedBox.shrink();
                return CustomPaint(
                  painter: RadialRevealPainter(
                    center: screenCenter,
                    radius: _revealProgress.value * maxRadius,
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Paints an expanding white radial circle from [center], filling the screen to reveal the login.
class RadialRevealPainter extends CustomPainter {
  final Offset center;
  final double radius;

  const RadialRevealPainter({required this.center, required this.radius});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawCircle(center, radius, Paint()..color = LoopitColors.white);
  }

  @override
  bool shouldRepaint(RadialRevealPainter old) => old.radius != radius;
}
