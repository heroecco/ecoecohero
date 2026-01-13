import 'package:eco_hero/game/obstacle.dart';

class LevelData {
  final int number;
  final double scrollSpeed;
  final int totalTrashCount;
  final double distance;
  final List<ObstacleType> enabledObstacles;
  /// Chance of spawning an obstacle vs trash (0.0 to 1.0)
  /// Higher values = more obstacles = harder level
  final double obstacleSpawnChance;
  /// Time limit in seconds to complete the level
  final int timeLimit;

  const LevelData({
    required this.number,
    required this.scrollSpeed,
    required this.totalTrashCount,
    required this.distance,
    required this.enabledObstacles,
    this.obstacleSpawnChance = 0.2,
    required this.timeLimit,
  });
}

final List<LevelData> levels = [
  // Level 1: Very easy intro - slow speed, few obstacles (10% chance)
  // Generous time limit for beginners
  const LevelData(
    number: 1,
    scrollSpeed: 80,
    totalTrashCount: 12,
    distance: 5000,
    enabledObstacles: [ObstacleType.fish],
    obstacleSpawnChance: 0.10,
    timeLimit: 90, // 90 seconds - very generous
  ),
  // Level 2: Still easy - slightly faster, 15% obstacle chance
  const LevelData(
    number: 2,
    scrollSpeed: 90,
    totalTrashCount: 15,
    distance: 5000,
    enabledObstacles: [ObstacleType.fish],
    obstacleSpawnChance: 0.15,
    timeLimit: 80, // 80 seconds
  ),
  // Level 3: Introduce rocks, 20% obstacle chance
  const LevelData(
    number: 3,
    scrollSpeed: 100,
    totalTrashCount: 18,
    distance: 5500,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock],
    obstacleSpawnChance: 0.20,
    timeLimit: 75, // 75 seconds
  ),
  // Level 4: Moderate, 25% obstacle chance
  const LevelData(
    number: 4,
    scrollSpeed: 110,
    totalTrashCount: 20,
    distance: 6000,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock],
    obstacleSpawnChance: 0.25,
    timeLimit: 75, // 75 seconds
  ),
  // Level 5: Medium difficulty, introduce jellyfish, 28% obstacle chance
  const LevelData(
    number: 5,
    scrollSpeed: 120,
    totalTrashCount: 22,
    distance: 6500,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock, ObstacleType.jellyfish],
    obstacleSpawnChance: 0.28,
    timeLimit: 70, // 70 seconds
  ),
  // Level 6: Getting challenging, 32% obstacle chance
  const LevelData(
    number: 6,
    scrollSpeed: 130,
    totalTrashCount: 25,
    distance: 7000,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock, ObstacleType.jellyfish],
    obstacleSpawnChance: 0.32,
    timeLimit: 70, // 70 seconds
  ),
  // Level 7: Challenging, 35% obstacle chance
  const LevelData(
    number: 7,
    scrollSpeed: 140,
    totalTrashCount: 28,
    distance: 7500,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock, ObstacleType.jellyfish],
    obstacleSpawnChance: 0.35,
    timeLimit: 65, // 65 seconds
  ),
  // Level 8: Hard, 38% obstacle chance
  const LevelData(
    number: 8,
    scrollSpeed: 150,
    totalTrashCount: 30,
    distance: 8000,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock, ObstacleType.jellyfish],
    obstacleSpawnChance: 0.38,
    timeLimit: 65, // 65 seconds
  ),
  // Level 9: Very hard, 42% obstacle chance
  const LevelData(
    number: 9,
    scrollSpeed: 160,
    totalTrashCount: 32,
    distance: 9000,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock, ObstacleType.jellyfish],
    obstacleSpawnChance: 0.42,
    timeLimit: 65, // 65 seconds
  ),
  // Level 10: Expert, 45% obstacle chance
  const LevelData(
    number: 10,
    scrollSpeed: 180,
    totalTrashCount: 35,
    distance: 10000,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock, ObstacleType.jellyfish],
    obstacleSpawnChance: 0.45,
    timeLimit: 65, // 65 seconds - tighter!
  ),
  // Level 11: Master - significantly faster, 50% obstacles
  const LevelData(
    number: 11,
    scrollSpeed: 200,
    totalTrashCount: 38,
    distance: 11000,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock, ObstacleType.jellyfish],
    obstacleSpawnChance: 0.50,
    timeLimit: 60, // 60 seconds
  ),
  // Level 12: Legendary - extreme speed, heavy obstacle density
  const LevelData(
    number: 12,
    scrollSpeed: 220,
    totalTrashCount: 42,
    distance: 12000,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock, ObstacleType.jellyfish],
    obstacleSpawnChance: 0.55,
    timeLimit: 60, // 60 seconds
  ),
  // Level 13: Ultimate - maximum challenge!
  const LevelData(
    number: 13,
    scrollSpeed: 250,
    totalTrashCount: 45,
    distance: 13000,
    enabledObstacles: [ObstacleType.fish, ObstacleType.rock, ObstacleType.jellyfish],
    obstacleSpawnChance: 0.60,
    timeLimit: 55, // 55 seconds - brutal!
  ),
];

