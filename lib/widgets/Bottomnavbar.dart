import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:CarroTime/Core/Colors.dart';

class Bottomnavbar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTabChange;

  Bottomnavbar({
    super.key,
    required this.currentIndex,
    required this.onTabChange,
  });
  @override
  State<Bottomnavbar> createState() => _BottomnavbarState();
}

class _BottomnavbarState extends State<Bottomnavbar> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 100,
      decoration: BoxDecoration(
        color: AppBarrColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(30),
          topRight: Radius.circular(30),
        ),
      ),
      padding: EdgeInsets.only(bottom: 20, left: 8, right: 8),
      child: GNav(
        rippleColor: Color(0xffFFE2DA),

        haptic: true,
        tabBorderRadius: 15,
        curve: Curves.easeOutExpo, // tab animation curves
        duration: Duration(milliseconds: 220), // tab animation duration
        gap: 8, // the tab button gap between icon and text
        color: Colors.grey[800], // unselected icon color
        activeColor: Color(0xffA43700), // selected icon and text color
        iconSize: 25, // tab button icon size
        tabBackgroundColor: Color(0xffFCB9A6),
        padding: EdgeInsets.symmetric(
          horizontal: 25,
          vertical: 5,
        ), // navigation bar padding
        selectedIndex: widget.currentIndex,
        onTabChange: widget.onTabChange,
        tabs: [
          GButton(icon: Icons.schedule, text: 'TIMER'),
          GButton(icon: Icons.local_florist, text: 'GARDEN'),
          GButton(icon: Icons.shopping_bag, text: 'SHOP'),
        ],
      ),
    );
  }
}
