import 'package:flutter/material.dart';
import './screens/Home_Screen.dart';
import 'package:analog_clock/analog_clock.dart';

void main() {
  runApp(SmartProductivityApp());
}

class SmartProductivityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T-able',
      home:  Scaffold(
              body: AnalogClock(
	decoration: BoxDecoration(
	    border: Border.all(width: 2.0, color: Colors.black),
	    color: Colors.transparent,
	    shape: BoxShape.circle),
	width: 150.0,
	isLive: true,
	hourHandColor: Colors.black,
	minuteHandColor: Colors.black,
	showSecondHand: false,
	numberColor: Colors.black87,
	showNumbers: true,
	textScaleFactor: 1.4,
	showTicks: false,
	showDigitalClock: false,
	datetime: DateTime(2019, 1, 1, 9, 12, 15),
	),
      ),
      //initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id : (context) =>HomeScreen(),
      },
    );
  }
}
