import 'package:flame/components.dart';
import 'package:flame/parallax.dart';

class WorldBackground extends ParallaxComponent {
  final double levelSpeed;

  WorldBackground({this.levelSpeed = 200});

  @override
  Future<void> onLoad() async {
    // We want the foreground (fastest) layer to match roughly the level speed.
    // Layers: Far, Mid, Fore.
    // If we use default logic of Parallax, we set baseVelocity.
    // Let's assume standard parallax setup:
    // Base velocity is for the first layer.
    // We use velocityMultiplierDelta to increase speed for closer layers.
    
    // Config:
    // baseVelocity = V
    // velocityMultiplierDelta = (2.0, 0) -> Multipliers: 1, 3, 5? 
    // Wait, Parallax logic: 
    // layer 0: base
    // layer 1: base * (1 + delta) ? 
    // Actually, usually it's base * multiplier. 
    // And multiplier starts at 1.0 and adds delta for each subsequent layer?
    // Let's stick to what we had but scale V based on levelSpeed.
    
    // Previously: base=50, delta=2.0. Resulted in good look for speed ~200?
    // 50 * ? = 200. Maybe.
    // Let's just scale linearly.
    // V = levelSpeed / 4.0;
    
    final double baseV = levelSpeed / 5.0;

    parallax = await game.loadParallax(
      [
        ParallaxImageData('bg_layer_far.png'),
        ParallaxImageData('bg_layer_mid.png'),
        ParallaxImageData('bg_layer_fore.png'),
      ],
      baseVelocity: Vector2(baseV, 0),
      velocityMultiplierDelta: Vector2(2.0, 0),
      fill: LayerFill.height,
    );
  }
}
