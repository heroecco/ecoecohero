import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_colors.dart';
import '../widgets/eco_panel.dart';
import 'settings_overlay.dart';

class MainMenuScreen extends StatefulWidget {
  const MainMenuScreen({super.key});

  @override
  State<MainMenuScreen> createState() => _MainMenuScreenState();
}

class _MainMenuScreenState extends State<MainMenuScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _waveController;

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();
  }

  @override
  void dispose() {
    _waveController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Ocean gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFF0077B6),
                  Color(0xFF00A8E8),
                  Color(0xFF48CAE4),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Animated wave pattern at bottom
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  size: const Size(double.infinity, 120),
                  painter: _WavePainter(_waveController.value),
                );
              },
            ),
          ),

          // Floating bubbles decoration
          ...List.generate(8, (index) => _FloatingBubble(index: index)),

          // Main content
          SafeArea(
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Logo area with enhanced styling - wrapped in Flexible + FittedBox for responsiveness
                  Flexible(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Decorative submarine icon
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: AppColors.white.withValues(alpha: 0.15),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.water,
                                size: 64,
                                color: AppColors.white,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Main title
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [Colors.white, Color(0xFFE0F7FA)],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ).createShader(bounds),
                              child: Text(
                                'ECO HERO',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 72,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                  letterSpacing: 4,
                                  shadows: [
                                    const Shadow(
                                      color: AppColors.deepNavy,
                                      offset: Offset(4, 4),
                                      blurRadius: 0,
                                    ),
                                    Shadow(
                                      color: AppColors.deepNavy.withValues(alpha: 0.3),
                                      offset: const Offset(8, 8),
                                      blurRadius: 0,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            // Subtitle
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 24, vertical: 8),
                              decoration: BoxDecoration(
                                color: AppColors.deepNavy.withValues(alpha: 0.3),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                'OCEAN CLEANUP',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.white,
                                  letterSpacing: 6,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                // Enhanced menu panel
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.deepNavy.withValues(alpha: 0.3),
                        blurRadius: 30,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: EcoPanel(
                    width: 320,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Dive In button (formerly Play)
                        _MenuButton(
                          icon: Icons.play_arrow_rounded,
                          label: 'DIVE IN',
                          color: AppColors.green,
                          onPressed: () {
                            Navigator.pushNamed(context, '/level_select');
                          },
                        ),
                        const SizedBox(height: 16),

                        // Hangar button (formerly Shop)
                        _MenuButton(
                          icon: Icons.rocket_launch_rounded,
                          label: 'HANGAR',
                          color: AppColors.gold,
                          onPressed: () {
                            Navigator.pushNamed(context, '/shop');
                          },
                        ),
                        const SizedBox(height: 16),

                        // Options button (formerly Settings)
                        _MenuButton(
                          icon: Icons.tune_rounded,
                          label: 'OPTIONS',
                          color: AppColors.deepNavy,
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) => const SettingsOverlay(),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          ),
        ],
      ),
    );
  }
}

// Custom menu button with icon
class _MenuButton extends StatefulWidget {
  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _MenuButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_MenuButton> createState() => _MenuButtonState();
}

class _MenuButtonState extends State<_MenuButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _isPressed ? 4 : 0, 0),
        child: Container(
          height: 64,
          decoration: BoxDecoration(
            color: widget.color,
            borderRadius: BorderRadius.circular(32),
            border: Border.all(color: AppColors.deepNavy, width: 3),
            boxShadow: _isPressed
                ? []
                : [
                    const BoxShadow(
                      color: AppColors.deepNavy,
                      offset: Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.white.withValues(alpha: 0.2),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  color: AppColors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                widget.label,
                style: GoogleFonts.comfortaa(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.white,
                  letterSpacing: 1,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Animated wave painter
class _WavePainter extends CustomPainter {
  final double animationValue;

  _WavePainter(this.animationValue);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.deepNavy.withValues(alpha: 0.15)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.5 +
          math.sin((x / size.width * 4 * math.pi) + (animationValue * 2 * math.pi)) * 20 +
          math.sin((x / size.width * 2 * math.pi) + (animationValue * math.pi)) * 10;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.close();
    canvas.drawPath(path, paint);

    // Second wave layer
    final paint2 = Paint()
      ..color = AppColors.deepNavy.withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path2 = Path();
    path2.moveTo(0, size.height);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.6 +
          math.sin((x / size.width * 3 * math.pi) - (animationValue * 2 * math.pi)) * 15 +
          math.sin((x / size.width * 1.5 * math.pi) - (animationValue * math.pi)) * 8;
      path2.lineTo(x, y);
    }

    path2.lineTo(size.width, size.height);
    path2.close();
    canvas.drawPath(path2, paint2);
  }

  @override
  bool shouldRepaint(covariant _WavePainter oldDelegate) =>
      oldDelegate.animationValue != animationValue;
}

// Floating bubble decoration
class _FloatingBubble extends StatefulWidget {
  final int index;

  const _FloatingBubble({required this.index});

  @override
  State<_FloatingBubble> createState() => _FloatingBubbleState();
}

class _FloatingBubbleState extends State<_FloatingBubble>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late double _startX;
  late double _size;
  late double _speed;

  @override
  void initState() {
    super.initState();
    final random = math.Random(widget.index);
    _startX = random.nextDouble();
    _size = 8 + random.nextDouble() * 24;
    _speed = 4 + random.nextDouble() * 6;

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: _speed.toInt()),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final screenHeight = MediaQuery.of(context).size.height;
        final screenWidth = MediaQuery.of(context).size.width;
        final y = screenHeight - (_controller.value * (screenHeight + 100));
        final x = _startX * screenWidth +
            math.sin(_controller.value * 4 * math.pi) * 30;

        return Positioned(
          left: x,
          top: y,
          child: Container(
            width: _size,
            height: _size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.white.withValues(alpha: 0.15),
              border: Border.all(
                color: AppColors.white.withValues(alpha: 0.3),
                width: 1,
              ),
            ),
          ),
        );
      },
    );
  }
}

