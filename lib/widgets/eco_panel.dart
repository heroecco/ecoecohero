import 'package:flutter/material.dart';
import '../utils/app_colors.dart';

class EcoPanel extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry padding;

  const EcoPanel({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding = const EdgeInsets.all(24),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: AppColors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: AppColors.deepNavy,
          width: 2,
        ),
      ),
      child: child,
    );
  }
}

