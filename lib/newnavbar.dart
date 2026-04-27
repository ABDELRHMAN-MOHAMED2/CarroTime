import 'package:circle_nav_bar/circle_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:CarroTime/Core/Colors.dart';
import 'Homepage.dart';
import 'package:CarroTime/ShedScreen.dart';
import 'package:CarroTime/ShopPage.dart';
import 'package:CarroTime/gardenpage.dart';

class Newnavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  Newnavbar({super.key, required this.currentIndex, required this.onTabChange});

  @override
  State<Newnavbar> createState() => _NewnavbarState();
}

class _NewnavbarState extends State<Newnavbar>
    with SingleTickerProviderStateMixin {
  @override
  Widget build(BuildContext context) {
    return CircleNavBar(
      tabDurationMillSec: 2000,
      activeIcons: [
        Icon(Icons.local_florist, color: Colors.white),
        Icon(Icons.home, color: Colors.white),
        Icon(Icons.shopping_bag, color: Colors.white),
      ],
      inactiveIcons: const [
        Text("Garden", style: TextStyle(color: Colors.white)),
        Text("Home", style: TextStyle(color: Colors.white)),
        Text("Shop", style: TextStyle(color: Colors.white)),
      ],
      color: Colors.white,
      circleColor: Colors.white,
      height: 60,
      circleWidth: 60,
      activeIndex: widget.currentIndex,
      // initIndex: 1,
      onTap: widget.onTabChange,
      // tabCurve: ,
      padding: const EdgeInsets.only(left: 16, right: 16, bottom: 20),
      cornerRadius: const BorderRadius.only(
        topLeft: Radius.circular(8),
        topRight: Radius.circular(8),
        bottomRight: Radius.circular(24),
        bottomLeft: Radius.circular(24),
      ),
      shadowColor: sec,
      circleShadowColor: sec,
      elevation: 10,
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color.fromARGB(255, 230, 116, 85), pri],
      ),
      circleGradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [Color.fromARGB(255, 230, 116, 85), pri],
      ),
    );
  }
}
