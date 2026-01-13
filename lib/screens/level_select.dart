import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/player_data.dart';
import '../data/levels.dart';
import '../utils/app_colors.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerData = PlayerData();

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
                  Color(0xFF023E8A),
                  Color(0xFF0077B6),
                  Color(0xFF00A8E8),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Decorative depth lines
          ...List.generate(5, (i) => Positioned(
            top: 150.0 + i * 100,
            left: 0,
            right: 0,
            child: Container(
              height: 1,
              color: AppColors.white.withValues(alpha: 0.05 + i * 0.02),
            ),
          )),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Custom header
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  child: Row(
                    children: [
                      // Back button
                      _BackButton(onPressed: () => Navigator.pop(context)),
                      const Spacer(),
                      // Title with depth indicator
                      Column(
                        children: [
                          Text(
                            'SELECT MISSION',
                            style: GoogleFonts.comfortaa(
                              fontSize: 28,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              letterSpacing: 2,
                              shadows: [
                                Shadow(
                                  color: AppColors.deepNavy.withValues(alpha: 0.5),
                                  offset: const Offset(2, 2),
                                  blurRadius: 0,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 40,
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Colors.transparent,
                                      AppColors.white.withValues(alpha: 0.5),
                                    ],
                                  ),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Icon(
                                Icons.waves_rounded,
                                color: AppColors.white.withValues(alpha: 0.7),
                                size: 20,
                              ),
                              const SizedBox(width: 8),
                              Container(
                                width: 40,
                                height: 2,
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      AppColors.white.withValues(alpha: 0.5),
                                      Colors.transparent,
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      const Spacer(),
                      // Invisible spacer to balance layout
                      const SizedBox(width: 56),
                    ],
                  ),
                ),

                // Level grid
                Expanded(
                  child: Center(
                    child: ValueListenableBuilder<int>(
                      valueListenable: playerData.highestLevelUnlockedNotifier,
                      builder: (context, highestUnlocked, _) {
                        return Padding(
                          padding: const EdgeInsets.all(24),
                          child: GridView.builder(
                            shrinkWrap: true,
                            gridDelegate:
                                const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 5,
                              childAspectRatio: 1.1,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: levels.length, // Dynamic level count
                            itemBuilder: (context, index) {
                              final level = index + 1;
                              final isLocked = !playerData.isLevelUnlocked(level);
                              final isCompleted = level < highestUnlocked;

                              return _LevelCard(
                                level: level,
                                isLocked: isLocked,
                                isCompleted: isCompleted,
                                depthIndex: index,
                                onPressed: () {
                                  if (!isLocked) {
                                    Navigator.pushNamed(context, '/game',
                                        arguments: level);
                                  }
                                },
                              );
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _BackButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _BackButton({required this.onPressed});

  @override
  State<_BackButton> createState() => _BackButtonState();
}

class _BackButtonState extends State<_BackButton> {
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
        transform: Matrix4.translationValues(0, _isPressed ? 2 : 0, 0),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.white.withValues(alpha: 0.15),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.3),
            width: 2,
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: AppColors.deepNavy.withValues(alpha: 0.3),
                    offset: const Offset(0, 2),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: const Icon(
          Icons.arrow_back_rounded,
          color: AppColors.white,
          size: 28,
        ),
      ),
    );
  }
}

class _LevelCard extends StatefulWidget {
  final int level;
  final bool isLocked;
  final bool isCompleted;
  final int depthIndex;
  final VoidCallback onPressed;

  const _LevelCard({
    required this.level,
    required this.isLocked,
    required this.isCompleted,
    required this.depthIndex,
    required this.onPressed,
  });

  @override
  State<_LevelCard> createState() => _LevelCardState();
}

class _LevelCardState extends State<_LevelCard> {
  bool _isPressed = false;

  // Get gradient colors based on depth (level)
  List<Color> get _gradientColors {
    if (widget.isLocked) {
      return [
        const Color(0xFF4A525A),
        const Color(0xFF3D4449),
      ];
    }

    // Ocean depth gradients - darker as you go deeper
    // Extended to support 13+ levels
    final gradients = [
      [const Color(0xFF48CAE4), const Color(0xFF00B4D8)], // Surface (1-2)
      [const Color(0xFF00B4D8), const Color(0xFF0096C7)], // Shallow (3-4)
      [const Color(0xFF0096C7), const Color(0xFF0077B6)], // Medium (5-6)
      [const Color(0xFF0077B6), const Color(0xFF023E8A)], // Deep (7-8)
      [const Color(0xFF023E8A), const Color(0xFF03045E)], // Abyss (9-10)
      [const Color(0xFF03045E), const Color(0xFF020228)], // Trench (11-12)
      [const Color(0xFF1A0033), const Color(0xFF0D001A)], // Void (13+) - purple-black
    ];

    final gradientIndex = (widget.depthIndex ~/ 2).clamp(0, gradients.length - 1);
    return gradients[gradientIndex];
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: widget.isLocked ? null : (_) => setState(() => _isPressed = true),
      onTapUp: widget.isLocked
          ? null
          : (_) {
              setState(() => _isPressed = false);
              widget.onPressed();
            },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 100),
        transform: Matrix4.translationValues(0, _isPressed ? 4 : 0, 0),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: _gradientColors,
            ),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isLocked
                  ? const Color(0xFF3D4449)
                  : AppColors.white.withValues(alpha: 0.5),
              width: 3,
            ),
            boxShadow: widget.isLocked || _isPressed
                ? []
                : [
                    BoxShadow(
                      color: AppColors.deepNavy.withValues(alpha: 0.5),
                      offset: const Offset(0, 4),
                      blurRadius: 0,
                    ),
                  ],
          ),
          child: Stack(
            children: [
              // Subtle wave pattern overlay
              if (!widget.isLocked)
                Positioned.fill(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: CustomPaint(
                      painter: _CardWavePainter(),
                    ),
                  ),
                ),

              // Content
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Level number
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 4),
                      decoration: BoxDecoration(
                        color: widget.isLocked
                            ? Colors.transparent
                            : AppColors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        '${widget.level}',
                        style: GoogleFonts.comfortaa(
                          fontSize: 36,
                          fontWeight: FontWeight.bold,
                          color: widget.isLocked
                              ? const Color(0xFF6B7280)
                              : AppColors.white,
                          shadows: widget.isLocked
                              ? []
                              : [
                                  Shadow(
                                    color: AppColors.deepNavy.withValues(alpha: 0.3),
                                    offset: const Offset(1, 1),
                                    blurRadius: 0,
                                  ),
                                ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Status indicator
                    if (widget.isLocked)
                      Container(
                        padding: const EdgeInsets.all(6),
                        decoration: BoxDecoration(
                          color: const Color(0xFF3D4449),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.lock_rounded,
                          color: Color(0xFF6B7280),
                          size: 20,
                        ),
                      )
                    else if (widget.isCompleted)
                      // Stars for completed levels
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: List.generate(
                          3,
                          (i) => Icon(
                            Icons.star_rounded,
                            color: AppColors.gold,
                            size: 22,
                            shadows: [
                              Shadow(
                                color: AppColors.deepNavy.withValues(alpha: 0.3),
                                offset: const Offset(1, 1),
                                blurRadius: 0,
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      // Current level indicator
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.play_circle_filled_rounded,
                            color: AppColors.white.withValues(alpha: 0.9),
                            size: 24,
                          ),
                        ],
                      ),
                  ],
                ),
              ),

              // Depth indicator badge
              if (!widget.isLocked)
                Positioned(
                  top: 8,
                  right: 8,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                    decoration: BoxDecoration(
                      color: AppColors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${(widget.level * 10)}m',
                      style: GoogleFonts.comfortaa(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white.withValues(alpha: 0.8),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// Wave pattern for level cards
class _CardWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.05)
      ..style = PaintingStyle.fill;

    final path = Path();
    path.moveTo(0, size.height * 0.7);

    for (double x = 0; x <= size.width; x++) {
      final y = size.height * 0.7 +
          math.sin((x / size.width * 2 * math.pi)) * 8;
      path.lineTo(x, y);
    }

    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

