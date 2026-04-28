import 'dart:async';
import 'package:CarroTime/Bottomnavbar.dart';
import 'package:CarroTime/newnavbar.dart';
import 'package:CarroTime/Core/Colors.dart';
import 'package:CarroTime/ShedScreen.dart';
import 'package:CarroTime/ShopPage.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:CarroTime/gardenpage.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'globaldata.dart';
import 'package:signals/signals_flutter.dart';

class Home extends StatefulWidget {
  Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home>
    with WidgetsBindingObserver, SingleTickerProviderStateMixin {
  int _currentIndex = 1;
  late PageController pageController;
  // قائمة الصفحات
  final List<Widget> _screens = [Garden(), SHED(), SHOP()];

  @override
  void initState() {
    super.initState();
    initAppLogic();
    WidgetsBinding.instance.addObserver(this);
    pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      checkAndResetData();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bg,
      appBar: AppBar(
        backgroundColor: AppBarrColor,
        leading: Image.asset("assets/logo2.png"),
        title: Text(
          "CarroTime",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 22,
            color: Color(0xffA43700),
          ),
        ),
        actions: [
          MaterialButton(
            child: Container(
              width: 100,
              height: 40,
              decoration: BoxDecoration(
                color: Color(0xffFFF1ED),
                borderRadius: BorderRadius.circular(100),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Watch((context) {
                    return Text(
                      "${globalCoins.value} ",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                      ),
                    );
                  }),
                  Image.asset("assets/CarroCoin.png", width: 22, height: 22),
                ],
              ),
            ),
            onPressed: () {
              AwesomeDialog(
                context: context,
                // dialogType: DialogType.noHeader,
                customHeader: Center(
                  child: Image.asset("assets/CarroCoin.png"),
                ),
                animType: AnimType.scale,
                body: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      "CarroCoin",
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Used in the store to buy new seeds.",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 1),
                    Text(
                      "You get them when you plant a new seed.",
                      style: TextStyle(fontSize: 10),
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

      body: PageView(
        controller: pageController,
        onPageChanged: (v) {
          setState(() {
            _currentIndex = v;
          });
        },
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            color: bg,
            child: Garden(),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: bg,
            child: SHED(),
          ),
          Container(
            width: double.infinity,
            height: double.infinity,
            color: bg,
            child: SHOP(),
          ),
        ],
      ),

      // IndexedStack(index: _currentIndex, children: _screens),
      bottomNavigationBar: Newnavbar(
        currentIndex: _currentIndex,
        onTabChange: (index) {
          setState(() {
            _currentIndex = index;
            pageController.jumpToPage(_currentIndex);
          });
        },
      ),
    );
  }
}
