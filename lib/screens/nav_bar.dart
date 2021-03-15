import 'package:t_able/models/Event/event.dart';
import 'package:t_able/models/calendar/calendar.dart';
import 'package:t_able/screens/Home_Screen.dart';
import 'package:t_able/screens/add_event_screen.dart';
import 'package:t_able/screens/calendars_screen.dart';
import 'package:t_able/screens/chat_screen.dart';
import 'package:t_able/screens/settings_screen.dart';
import 'package:t_able/utils/bloc/calendarsList/calenderList_bloc.dart';
import 'package:t_able/utils/vars_consts.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'dynamic_calendar_screen.dart';


  void showToast() {
    final scaffold = Scaffold.of(con);
    scaffold.showSnackBar(
      SnackBar(
        content: const Text('Updating..'),
      ),
    );
  }

  var con;
class NavBarScreen extends StatefulWidget {
  //final _calendars;
  NavBarScreen();
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _currentIndex = 0;
  //var _calendars;
//final _bloc = CalenderListBloc();

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    con = context;
    final List<Widget> _children = [
      HomeScreen(),
      CalendarsScreen(),
      DynamicCalendarScreen(),
      ChatScreen(),
      SettingsScreen(),
    ];

    return Scaffold(
      backgroundColor: primaryColor1,
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        // key: _bottomNavigationKey,
        backgroundColor: primaryColor1,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.alarm, size: 30),
          Icon(Icons.event, size: 30),
          Icon(Icons.chat_rounded, size: 30),
          Icon(Icons.person_rounded, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
          setState(() {
            _currentIndex = index;
          });
        },
        //color: Colors.green,
      ),
    );
  }
  //  @override
  // void dispose() {
  //   _bloc.dispose();
  //   super.dispose();
  // }
}
