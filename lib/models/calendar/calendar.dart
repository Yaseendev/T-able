import 'package:t_able/models/Event/event.dart';
import 'package:googleapis/androidmanagement/v1.dart';
import 'package:hive/hive.dart';
import 'package:googleapis/calendar/v3.dart' as gc;

part 'calendar.g.dart';

@HiveType(typeId: 2)
class Calendar extends HiveObject {
  @HiveField(0)
  String title;
  @HiveField(1)
  DateTime start;
  @HiveField(2)
  DateTime end;
  @HiveField(3)
  String type;
  @HiveField(4)
  String notes;
  @HiveField(5)
  List<Calendar> content;
  @HiveField(6)
  List<Event> events;
  @HiveField(7)
  String rootCalendarTitle;
  @HiveField(8)
  String googleCalendarId;
  @HiveField(9)
  String location;

  Calendar(
      {this.title = 'No title',
      this.start,
      this.end,
      this.type = 'other',
      this.notes = '',
      this.content,
      this.events,
      this.rootCalendarTitle,
      this.googleCalendarId,
      this.location});

  // void addCalendars(List<Calendar> calendars) {
  //   content.addAll(calendars);
  //   notifyListeners();
  // }

  // void addEvents(List<Event> newEvents) {
  //   events.addAll(n);
  //   notifyListeners();
  // }
  // void editTitle() {}
  // void editStartDateTime() {}
  // void editEndDateTime() {}
  // void editNotes() {}
}
