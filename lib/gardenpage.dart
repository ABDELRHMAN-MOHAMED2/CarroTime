import 'package:flutter/material.dart';
import 'package:CarroTime/Core/Colors.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:signals/signals_flutter.dart';
import 'globaldata.dart';

class Garden extends StatefulWidget {
  Garden({super.key});

  @override
  State<Garden> createState() => _GardenState();
}

class _GardenState extends State<Garden> {
  String formattedDate = DateFormat('MMM yyyy').format(DateTime.now());
  int sindex = 0;

  @override
  Widget build(BuildContext context) {
    List timeswidget = ["Today", "this week", formattedDate];
    return ListView(
      children: [
        SizedBox(height: 24),
        Container(
          width: double.infinity,
          padding: EdgeInsets.only(left: 24),
          child: Text(
            "Your Garden",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 32,
              color: pri,
            ),
          ),
        ),
        SizedBox(height: 24),
        SizedBox(
          height: 50,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: timeswidget.length,
            // 1. تصحيح الـ Parameters هنا
            itemBuilder: (context, index) {
              return GestureDetector(
                // يفضل هنا GestureDetector لو مش محتاج Ripple effect قوي
                onTap: () {
                  setState(() {
                    sindex = index; // 2. بنحدث المتغير اللي بره
                  });
                  print(timeswidget[index]);
                },
                child: Container(
                  margin: EdgeInsets.symmetric(
                    horizontal: 5,
                  ), // عشان المسافات بين الأزرار
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: BoxDecoration(
                    // 3. استخدام sindex لمقارنة الاختيار
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
        Center(
          child: Container(
            width: 330,
            height: 236,
            decoration: BoxDecoration(
              gradient: RadialGradient(
                colors: [Color.fromARGB(255, 230, 116, 85), pri],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FaIcon(FontAwesomeIcons.fire, color: Colors.white, size: 36),
                SizedBox(height: 16),
                Text(
                  "CURRENT STREAK",
                  style: TextStyle(
                    color: Colors.grey[350],
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Watch(
                  (context) => Text(
                    "$currentStreak days",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 45,
                    ),
                  ),
                ),
                SizedBox(height: 5),
                Text(
                  "Keep GOING!",
                  style: TextStyle(
                    color: Colors.grey[350],
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
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
                        // تحديد القيمة بناءً على الزرار اللي انداس عليه (sindex)
                        int displayedPlants = 0;
                        if (sindex == 0) displayedPlants = todayPlants.value;
                        else if (sindex == 1) displayedPlants = total_plants.value;
                        else if (sindex == 2) displayedPlants = monthPlants.value;

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

              // كارت الـ TOTAL FOCUS
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
                      Expanded(
                        child: Watch((context) {
                          // تحديد القيمة بناءً على الزرار اللي انداس عليه (sindex)
                          int displayedTime = 0;
                          if (sindex == 0) displayedTime = todayTime.value;
                          else if (sindex == 1) displayedTime = totalTime.value;
                          else if (sindex == 2) displayedTime = monthTime.value;

                          return Text(
                            "${displayedTime ~/ 60}h${displayedTime % 60}m",
                            style: TextStyle(
                              fontWeight: FontWeight.w900,
                              fontSize: 28,
                            ),
                          );
                        }),
                      ),
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
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "SUN",
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
                              itemCount: Harvest["SUN"]!.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Image.asset(
                                    "assets/${Harvest["SUN"]![i]}",
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "MON",
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
                              itemCount: Harvest["MON"]!.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Image.asset(
                                    "assets/${Harvest["MON"]![i]}",
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "TUE",
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
                              itemCount: Harvest["TUE"]!.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Image.asset(
                                    "assets/${Harvest["TUE"]![i]}",
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "WED",
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
                              itemCount: Harvest["WED"]!.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Image.asset(
                                    "assets/${Harvest["WED"]![i]}",
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  Divider(color: Colors.grey[400], thickness: 1),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 30),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "THU",
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
                              itemCount: Harvest["THU"]!.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Image.asset(
                                    "assets/${Harvest["THU"]![i]}",
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "FRI",
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
                              itemCount: Harvest["FRI"]!.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Image.asset(
                                    "assets/${Harvest["FRI"]![i]}",
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                      SizedBox(width: 15),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "SAT",
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
                              itemCount: Harvest["SAT"]!.length,
                              itemBuilder: (context, i) {
                                return Container(
                                  decoration: BoxDecoration(
                                    color: Colors.white,
                                  ),
                                  width: 50,
                                  height: 50,
                                  margin: EdgeInsets.only(bottom: 10),
                                  child: Image.asset(
                                    "assets/${Harvest["SAT"]![i]}",
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
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
