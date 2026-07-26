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
      backgroundColor: LoopitColors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Align(
              alignment: Alignment.bottomCenter,
              child: ShaderMask(
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
            ),

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

                      const SizedBox(height: 32),

                      // --- Footer Text ---
                      const Text(
                        'Managed by Transportation Department\nMade by School of STEM',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 12,
                          color: LoopitColors.grey500,
                          fontWeight: FontWeight.w400,
                          height: 1.4,
                        ),
                      ),
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