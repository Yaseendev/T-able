import 'package:T_able/models/calendar/calendar.dart';
import 'package:T_able/screens/calender_content.dart';
import 'package:T_able/widgets/calendar_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/vars_consts.dart';

class CalendarsListWidget extends StatefulWidget {
  final calendarlist;
  //final bloc;

  CalendarsListWidget({this.calendarlist});

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
                try{
                     widget.calendarlist.getAt(position);}
                     catch (e) {
                      print(e);
                      isHive = false;
                    }
                return Dismissible(
                  onDismissed: (direction) {
                    //setState(() {
                    try {
                      widget.calendarlist.deleteAt(position);
                    } catch (e) {
                      print(e);
                      isHive = false;
                      widget.calendarlist.removeAt(position);
                    }
                    print(widget.calendarlist.toMap());
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
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (BuildContext context) => CalendarScreen(
                                calendar: isHive
                                    ? widget.calendarlist.getAt(position)
                                    : widget.calendarlist[position],
                                calendars: widget.calendarlist,
                              )));
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
