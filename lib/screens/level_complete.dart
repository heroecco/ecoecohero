import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../data/levels.dart';
import '../game/eco_hero_game.dart';
import '../utils/app_colors.dart';
import '../widgets/eco_button.dart';
import '../widgets/eco_panel.dart';

class LevelCompleteMenu extends StatelessWidget {
  final EcoHeroGame game;

  const LevelCompleteMenu({super.key, required this.game});

  /// Navigate to a new level by replacing the current game screen
  void _navigateToLevel(BuildContext context, int levelNumber) {
    // Use pushReplacementNamed to dispose the old game and start fresh
    Navigator.of(context).pushReplacementNamed('/game', arguments: levelNumber);
  }

  @override
  Widget build(BuildContext context) {
    // Calculate next level (wrap to 1 if past last level)
    final int nextLevel = game.currentLevelIndex < levels.length
        ? game.currentLevelIndex + 1
        : 1;

    final screenSize = MediaQuery.of(context).size;
    final isSmallScreen = screenSize.width < 400;

    // Responsive sizing
    final double maxPanelWidth = screenSize.width * 0.85;
    final double panelWidth = maxPanelWidth.clamp(280.0, 380.0);
    final double titleSize = isSmallScreen ? 22 : 26;
    final double starSize = isSmallScreen ? 36 : 42;
    final double scoreSize = isSmallScreen ? 18 : 20;
    final double coinSize = isSmallScreen ? 18 : 20;
    final double spacing = isSmallScreen ? 12 : 16;

    return Center(
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: spacing),
          child: EcoPanel(
            width: panelWidth,
            padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'LEVEL COMPLETE!',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.comfortaa(
                    fontSize: titleSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.gold,
                    shadows: [
                      const Shadow(
                        color: AppColors.deepNavy,
                        offset: Offset(2, 2),
                        blurRadius: 0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: spacing),

                // Stars Display
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(3, (index) {
                    // If index < starsEarned, show full star. Else empty/border.
                    // e.g. 2 stars = indices 0, 1 are full. index 2 is empty.
                    return Icon(
                      index < game.starsEarned ? Icons.star : Icons.star_border,
                      color: AppColors.gold,
                      size: starSize,
                    );
                  }),
                ),
                SizedBox(height: spacing),

                Text(
                  'Score: ${game.score}',
                  style: GoogleFonts.comfortaa(
                    fontSize: scoreSize,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepNavy,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.monetization_on,
                      color: AppColors.gold,
                      size: coinSize + 4,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '+${game.coinsEarned}',
                      style: GoogleFonts.comfortaa(
                        fontSize: coinSize,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepNavy,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: spacing * 1.5),
                EcoButton(
                  text: 'NEXT LEVEL',
                  onPressed: () => _navigateToLevel(context, nextLevel),
                  width: double.infinity,
                ),
                SizedBox(height: spacing * 0.75),
                EcoButton(
                  text: 'REPLAY',
                  color: AppColors.cyan,
                  onPressed: () =>
                      _navigateToLevel(context, game.currentLevelIndex),
                  width: double.infinity,
                ),
                SizedBox(height: spacing * 0.75),
                EcoButton(
                  text: 'HOME',
                  color: AppColors.deepNavy,
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  width: double.infinity,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
