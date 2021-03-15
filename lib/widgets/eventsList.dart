import 'dart:io';

import 'package:t_able/models/calendar/calendar.dart';
import 'package:t_able/utils/google_calender_handler.dart';
import 'package:t_able/widgets/event_card.dart';
import 'package:flutter/material.dart';
import '../utils/vars_consts.dart';

class EventsListWidget extends StatefulWidget {
  final Calendar calendar;
  final skey;
  EventsListWidget({this.calendar, this.skey});
  @override
  _EventsListWidgetState createState() => _EventsListWidgetState();
}

class _EventsListWidgetState extends State<EventsListWidget> {
  //var eventsVals = events.toMap().values.toList().reversed;
  //var revEvents ;
  //TODO: Implement reversing order of events list

  @override
  Widget build(BuildContext context) {
    //revEvents=eventsVals.reversed;
    return Container(
        child: widget.calendar.events.length > 0
            ? ListView.builder(
                itemCount: widget.calendar.events.length,
                itemBuilder: (BuildContext context, int position) {
                  String gcEventId =
                      widget.calendar.events[position].googleCalendarEventId;
                  String gcCalendarId = widget.calendar.googleCalendarId;
                  return Dismissible(
                    onDismissed: (direction) {
                      final gcCalendar = GoogleCalendar();
                      if (gcEventId != null) {
                        Platform.isAndroid
                            ? showDialog(
                                context: widget.skey.currentContext,
                                barrierDismissible: false,
                                builder: (_) => AlertDialog(
                                  title: Text('Alert'),
                                  content: Text(
                                      'Delete it Also from Google calendar?'),
                                  actions: [
                                    FlatButton(
                                      child: Text('No'),
                                      onPressed: () => Navigator.pop(_),
                                    ),
                                    FlatButton(
                                      child: Text('Yes'),
                                      onPressed: () {
                                        Navigator.pop(_);
                                        gcCalendar.deleteEvent(
                                            gcCalendarId, gcEventId);
                                        widget.skey.currentState
                                            .showSnackBar(SnackBar(
                                          content: Text(
                                              'The event should be deleted from google calendar'),
                                        ));
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : showDialog(context: null);
                      }
                      String root = widget.calendar.rootCalendarTitle;
                     // setState(() {
                        widget.calendar.events.removeAt(position);
                        allCalendars.put(root, allCalendars.get(root));
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
                    child: EventCard(widget.calendar.events[position]),
                    key: UniqueKey(),
                    direction: DismissDirection.endToStart,
                  );
                })
            : Center(
                child: Text('No Events yet'),
              ));
  }
}
