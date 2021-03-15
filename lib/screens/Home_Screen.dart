import 'package:t_able/screens/add_event_screen.dart';
import 'package:t_able/utils/vars_consts.dart';
import 'package:t_able/widgets/action_button.dart';
import 'package:flutter/material.dart';
import 'package:analog_clock/analog_clock.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';

class HomeScreen extends StatefulWidget {
  static const String id = 'home_screen';
  //final _calendars;
  //final bloc;
  //final sKey;
  HomeScreen();
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  //GlobalKey _bottomNavigationKey = GlobalKey();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: primaryColor1,
      floatingActionButton: CustomActionButton(sKey: _scaffoldKey),
      body: Container(
        /*decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/background.png'),
            fit: BoxFit.cover,
          ),
          ),*/
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(5.0),
                  child: AnalogClock(
                    decoration: BoxDecoration(
                      //border: Border.all(width: 2.0, color: Colors.black),
                      color: Colors.transparent,
                      shape: BoxShape.circle,
                    ),
                    isLive: true,
                    hourHandColor: Colors.yellow,
                    minuteHandColor: Colors.amber,
                    showSecondHand: true,
                    numberColor: Colors.blue,
                    showNumbers: true,
                    textScaleFactor: 1.4,
                    showTicks: true,
                    showDigitalClock: true,
                    digitalClockColor: Colors.blueAccent,
                    datetime: DateTime(2019, 1, 1, 9, 12, 15),
                  ),
                ),
              ),
              Expanded(
                  flex: 1,
                  child: Container(
                    child: Center(
                      child: Text(
                        'No Events for now !\nAdd Events to see here',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 23,
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
      //      bottomNavigationBar: CurvedNavigationBar(
      //        key: _bottomNavigationKey,
      //   //backgroundColor: Colors.lightGreenAccent,
      //   items: <Widget>[
      //     Icon(Icons.list, size: 30),
      //     Icon(Icons.add, size: 30),
      //     Icon(Icons.compare_arrows, size: 30),
      //   ],
      //   onTap: (index) {
      //     //Handle button tap
      //      setState(() {
      //             _page = index;
      //           });
      //           final CurvedNavigationBarState navBarState =
      //                       _bottomNavigationKey.currentState;
      //                   navBarState.setPage(1);

      //     print('Page: $index');
      //   },
      //   //color: Colors.green,
      // ),
    );
  }
}
