import 'package:T_able/screens/Home_Screen.dart';
import 'package:T_able/screens/add_event_screen.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import 'events_screen.dart';

class NavBarScreen extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    AddEventScreen(),
    EventsScreen(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      bottomNavigationBar: CurvedNavigationBar(
        // key: _bottomNavigationKey,
    //backgroundColor: Colors.lightGreenAccent,
    items: <Widget>[
      Icon(Icons.list, size: 30),
      Icon(Icons.add, size: 30),
      Icon(Icons.compare_arrows, size: 30),
    ],
    onTap: (index) {
      //Handle button tap
      setState(() {
     _currentIndex = index;
   });
            // final CurvedNavigationBarState navBarState =
            //             _bottomNavigationKey.currentState;
            //         navBarState.setPage(1);
           
      print('Page: $index');
    },
    //color: Colors.green,
  ),
    );
  }
}