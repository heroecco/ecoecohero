import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/eco_hero_game.dart';
import '../utils/app_colors.dart';
import '../widgets/eco_button.dart';
import '../widgets/eco_panel.dart';

class GameOverMenu extends StatelessWidget {
  final EcoHeroGame game;

  const GameOverMenu({super.key, required this.game});

  /// Restart the current level by replacing the game screen
  void _restartLevel(BuildContext context) {
    Navigator.of(context).pushReplacementNamed(
      '/game',
      arguments: game.currentLevelIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: EcoPanel(
        width: 400,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'GAME OVER',
              style: GoogleFonts.comfortaa(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.red,
              ),
            ),
            const SizedBox(height: 32),
            EcoButton(
              text: 'TRY AGAIN',
              onPressed: () => _restartLevel(context),
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

