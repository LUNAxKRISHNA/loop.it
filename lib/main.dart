import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loopit_ui/loopit_ui.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'features/splash/presentation/splash_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load environment variables
  await dotenv.load(fileName: '.env');

  // Initialize Supabase
  await Supabase.initialize(
    url: dotenv.env['SUPABASE_URL']!,
    anonKey: dotenv.env['SUPABASE_ANON_KEY']!, // ignore: deprecated_member_use
  );

  runApp(
    const ProviderScope(
      child: LoopitApp(),
    ),
  );
}

class LoopitApp extends StatelessWidget {
  const LoopitApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LOOPIT',
      debugShowCheckedModeBanner: false,
      theme: LoopitTheme.lightTheme,
      home: const SplashScreen(),
    );
  }
}
