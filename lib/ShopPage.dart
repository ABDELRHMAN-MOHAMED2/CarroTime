import 'package:CarroTime/Core/Colors.dart';
import 'package:flutter/material.dart';

class SHOP extends StatelessWidget {
  const SHOP({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Image.asset("assets/Soon.png"),
          Text(
            "Coming Soon",
            style: TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w900,
              color: pri,
            ),
          ),
        ],
      ),
    );
  }
}
