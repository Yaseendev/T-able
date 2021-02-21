import 'package:T_able/models/Event/event.dart';
import 'package:T_able/models/calendar/calendar.dart';
import 'package:flutter/material.dart';

enum EndingOptions { never, onDate, after }
var events;
//var calendars;
List<Event> impEvents = [];
const Color primaryColor1 = Color(0xFF082050);
const Color primaryColor2 = Color(0xFF000C18);
const Color primaryColor3 = Color(0xFF181D29);
const Color primaryColor4 = Color(0xFF2D2F3F);
const String BOT_URL = "https://t-able-chatbot.herokuapp.com/bot";
var allCalendars;
 
