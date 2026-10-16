class PlantModel {
  final String id;
  final String name;
  final String imgPath;
  final int price;
  bool isUnlocked;

  PlantModel({
    required this.id,
    required this.name,
    required this.imgPath,
    required this.price,
    this.isUnlocked = false,
  });

  /// Returns a copy of this plant with [isUnlocked] toggled.
  PlantModel copyWith({bool? isUnlocked}) {
    return PlantModel(
      id: id,
      name: name,
      imgPath: imgPath,
      price: price,
      isUnlocked: isUnlocked ?? this.isUnlocked,
    );
  }
}
