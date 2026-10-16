import 'package:CarroTime/Models/plantModel.dart';

/// The master list of all plants in the game.
/// Only Carrot is unlocked by default.
/// All image paths reference files inside /assets/.
List<PlantModel> kAllPlants = [
  PlantModel(
    id: 'carrot',
    name: 'Carrot',
    imgPath: 'assets/carrot.png',
    price: 0,
    isUnlocked: true,
  ),
  PlantModel(
    id: 'strawberry',
    name: 'Strawberry',
    imgPath: 'assets/strawparry.png',
    price: 1200,
    isUnlocked: false,
  ),
  PlantModel(
    id: 'tomato',
    name: 'Tomato',
    imgPath: 'assets/tomato.png',
    price: 1500,
    isUnlocked: false,
  ),
  PlantModel(
    id: 'tulip',
    name: 'Tulip',
    imgPath: 'assets/tulipp.png',
    price: 5000,
    isUnlocked: false,
  ),
  PlantModel(
    id: 'watermelon',
    name: 'Watermelon',
    imgPath: 'assets/watermellon.png',
    price: 2500,
    isUnlocked: false,
  ),
];

/// Returns the [PlantModel] matching [id], or null if not found.
PlantModel? findPlantById(String id) {
  try {
    return kAllPlants.firstWhere((p) => p.id == id);
  } catch (_) {
    return null;
  }
}

/// Returns the [PlantModel] matching [id].
/// Falls back to Carrot (the default / always-unlocked plant) if [id] is unknown.
PlantModel getPlantByIdOrDefault(String id) {
  return findPlantById(id) ?? kAllPlants.first;
}
