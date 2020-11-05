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
      home: HomeScreen(),
      //initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id : (context) =>HomeScreen(),
      },
    );
  }
}
