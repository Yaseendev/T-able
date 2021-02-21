import 'package:T_able/screens/nav_bar.dart';
import 'package:T_able/utils/bloc/calendarsList/CalenderList_bloc.dart';
import 'package:T_able/utils/vars_consts.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import './screens/Home_Screen.dart';
import 'models/Event/event.dart';
import 'models/calendar/calendar.dart';
//import 'package:analog_clock/analog_clock.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  Hive.registerAdapter(CalendarAdapter());
  events = await Hive.openBox<Event>('eventBox');
   allCalendars = await Hive.openBox<Calendar>('calendarsBox');
  allCalendars.clear();
  
  runApp(SmartProductivityApp());
}

class SmartProductivityApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'T-able',
      theme: ThemeData(
        brightness: Brightness.light,
        //accentColor: primaryColor1,
        primaryColor: primaryColor1,
        scaffoldBackgroundColor: primaryColor1,
      ),
      home: NavBarScreen(),
      //initialRoute: HomeScreen.id,
      routes: {
        //HomeScreen.id: (context) => HomeScreen(),
      },
    );
  }
}
