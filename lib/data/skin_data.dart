class SkinData {
  final String id;
  final String name;
  final String assetPath;
  final int price;

  const SkinData({
    required this.id,
    required this.name,
    required this.assetPath,
    required this.price,
  });

  static const List<SkinData> allSkins = [
    SkinData(
      id: 'default',
      name: 'Yellow Sub',
      assetPath: 'submarine_default.png',
      price: 0,
    ),
    SkinData(
      id: 'turtle',
      name: 'Turtle',
      assetPath: 'submarine_turtle.png',
      price: 500,
    ),
    SkinData(
      id: 'shark',
      name: 'Shark',
      assetPath: 'submarine_shark.png',
      price: 1000,
    ),
    SkinData(
      id: 'scifi',
      name: 'Sci-Fi',
      assetPath: 'submarine_scifi.png',
      price: 2000,
    ),
  ];
}

