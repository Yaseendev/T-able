import 'package:T_able/models/calendar/calendar.dart';
import 'package:flutter/material.dart';

class CalendarCard extends StatelessWidget {
  final Calendar calendar;
  final Function onPress;
  CalendarCard({this.calendar,this.onPress});
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(calendar.title),
        subtitle: Text('${calendar.content.length} Calendars . ${calendar.events.length} Events'),
        onTap: onPress,
        trailing: Icon(Icons.arrow_forward_ios_rounded),
      ),
    );
  }
}
