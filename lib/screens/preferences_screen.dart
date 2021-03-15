import 'package:t_able/models/calendar/calendar.dart';
import 'package:t_able/screens/nav_bar.dart';
import 'package:t_able/utils/vars_consts.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class PreferencesScreen extends StatefulWidget {
  @override
  _PreferencesScreenState createState() => _PreferencesScreenState();
}

class _PreferencesScreenState extends State<PreferencesScreen> {
  String selectedPrim = 'University Student (Study)';
  TextEditingController numController = TextEditingController();
  String readySelect = 'Minutes';
  List<bool> _gcSync = List.generate(2, (_) => false);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Text(
                'Before you use the app...\nT-able wants to know a little bit about you so it can be more helpful to you',
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Divider(color: Colors.white),
            Expanded(
              child: Text(
                  'What best describes you ? (What do you want to use this app primarily for ?) ',
                  style: TextStyle(fontSize: 15, color: Colors.white)),
            ),
            DropdownButton<String>(
              value: selectedPrim,
              style: TextStyle(color: Colors.white),
              items: <DropdownMenuItem<String>>[
                DropdownMenuItem(
                  child: Text('University Student (Study)'),
                  value: 'University Student (Study)',
                ),
                DropdownMenuItem(
                  child: Text('Worker (Work)'),
                  value: 'Work',
                ),
                DropdownMenuItem(
                  child: Text('Sporty Person (Sport)'),
                  value: 'Sport',
                ),
                DropdownMenuItem(
                  child: Text('Musician (Music sessions)'),
                  value: 'Music',
                ),
                DropdownMenuItem(
                  child: Text('Other'),
                  value: 'other',
                ),
              ],
              onChanged: (value) {
                setState(() {
                  selectedPrim = value;
                });
              },
            ),
            Divider(),
            Text(
                'If you want to go out, how long usually does it take you to get ready ?',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            Row(
              crossAxisAlignment: CrossAxisAlignment.baseline,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 50.0,
                  height: 50.0,
                  child: TextField(
                    decoration:
                        InputDecoration(fillColor: Colors.white, filled: true),
                    showCursor: true,
                    cursorColor: Colors.white,
                    keyboardType: TextInputType.number,
                    maxLength: 2,
                    textAlign: TextAlign.center,
                    maxLengthEnforced: true,
                    controller: numController,
                  ),
                ),
                SizedBox(
                  width: 50.0,
                ),
                Container(
                  width: 100.0,
                  height: 50.0,
                  child: DropdownButton<String>(
                    elevation: 15,
                    value: readySelect,
                    style: TextStyle(color: Colors.white),
                    items: [
                      DropdownMenuItem(
                        child: Text('Minutes'),
                        value: 'Minutes',
                      ),
                      DropdownMenuItem(
                        child: Text('Hours'),
                        value: 'Hours',
                      ),
                    ],
                    onChanged: (val) {
                      setState(() {
                        readySelect = val;
                      });
                    },
                  ),
                ),
              ],
            ),
            Divider(),
            Text(
                'Do you want your calendars to be automatically synchronized with Google Calendar?',
                style: TextStyle(fontSize: 15, color: Colors.white)),
            Center(
              heightFactor: 2.0,
              child: ToggleButtons(
                borderColor: Colors.white,
                children: [
                  Icon(Icons.check, color: Colors.white),
                  Icon(Icons.close_sharp, color: Colors.white),
                ],
                isSelected: _gcSync,
                onPressed: (index) {
                  //if (_gcSync.contains(true) && _gcSync[index] != true)
                  //print('More then one selected');
                  //else {
                  _gcSync = [false, false];
                  setState(() {
                    _gcSync[index] = !_gcSync[index];
                  });
                  // }
                },
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
                borderWidth: 5,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: () {
          var prefBox = Hive.box('preferences');
          prefBox.put('isSet', true);
          addUserCalendars(selectedPrim);
          double timeInMinutes = readySelect == 'Hours'
              ? double.tryParse(numController.text) * 60
              : double.tryParse(numController.text);
          prefBox.put('readyTime', timeInMinutes);
          prefBox.put('gcSync', _gcSync[0]);
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (BuildContext context) {
            return NavBarScreen();
          }));
        },
        elevation: 25,
        isExtended: true,
      ),
    );
  }

  void addUserCalendars(String opt) {
    allCalendars.put(
        'Other',
        Calendar(
          title: 'Other',
          content: [],
          events: [],
          rootCalendarTitle: 'Other',
        ));
    switch (opt) {
      case 'University Student (Study)':
        allCalendars.put(
            'University',
            Calendar(
              title: 'University',
              content: [],
              events: [],
              rootCalendarTitle: 'University',
            ));
        break;
      case 'Work':
        allCalendars.put(
            'Work',
            Calendar(
              title: 'Work',
              content: [],
              events: [],
              rootCalendarTitle: 'Work',
            ));
        break;
      case 'Sport':
        allCalendars.put(
            'Sport',
            Calendar(
              title: 'Sport',
              content: [],
              events: [],
              rootCalendarTitle: 'Sport',
            ));
        break;
      case 'Music':
        allCalendars.put(
            'Music',
            Calendar(
              title: 'Music',
              content: [],
              events: [],
              rootCalendarTitle: 'Music',
            ));
        break;
      default:
        break;
    }
  }
}
