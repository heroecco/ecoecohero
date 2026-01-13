import 'package:eco_hero/data/player_data.dart';
import 'package:eco_hero/data/levels.dart';
import 'package:eco_hero/game/background.dart';
import 'package:eco_hero/game/cleaning_overlay.dart';
import 'package:eco_hero/game/player.dart';
import 'package:eco_hero/game/spawn_manager.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_audio/flame_audio.dart';
import 'package:flutter/material.dart';

/// Main game class for Eco Hero
/// 
/// This is the entry point for the Flame game engine.
/// Add your game components, systems, and logic here.
class EcoHeroGame extends FlameGame
    with HasCollisionDetection, TapCallbacks, DragCallbacks {
  
  final int initialLevel;
  EcoHeroGame({this.initialLevel = 1});

  /// Game state
  bool _isGameOver = false;
  bool _isPaused = false;
  bool _isLevelComplete = false;
  
  /// Score tracking
  int score = 0;
  int coinsEarned = 0;
  int starsEarned = 0;
  int health = 3;
  final int maxHealth = 3;
  int trashCollected = 0;
  
  /// Notifiers for HUD
  final ValueNotifier<int> healthNotifier = ValueNotifier<int>(3);
  final ValueNotifier<int> scoreNotifier = ValueNotifier<int>(0);
  final ValueNotifier<double> cleaningProgressNotifier = ValueNotifier<double>(0.0);
  final ValueNotifier<bool> levelCompleteNotifier = ValueNotifier<bool>(false);
  final ValueNotifier<double> timerNotifier = ValueNotifier<double>(0.0);
  
  /// Timer tracking
  double timeRemaining = 0;

  /// Level management
  int currentLevelIndex = 1; // 1-based index
  LevelData? currentLevel;
  double distanceTraveled = 0;

  /// Components
  late Player _player;
  late WorldBackground _background;
  late SpawnManager _spawnManager;
  late CleaningOverlay _cleaningOverlay;

  @override
  void onRemove() {
    // Stop background music when leaving the game
    FlameAudio.bgm.stop();
    super.onRemove();
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Load requested level
    _loadLevel(initialLevel);

    // Load background
    double speed = currentLevel?.scrollSpeed ?? 200;
    _background = WorldBackground(levelSpeed: speed);
    _background.priority = -10;
    await add(_background);

    // Load cleaning overlay
    _cleaningOverlay = CleaningOverlay();
    _cleaningOverlay.priority = 2; // Over BG, items, player (1). Under HUD.
    await add(_cleaningOverlay);

    // Load player
    _player = Player();
    await add(_player);

    // Load spawn manager
    _spawnManager = SpawnManager();
    await add(_spawnManager);
    
    // Preload audio
    await FlameAudio.audioCache.loadAll([
      'sfx_collect.mp3',
      'sfx_hit.mp3',
      'bgm_ocean.mp3',
    ]);
    
    // Start background music (loops by default)
    FlameAudio.bgm.play('bgm_ocean.mp3', volume: 0.5);
    
    debugPrint('Eco Hero Game loaded successfully!');
  }

  void _loadLevel(int levelNumber) {
    if (levelNumber < 1 || levelNumber > levels.length) {
      // Fallback or end game
      levelNumber = 1;
    }
    currentLevelIndex = levelNumber;
    currentLevel = levels.firstWhere((l) => l.number == levelNumber);
    
    // Reset level state
    distanceTraveled = 0;
    trashCollected = 0;
    _isLevelComplete = false;
    levelCompleteNotifier.value = false;
    cleaningProgressNotifier.value = 0.0;
    
    // Initialize timer from level data
    timeRemaining = currentLevel!.timeLimit.toDouble();
    timerNotifier.value = timeRemaining;
    
    debugPrint('Loaded Level $levelNumber: ${currentLevel!.distance}m distance, ${currentLevel!.timeLimit}s time limit');
  }

  @override
  void update(double dt) {
    if (_isPaused || _isGameOver || _isLevelComplete) {
      // Allow component lifecycle to process (add/remove) even when game logic is paused
      super.update(0);
      return;
    }
    super.update(dt);
    
    // Update distance
    if (currentLevel != null) {
      // Distance = speed * time
      distanceTraveled += currentLevel!.scrollSpeed * dt;
      
      // Update timer countdown
      timeRemaining -= dt;
      timerNotifier.value = timeRemaining;
      
      // Check if time ran out
      if (timeRemaining <= 0) {
        timeRemaining = 0;
        timerNotifier.value = 0;
        gameOver();
        return;
      }
      
      // Update cleaning progress (based on trash collected / total trash)
      // Note: We clamp it because we might collect bonus trash or logic might vary
      if (currentLevel!.totalTrashCount > 0) {
        double progress = trashCollected / currentLevel!.totalTrashCount;
        cleaningProgressNotifier.value = progress.clamp(0.0, 1.0);
        // Also update the visual overlay opacity (1.0 progress = 0.0 opacity)
        _cleaningOverlay.opacity = (1.0 - progress).clamp(0.0, 0.6);
      }

      // Check win condition
      if (distanceTraveled >= currentLevel!.distance) {
        completeLevel();
      }
    }
  }

  @override
  void render(Canvas canvas) {
    // Render background color behind the parallax layers
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.x, size.y),
      Paint()..color = const Color(0xFF006994), // Deep ocean blue
    );
    
    super.render(canvas);
  }

  @override
  void onTapDown(TapDownEvent event) {
    super.onTapDown(event);
    
    // Handle tap events - check all blocking states
    if (!_isPaused && !_isGameOver && !_isLevelComplete) {
      _player.updatePosition(event.localPosition.y);
    }
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    super.onDragUpdate(event);

    if (!_isPaused && !_isGameOver && !_isLevelComplete) {
       _player.updatePosition(event.localEndPosition.y);
    }
  }

  @override
  void onDragStart(DragStartEvent event) {
    super.onDragStart(event);
    
    if (!_isPaused && !_isGameOver && !_isLevelComplete) {
       _player.updatePosition(event.localPosition.y);
    }
  }

  /// Pause the game
  void pauseGame() {
    // Don't allow pausing when level is complete or game over
    if (_isLevelComplete || _isGameOver) return;
    
    _isPaused = true;
    overlays.add('pause');
    FlameAudio.bgm.pause();
    pauseEngine();
  }

  /// Resume the game
  void resumeGame() {
    _isPaused = false;
    overlays.remove('pause');
    FlameAudio.bgm.resume();
    resumeEngine();
  }

  /// Trigger game over state
  void gameOver() {
    _isGameOver = true;
    overlays.add('gameOver');
    pauseEngine();
  }

  /// Add points to the score
  void addScore(int points) {
    score += points;
    trashCollected++;
    scoreNotifier.value = score;
    // Play collect sound (optional here, or in collision logic)
  }

  /// Player takes damage (with optional score penalty)
  void takeDamage({int scorePenalty = 0}) {
    if (_isGameOver || _isLevelComplete) return;
    
    health--;
    healthNotifier.value = health;
    FlameAudio.play('sfx_hit.mp3');
    _player.flashRed();
    
    // Apply score penalty (don't go below 0)
    if (scorePenalty > 0) {
      score = (score - scorePenalty).clamp(0, score);
      scoreNotifier.value = score;
    }
    
    if (health <= 0) {
      gameOver();
    }
  }

  /// Player heals
  void healPlayer() {
    if (_isGameOver || _isLevelComplete || health >= maxHealth) return;
    
    health++;
    healthNotifier.value = health;
    FlameAudio.play('sfx_collect.mp3'); 
  }

  void playCollectSound() {
    FlameAudio.play('sfx_collect.mp3');
  }
  
  void completeLevel() {
    _isLevelComplete = true;
    levelCompleteNotifier.value = true;
    
    // Calculate coins (e.g., 1 coin per 10 points)
    coinsEarned = (score / 10).floor();
    
    // Calculate stars
    // 1 Star: Finish (default if here)
    // 2 Stars: 50% trash
    // 3 Stars: 90% trash
    starsEarned = 1;
    if (currentLevel != null && currentLevel!.totalTrashCount > 0) {
      double pct = trashCollected / currentLevel!.totalTrashCount;
      if (pct >= 0.9) {
        starsEarned = 3;
      } else if (pct >= 0.5) {
        starsEarned = 2;
      }
    }

    // Award coins
    PlayerData().addCoins(coinsEarned);
    
    // Unlock next level
    PlayerData().completeLevel(currentLevelIndex);
    
    pauseEngine();
    overlays.add('levelComplete');
  }
}
