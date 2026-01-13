import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'screens/splash_screen.dart';
import 'screens/main_menu.dart';
import 'screens/level_select.dart';
import 'screens/shop_screen.dart';
import 'screens/game_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations for the game
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ]);

  // Set fullscreen mode
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  runApp(const EcoHeroApp());
}

class EcoHeroApp extends StatelessWidget {
  const EcoHeroApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Eco Hero',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const SplashScreen(),
        '/main_menu': (context) => const MainMenuScreen(),
        '/level_select': (context) => const LevelSelectScreen(),
        '/shop': (context) => const ShopScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/game') {
          final level = settings.arguments as int? ?? 1;
          return MaterialPageRoute(
            builder: (context) => GameScreen(levelNumber: level),
          );
        }
        return null;
      },
    );
  }
}
