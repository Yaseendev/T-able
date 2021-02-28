import 'package:T_able/models/Event/event.dart';
import 'package:T_able/models/calendar/calendar.dart';
import 'package:T_able/widgets/action_button.dart';
import 'package:T_able/widgets/calendarsList.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CalendarScreen extends StatefulWidget {
  final Calendar calendar;
  final calendars;
  //final bloc;
  CalendarScreen({this.calendar,this.calendars});
  @override
  _CalendarScreenState createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        key: _scaffoldKey,
        floatingActionButton: CustomActionButton(
          sKey: _scaffoldKey,
          calendar: widget.calendar,
        ),
        appBar: AppBar(
          title: Column(
            children: [
              Text(widget.calendar.title),
              TabBar(
                tabs: [
                  Tab(text: 'Calendars'),
                  Tab(text: 'Events'),
                  Tab(
                    text: 'Alarms',
                  )
                ],
              ),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            CalendarsListWidget(
              calendarlist: widget.calendar.content,
              skey: _scaffoldKey,
            ),
            Container(),
            Icon(Icons.directions_transit),
          ],
        ),
      ),
    );
  }
}
