import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'package:eco_hero/game/eco_hero_game.dart';

class CleaningOverlay extends PositionComponent with HasGameReference<EcoHeroGame> {
  // Add an opacity property that can be controlled externally or internally
  double _opacity = 0.6;
  
  set opacity(double value) {
    _opacity = value.clamp(0.0, 1.0);
  }

  CleaningOverlay() : super(priority: 5); // Render above most things, below HUD

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    size = game.size;
    // Ensure it covers the whole screen
    position = Vector2.zero();
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    this.size = size;
  }

  @override
  void render(Canvas canvas) {
    // Opacity is now controlled by the Game class update loop
    // But we should ensure we start with the calculation if not updated yet?
    // Actually, let's just respect the _opacity field.
    // The Game loop updates it based on trash count.

    // Don't draw if invisible
    if (_opacity <= 0.01) return;

    canvas.drawRect(
      size.toRect(),
      Paint()..color = Color.fromRGBO(74, 82, 90, _opacity), // #4A525A
    );
  }
}
