import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    await Future.delayed(const Duration(seconds: 2));
    if (mounted) {
      Navigator.pushReplacementNamed(context, '/main_menu');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.cyan,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Eco Hero',
              style: GoogleFonts.comfortaa(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
                shadows: [
                  const Shadow(
                    color: AppColors.deepNavy,
                    offset: Offset(4, 4),
                    blurRadius: 0,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Ocean Cleanup',
              style: GoogleFonts.comfortaa(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: AppColors.deepNavy,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

