import 'package:t_able/screens/nav_bar.dart';
import 'package:t_able/screens/preferences_screen.dart';
import 'package:t_able/utils/bloc/calendarsList/CalenderList_bloc.dart';
import 'package:t_able/utils/timeMachineHive.dart';
import 'package:t_able/utils/vars_consts.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:time_machine/time_machine.dart';
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
  //allCalendars.clear();
  await Hive.openBox('settings');
  await Hive.openBox('preferences');
  WidgetsFlutterBinding.ensureInitialized();
  await TimeMachine.initialize(<dynamic, dynamic>{'rootBundle': rootBundle});
  addTodynCalendar();
  runApp(SmartProductivityApp());
}

class SmartProductivityApp extends StatelessWidget {
  final prefBox = Hive.box('preferences');
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
      home: prefBox.get('isSet', defaultValue: false)
          ? NavBarScreen()
          : PreferencesScreen(),
      //initialRoute: HomeScreen.id,
      routes: {
        //HomeScreen.id: (context) => HomeScreen(),
      },
      debugShowCheckedModeBanner: false,
    );
  }
}
