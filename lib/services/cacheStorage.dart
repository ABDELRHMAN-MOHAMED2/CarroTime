// import 'package:shared_preferences/shared_preferences.dart';

// class StorageService {

//   static final StorageService _instance = StorageService._internal();
//   factory StorageService() => _instance;
//   StorageService._internal();

//   late SharedPreferences _prefs;

//   Future<void> init() async {
//     _prefs = await SharedPreferences.getInstance();
//   }

  
//   Future<void> setBool(String key, bool value) async => await _prefs.setBool(key, value);
//   bool? getBool(String key) => _prefs.getBool(key);
// }