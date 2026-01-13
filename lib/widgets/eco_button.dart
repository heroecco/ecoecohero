import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';

class EcoButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color? color;
  final double? width;
  final double height;
  final double fontSize;
  final Widget? icon;

  const EcoButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color,
    this.width,
    this.height = 60,
    this.fontSize = 24,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: color ?? AppColors.green,
          foregroundColor: AppColors.white,
          elevation: 4,
          shadowColor: AppColors.deepNavy,
          shape: const StadiumBorder(),
          side: const BorderSide(color: AppColors.deepNavy, width: 3),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
        ).copyWith(
          elevation: WidgetStateProperty.resolveWith<double>(
            (Set<WidgetState> states) {
              if (states.contains(WidgetState.pressed)) return 0;
              return 4;
            },
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              icon!,
              const SizedBox(width: 12),
            ],
            Text(
              text,
              style: GoogleFonts.comfortaa(
                fontSize: fontSize,
                fontWeight: FontWeight.bold,
                color: AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

