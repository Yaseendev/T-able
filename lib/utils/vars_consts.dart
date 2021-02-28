import 'package:T_able/models/Event/event.dart';
import 'package:T_able/models/calendar/calendar.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as gc;

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