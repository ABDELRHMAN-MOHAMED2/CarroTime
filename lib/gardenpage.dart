import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:CarroTime/Core/Colors.dart';
import 'package:CarroTime/Models/plant_repository.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signals/signals_flutter.dart';
import 'Models/globaldata.dart';
import 'package:flutter_auto_size_text/flutter_auto_size_text.dart';

// green to 0-5 orange 6-49 , red 50-75 , blue 76 - 99 , purple 100 - infinty
class Garden extends StatefulWidget {
  Garden({super.key});

  @override
  State<Garden> createState() => _GardenState();
}

class _GardenState extends State<Garden> {
  String formattedDate = DateFormat('MMM yyyy').format(DateTime.now());
  int sindex = 0;

  /// Builds a single day column for the weekly harvest grid.
  /// [dayKey] — one of "SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT".
  Widget _buildDayColumn(String dayKey) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          dayKey,
          style: TextStyle(
            color: Color(0xff727A69),
            fontSize: 15,
          ),
        ),
        SizedBox(height: 6),
        SizedBox(
          height: 190,
          width: 50,
          child: ListView.builder(
            itemCount: Harvest[dayKey]!.length,
            itemBuilder: (context, i) {
              // Map the stored plant ID → PlantModel → imgPath.
              final plant = getPlantByIdOrDefault(Harvest[dayKey]![i]);
              return Container(
                decoration: BoxDecoration(color: Colors.white),
                width: 50,
                height: 50,
                margin: EdgeInsets.only(bottom: 10),
                child: Image.asset(plant.imgPath),
              );
            },
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    List timeswidget = ["Today", "this week", formattedDate];
    return ListView(
      children: [
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 24),
          child: Row(
            children: [
              Text(
                "Your Garden",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32,
                  color: pri,
                ),
              ),

              SizedBox(width: 60),
              InkWell(
                child: Container(
                  width: 80,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Color(0xffFFF1ED),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Watch((context) {
                        return AutoSizeText(
                          "${globalFreeze.value}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 18,
                          ),
                          maxFontSize: 18,
                        );
                      }),
                      Image.asset("assets/f.png", width: 22, height: 22),
                    ],
                  ),
                ),
                onTap: () {
                  AwesomeDialog(
                    context: context,
                    // dialogType: DialogType.noHeader,
                    customHeader: Center(child: Image.asset("assets/f.png")),
                    animType: AnimType.scale,
                    body: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          "CarroFreeze",
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          "Used in freeze your Streak.",
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        SizedBox(height: 1),
                        Text(
                          "You get them when you plant a new seed \n at least for 2 Hr per day.",
                          style: TextStyle(fontSize: 10),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 10),
                        Text(""),
                      ],
                    ),
                  )..show();
                },
              ),
            ],
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timeswidget.length,
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  setState(() {
                    sindex = index;
                  });
                  print(timeswidget[index]);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(horizontal: 5),
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    color: (sindex == index) ? pri : AppBarrColor,
                    borderRadius: BorderRadius.circular(100),
                  ),
                  child: Center(
                    child: Text(
                      "${timeswidget[index]}",
                      style: TextStyle(
                        color: (sindex == index) ? Colors.white : Colors.black,
                        fontWeight: (sindex == index)
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        SizedBox(height: 32),
        Watch(
          (context) {
            final streakCardTitle = switch (streakState.value) {
              StreakState.normal => "CURRENT STREAK",
              StreakState.frozen => "STREAK FROZEN",
              StreakState.lost => "STREAK LOST",
            };
            final streakCardMessage = switch (streakState.value) {
              StreakState.normal => "Keep GOING!",
              StreakState.frozen => "Protected by CarroFreeze",
              StreakState.lost => "Plant today to restart",
            };

            return Center(
              child:
                  // List<Color> g = getStreakColor();
                  Container(
                    width: 330,
                    height: 236,
                    decoration: BoxDecoration(
                      gradient: RadialGradient(colors: streakColorSignal.value),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          getStreakIcon(),
                          color: Colors.white,
                          size: 36,
                        ),
                        SizedBox(height: 16),
                        Text(
                          streakCardTitle,
                          style: TextStyle(
                            color: Colors.grey[350],
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Watch((context) {
                          int streak = currentStreak.value;
                          return Text(
                            "$streak days",
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 45,
                            ),
                          );
                        }),
                        SizedBox(height: 5),
                        Text(
                          streakCardMessage,
                          style: TextStyle(
                            color: Colors.grey[350],
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
            );
          },
        ),
        SizedBox(height: 32),
        Container(
          height: 180,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: GridView(
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              childAspectRatio: 1.2,
              crossAxisSpacing: 15,
              mainAxisSpacing: 15,
            ),
            children: [
              // كارت الـ PLANTED
              Card(
                color: AppBarrColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      FaIcon(
                        FontAwesomeIcons.seedling,
                        color: Colors.green,
                        size: 20,
                      ),
                      SizedBox(height: 18),
                      Watch((context) {
                        int displayedPlants = 0;
                        if (sindex == 0)
                          displayedPlants = todayPlants.value;
                        else if (sindex == 1)
                          displayedPlants = total_plants.value;
                        else if (sindex == 2)
                          displayedPlants = monthPlants.value;

                        return Text(
                          "$displayedPlants",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 28,
                          ),
                        );
                      }),
                      Text(
                        "PLANTED",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),

              Card(
                color: AppBarrColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadiusGeometry.circular(20),
                ),
                child: Padding(
                  padding: EdgeInsetsGeometry.all(15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(Icons.schedule, color: pri, size: 25),
                      SizedBox(height: 15),
                      Watch((context) {
                        int displayedTime = 0;
                        if (sindex == 0)
                          displayedTime = todayTime.value;
                        else if (sindex == 1)
                          displayedTime = totalTime.value;
                        else if (sindex == 2)
                          displayedTime = monthTime.value;

                        return AutoSizeText(
                          "${displayedTime ~/ 60}h${displayedTime % 60}m",
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 24,
                          ),
                          maxFontSize: 24,
                        );
                      }),
                      Text(
                        "TOTAL FOCUS",
                        style: TextStyle(color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
        Center(
          child: Watch((context) {
            int trigger = total_plants.value;
            return Container(
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppBarrColor,
                borderRadius: BorderRadius.circular(20),
              ),
              width: 333,
              height: 550,
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.category_outlined, color: pri, size: 20),
                      SizedBox(width: 10),
                      Text(
                        "This Week's Harvest",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildDayColumn("SUN"),
                      SizedBox(width: 15),
                      _buildDayColumn("MON"),
                      SizedBox(width: 15),
                      _buildDayColumn("TUE"),
                      SizedBox(width: 15),
                      _buildDayColumn("WED"),
                    ],
                  ),
                  SizedBox(height: 12),
                  Divider(color: Colors.grey[400], thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 30),
                      _buildDayColumn("THU"),
                      SizedBox(width: 15),
                      _buildDayColumn("FRI"),
                      SizedBox(width: 15),
                      _buildDayColumn("SAT"),
                    ],
                  ),
                ],
              ),
            );
          }),
        ),
        SizedBox(height: 50),
      ],
    );
  }
}
