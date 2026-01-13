import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/player_data.dart';
import '../data/skin_data.dart';
import '../utils/app_colors.dart';

class ShopScreen extends StatelessWidget {
  const ShopScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final playerData = PlayerData();

    return Scaffold(
      body: Stack(
        children: [
          // Industrial/hangar gradient background
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF1A1A2E),
                  Color(0xFF16213E),
                  Color(0xFF0F3460),
                ],
                stops: [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // Grid pattern overlay
          Positioned.fill(
            child: CustomPaint(
              painter: _GridPatternPainter(),
            ),
          ),

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
                      _HangarBackButton(onPressed: () => Navigator.pop(context)),
                      const SizedBox(width: 24),

                      // Title
                      Expanded(
                        child: Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: AppColors.gold.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.gold.withValues(alpha: 0.5),
                                  width: 2,
                                ),
                              ),
                              child: const Icon(
                                Icons.rocket_launch_rounded,
                                color: AppColors.gold,
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'HANGAR',
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.white,
                                    letterSpacing: 4,
                                  ),
                                ),
                                Text(
                                  'SUBMARINE COLLECTION',
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: AppColors.white.withValues(alpha: 0.5),
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),

                      // Coins display
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 12),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              AppColors.gold.withValues(alpha: 0.3),
                              AppColors.gold.withValues(alpha: 0.1),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(30),
                          border: Border.all(
                            color: AppColors.gold.withValues(alpha: 0.5),
                            width: 2,
                          ),
                        ),
                        child: ValueListenableBuilder<int>(
                          valueListenable: playerData.coinsNotifier,
                          builder: (context, coins, _) {
                            return Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(6),
                                  decoration: BoxDecoration(
                                    color: AppColors.gold,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.gold.withValues(alpha: 0.5),
                                        blurRadius: 8,
                                        spreadRadius: 1,
                                      ),
                                    ],
                                  ),
                                  child: const Icon(
                                    Icons.monetization_on,
                                    color: AppColors.deepNavy,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  '$coins',
                                  style: GoogleFonts.comfortaa(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.gold,
                                  ),
                                ),
                              ],
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),

                // Divider
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 24),
                  height: 1,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        AppColors.gold.withValues(alpha: 0.3),
                        Colors.transparent,
                      ],
                    ),
                  ),
                ),

                // Submarine grid
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.all(24),
                    child: Wrap(
                      spacing: 24,
                      runSpacing: 24,
                      alignment: WrapAlignment.center,
                      children: SkinData.allSkins
                          .map((skin) => _SubmarineCard(skin: skin))
                          .toList(),
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

class _HangarBackButton extends StatefulWidget {
  final VoidCallback onPressed;

  const _HangarBackButton({required this.onPressed});

  @override
  State<_HangarBackButton> createState() => _HangarBackButtonState();
}

class _HangarBackButtonState extends State<_HangarBackButton> {
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
          color: AppColors.white.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: AppColors.white.withValues(alpha: 0.2),
            width: 2,
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.3),
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

class _SubmarineCard extends StatefulWidget {
  final SkinData skin;

  const _SubmarineCard({required this.skin});

  @override
  State<_SubmarineCard> createState() => _SubmarineCardState();
}

class _SubmarineCardState extends State<_SubmarineCard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final playerData = PlayerData();

    return ValueListenableBuilder<String>(
      valueListenable: playerData.equippedSkinNotifier,
      builder: (context, equippedSkinId, _) {
        return ValueListenableBuilder<int>(
          valueListenable: playerData.coinsNotifier,
          builder: (context, coins, _) {
            final isOwned = playerData.isSkinOwned(widget.skin.id);
            final isEquipped = equippedSkinId == widget.skin.id;
            final canAfford = coins >= widget.skin.price;

            return MouseRegion(
              onEnter: (_) => setState(() => _isHovered = true),
              onExit: (_) => setState(() => _isHovered = false),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                transform: Matrix4.translationValues(0, _isHovered ? -4 : 0, 0),
                child: Container(
                  width: 240,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: isEquipped
                          ? [
                              AppColors.green.withValues(alpha: 0.2),
                              AppColors.green.withValues(alpha: 0.1),
                            ]
                          : [
                              AppColors.white.withValues(alpha: 0.1),
                              AppColors.white.withValues(alpha: 0.05),
                            ],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isEquipped
                          ? AppColors.green
                          : AppColors.white.withValues(alpha: 0.2),
                      width: isEquipped ? 3 : 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isEquipped
                            ? AppColors.green.withValues(alpha: 0.2)
                            : Colors.black.withValues(alpha: 0.2),
                        blurRadius: _isHovered ? 20 : 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Top badge
                      if (isEquipped)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(vertical: 6),
                          decoration: BoxDecoration(
                            color: AppColors.green,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(17),
                              topRight: Radius.circular(17),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.check_circle,
                                color: AppColors.white,
                                size: 16,
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'ACTIVE',
                                style: GoogleFonts.comfortaa(
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.white,
                                  letterSpacing: 2,
                                ),
                              ),
                            ],
                          ),
                        ),

                      // Submarine display area
                      Container(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          children: [
                            // Submarine image with glow effect
                            Container(
                              height: 100,
                              width: 160,
                              decoration: BoxDecoration(
                                gradient: RadialGradient(
                                  colors: [
                                    AppColors.cyan.withValues(alpha: 0.3),
                                    Colors.transparent,
                                  ],
                                ),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Glow effect for equipped
                                  if (isEquipped)
                                    Container(
                                      width: 100,
                                      height: 60,
                                      decoration: BoxDecoration(
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.green.withValues(alpha: 0.3),
                                            blurRadius: 30,
                                            spreadRadius: 5,
                                          ),
                                        ],
                                      ),
                                    ),
                                  Image.asset(
                                    'assets/images/${widget.skin.assetPath}',
                                    width: 120,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Submarine name
                            Text(
                              widget.skin.name.toUpperCase(),
                              style: GoogleFonts.comfortaa(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                letterSpacing: 1,
                              ),
                            ),
                            const SizedBox(height: 16),

                            // Action button
                            _buildActionButton(
                              isEquipped: isEquipped,
                              isOwned: isOwned,
                              canAfford: canAfford,
                              playerData: playerData,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildActionButton({
    required bool isEquipped,
    required bool isOwned,
    required bool canAfford,
    required PlayerData playerData,
  }) {
    if (isEquipped) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: AppColors.green.withValues(alpha: 0.2),
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: AppColors.green, width: 2),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.anchor, color: AppColors.green, size: 18),
            const SizedBox(width: 8),
            Text(
              'DEPLOYED',
              style: GoogleFonts.comfortaa(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: AppColors.green,
              ),
            ),
          ],
        ),
      );
    } else if (isOwned) {
      return _ActionButton(
        label: 'SELECT',
        icon: Icons.touch_app_rounded,
        color: AppColors.cyan,
        onPressed: () => playerData.equipSkin(widget.skin.id),
      );
    } else {
      return _ActionButton(
        label: '${widget.skin.price}',
        icon: Icons.monetization_on,
        color: canAfford ? AppColors.gold : const Color(0xFF4A525A),
        onPressed: () {
          if (canAfford) {
            playerData.buySkin(widget.skin);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Row(
                  children: [
                    const Icon(Icons.warning_rounded, color: AppColors.gold),
                    const SizedBox(width: 12),
                    Text(
                      'Insufficient credits!',
                      style: GoogleFonts.comfortaa(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                backgroundColor: AppColors.deepNavy,
                behavior: SnackBarBehavior.floating,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            );
          }
        },
      );
    }
  }
}

class _ActionButton extends StatefulWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  const _ActionButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  @override
  State<_ActionButton> createState() => _ActionButtonState();
}

class _ActionButtonState extends State<_ActionButton> {
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
        width: double.infinity,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: widget.color,
          borderRadius: BorderRadius.circular(30),
          border: Border.all(
            color: widget.color == AppColors.gold
                ? AppColors.deepNavy
                : Colors.transparent,
            width: 2,
          ),
          boxShadow: _isPressed
              ? []
              : [
                  BoxShadow(
                    color: widget.color.withValues(alpha: 0.5),
                    offset: const Offset(0, 2),
                    blurRadius: 0,
                  ),
                ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              widget.icon,
              color: widget.color == AppColors.gold
                  ? AppColors.deepNavy
                  : AppColors.white,
              size: 18,
            ),
            const SizedBox(width: 8),
            Text(
              widget.label,
              style: GoogleFonts.comfortaa(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: widget.color == AppColors.gold
                    ? AppColors.deepNavy
                    : AppColors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Grid pattern painter for hangar background
class _GridPatternPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withValues(alpha: 0.03)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    const spacing = 40.0;

    // Vertical lines
    for (double x = 0; x < size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Horizontal lines
    for (double y = 0; y < size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }

    // Diagonal accent lines
    final accentPaint = Paint()
      ..color = AppColors.gold.withValues(alpha: 0.05)
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    for (double i = -size.height; i < size.width; i += 100) {
      canvas.drawLine(
        Offset(i, 0),
        Offset(i + size.height, size.height),
        accentPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
