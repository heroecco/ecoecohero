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
    
    return Center(
      child: EcoPanel(
        width: 450,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'LEVEL COMPLETE!',
              textAlign: TextAlign.center,
              style: GoogleFonts.comfortaa(
                fontSize: 32,
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
            const SizedBox(height: 24),
            
            // Stars Display
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(3, (index) {
                // If index < starsEarned, show full star. Else empty/border.
                // e.g. 2 stars = indices 0, 1 are full. index 2 is empty.
                return Icon(
                  index < game.starsEarned ? Icons.star : Icons.star_border,
                  color: AppColors.gold,
                  size: 48,
                );
              }),
            ),
            const SizedBox(height: 24),

            Text(
              'Score: ${game.score}',
              style: GoogleFonts.comfortaa(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: AppColors.deepNavy,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.monetization_on, color: AppColors.gold, size: 28),
                const SizedBox(width: 8),
                Text(
                  '+${game.coinsEarned}',
                  style: GoogleFonts.comfortaa(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: AppColors.deepNavy,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 32),
            EcoButton(
              text: 'NEXT LEVEL',
              onPressed: () => _navigateToLevel(context, nextLevel),
              width: double.infinity,
            ),
            const SizedBox(height: 16),
            EcoButton(
              text: 'REPLAY',
              color: AppColors.cyan,
              onPressed: () => _navigateToLevel(context, game.currentLevelIndex),
              width: double.infinity,
            ),
            const SizedBox(height: 16),
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
    );
  }
}
