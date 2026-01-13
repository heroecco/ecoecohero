import 'package:flame/collisions.dart';
import 'package:flame/components.dart';
import 'package:eco_hero/game/eco_hero_game.dart';

enum TrashType {
  bottle,
  bag,
  tire,
  healthKit,
}

class Trash extends SpriteComponent with HasGameReference<EcoHeroGame> {
  final TrashType type;
  final double speed;

  Trash({
    required this.type,
    this.speed = 200.0, // Default speed, can be adjusted
  }) : super(priority: 0); // Render behind player but in front of background? Actually player is 1, so 0 is fine.

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // Load sprite based on type
    String spriteName;
    switch (type) {
      case TrashType.bottle:
        spriteName = 'trash_bottle.png';
        break;
      case TrashType.bag:
        spriteName = 'trash_bag.png';
        break;
      case TrashType.tire:
        spriteName = 'trash_tire.png';
        break;
      case TrashType.healthKit:
        spriteName = 'item_healthkit.png';
        break;
    }

    sprite = await game.loadSprite(spriteName);

    // Set size
    final originalSize = sprite!.originalSize;
    // Scale items to be reasonable size, e.g., 50 width
    const double targetWidth = 50.0;
    final scaleFactor = targetWidth / originalSize.x;
    size = originalSize * scaleFactor;

    anchor = Anchor.center;

    // Add hitbox
    add(CircleHitbox(radius: size.x / 2 * 0.8, anchor: Anchor.center, position: size / 2));
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move left
    position.x -= speed * dt;

    // Remove if off screen
    if (position.x < -size.x) {
      removeFromParent();
    }
  }
}

