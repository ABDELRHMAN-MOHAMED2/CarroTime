import 'package:CarroTime/Local_notification.dart';
import 'package:CarroTime/Models/globaldata.dart';
import 'package:CarroTime/services/cacheStorage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:CarroTime/Homepage.dart';
import 'package:CarroTime/gardenpage.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'ShedScreen.dart';
// import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  // await StorageService().init();
  await Hive.initFlutter();
  await LocalNotifcationService.init();
  tz.initializeTimeZones();
  await Hive.openBox("User");
  await Hive.openBox("harvest");
  await Hive.openBox("Stat");
  // final bool isNew = StorageService().getBool("isNew") ?? true;
  // if(isNew==true){
  //   // addPlantsdata();
  // }
  FlutterNativeSplash.remove();
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
