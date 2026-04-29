import 'dart:async';
import 'package:flutter/material.dart';
import 'Core/Colors.dart';
import 'Bottomnavbar.dart';
import 'globaldata.dart';

class SHED extends StatefulWidget {
  const SHED({super.key});
  @override
  State<SHED> createState() => _SHEDState();
}

class _SHEDState extends State<SHED> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int selectedIndex = 0;

  // متغيرات إعداد الوقت
  int timeInMinutes = 10;
  String Today = getCurrentDay();
  String? chosen = "carrot.png"; // خليت الديفولت الجزر عشان يليق مع الاسم
  List plants = [
    {"name": "Carrot", "image": "carrot.png"},
    {"name": "Flower", "image": "tulipp.png"},
    {"name": "Watermellon", "image": "watermellon.png"},
    {"name": "Tomato", "image": "tomato.png"},
    {"name": "Strawbarry", "image": "strawparry.png"},
  ];

  // ----------------------------------------
  // متغيرات المؤقت (Timer Variables)
  // ----------------------------------------
  Timer? _timer;
  bool isRunning = false;
  int currentSeconds = 0;
  int maxSeconds = 1;
  DateTime? targetEndTime;
  void startTimer() {
    setState(() {
      isRunning = true;
      maxSeconds = timeInMinutes * 60; // تحويل الدقائق لثواني
      currentSeconds = maxSeconds;
      // targetEndTime = DateTime.now().add(Duration(seconds: maxSeconds));
    });

    DateTime targetEndTime = DateTime.now().add(
      Duration(minutes: timeInMinutes),
    );
    userDataBox.put('targetEndTime', targetEndTime);
    userDataBox.put('isTimerRunning', true); // عشان نعرف إن في تايمر شغال
    userDataBox.put('currentPlant', chosen); // نحفظ الزرعة اللي اختارها
    userDataBox.put('currentPlantTime', timeInMinutes);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (targetEndTime != null) {
        // بنطرح الوقت الحالي من وقت الانتهاء عشان نجيب الثواني المتبقية الحقيقية
        int remainingSeconds = targetEndTime!
            .difference(DateTime.now())
            .inSeconds;

        if (remainingSeconds > 0) {
          setState(() {
            currentSeconds = remainingSeconds;
          });
        } else {
          // لو الوقت خلص
          stopTimer(completed: true);
        }
      }
    });
  }

  void stopTimer({bool completed = false}) {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      targetEndTime = null;
    });

    userDataBox.delete('targetEndTime');
    userDataBox.put('isTimerRunning', false);

    if (completed) {
      add_plant(context, chosen, Today, timeInMinutes);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            "You cancelled a ${chosen!.split(".png")[0]}",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: AppBarrColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  // دالة عشان تظبط شكل الوقت (MM:SS)
  String get displayTime {
    if (!isRunning) {
      return "${timeInMinutes.toString().padLeft(2, '0')}:00";
    }
    int m = currentSeconds ~/ 60;
    int s = currentSeconds % 60;
    return "${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}";
  }

  @override
  void initState() {
    super.initState();

    // الأداة دي بتخلي الكود يستنى لحد ما الشاشة تترسم الأول عشان الـ SnackBar ميضربش إيرور
    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool wasRunning = userDataBox.get('isTimerRunning', defaultValue: false);

      if (wasRunning) {
        DateTime? savedTargetTime = userDataBox.get('targetEndTime');

        if (savedTargetTime != null) {
          DateTime now = DateTime.now();

          if (now.isBefore(savedTargetTime)) {
            // التايمر لسه مخلصش!
            int remainingSeconds = savedTargetTime.difference(now).inSeconds;

            setState(() {
              chosen = userDataBox.get(
                'currentPlant',
                defaultValue: "carrot.png",
              );
              timeInMinutes = userDataBox.get(
                'currentPlantTime',
                defaultValue: 10,
              );
              isRunning = true;
              maxSeconds = timeInMinutes * 60;
              currentSeconds = remainingSeconds;
              // بنحدث المتغير اللي بره عشان التايمر يشتغل عليه
              targetEndTime = savedTargetTime;
            });

            // نشغل العداد من جديد بالثواني الباقية
            _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
              if (targetEndTime != null) {
                int remSeconds = targetEndTime!
                    .difference(DateTime.now())
                    .inSeconds;
                if (remSeconds > 0) {
                  setState(() {
                    currentSeconds = remSeconds;
                  });
                } else {
                  stopTimer(completed: true);
                }
              }
            });
          } else {
            // الوقت عدّى والمستخدم كان قافل التطبيق!
            setState(() {
              chosen = userDataBox.get(
                'currentPlant',
                defaultValue: "carrot.png",
              );
              timeInMinutes = userDataBox.get(
                'currentPlantTime',
                defaultValue: 10,
              );
            });
            // نوقفه ونديله الجايزة (دلوقتي مش هيضرب إيرور لأن الشاشة خلاص اترسمت)
            stopTimer(completed: true);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // عشان نقفل العداد لو المستخدم خرج من الشاشة
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SingleChildScrollView(
      child: Column(
        children: [
          SizedBox(height: 30),
          Container(
            width: 288,
            height: 288,
            decoration: BoxDecoration(
              color: AppBarrColor,
              borderRadius: BorderRadius.circular(48),
            ),
            child: Center(
              child: Container(
                width: 264,
                height: 264,
                decoration: BoxDecoration(
                  color: AppBarrColor,
                  borderRadius: BorderRadius.circular(48),
                  border: Border.all(color: bg, width: 7),
                  // شلنا الـ border من هنا لأن الـ Indicator هو اللي هيرسمه
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: bg,
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Image.asset("assets/$chosen"),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // إخفاء زرار (-) أثناء تشغيل المؤقت
                        if (!isRunning)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (timeInMinutes > 5) {
                                  setState(() {
                                    timeInMinutes -= 5;
                                  });
                                }
                              },
                              icon: const Icon(Icons.remove),
                              color: Colors.black,
                              iconSize: 15,
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                        SizedBox(width: 5),

                        // عرض الوقت المتغير
                        Text(
                          displayTime,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 35,
                            color: Color(0xffA43700),
                          ),
                        ),
                        SizedBox(width: 5),

                        // إخفاء زرار (+) أثناء تشغيل المؤقت
                        if (!isRunning)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              shape: BoxShape.circle,
                            ),
                            child: IconButton(
                              onPressed: () {
                                if (timeInMinutes > 0 && timeInMinutes <= 175) {
                                  setState(() {
                                    timeInMinutes += 5;
                                  });
                                }
                              },
                              icon: const Icon(Icons.add),
                              color: Colors.black,
                              iconSize: 15,
                              constraints: const BoxConstraints(),
                              padding: const EdgeInsets.all(12),
                            ),
                          ),
                      ],
                    ),
                    Text(
                      "Focus Session",
                      style: TextStyle(
                        color: Color(0xff42493A),
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 15),
          Container(
            width: double.infinity,
            margin: EdgeInsets.only(left: 15),
            child: Text(
              "Select Seed",
              textAlign: TextAlign.left,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
                color: Color(0xff42493A),
              ),
            ),
          ),
          SizedBox(height: 13),

          // عشان المستخدم ميغيرش البذرة وهو مركز
          Opacity(
            opacity: isRunning ? 0.5 : 1.0,
            child: IgnorePointer(
              ignoring: isRunning,
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: plants.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(6),
                      padding: EdgeInsets.all(1),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            chosen = plants[index]["image"];
                          });
                        },
                        child: Container(
                          margin: EdgeInsets.only(right: 7),
                          width: 132,
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: AppBarrColor,
                            // تمييز البذرة المختارة
                            border: chosen == plants[index]["image"]
                                ? Border.all(color: Color(0xffA43700), width: 2)
                                : null,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                "assets/${plants[index]["image"]}",
                                width: 35,
                                height: 35,
                              ),
                              SizedBox(width: 5),
                              Text("${plants[index]["name"]}"),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ),

          SizedBox(height: 40),

          // زرار التشغيل والإلغاء
          InkWell(
            onTap: () {
              if (isRunning) {
                stopTimer(); // لو شغال، وقفه (إلغاء)
              } else {
                startTimer(); // لو واقف، شغله
              }
            },
            child: Container(
              width: 300,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                // تغيير لون الزرار للرمادي لو المؤقت شغال
                color: isRunning ? Colors.grey[700] : pri,
                boxShadow: isRunning
                    ? []
                    : [
                        BoxShadow(
                          color: pri.withValues(alpha: 40),
                          spreadRadius: -12,
                          blurRadius: 32,
                        ),
                      ],
              ),
              child: Text(
                isRunning ? "Cancel Session" : "Plant Seed",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
