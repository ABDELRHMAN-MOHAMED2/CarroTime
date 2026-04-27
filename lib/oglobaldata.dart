// import 'package:CarroTime/Core/Colors.dart';
// import 'package:flutter/material.dart';
// import 'package:signals/signals.dart';
// import 'package:hive_flutter/hive_flutter.dart';

// final Box userDataBox = Hive.box('userData');
// final Box harvestBox = Hive.box('harvest');
// final Box statsBox = Hive.box('statistics');

// final globalCoins = signal(0);
// final total_plants = signal(0);
// final totalTime = signal(0);
// final currentStreak = signal(0);

// Map<String, List<String>> Harvest = {
//   "SUN": [],
//   "MON": [],
//   "TUE": [],
//   "WED": [],
//   "THU": [],
//   "FRI": [],
//   "SAT": [],
// };

// void initAppLogic() {
//   globalCoins.value = userDataBox.get('coins', defaultValue: 0);
//   total_plants.value = userDataBox.get('totalPlants', defaultValue: 0);
//   totalTime.value = userDataBox.get('totalTime', defaultValue: 0);
//   currentStreak.value = userDataBox.get('streak', defaultValue: 0);

//   var savedHarvest = harvestBox.get('weeklyHarvest');
//   if (savedHarvest != null) {
//     Harvest = Map<String, List<String>>.from(
//       (savedHarvest as Map).map(
//         (key, value) => MapEntry(key.toString(), List<String>.from(value)),
//       ),
//     );
//   }

//   // checkAndResetData();
// }



// void add_plant(BuildContext context, String? plantImage, String? day, int min) {
//   Harvest[day]!.add(plantImage!);
//   globalCoins.value += (40 + (10 * (min / 5))).toInt();
//   total_plants.value++;
//   updateStreak();
//   ScaffoldMessenger.of(context).showSnackBar(
//     SnackBar(
//       content: Text(
//         "Great job! You planted a ${plantImage.split(".png")[0]}",
//         style: TextStyle(color: Colors.black),
//       ),
//       backgroundColor: AppBarrColor,
//       behavior: SnackBarBehavior.floating,
//     ),
//   );
// }

// // 1. هنعمل Signals للاستريك

// // 2. المتغير اللي بيحفظ تاريخ آخر زراعة
// // (في المستقبل ده هتقراه من قاعدة البيانات، دلوقتي هنخليه كمتغير عادي)
// DateTime? lastPlantDate;

// // 3. دالة حساب الاستريك
// void updateStreak() {
//   DateTime now = DateTime.now();
//   // 🔥 تريكة مهمة جداً: بنصفر الساعات والدقايق عشان نحسب الأيام صح
//   // (يعني لو زرع 11 بالليل ورجع زرع 1 الصبح، يتحسبوا يومين مختلفين)
//   DateTime today = DateTime(now.year, now.month, now.day);

//   // لو دي أول مرة يزرع في حياته
//   if (lastPlantDate == null) {
//     currentStreak.value = 1;
//     lastPlantDate = today;
//     print("أول زرعة! الاستريك بدأ: 1");
//     return;
//   }

//   // نحسب الفرق بالأيام بين النهاردة وآخر مرة زرع
//   int differenceInDays = today.difference(lastPlantDate!).inDays;

//   if (differenceInDays == 0) {
//     // زرع كذا مرة في نفس اليوم.. مش هنعمل حاجة في الاستريك
//     print("زرعة إضافية في نفس اليوم. الاستريك ثابت: ${currentStreak.value}");
//   } else if (differenceInDays == 1) {
//     // عاش! رجع تاني يوم
//     currentStreak.value += 1;
//     lastPlantDate = today;
//     print("عاش! الاستريك زاد بقى: ${currentStreak.value}");
//   } else if (differenceInDays > 1) {
//     // للأسف السلسلة اتكسرت
//     currentStreak.value = 1;
//     lastPlantDate = today;
//     print("للأسف الاستريك اتكسر وبدأ من الأول: 1");
//   }
// }
