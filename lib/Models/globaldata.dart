import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:hive/hive.dart';
import 'package:signals/signals_flutter.dart';
import 'package:CarroTime/services/cacheStorage.dart';
import 'package:CarroTime/Models/plantModel.dart';

enum StreakState { normal, frozen, lost }

// ValueNotifier<StreakState> streakState = ValueNotifier(StreakState.normal);
final Box userDataBox = Hive.box('User');
final Box harvestBox = Hive.box('harvest');
final Box statsBox = Hive.box('Stat');
// final Box plantBox = Hive.box('plants');

final globalCoins = signal(0);
final globalFreeze = signal(0);
final currentStreak = signal(0);


final todayPlants = signal(0);
final todayTime = signal(0);

final total_plants = signal(0);
final totalTime = signal(0);

final monthPlants = signal(0);
final monthTime = signal(0);

final streakState = signal<StreakState>(StreakState.lost);

// final StreakColor = ValueNotifier<List<Color>> (getStreakColor());

Map<String, List<String>> Harvest = {
  "SUN": [],
  "MON": [],
  "TUE": [],
  "WED": [],
  "THU": [],
  "FRI": [],
  "SAT": [],
};

void initAppLogic() {
  // UserPlants = userDataBox.get('userplant' , defaultValue: List=> defualtPlants [every plant has name , photoPath , price])
  globalCoins.value = userDataBox.get('coins', defaultValue: 0);
  currentStreak.value = userDataBox.get('streak', defaultValue: 0);
  globalFreeze.value = userDataBox.get('availableFreezes', defaultValue: 0);

  todayPlants.value = userDataBox.get('todayPlants', defaultValue: 0);
  todayTime.value = userDataBox.get('todayTime', defaultValue: 0);

  total_plants.value = userDataBox.get('totalPlants', defaultValue: 0);
  totalTime.value = userDataBox.get('totalTime', defaultValue: 0);

  monthPlants.value = userDataBox.get('monthPlants', defaultValue: 0);
  monthTime.value = userDataBox.get('monthTime', defaultValue: 0);

  var savedHarvest = harvestBox.get('weeklyHarvest');
  if (savedHarvest != null) {
    Harvest = Map<String, List<String>>.from(
      (savedHarvest as Map).map(
        (key, value) => MapEntry(key.toString(), List<String>.from(value)),
      ),
    );
  }

  checkAndResetData();
}

void checkAndResetData() {
  DateTime now = DateTime.now();
  DateTime lastOpened = userDataBox.get('lastOpenedDate', defaultValue: now);

  if (now.day != lastOpened.day ||
      now.month != lastOpened.month ||
      now.year != lastOpened.year) {
    todayPlants.value = 0;
    todayTime.value = 0;
    userDataBox.put('todayPlants', 0);
    userDataBox.put('todayTime', 0);
  }

  int daysToSubtract = (now.weekday == 7) ? 0 : now.weekday;
  DateTime startOfCurrentWeek = DateTime(
    now.year,
    now.month,
    now.day - daysToSubtract,
  );

  if (lastOpened.isBefore(startOfCurrentWeek)) {
    String lastWeekKey =
        "week_of_${lastOpened.year}-${lastOpened.month}-${lastOpened.day}";
    statsBox.put(lastWeekKey, {
      "time": totalTime.value,
      "plants": total_plants.value,
    });

    totalTime.value = 0;
    total_plants.value = 0;
    Harvest = {
      "SUN": [],
      "MON": [],
      "TUE": [],
      "WED": [],
      "THU": [],
      "FRI": [],
      "SAT": [],
    };

    userDataBox.put('totalTime', 0);
    userDataBox.put('totalPlants', 0);
    harvestBox.put('weeklyHarvest', Harvest);
  }

  if (now.month != lastOpened.month || now.year != lastOpened.year) {
    monthPlants.value = 0;
    monthTime.value = 0;
    userDataBox.put('monthPlants', 0);
    userDataBox.put('monthTime', 0);
  }

  userDataBox.put('lastOpenedDate', now);
}

/// Saves a completed focus session to Hive.
/// [selectedPlant] — the plant the user grew.
/// [day]           — day key e.g. "MON", "SUN".
/// [min]           — session length in minutes.
void add_plant(
  BuildContext context,
  PlantModel selectedPlant,
  String? day,
  int min,
) {
  // Store the plant's ID (a plain String) — no Hive adapter needed.
  Harvest[day!]!.add(selectedPlant.id);
  globalCoins.value += (40 + (10 * (min / 5))).toInt();

  todayPlants.value++;
  todayTime.value += min;

  total_plants.value++;
  totalTime.value += min;

  monthPlants.value++;
  monthTime.value += min;

  increaseStreakOnPlant();

  userDataBox.put('coins', globalCoins.value);
  userDataBox.put('todayPlants', todayPlants.value);
  userDataBox.put('todayTime', todayTime.value);
  userDataBox.put('totalPlants', total_plants.value);
  userDataBox.put('totalTime', totalTime.value);
  userDataBox.put('monthPlants', monthPlants.value);
  userDataBox.put('monthTime', monthTime.value);
  harvestBox.put('weeklyHarvest', Harvest);

  if (min >= 120) {
    int fresszes = userDataBox.get('availableFreezes', defaultValue: 0);
    fresszes++;
    globalFreeze.value++;
    userDataBox.put('availableFreezes', fresszes);
  }

  // AwesomeDialog(
  //   context: context,
  //   // dialogType: DialogType.noHeader,
  //   customHeader: Image.asset("assets/CarroCoin.png"),
  //   animType: AnimType.scale,
  //   body: Column(
  //     crossAxisAlignment: CrossAxisAlignment.center,
  //     children: [
  //       Text(
  //         "Great Job!",
  //         style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
  //       ),
  //       SizedBox(height: 2),
  //       Text(
  //         "you earned ${(40 + (10 * (min / 5))).toInt()} CarroCoins.",
  //         style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
  //       ),
  //       SizedBox(height: 10),
  //       Text(""),
  //     ],
  //   ),
  //   // autoHide: Duration(seconds: 5),
  // )..show();
}

String getCurrentDay() {
  List<String> days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  return days[DateTime.now().weekday - 1];
}

void checkStreakOnStartup() {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  DateTime? lastPlantDate = userDataBox.get('lastPlantDate');
  int availableFreezes = userDataBox.get('availableFreezes', defaultValue: 0);

  if (lastPlantDate != null) {
    int difference = today.difference(lastPlantDate).inDays;

    if (difference == 0) {
      streakState.value = StreakState.normal;
    } else if (difference == 1) {
      streakState.value = StreakState.normal;
    } else if (difference == 2) {
      if (availableFreezes > 0) {
        availableFreezes--;
        userDataBox.put('availableFreezes', availableFreezes);
        globalFreeze.value = availableFreezes;

        DateTime yesterday = today.subtract(const Duration(days: 1));
        userDataBox.put('lastPlantDate', yesterday);

        streakState.value = StreakState.frozen;
      } else {
        currentStreak.value = 0;
        userDataBox.put('streak', 0);
        streakState.value = StreakState.lost;
      }
    } else if (difference > 2) {
      currentStreak.value = 0;
      userDataBox.put('streak', 0);
      streakState.value = StreakState.lost;
    }
  }
}

void increaseStreakOnPlant() {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);

  DateTime? lastPlantDate = userDataBox.get('lastPlantDate');
  streakState.value = StreakState.normal;

  if (lastPlantDate == null) {
    // أول مرة يزرع في حياته أو بعد ما الاستريك اتصفر
    currentStreak.value = 1;
    userDataBox.put('streak', 1);
    userDataBox.put('lastPlantDate', today);
  } else {
    int difference = today.difference(lastPlantDate).inDays;

    if (difference == 1) {
      // زرع النهاردة وكان زارع امبارح (أو الفريز أنقذه امبارح): زود الاستريك
      currentStreak.value++;
      userDataBox.put('streak', currentStreak.value);
      userDataBox.put('lastPlantDate', today);
    } else if (difference == 0) {
      // زارع النهاردة قبل كده: مش هنزود الاستريك عشان هو بيزيد مرة واحدة في اليوم
      // بس ممكن تديله كوينز عادي
    } else {
      // لو لسبب ما (مثلا ساب التطبيق مفتوح يومين في الخلفية وزرع): ابدأ من 1
      currentStreak.value = 1;
      userDataBox.put('streak', 1);
      userDataBox.put('lastPlantDate', today);
    }
  }
}

// دالة بتحدد لون الاستريك
// نستخدم computed لأنه يراقب أي signal بداخله (مثل currentStreak) ويعيد الحساب تلقائياً
final streakColorSignal = computed<List<Color>>(() {
  int streak = currentStreak.value;
  List<Color> gradientColors;

  // منطق اختيار الألوان الخاص بك
  if (streak <= 4) {
    gradientColors = [Color(0xFF94C973), Color(0xFF4E8033)];
  } else if (streak <= 49) {
    gradientColors = [Color.fromARGB(255, 230, 116, 85), Color(0xffA43700)];
  } else if (streak <= 75) {
    gradientColors = [Color(0xFF7BAAF7), Color(0xFF2B5C9C)];
  } else {
    gradientColors = [Color(0xFFC084FC), Color(0xFF6B21A8)];
  }

  // التعامل مع حالة الـ Streak (frozen, lost, etc.)
  switch (streakState.value) {
    case StreakState.normal:
      return gradientColors;
    case StreakState.frozen:
      return [Color(0xFF81D4FA), Color(0xFF0288D1)];
    case StreakState.lost:
      return [Color(0xFFBDBDBD), Color(0xFF616161)];
  }
});
// دالة بتحدد الأيقونة
IconData getStreakIcon() {
  switch (streakState.value) {
    case StreakState.normal:
      return Icons.local_fire_department;
    case StreakState.frozen:
      return Icons.ac_unit;
    case StreakState.lost:
      return Icons.sentiment_dissatisfied;
  }
}
// void updateStreak() {
//   DateTime now = DateTime.now();
//   DateTime today = DateTime(now.year, now.month, now.day);

//   DateTime? lastPlantDate = userDataBox.get('lastPlantDate');

//   if (lastPlantDate == null) {
//     currentStreak.value = 1;
//   } else {
//     int difference = today.difference(lastPlantDate).inDays;

//     if (difference == 1) {
//       currentStreak.value++;
//     } else if (difference > 1) {
//       currentStreak.value = 1;
//     }
//   }

//   userDataBox.put('streak', currentStreak.value);
//   userDataBox.put('lastPlantDate', today);
// }
