/*
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopit_ui/loopit_ui.dart';
import '../../main/presentation/main_scaffold.dart';
import '../application/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  bool _rememberMe = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: LoopitColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Locked Bottom Section (Image + Footer Text)
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.5),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      'assets/images/login_illustration.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(height: 150, color: LoopitColors.grey50),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Managed by Transportation Department\nMade by School of STEM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: LoopitColors.grey500,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Foreground Form Controls
            Positioned.fill(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/loopit.png',
                          height: 90,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.apps, size: 90),
                        ),
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        'Sign in to continue manage campus\ndispatches and deliveries.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: LoopitColors.grey500,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 24),

                      // --- Input Fields ---
                      const PremiumTextField(
                        title: 'Email',
                        prefixIcon: Icons.email_outlined,
                      ),
                      const SizedBox(height: 16),
                      const PremiumTextField(
                        title: 'Password',
                        prefixIcon: Icons.lock_outline,
                        isPassword: true,
                      ),
                      const SizedBox(height: 16),

                      // --- Remember Me ---
                      Row(
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _rememberMe = !_rememberMe;
                              });
                            },
                            child: Container(
                              width: 20,
                              height: 20,
                              decoration: BoxDecoration(
                                color: _rememberMe
                                    ? LoopitColors.black
                                    : Colors.transparent,
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: _rememberMe
                                      ? LoopitColors.black
                                      : LoopitColors.grey300,
                                  width: 1.5,
                                ),
                              ),
                              child: _rememberMe
                                  ? const Icon(
                                      Icons.check,
                                      color: LoopitColors.white,
                                      size: 14,
                                    )
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Text(
                            'Remember me',
                            style: TextStyle(
                              fontSize: 13,
                              color: LoopitColors.grey500,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 32),

                      // --- Buttons ---
                      Consumer(
                        builder: (context, ref, child) {
                          final authState = ref.watch(authNotifierProvider);
                          final isLoading = authState.isLoading;

                          return PremiumButton(
                            text: isLoading ? 'Signing In...' : 'Sign In',
                            onPressed: isLoading
                                ? () {}
                                : () {
                                    ref
                                        .read(authNotifierProvider.notifier)
                                        .signIn('test@example.com', 'password')
                                        .then((_) {
                                      if (context.mounted &&
                                          !ref
                                              .read(authNotifierProvider)
                                              .hasError) {
                                        Navigator.of(context).pushReplacement(
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                const MainScaffold(),
                                          ),
                                        );
                                      }
                                    });
                                  },
                          );
                        },
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}








import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopit_ui/loopit_ui.dart';
import '../../main/presentation/main_scaffold.dart';
import '../application/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: LoopitColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Locked Bottom Section (Image + Footer Text)
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.5),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      'assets/images/login_illustration.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(height: 150, color: LoopitColors.grey50),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Managed by Transportation Department\nMade by School of STEM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: LoopitColors.grey500,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Foreground Form Controls
            Positioned.fill(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/loopit.png',
                          height: 90,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.apps, size: 90),
                        ),
                      ),

                      const SizedBox(height: 40),

                      const Text(
                        'Sign in to continue manage campus\ndispatches and deliveries.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: LoopitColors.grey500,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // --- Google Sign In Button ---
                      Consumer(
                        builder: (context, ref, child) {
                          final authState = ref.watch(authNotifierProvider);
                          final isLoading = authState.isLoading;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      ref
                                          .read(authNotifierProvider.notifier)
                                          .signIn(
                                              'test@example.com', 'password')
                                          .then((_) {
                                        if (context.mounted &&
                                            !ref
                                                .read(authNotifierProvider)
                                                .hasError) {
                                          Navigator.of(context)
                                              .pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainScaffold(),
                                            ),
                                          );
                                        }
                                      });
                                    },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: LoopitColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: LoopitColors.grey300,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: LoopitColors.black
                                          .withValues(alpha: 0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isLoading)
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  LoopitColors.black),
                                        ),
                                      )
                                    else ...[
                                      Image.asset(
                                        'assets/images/google_logo.png',
                                        height: 22,
                                        width: 22,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.g_mobiledata,
                                          size: 28,
                                          color: LoopitColors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: LoopitColors.black,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopit_ui/loopit_ui.dart';
import '../../main/presentation/main_scaffold.dart';
import '../application/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: LoopitColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Locked Bottom Section (Image + Footer Text)
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.5),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      'assets/images/login_illustration.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(height: 150, color: LoopitColors.grey50),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Managed by Transportation Department\nMade by School of STEM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: LoopitColors.grey500,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Foreground Form Controls
            Positioned.fill(
              child: Center(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/loopit.png',
                          height: 90,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.apps, size: 90),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Large "Sign In" Title
                      const Text(
                        'Sign In',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: LoopitColors.black,
                        ),
                      ),

                      const SizedBox(height: 8),

                      // Updated Subtitle Text
                      const Text(
                        'To continue with your university account to manage campus dispatches and deliveries',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 14,
                          color: LoopitColors.grey500,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),

                      const SizedBox(height: 32),

                      // --- Google Sign In Button ---
                      Consumer(
                        builder: (context, ref, child) {
                          final authState = ref.watch(authNotifierProvider);
                          final isLoading = authState.isLoading;

                          return Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: isLoading
                                  ? null
                                  : () {
                                      ref
                                          .read(authNotifierProvider.notifier)
                                          .signIn(
                                              'test@example.com', 'password')
                                          .then((_) {
                                        if (context.mounted &&
                                            !ref
                                                .read(authNotifierProvider)
                                                .hasError) {
                                          Navigator.of(context)
                                              .pushReplacement(
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  const MainScaffold(),
                                            ),
                                          );
                                        }
                                      });
                                    },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                height: 52,
                                decoration: BoxDecoration(
                                  color: LoopitColors.white,
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: LoopitColors.grey300,
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: LoopitColors.black
                                          .withValues(alpha: 0.04),
                                      blurRadius: 10,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    if (isLoading)
                                      const SizedBox(
                                        width: 20,
                                        height: 20,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 2,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                  LoopitColors.black),
                                        ),
                                      )
                                    else ...[
                                      Image.asset(
                                        'assets/images/google_logo.png',
                                        height: 22,
                                        width: 22,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                const Icon(
                                          Icons.g_mobiledata,
                                          size: 28,
                                          color: LoopitColors.black,
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                      const Text(
                                        'Continue with Google',
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w600,
                                          color: LoopitColors.black,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

*/

import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopit_ui/loopit_ui.dart';
import '../../main/presentation/main_scaffold.dart';
import '../application/auth_notifier.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: LoopitColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            // Locked Bottom Section (Image + Footer Text)
            Align(
              alignment: Alignment.bottomCenter,
              child: Stack(
                alignment: Alignment.bottomCenter,
                children: [
                  ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.white.withValues(alpha: 0.5),
                          Colors.white,
                        ],
                        stops: const [0.0, 0.4, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Image.asset(
                      'assets/images/login_illustration.png',
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          Container(height: 150, color: LoopitColors.grey50),
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(bottom: 24.0),
                    child: Text(
                      'Managed by Transportation Department\nMade by School of STEM',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: LoopitColors.grey500,
                        fontWeight: FontWeight.w400,
                        height: 1.4,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Foreground Form Controls
            Positioned.fill(
              child: Center(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 20.0,
                    vertical: 24.0,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Center(
                        child: Image.asset(
                          'assets/images/loopit.png',
                          height: 90,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.apps, size: 90),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // --- High-Contrast Frosted Glass Sign In Box ---
                      Center(
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 400),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: BackdropFilter(
                              filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 20.0,
                                  vertical: 24.0,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF8FAFC)
                                      .withValues(alpha: 0.75),
                                  borderRadius: BorderRadius.circular(24),
                                  border: Border.all(
                                    color: const Color(0xFFCBD5E1),
                                    width: 1.5,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          Colors.black.withValues(alpha: 0.12),
                                      blurRadius: 28,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Large "Sign In" Title
                                    const Text(
                                      'Sign In',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w700,
                                        color: Color(0xFF0F172A),
                                        letterSpacing: -0.3,
                                      ),
                                    ),

                                    const SizedBox(height: 8),

                                    // Subtitle Text
                                    const Text(
                                      'To continue with your university account to manage campus dispatches and deliveries',
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                        fontSize: 12.5,
                                        color: Color(0xFF64748B),
                                        height: 1.4,
                                      ),
                                    ),

                                    const SizedBox(height: 24),

                                    // --- Google Sign In Button ---
                                    Consumer(
                                      builder: (context, ref, child) {
                                        final authState =
                                            ref.watch(authNotifierProvider);
                                        final isLoading = authState.isLoading;

                                        return Material(
                                          color: Colors.transparent,
                                          child: InkWell(
                                             onTap: isLoading
                                                ? null
                                                : () {
                                                    Navigator.of(context)
                                                        .pushReplacement(
                                                      MaterialPageRoute(
                                                        builder: (context) =>
                                                            const MainScaffold(),
                                                      ),
                                                    );
                                                  },
                                            borderRadius:
                                                BorderRadius.circular(28),
                                            splashColor: Colors.black
                                                .withValues(alpha: 0.05),
                                            highlightColor: Colors.black
                                                .withValues(alpha: 0.02),
                                            child: Container(
                                              height: 50,
                                              decoration: BoxDecoration(
                                                color: Colors.white
                                                    .withValues(alpha: 0.9),
                                                borderRadius:
                                                    BorderRadius.circular(28),
                                                border: Border.all(
                                                  color:
                                                      const Color(0xFFCBD5E1),
                                                  width: 1,
                                                ),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.black
                                                        .withValues(
                                                            alpha: 0.04),
                                                    blurRadius: 6,
                                                    offset: const Offset(0, 2),
                                                  ),
                                                ],
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  if (isLoading)
                                                    const SizedBox(
                                                      width: 20,
                                                      height: 20,
                                                      child:
                                                          CircularProgressIndicator(
                                                        strokeWidth: 2,
                                                        valueColor:
                                                            AlwaysStoppedAnimation<
                                                                    Color>(
                                                                LoopitColors
                                                                    .black),
                                                      ),
                                                    )
                                                  else ...[
                                                    Image.asset(
                                                      'assets/images/google_logo.png',
                                                      height: 20,
                                                      width: 20,
                                                    ),
                                                    const SizedBox(width: 10),
                                                    const Text(
                                                      'Continue with Google',
                                                      style: TextStyle(
                                                        fontSize: 14.5,
                                                        fontWeight:
                                                            FontWeight.w600,
                                                        color:
                                                            Color(0xFF0F172A),
                                                      ),
                                                    ),
                                                  ],
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    ),

                                    const SizedBox(height: 18),

                                    const Divider(
                                      color: Color(0xFFCBD5E1),
                                      thickness: 0.8,
                                    ),

                                    const SizedBox(height: 14),

                                    // --- Center-Aligned Lock Notice ---
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFFEF2F2),
                                            shape: BoxShape.circle,
                                            border: Border.all(
                                              color: const Color(0xFFFEE2E2),
                                            ),
                                          ),
                                          child: const Icon(
                                            Icons.lock_outline_rounded,
                                            size: 15,
                                            color: Color(0xFFEF4444),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        const Flexible(
                                          child: Text(
                                            'Only authorized personnel can access the application.',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 11.5,
                                              color: Color(0xFF64748B),
                                              height: 1.3,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}