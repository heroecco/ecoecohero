import 'package:flutter/foundation.dart';
import 'skin_data.dart';

class PlayerData {
  static final PlayerData _instance = PlayerData._internal();
  factory PlayerData() => _instance;
  PlayerData._internal();

  // Notifiers for UI updates
  final ValueNotifier<int> coinsNotifier = ValueNotifier<int>(0);
  final ValueNotifier<String> equippedSkinNotifier = ValueNotifier<String>('default');
  final ValueNotifier<int> highestLevelUnlockedNotifier = ValueNotifier<int>(1);

  // Internal state
  int _coins = 2500; // Giving some starter coins for testing/MVP
  List<String> _ownedSkins = ['default'];
  String _equippedSkin = 'default';
  int _highestLevelUnlocked = 1; // Level 1 is unlocked by default

  int get coins => _coins;
  String get equippedSkin => _equippedSkin;
  int get highestLevelUnlocked => _highestLevelUnlocked;

  bool isSkinOwned(String skinId) {
    return _ownedSkins.contains(skinId);
  }

  void addCoins(int amount) {
    _coins += amount;
    coinsNotifier.value = _coins;
  }

  bool buySkin(SkinData skin) {
    if (_coins >= skin.price && !isSkinOwned(skin.id)) {
      _coins -= skin.price;
      _ownedSkins.add(skin.id);
      coinsNotifier.value = _coins;
      equipSkin(skin.id); // Auto-equip on buy
      return true;
    }
    return false;
  }

  void equipSkin(String skinId) {
    if (isSkinOwned(skinId)) {
      _equippedSkin = skinId;
      equippedSkinNotifier.value = _equippedSkin;
    }
  }

  /// Check if a level is unlocked
  bool isLevelUnlocked(int level) {
    return level <= _highestLevelUnlocked;
  }

  /// Unlock the next level after completing a level
  void completeLevel(int levelCompleted) {
    // Unlock the next level if this is the highest completed
    if (levelCompleted >= _highestLevelUnlocked) {
      _highestLevelUnlocked = levelCompleted + 1;
      highestLevelUnlockedNotifier.value = _highestLevelUnlocked;
    }
  }

  // Temporary method to load initial data or reset
  void reset() {
    _coins = 0;
    _ownedSkins = ['default'];
    _equippedSkin = 'default';
    _highestLevelUnlocked = 1;
    coinsNotifier.value = _coins;
    equippedSkinNotifier.value = _equippedSkin;
    highestLevelUnlockedNotifier.value = _highestLevelUnlocked;
  }
}

