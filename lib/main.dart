import 'package:flutter/material.dart';
import './screens/Home_Screen.dart';

void main() {
  runApp(SmartProductivityApp());
}

class SmartProductivityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T-able',
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id : (context) =>HomeScreen(),
      },
    );
  }
}
