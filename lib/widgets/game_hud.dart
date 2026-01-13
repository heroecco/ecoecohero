import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../game/eco_hero_game.dart';
import '../utils/app_colors.dart';

class GameHud extends StatelessWidget {
  final EcoHeroGame game;

  const GameHud({super.key, required this.game});

  /// Formats seconds into MM:SS format
  String _formatTime(double seconds) {
    int totalSeconds = seconds.ceil();
    int minutes = totalSeconds ~/ 60;
    int secs = totalSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    // Use SafeArea and Align to position HUD at top only, allowing touch pass-through
    return SafeArea(
      child: Align(
        alignment: Alignment.topCenter,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Only take up needed space
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Health Hearts
                  ValueListenableBuilder<int>(
                    valueListenable: game.healthNotifier,
                    builder: (context, health, _) {
                      return Row(
                        children: List.generate(3, (index) {
                          return Icon(
                            index < health ? Icons.favorite : Icons.favorite_border,
                            color: AppColors.red,
                            size: 32,
                          );
                        }),
                      );
                    },
                  ),
                  
                  // Progress Bar
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 24),
                      child: ValueListenableBuilder<double>(
                        valueListenable: game.cleaningProgressNotifier,
                        builder: (context, progress, _) {
                          return Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(10),
                                child: LinearProgressIndicator(
                                  value: progress.clamp(0.0, 1.0),
                                  minHeight: 16,
                                  backgroundColor: AppColors.white.withValues(alpha: 0.3),
                                  valueColor: const AlwaysStoppedAnimation<Color>(AppColors.green),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'CLEANING',
                                style: GoogleFonts.comfortaa(
                                  color: AppColors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ),
                  ),

                  // Pause Button - hidden when level is complete
                  ValueListenableBuilder<bool>(
                    valueListenable: game.levelCompleteNotifier,
                    builder: (context, isLevelComplete, _) {
                      if (isLevelComplete) {
                        // Return empty space to maintain layout
                        return const SizedBox(width: 48, height: 48);
                      }
                      return IconButton(
                        icon: const Icon(Icons.pause_circle_filled, color: AppColors.white, size: 48),
                        onPressed: () {
                          game.pauseGame();
                        },
                      );
                    },
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Timer and Score Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // Timer Display
                  ValueListenableBuilder<double>(
                    valueListenable: game.timerNotifier,
                    builder: (context, timeRemaining, _) {
                      // Change color when time is running low (< 15 seconds)
                      final bool isLowTime = timeRemaining <= 15;
                      final Color timerColor = isLowTime ? AppColors.red : AppColors.white;
                      
                      return Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: isLowTime 
                            ? AppColors.red.withValues(alpha: 0.3)
                            : AppColors.deepNavy.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(20),
                          border: isLowTime 
                            ? Border.all(color: AppColors.red, width: 2)
                            : null,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.timer,
                              color: timerColor,
                              size: 24,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _formatTime(timeRemaining),
                              style: GoogleFonts.comfortaa(
                                color: timerColor,
                                fontWeight: FontWeight.bold,
                                fontSize: 20,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                  
                  // Score
                  ValueListenableBuilder<int>(
                    valueListenable: game.scoreNotifier,
                    builder: (context, score, _) {
                       return Container(
                         padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                         decoration: BoxDecoration(
                           color: AppColors.deepNavy.withValues(alpha: 0.5),
                           borderRadius: BorderRadius.circular(20),
                         ),
                         child: Text(
                           'Score: $score',
                           style: GoogleFonts.comfortaa(
                             color: AppColors.white,
                             fontWeight: FontWeight.bold,
                             fontSize: 20,
                           ),
                         ),
                       );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
