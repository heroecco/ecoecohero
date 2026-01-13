import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/particles.dart';
import 'package:flutter/material.dart';

/// Positive particle effect for collecting trash
/// Creates a burst of green/cyan sparkles
class CollectParticleEffect extends ParticleSystemComponent {
  CollectParticleEffect({required Vector2 position})
    : super(
        particle: _createCollectParticle(),
        position: position,
        priority: 10,
      );

  static Particle _createCollectParticle() {
    final random = Random();

    return Particle.generate(
      count: 12,
      lifespan: 0.6,
      generator: (i) {
        // Random angle for burst effect
        final angle = (i / 12) * 2 * pi + random.nextDouble() * 0.3;
        final speed = 80 + random.nextDouble() * 60;
        final velocity = Vector2(cos(angle), sin(angle)) * speed;

        // Vary between green, cyan, and white for a sparkling effect
        final colors = [
          const Color(0xFF88D498), // Green
          const Color(0xFF48CAE4), // Cyan
          const Color(0xFFFFFFFF), // White sparkle
          const Color(0xFFAED581), // Light green
        ];
        final color = colors[random.nextInt(colors.length)];

        return AcceleratedParticle(
          acceleration: Vector2(0, 50), // Slight downward drift
          speed: velocity,
          child: ComputedParticle(
            renderer: (canvas, particle) {
              // Fade out and shrink over time
              final progress = particle.progress;
              final opacity = (1.0 - progress).clamp(0.0, 1.0);
              final size = (6.0 - progress * 4.0).clamp(1.0, 6.0);

              final paint = Paint()
                ..color = color.withValues(alpha: opacity)
                ..style = PaintingStyle.fill;

              // Draw star-like sparkle
              canvas.drawCircle(Offset.zero, size, paint);

              // Add a brighter center
              if (size > 2) {
                final innerPaint = Paint()
                  ..color = Colors.white.withValues(alpha: opacity * 0.8)
                  ..style = PaintingStyle.fill;
                canvas.drawCircle(Offset.zero, size * 0.4, innerPaint);
              }
            },
          ),
        );
      },
    );
  }
}

/// Negative particle effect for hitting obstacles
/// Creates a red mist/splash effect
class HitParticleEffect extends ParticleSystemComponent {
  HitParticleEffect({required Vector2 position})
    : super(particle: _createHitParticle(), position: position, priority: 10);

  static Particle _createHitParticle() {
    final random = Random();

    // Create a combination of mist particles and splash droplets
    return ComposedParticle(
      children: [
        // Red mist effect (larger, slower particles)
        Particle.generate(
          count: 8,
          lifespan: 0.8,
          generator: (i) {
            final angle = random.nextDouble() * 2 * pi;
            final speed = 30 + random.nextDouble() * 40;
            final velocity = Vector2(cos(angle), sin(angle)) * speed;

            return AcceleratedParticle(
              acceleration: Vector2(0, -20), // Slight upward drift for mist
              speed: velocity,
              child: ComputedParticle(
                renderer: (canvas, particle) {
                  final progress = particle.progress;
                  final opacity = (0.6 - progress * 0.6).clamp(0.0, 0.6);
                  final size = 12.0 + progress * 15.0; // Expand as it fades

                  final paint = Paint()
                    ..color = const Color(0xFFEF476F).withValues(alpha: opacity)
                    ..style = PaintingStyle.fill
                    ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 8);

                  canvas.drawCircle(Offset.zero, size, paint);
                },
              ),
            );
          },
        ),

        // Splash droplets (smaller, faster particles)
        Particle.generate(
          count: 10,
          lifespan: 0.5,
          generator: (i) {
            final angle = (i / 10) * 2 * pi + random.nextDouble() * 0.5;
            final speed = 100 + random.nextDouble() * 80;
            final velocity = Vector2(cos(angle), sin(angle)) * speed;

            // Vary red shades
            final colors = [
              const Color(0xFFEF476F), // Primary red
              const Color(0xFFFF6B6B), // Lighter red
              const Color(0xFFD32F2F), // Darker red
            ];
            final color = colors[random.nextInt(colors.length)];

            return AcceleratedParticle(
              acceleration: Vector2(0, 150), // Gravity
              speed: velocity,
              child: ComputedParticle(
                renderer: (canvas, particle) {
                  final progress = particle.progress;
                  final opacity = (1.0 - progress).clamp(0.0, 1.0);
                  final size = (4.0 - progress * 3.0).clamp(1.0, 4.0);

                  final paint = Paint()
                    ..color = color.withValues(alpha: opacity)
                    ..style = PaintingStyle.fill;

                  canvas.drawCircle(Offset.zero, size, paint);
                },
              ),
            );
          },
        ),
      ],
    );
  }
}

/// Screen flash effect for taking damage
class DamageFlashOverlay extends Component with HasGameReference<FlameGame> {
  double _opacity = 0.4;
  bool _removing = false;

  @override
  void update(double dt) {
    super.update(dt);

    // Fade out quickly
    _opacity -= dt * 2.0;

    if (_opacity <= 0 && !_removing) {
      _removing = true;
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    if (_opacity > 0) {
      final paint = Paint()
        ..color = const Color(
          0xFFEF476F,
        ).withValues(alpha: _opacity.clamp(0.0, 0.4))
        ..style = PaintingStyle.fill;

      canvas.drawRect(Rect.fromLTWH(0, 0, game.size.x, game.size.y), paint);
    }
  }
}

/// Plus score indicator that floats up
class ScorePopup extends PositionComponent with HasGameReference<FlameGame> {
  final int points;
  final bool isPositive;
  double _lifetime = 0;
  static const double maxLifetime = 1.0;

  ScorePopup({
    required Vector2 position,
    required this.points,
    this.isPositive = true,
  }) : super(position: position, priority: 15);

  @override
  void update(double dt) {
    super.update(dt);

    // Float upward
    position.y -= 60 * dt;

    _lifetime += dt;
    if (_lifetime >= maxLifetime) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final progress = _lifetime / maxLifetime;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final scale = 1.0 + progress * 0.3;

    final text = isPositive ? '+$points' : '-$points';
    final color = isPositive
        ? const Color(0xFF88D498)
        : const Color(0xFFEF476F);

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withValues(alpha: opacity),
          fontSize: 24 * scale,
          fontWeight: FontWeight.bold,
          shadows: [
            Shadow(
              color: Colors.black.withValues(alpha: opacity * 0.5),
              offset: const Offset(2, 2),
              blurRadius: 2,
            ),
          ],
        ),
      ),
      textDirection: TextDirection.ltr,
    );

    textPainter.layout();
    textPainter.paint(
      canvas,
      Offset(-textPainter.width / 2, -textPainter.height / 2),
    );
  }
}
