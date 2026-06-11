import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'theme.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const HitachiApp());
}

class HitachiApp extends StatelessWidget {
  const HitachiApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      brightness: Brightness.light,
      scaffoldBackgroundColor: Colors.white,
      colorScheme: ColorScheme.fromSeed(
        seedColor: Brand.facebook,
        primary: Brand.facebook,
      ),
      useMaterial3: true,
    );

    return MaterialApp(
      title: 'Hitachi Exam',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        textTheme: GoogleFonts.plusJakartaSansTextTheme(base.textTheme).apply(
          bodyColor: Brand.ink,
          displayColor: Brand.ink,
        ),
        appBarTheme: AppBarTheme(
          titleTextStyle: GoogleFonts.plusJakartaSans(
            fontSize: 18,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
      ),
      home: const SplashScreen(),
    );
  }
}
