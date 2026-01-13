// This is a basic Flutter widget test for Eco Hero game.

import 'package:flutter_test/flutter_test.dart';

import 'package:eco_hero/main.dart';

void main() {
  testWidgets('Eco Hero app builds successfully', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const EcoHeroApp());

    // Verify that the app renders without errors
    await tester.pumpAndSettle();
  });
}
