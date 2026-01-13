import 'dart:math';

import 'package:flame/components.dart';
import 'package:eco_hero/game/eco_hero_game.dart';
import 'package:eco_hero/game/trash.dart';
import 'package:eco_hero/game/obstacle.dart';

class SpawnManager extends Component with HasGameReference<EcoHeroGame> {
  final Random _random = Random();
  late Timer _spawnTimer;

  SpawnManager() {
    // Slower spawn rate (2.0s instead of 1.5s) for easier gameplay
    _spawnTimer = Timer(2.0, onTick: _spawnItem, repeat: true);
  }

  @override
  void update(double dt) {
    _spawnTimer.update(dt);
  }

  void _spawnItem() {
    // Check if level is loaded
    if (game.currentLevel == null) return;
    
    final level = game.currentLevel!;
    
    // Update timer limit based on level data if needed
    // Calculate required spawn interval to make level beatable
    // Time = Distance / Speed
    // Spawns = TotalTrash / trashSpawnChance (1 - obstacleSpawnChance)
    // Interval = Time / Spawns
    if (level.scrollSpeed > 0 && level.totalTrashCount > 0) {
      final double timeToComplete = level.distance / level.scrollSpeed;
      final double trashSpawnChance = 1.0 - level.obstacleSpawnChance;
      // Add buffer (1.3x) to ensure enough trash spawns
      final double estimatedSpawnsNeeded = (level.totalTrashCount * 1.3) / trashSpawnChance; 
      
      if (estimatedSpawnsNeeded > 0) {
        final double requiredInterval = timeToComplete / estimatedSpawnsNeeded;
        // Clamp to reasonable limits (faster spawn at higher levels)
        // Min 0.4s at hardest, max 1.8s at easiest
        final double newLimit = requiredInterval.clamp(0.4, 1.8);
        
        if ((_spawnTimer.limit - newLimit).abs() > 0.1) {
             _spawnTimer.limit = newLimit;
        }
      }
    }
    
    // Use level's obstacle spawn chance for difficulty scaling
    // Higher levels have higher obstacle spawn chance
    final double obstacleChance = level.obstacleSpawnChance;
    
    if (_random.nextDouble() >= obstacleChance) {
      _spawnTrash();
    } else {
      _spawnObstacle();
    }
  }

  void _spawnTrash() {
    // Trash spawn probabilities (more health kits for easier gameplay)
    final double roll = _random.nextDouble();
    TrashType type;

    if (roll < 0.45) {
      type = TrashType.bottle;
    } else if (roll < 0.75) {
      type = TrashType.bag;
    } else if (roll < 0.90) {
      type = TrashType.tire;
    } else {
      type = TrashType.healthKit; // 10% chance (doubled from 5%)
    }
    
    // Use level speed
    final double speed = game.currentLevel!.scrollSpeed;

    final trash = Trash(type: type, speed: speed);
    _positionComponent(trash);
    game.add(trash);
  }

  void _spawnObstacle() {
    final List<ObstacleType> allowed = game.currentLevel!.enabledObstacles;
    if (allowed.isEmpty) return;

    // Pick random allowed type
    final ObstacleType type = allowed[_random.nextInt(allowed.length)];

    // Use level speed
    final double speed = game.currentLevel!.scrollSpeed;

    final obstacle = Obstacle(type: type, speed: speed);
    _positionComponent(obstacle);
    game.add(obstacle);
  }

  void _positionComponent(PositionComponent component) {
    // Spawn off-screen right
    final double x = game.size.x + 50;
    
    // Random Y
    // Avoid top and bottom margins
    final double minY = 100;
    final double maxY = game.size.y - 100;
    final double y = minY + _random.nextDouble() * (maxY - minY);

    component.position = Vector2(x, y);
  }
}

