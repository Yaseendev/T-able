import 'dart:async';
import 'package:T_able/models/calendar/calendar.dart';
import 'package:T_able/utils/bloc/calendarsList/calendarList_state.dart';
//import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'calendarList_event.dart';

class CalenderListBloc extends Bloc<CalenderListEvent, CalendarListState> {
  CalenderListBloc(CalendarListState initialState) : super(initialState);

  //CalenderListBloc(CalendarListState initialState) : super(initialState);

  @override
  Stream<CalendarListState> mapEventToState(CalenderListEvent event) {
    // TODO: implement mapEventToState
    throw UnimplementedError();
  }

 

    // if (event is AddCalendarEvent)
    //   _allCalendars.add(event.calendar);
    // else if (event is RemoveCalendarEvent) _allCalendars.remove(event.calendar);

}
