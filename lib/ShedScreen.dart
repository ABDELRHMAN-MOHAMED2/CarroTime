import 'dart:async';
import 'package:CarroTime/Local_notification.dart';
import 'package:CarroTime/Models/plant_repository.dart';
import 'package:CarroTime/Models/plantModel.dart';
import 'package:flutter/material.dart';
import 'Core/Colors.dart';
import 'Models/globaldata.dart';

class SHED extends StatefulWidget {
  const SHED({super.key});
  @override
  State<SHED> createState() => _SHEDState();
}

class _SHEDState extends State<SHED> with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  int selectedIndex = 0;

  int timeInMinutes = 10;
  String Today = getCurrentDay();

  /// The currently selected plant – starts with Carrot (always unlocked).
  PlantModel chosen = kAllPlants.first;

  Timer? _timer;
  bool isRunning = false;
  int currentSeconds = 0;
  int maxSeconds = 1;
  DateTime? targetEndTime;

  void startTimer({required String name}) {
    setState(() {
      isRunning = true;
      maxSeconds = timeInMinutes * 60;
      currentSeconds = maxSeconds;
    });

    DateTime targetEndTime = DateTime.now().add(
      Duration(minutes: timeInMinutes),
    );

    LocalNotifcationService.showNotification(
      name: name,
      targetEndTime: targetEndTime,
    );

    userDataBox.put('targetEndTime', targetEndTime);
    userDataBox.put('isTimerRunning', true);
    // Save the plant ID (String) – no Hive adapter needed.
    userDataBox.put('currentPlantId', chosen.id);
    userDataBox.put('currentPlantTime', timeInMinutes);

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      int remainingSeconds = targetEndTime.difference(DateTime.now()).inSeconds;

      if (remainingSeconds > 0) {
        setState(() {
          currentSeconds = remainingSeconds;
        });
      } else {
        stopTimer(completed: true);
      }
    });
  }

  void stopTimer({bool completed = false}) async {
    _timer?.cancel();
    setState(() {
      isRunning = false;
      targetEndTime = null;
    });
    await Future.delayed(Duration(seconds: 5));
    LocalNotifcationService.Cancel(id: 1);

    userDataBox.delete('targetEndTime');
    userDataBox.put('isTimerRunning', false);

    if (completed) {
      add_plant(context, chosen, Today, timeInMinutes);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          duration: Duration(seconds: 2),
          content: Text(
            "You cancelled a ${chosen.name}",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: AppBarrColor,
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  String getDynamicPlantImage() {
    if (!isRunning) {
      return chosen.imgPath;
    }

    double progress = (maxSeconds - currentSeconds) / maxSeconds;

    if (progress < 0.25) {
      return "assets/soil.png";
    } else if (progress >= 0.25 && currentSeconds > 0) {
      return "assets/grow.gif";
    } else {
      return chosen.imgPath;
    }
  }

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

    WidgetsBinding.instance.addPostFrameCallback((_) {
      bool wasRunning = userDataBox.get('isTimerRunning', defaultValue: false);

      if (wasRunning) {
        DateTime? savedTargetTime = userDataBox.get('targetEndTime');

        if (savedTargetTime != null) {
          DateTime now = DateTime.now();

          // Restore the chosen plant from the saved ID.
          final String savedId = userDataBox.get(
            'currentPlantId',
            defaultValue: kAllPlants.first.id,
          );
          final PlantModel restoredPlant = getPlantByIdOrDefault(savedId);

          if (now.isBefore(savedTargetTime)) {
            int remainingSeconds = savedTargetTime.difference(now).inSeconds;

            setState(() {
              chosen = restoredPlant;
              timeInMinutes = userDataBox.get(
                'currentPlantTime',
                defaultValue: 10,
              );
              isRunning = true;
              maxSeconds = timeInMinutes * 60;
              currentSeconds = remainingSeconds;
              targetEndTime = savedTargetTime;
            });

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
            setState(() {
              chosen = restoredPlant;
              timeInMinutes = userDataBox.get(
                'currentPlantTime',
                defaultValue: 10,
              );
            });

            stopTimer(completed: true);
          }
        }
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
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
                      child: ClipOval(
                        child: Image.asset(
                          getDynamicPlantImage(),
                          width: 70,
                          height: 70,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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

                        Text(
                          displayTime,
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 35,
                            color: Color(0xffA43700),
                          ),
                        ),
                        SizedBox(width: 5),

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

          Opacity(
            opacity: isRunning ? 0.5 : 1.0,
            child: IgnorePointer(
              ignoring: isRunning,
              child: SizedBox(
                height: 60,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemCount: kAllPlants.length,
                  itemBuilder: (context, index) {
                    final PlantModel plant = kAllPlants[index];
                    final bool isSelected = chosen.id == plant.id;
                    final bool locked = !plant.isUnlocked;

                    return Container(
                      margin: EdgeInsets.all(6),
                      padding: EdgeInsets.all(1),
                      child: locked
                          ? Container()
                          : Opacity(
                              opacity: locked ? 0.45 : 1.0,
                              child: InkWell(
                                onTap: locked
                                    ? () {
                                        // Show a hint that the plant is locked.
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          SnackBar(
                                            duration: Duration(seconds: 2),
                                            content: Text(
                                              "${plant.name} is locked. Coming soon!",
                                              style: TextStyle(
                                                color: Colors.black,
                                              ),
                                            ),
                                            backgroundColor: AppBarrColor,
                                            behavior: SnackBarBehavior.floating,
                                          ),
                                        );
                                      }
                                    : () {
                                        setState(() {
                                          chosen = plant;
                                        });
                                      },
                                child: Container(
                                  margin: EdgeInsets.only(right: 2),
                                  width: 140,
                                  height: 50,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    color: AppBarrColor,
                                    border: isSelected
                                        ? Border.all(
                                            color: Color(0xffA43700),
                                            width: 2,
                                          )
                                        : null,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Image.asset(
                                        plant.imgPath,
                                        width: 35,
                                        height: 35,
                                      ),
                                      SizedBox(width: 5),
                                      Text(plant.name),
                                      if (locked) ...[
                                        SizedBox(width: 4),
                                        Icon(
                                          Icons.lock,
                                          size: 13,
                                          color: Colors.grey[600],
                                        ),
                                      ],
                                    ],
                                  ),
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

          InkWell(
            onTap: () {
              if (isRunning) {
                stopTimer();
              } else {
                startTimer(name: chosen.name);
              }
            },
            child: Container(
              width: 300,
              height: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
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
