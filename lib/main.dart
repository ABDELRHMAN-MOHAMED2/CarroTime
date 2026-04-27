import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; 
import 'package:CarroTime/Homepage.dart';
import 'package:CarroTime/gardenpage.dart';
import 'ShedScreen.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  await Hive.initFlutter();

  await Hive.openBox("User");
  await Hive.openBox("harvest");
  await Hive.openBox("Stat");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(fontFamily: "PlusJakartaSans"),
      debugShowCheckedModeBanner: false,
      home: Home(),
    );
  }
}
