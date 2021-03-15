import 'package:t_able/models/calendar/calendar.dart';

class CalendarListState {
  List<Calendar> _allCalendars;

  CalendarListState._();

  factory CalendarListState.initial() {
    return CalendarListState._().._allCalendars = [];
  }
}
