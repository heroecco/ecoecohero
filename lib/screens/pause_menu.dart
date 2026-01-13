import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/eco_hero_game.dart';
import '../utils/app_colors.dart';
import '../widgets/eco_button.dart';
import '../widgets/eco_panel.dart';

class PauseMenu extends StatelessWidget {
  final EcoHeroGame game;

  const PauseMenu({super.key, required this.game});

  /// Restart the current level by replacing the game screen
  void _restartLevel(BuildContext context) {
    Navigator.of(
      context,
    ).pushReplacementNamed('/game', arguments: game.currentLevelIndex);
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
              'PAUSED',
              style: GoogleFonts.comfortaa(
                fontSize: 40,
                fontWeight: FontWeight.bold,
                color: AppColors.deepNavy,
              ),
            ),
            const SizedBox(height: 32),
            EcoButton(
              text: 'RESUME',
              onPressed: () => game.resumeGame(),
              width: double.infinity,
            ),
            const SizedBox(height: 16),
            EcoButton(
              text: 'RESTART',
              color: AppColors.cyan,
              onPressed: () => _restartLevel(context),
              width: double.infinity,
            ),
            const SizedBox(height: 16),
            EcoButton(
              text: 'QUIT',
              color: AppColors.red,
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
