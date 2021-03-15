import 'package:t_able/models/calendar/calendar.dart';
import 'package:t_able/utils/bloc/calendarsList/CalenderList_bloc.dart';
import 'package:t_able/utils/vars_consts.dart';
import 'package:t_able/widgets/action_button.dart';
import 'package:t_able/widgets/calendarsList.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

class CalendarsScreen extends StatefulWidget {
  //final bloc;
  //final _calendars;
  CalendarsScreen();
  @override
  _CalendarsScreenState createState() => _CalendarsScreenState();
}

class _CalendarsScreenState extends State<CalendarsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  
  @override
  Widget build(BuildContext context) {
    //var allCalendars =Provider.of<ValueNotifier<List<Calendar>>>(context);
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: TabBar(
            tabs: [
              Tab(text: 'My Calendars'),
              Tab(text: 'Alarms'),
            ],
          ),
          // actions: [
          //   PopupMenuButton<String>(
          //     onSelected: (val) {
          //       print(val);
          //     },
          //     itemBuilder: (BuildContext context) {
          //       return {
          //         'Add a calendar',
          //         'Add a calendar from image',
          //         'Subscribe to a Google calendar'
          //       }.map((String choice) {
          //         return PopupMenuItem<String>(
          //           value: choice,
          //           child: Text(choice),
          //         );
          //       }).toList();
          //     },
          //   ),
          // ],
        ),
        body: ValueListenableBuilder(
          valueListenable: Hive.box<Calendar>('calendarsBox').listenable(),
          builder: (context, box, widget) {
        return TabBarView(
          children: [
            CalendarsListWidget(
              calendarlist: allCalendars,
              skey: _scaffoldKey,
            ),
            Icon(Icons.directions_transit),
          ],
        );}),
        floatingActionButton: CustomActionButton(sKey: _scaffoldKey,),
      ),
    );
  }
}
