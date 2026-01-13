import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:flame/effects.dart';
import 'package:flutter/material.dart';
import 'package:eco_hero/game/eco_hero_game.dart';
import 'package:eco_hero/game/trash.dart';
import 'package:eco_hero/game/obstacle.dart';
import 'package:eco_hero/game/particles.dart';
import '../data/player_data.dart';
import '../data/skin_data.dart';

class Player extends SpriteComponent with HasGameReference<EcoHeroGame>, CollisionCallbacks {
  Player() : super(priority: 1); // Render above background

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Get equipped skin
    final playerData = PlayerData();
    final equippedSkinId = playerData.equippedSkin;
    final skinData = SkinData.allSkins.firstWhere(
      (s) => s.id == equippedSkinId,
      orElse: () => SkinData.allSkins.first,
    );
    
    // Load the selected skin
    sprite = await game.loadSprite(skinData.assetPath);
    
    // Set size based on the sprite's original size, scaled down if necessary
    // Assuming standard sprite size, but let's set a reasonable game size
    // We can adjust this after seeing it on screen.
    // Preserving aspect ratio is key.
    final originalSize = sprite!.originalSize;
    final scaleFactor = 100.0 / originalSize.x; // Target width 100
    size = originalSize * scaleFactor;

    // Initial position: Left side, centered vertically
    position = Vector2(game.size.x * 0.1, game.size.y / 2);
    anchor = Anchor.center;

    // Add collision hitbox (slightly smaller than sprite for better feel)
    add(RectangleHitbox.relative(Vector2(0.8, 0.6), parentSize: size));
  }

  /// Updates the player's vertical position based on input
  void updatePosition(double y) {
    // Clamp Y to screen bounds
    // Keep some padding so the sub doesn't go half off-screen
    final double minY = size.y / 2;
    final double maxY = game.size.y - (size.y / 2);
    
    position.y = y.clamp(minY, maxY);
  }

  @override
  void onCollisionStart(Set<Vector2> intersectionPoints, PositionComponent other) {
    super.onCollisionStart(intersectionPoints, other);

    // Get collision point for particle effects
    final collisionPoint = intersectionPoints.isNotEmpty
        ? intersectionPoints.first
        : other.position;

    if (other is Trash) {
      if (other.type == TrashType.healthKit) {
        game.healPlayer();
        // Green sparkle effect for health pickup
        game.add(CollectParticleEffect(position: collisionPoint));
      } else {
        int points = 0;
        switch (other.type) {
          case TrashType.bottle: points = 10; break;
          case TrashType.bag: points = 20; break;
          case TrashType.tire: points = 50; break;
          default: points = 0;
        }
        game.addScore(points);
        game.playCollectSound();

        // Spawn positive particle effect at collision point
        game.add(CollectParticleEffect(position: collisionPoint));

        // Show score popup
        game.add(ScorePopup(
          position: collisionPoint.clone(),
          points: points,
          isPositive: true,
        ));
      }
      other.removeFromParent();
    } else if (other is Obstacle) {
      // Calculate score penalty based on obstacle type
      // Fish: -15 points (common, lower penalty)
      // Rock: -25 points (avoidable, medium penalty)
      // Jellyfish: -20 points (tricky movement, medium penalty)
      int penalty = 0;
      switch (other.type) {
        case ObstacleType.fish:
          penalty = 15;
          break;
        case ObstacleType.rock:
          penalty = 25;
          break;
        case ObstacleType.jellyfish:
          penalty = 20;
          break;
      }

      // Spawn hit particle effect (red mist/splash)
      game.add(HitParticleEffect(position: collisionPoint));

      // Show penalty popup
      game.add(ScorePopup(
        position: collisionPoint.clone(),
        points: penalty,
        isPositive: false,
      ));

      // Add screen flash effect for extra impact
      game.add(DamageFlashOverlay());

      // Take damage with score penalty
      game.takeDamage(scorePenalty: penalty);

      // Remove the obstacle so we don't hit it again immediately
      other.removeFromParent();
    }
  }

  void flashRed() {
    add(
      ColorEffect(
        Colors.red,
        EffectController(
          duration: 0.2,
          reverseDuration: 0.2,
          repeatCount: 1, 
        ),
        opacityTo: 0.8,
      ),
    );
  }
}
