import 'package:T_able/screens/nav_bar.dart';
import 'package:flutter/material.dart';
import './screens/Home_Screen.dart';
//import 'package:analog_clock/analog_clock.dart';

void main() {
  runApp(SmartProductivityApp());
}

class SmartProductivityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T-able',
      home: NavBarScreen(),
      //initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id : (context) =>HomeScreen(),
      },
    );
  }
}
