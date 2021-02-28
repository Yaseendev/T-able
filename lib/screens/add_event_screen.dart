import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter/material.dart';
import 'package:googleapis/calendar/v3.dart' as googleCalendar;
import 'package:googleapis_auth/auth_io.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:convert';

class AddEventScreen extends StatefulWidget {
  @override
  _AddEventScreenState createState() => _AddEventScreenState();
}

class _AddEventScreenState extends State<AddEventScreen> {
  insert(title, startTime, endTime) {
    
    var _clientID = new ClientId(
        "921123218509-vkfpjduam1m89v38j5np4mdcduet9m0b.apps.googleusercontent.com",
        "");
    clientViaUserConsent(_clientID, CalendarClient._scopes, prompt)
        .then((AuthClient client) {
      var calendar = googleCalendar.CalendarApi(client);
      calendar.calendarList
          .list()
          .then((value) => print("VAL________${value.etag}"));

      String calendarId =
          "primary"; //"primary "If you want to work on primary calender of logged in user
      googleCalendar.Event gEvent =
          googleCalendar.Event(); // Create object of event
      googleCalendar.CalendarList clist = googleCalendar.CalendarList();
      //calendar.calendarList.watch(request);
      googleCalendar.Channel channel = googleCalendar.Channel();
     // channel.
      gEvent.summary = title;

      googleCalendar.EventDateTime start = googleCalendar.EventDateTime();
      start.dateTime = startTime;
      start.timeZone = "GMT+03:00";
      gEvent.start = start;

      googleCalendar.EventDateTime end = new googleCalendar.EventDateTime();
      end.timeZone = "GMT+03:00";
      end.dateTime = endTime;
      gEvent.end = end;

      try {
        calendar.events.insert(gEvent, calendarId).then((value) {
          print("ADDED to calendar...${value.status}");
          if (value.status == "confirmed") {
            print('Your Event added successfully');
          } else {
            print("Unable to add event");
          }
        });
      } catch (e) {
        print('Error while creating event $e');
      }
    });
  }

  void prompt(String url) async {
    print("Please go to the following URL and grant access:");
    print("  => $url");

    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Row(
          children: [
            FlatButton(
                onPressed: () {
                  DatePicker.showDateTimePicker(context, showTitleActions: true,
                      onChanged: (date) {
                    print('change $date in time zone ' +
                        date.timeZoneOffset.inHours.toString());
                  }, onConfirm: (date) {
                    print('confirm date $date');
                    insert('Test flutter', DateTime.now(), date);
                  }, currentTime: DateTime.now());
                },
                child: Text(
                  'Add event',
                  style: TextStyle(color: Colors.blue),
                )),
            Text('${DateTime.now().toIso8601String()}'),
          ],
        ),
      ),
    );
  }
}

class CalendarClient {
  static const _scopes = const [googleCalendar.CalendarApi.CalendarScope];
}
