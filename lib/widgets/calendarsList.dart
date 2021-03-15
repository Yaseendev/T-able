import 'dart:io';

import 'package:t_able/models/calendar/calendar.dart';
import 'package:t_able/screens/calender_content.dart';
import 'package:t_able/utils/google_calender_handler.dart';
import 'package:t_able/widgets/calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/vars_consts.dart';

class CalendarsListWidget extends StatefulWidget {
  final calendarlist;
  //final bloc;
  final skey;
  CalendarsListWidget({this.calendarlist, this.skey});

  @override
  _CalendarsListWidgetState createState() => _CalendarsListWidgetState();
}

class _CalendarsListWidgetState extends State<CalendarsListWidget> {
  bool isHive = true;

  @override
  Widget build(BuildContext context) {
    //revEvents=eventsVals.reversed;

    return Container(
      child: widget.calendarlist.length > 0
          ? ListView.builder(
              itemCount: widget.calendarlist.length,
              itemBuilder: (BuildContext context, int position) {
                String gcId;
                try {
                  gcId = widget.calendarlist.getAt(position).googleCalendarId;
                } catch (e) {
                  print(e);
                  gcId = widget.calendarlist[position].googleCalendarId;
                  isHive = false;
                }
                return Dismissible(
                  onDismissed: (direction) {
                    //setState(() {
                    final gcCalendar = GoogleCalendar();
                    if (gcId != null) {
                      Platform.isAndroid
                          ? showDialog(
                              context: widget.skey.currentContext,
                              barrierDismissible: false,
                              builder: (_) => AlertDialog(
                                title: Text('Alert'),
                                content:
                                    Text('Delete Also from Google calendar?'),
                                actions: [
                                  FlatButton(
                                    child: Text('No'),
                                    onPressed: () => Navigator.pop(_),
                                  ),
                                  FlatButton(
                                    child: Text('Yes'),
                                    onPressed: () {
                                      Navigator.pop(_);
                                      gcCalendar.removeCalendar(gcId);
                                      widget.skey.currentState
                                          .showSnackBar(SnackBar(
                                        content: Text(
                                            'Calendar should be deleted from google calendar'),
                                      ));
                                      //   )); Scaffold.of(widget.skey.currentContext)
                                      //     .showSnackBar(
                                      //   SnackBar(
                                      //     content: Text(
                                      //         'Calendar should be deleted from google calendar'),
                                      //   ),
                                      // );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : showDialog(context: null);
                    }
                    try {
                      widget.calendarlist.deleteAt(position);
                    } catch (e) {
                      print(e);
                      isHive = false;
                      String root =
                          widget.calendarlist[position].rootCalendarTitle;
                      widget.calendarlist.removeAt(position);
                      allCalendars.put(root, allCalendars.get(root));
                    }
                    //print(widget.calendarlist.toMap());
                    // });
                  },
                  secondaryBackground: Container(
                    color: Colors.red,
                    child: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.delete, color: Colors.white),
                          SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            'Delete',
                            style: TextStyle(color: Colors.white),
                          ),
                        ],
                      ),
                    ),
                  ),
                  background: Container(),
                  child: CalendarCard(
                    calendar: isHive
                        ? widget.calendarlist.getAt(position)
                        : widget.calendarlist[position],
                    onPress: () {
                      Navigator.of(context).push(
                          MaterialPageRoute(builder: (BuildContext context) {
                        isHive
                            ? print('GC id : ' +
                                widget.calendarlist
                                    .getAt(position)
                                    .googleCalendarId
                                    .toString())
                            : print(
                                'GC id : ${widget.calendarlist[position].googleCalendarId}');
                        return CalendarScreen(
                          calendar: isHive
                              ? widget.calendarlist.getAt(position)
                              : widget.calendarlist[position],
                          calendars: widget.calendarlist,
                        );
                      }));
                    },
                  ),
                  key: UniqueKey(),
                  direction: DismissDirection.endToStart,
                );
              })
          : Center(
              child: Text(
                'No Calendars yet',
                style: TextStyle(color: Colors.white),
              ),
            ),
    );
  }

  // @override
  // void dispose() {
  //   super.dispose();
  //   widget.bloc.dispose();
  // }
}
