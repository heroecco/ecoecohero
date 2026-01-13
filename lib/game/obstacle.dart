import 'dart:math';
import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:eco_hero/game/eco_hero_game.dart';

enum ObstacleType {
  rock,
  fish,
  jellyfish,
}

class Obstacle extends SpriteComponent with HasGameReference<EcoHeroGame> {
  final ObstacleType type;
  final double speed;
  double _time = 0; // For bobbing animation

  Obstacle({
    required this.type,
    this.speed = 200.0,
  }) : super(priority: 0);

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    String spriteName;
    switch (type) {
      case ObstacleType.rock:
        spriteName = 'obstacle_rock.png';
        break;
      case ObstacleType.fish:
        spriteName = 'obstacle_fish.png';
        break;
      case ObstacleType.jellyfish:
        spriteName = 'obstacle_jelly.png';
        break;
    }

    sprite = await game.loadSprite(spriteName);

    // Scale
    final originalSize = sprite!.originalSize;
    double targetWidth = 60.0;
    if (type == ObstacleType.rock) targetWidth = 80.0;
    
    final scaleFactor = targetWidth / originalSize.x;
    size = originalSize * scaleFactor;

    anchor = Anchor.center;

    // Add hitbox
    // Rocks might need a rectangular hitbox, others circular
    if (type == ObstacleType.rock) {
       add(RectangleHitbox.relative(Vector2(0.9, 0.8), parentSize: size, position: Vector2(size.x * 0.05, size.y * 0.2)));
    } else {
       add(CircleHitbox(radius: size.x / 2 * 0.8, anchor: Anchor.center, position: size / 2));
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move left
    position.x -= speed * dt;

    // Jellyfish bobbing
    if (type == ObstacleType.jellyfish) {
      _time += dt;
      // Bob up and down using sine wave
      // Amplitude 50 pixels/s roughly? No, simple offset.
      // We modify Y position directly? Or add to a base?
      // Since it's moving, let's just add velocity to Y.
      // position.y += sin(_time * 3) * 1.0; // This would accumulate
      
      // Better: position.y = initialY + offset
      // But we don't store initialY easily without extra field.
      // Let's just oscillate the velocity.
      // Or easier: add a vertical velocity component.
      
      position.y += sin(_time * 5) * 60 * dt; 
    }

    // Remove if off screen
    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}

