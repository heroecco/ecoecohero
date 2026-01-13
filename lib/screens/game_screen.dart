import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import '../game/eco_hero_game.dart';
import '../widgets/game_hud.dart';
import 'pause_menu.dart';
import 'game_over.dart';
import 'level_complete.dart';

class GameScreen extends StatelessWidget {
  final int levelNumber;

  const GameScreen({super.key, required this.levelNumber});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GameWidget<EcoHeroGame>.controlled(
        gameFactory: () => EcoHeroGame(initialLevel: levelNumber),
        overlayBuilderMap: {
          'hud': (context, game) => GameHud(game: game),
          'pause': (context, game) => PauseMenu(game: game),
          'gameOver': (context, game) => GameOverMenu(game: game),
          'levelComplete': (context, game) => LevelCompleteMenu(game: game),
        },
        initialActiveOverlays: const ['hud'],
      ),
    );
  }
}

