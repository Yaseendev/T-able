import 'package:t_able/utils/vars_consts.dart';
import 'package:t_able/widgets/action_button.dart';
import 'package:timetable/timetable.dart';
import 'package:flutter/material.dart';
import 'package:time_machine/time_machine.dart';

class DynamicCalendarScreen extends StatefulWidget {
  @override
  _DynamicCalendarScreenState createState() => _DynamicCalendarScreenState();
}

class _DynamicCalendarScreenState extends State<DynamicCalendarScreen> {
  TimetableController<BasicEvent> _controller;
  
  @override
  void initState() {
    super.initState();
    _controller = TimetableController(
      eventProvider: EventProvider.list(
        bEvents
        // [
        // BasicEvent(
        //   id: 0,
        //   title: 'My Event',
        //   color: Colors.blue,
        //   start: LocalDate.today().at(LocalTime(13, 0, 0)),
        //   end: LocalDate.today().at(LocalTime(15, 0, 0)),
        // ),]
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
key: _scaffoldKey,
floatingActionButton: CustomActionButton(sKey: _scaffoldKey,),
      body: SafeArea(
        child: Timetable<BasicEvent>(
          controller: _controller,
          eventBuilder: (event) {
            return BasicEventWidget(
              event,
              onTap: () {},
            );
          },
        ),
      ),
    );
  }
}
