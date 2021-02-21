import 'package:T_able/models/calendar/calendar.dart';

abstract class CalenderListEvent {}

class AddCalendarEvent extends CalenderListEvent {
  final Calendar calendar;
  AddCalendarEvent(this.calendar);
}

class RemoveCalendarEvent extends CalenderListEvent {
  final Calendar calendar;
  RemoveCalendarEvent(this.calendar);
}
