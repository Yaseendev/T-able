import 'package:t_able/models/Event/event.dart';
import 'package:t_able/models/calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as gc;
import 'package:time_machine/time_machine.dart';
import 'package:timetable/timetable.dart' as t;

enum EndingOptions { never, onDate, after }
var events;
//var calendars;
List<Event> impEvents = [];
const Color primaryColor1 = Color(0xFF082050);
const Color primaryColor2 = Color(0xFF000C18);
const Color primaryColor3 = Color(0xFF181D29);
const Color primaryColor4 = Color(0xFF2D2F3F);
const String BOT_URL = "http://192.168.244.79:5000/bot";
var allCalendars;
var settings;
const clientID =
    '900920692727-3pojcvst9rek182r3gluud7e4rdpt15e.apps.googleusercontent.com';
const clientSecret = 'Wqv5TvtOWXXmaO1rBpt9r9k6';
const scopes = [gc.CalendarApi.CalendarScope];
const kDistanceApiKey = 'prj_test_pk_e5c000a2613315e821a5590d2180ebbba5c11007';
const kDistanceApiUrl = 'https://api.radar.io/v1/route/distance';
var dEventBox;
List<t.BasicEvent> bEvents = [];
int dEventId = 0;
void addTodynCalendar() {
  for (int i = 0; i < events.length; i++) {
    print(events.getAt(i));
    DateTime start = events.getAt(i).startTime;
    DateTime end = events.getAt(i).endTime;
    bEvents.add(t.BasicEvent(
      id: dEventId++,
      title: events.getAt(i).title,
      color: Colors.blue,
      start: LocalDate.dateTime(start)
          .at(LocalTime(start.hour, start.minute, 0)),
      end: LocalDate.dateTime(end)
          .at(LocalTime(end.hour, end.minute, 0)),
    ));
  }
}
