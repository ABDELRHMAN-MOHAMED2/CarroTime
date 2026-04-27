import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:signals/signals_flutter.dart';
import 'Core/Colors.dart';

final Box userDataBox = Hive.box('User');
final Box harvestBox = Hive.box('harvest');
final Box statsBox = Hive.box('Stat');

final globalCoins = signal(0);
final currentStreak = signal(0);

final todayPlants = signal(0); 
final todayTime = signal(0);

final total_plants = signal(0);
final totalTime = signal(0);

final monthPlants = signal(0);
final monthTime = signal(0);

Map<String, List<String>> Harvest = {
  "SUN": [], "MON": [], "TUE": [], "WED": [], "THU": [], "FRI": [], "SAT": []
};

void initAppLogic() {
  globalCoins.value = userDataBox.get('coins', defaultValue: 0);
  currentStreak.value = userDataBox.get('streak', defaultValue: 0);

  todayPlants.value = userDataBox.get('todayPlants', defaultValue: 0);
  todayTime.value = userDataBox.get('todayTime', defaultValue: 0);

  total_plants.value = userDataBox.get('totalPlants', defaultValue: 0);
  totalTime.value = userDataBox.get('totalTime', defaultValue: 0);

  monthPlants.value = userDataBox.get('monthPlants', defaultValue: 0);
  monthTime.value = userDataBox.get('monthTime', defaultValue: 0);

  var savedHarvest = harvestBox.get('weeklyHarvest');
  if (savedHarvest != null) {
    Harvest = Map<String, List<String>>.from(
      (savedHarvest as Map).map((key, value) => MapEntry(key.toString(), List<String>.from(value)))
    );
  }

  checkAndResetData();
}

void checkAndResetData() {
  DateTime now = DateTime.now();
  DateTime lastOpened = userDataBox.get('lastOpenedDate', defaultValue: now);

  if (now.day != lastOpened.day || now.month != lastOpened.month || now.year != lastOpened.year) {
    todayPlants.value = 0;
    todayTime.value = 0;
    userDataBox.put('todayPlants', 0);
    userDataBox.put('todayTime', 0);
  }

  int daysToSubtract = (now.weekday == 7) ? 0 : now.weekday; 
  DateTime startOfCurrentWeek = DateTime(now.year, now.month, now.day - daysToSubtract);

  if (lastOpened.isBefore(startOfCurrentWeek)) {
    print("أسبوع جديد! جاري حفظ الإحصائيات وتصفير الحديقة...");
    
    String lastWeekKey = "week_of_${lastOpened.year}-${lastOpened.month}-${lastOpened.day}";
    statsBox.put(lastWeekKey, {
      "time": totalTime.value,
      "plants": total_plants.value
    });

    totalTime.value = 0;
    total_plants.value = 0;
    Harvest = {
      "SUN": [], "MON": [], "TUE": [], "WED": [], "THU": [], "FRI": [], "SAT": []
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



void add_plant(BuildContext context, String? plantImage, String? day, int min) {
  Harvest[day!]!.add(plantImage!);
  globalCoins.value += (40 + (10 * (min / 5))).toInt(); 

  todayPlants.value++;
  todayTime.value += min;

  total_plants.value++;
  totalTime.value += min; 

  monthPlants.value++;
  monthTime.value += min;
  
  updateStreak(); 

  userDataBox.put('coins', globalCoins.value);
  userDataBox.put('todayPlants', todayPlants.value);
  userDataBox.put('todayTime', todayTime.value);
  userDataBox.put('totalPlants', total_plants.value);
  userDataBox.put('totalTime', totalTime.value);
  userDataBox.put('monthPlants', monthPlants.value);
  userDataBox.put('monthTime', monthTime.value);
  harvestBox.put('weeklyHarvest', Harvest);

  
  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      duration: Duration(seconds: 2),
      content: Text("Great job! You planted a ${plantImage.split(".png")[0]}", style: TextStyle(color: Colors.black)), 
      backgroundColor: AppBarrColor,
      behavior: SnackBarBehavior.floating, 
    ),
  );
}

String getCurrentDay() {
  List<String> days = ['MON', 'TUE', 'WED', 'THU', 'FRI', 'SAT', 'SUN'];
  return days[DateTime.now().weekday - 1];
}

void updateStreak() {
  DateTime now = DateTime.now();
  DateTime today = DateTime(now.year, now.month, now.day);
  
  DateTime? lastPlantDate = userDataBox.get('lastPlantDate');

  if (lastPlantDate == null) {
    currentStreak.value = 1;
  } else {
    int difference = today.difference(lastPlantDate).inDays;

    if (difference == 1) {
      currentStreak.value++;
    } else if (difference > 1) {
      currentStreak.value = 1;
    }
  }

  userDataBox.put('streak', currentStreak.value);
  userDataBox.put('lastPlantDate', today);
}