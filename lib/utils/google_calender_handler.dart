import 'package:googleapis/calendar/v3.dart' as gc;
import 'package:googleapis_auth/auth_io.dart';
import 'package:http/http.dart' as http;
import 'secure_storage.dart';
import 'package:url_launcher/url_launcher.dart';
import 'vars_consts.dart';

class GoogleCalendar {
  final storage = SecureStorage();
  gc.Calendar calendar = gc.Calendar();

  //Get Authenticated Http Client
  Future<http.Client> getHttpClient() async {
    //Get Credentials
    var credentials = await storage.getCredentials();
    if (credentials == null) {
      //Needs user authentication
      var authClient = await clientViaUserConsent(
          ClientId(clientID, clientSecret), scopes, (url) {
        //Open Url in Browser
        launch(url);
      });
      //Save Credentials
      await storage.saveCredentials(authClient.credentials.accessToken,
          authClient.credentials.refreshToken);
      return authClient;
    } else {
      print(credentials["expiry"]);
      //Already authenticated
      return authenticatedClient(
          http.Client(),
          AccessCredentials(
              AccessToken(credentials["type"], credentials["data"],
                  DateTime.tryParse(credentials["expiry"])),
              credentials["refreshToken"],
              scopes));
    }
  }

  Future<gc.Calendar> addCalendar(String title) async {
    //storage.clear();
    var client = await getHttpClient();
    var googleCalendar = gc.CalendarApi(client);

    calendar.summary = title;

    return googleCalendar.calendars.insert(calendar)
        //.then((value) {
        // print("ADDED a calendar...${value.summary}");
        //return value;
        //})
        .catchError((e) {
      print(e);
      storage.clear();
      addCalendar(title);
    });
  }

  Future<gc.Calendar> getCalendar(String calendarId) async {
    //storage.clear();
    var client = await getHttpClient();
    var googleCalendar = gc.CalendarApi(client);
    //try {
    return googleCalendar.calendars.get(calendarId).catchError((e) {
      if (e.toString().contains('404'))
        return null;
      else {
        print(e);
        storage.clear();
        getCalendar(calendarId);
      }
    });
  }

  Future<gc.CalendarList> getCalendarList() async {
    var client = await getHttpClient();
    var googleCalendar = gc.CalendarApi(client);
    try {
      googleCalendar.calendarList.list().then((resCalendar) {
        print("ADDED a calendar...${resCalendar.items.toString()}");
        return resCalendar;
      });
    } catch (e) {
      print('Error while creating event $e');
    }
    return null;
  }

  removeCalendar(String calendarId) async {
    var client = await getHttpClient();
    var googleCalendar = gc.CalendarApi(client);
    
     return googleCalendar.calendars.delete(calendarId).catchError((e) {
      if (e.toString().contains('404'))
        return null;
      else {
        print(e);
        storage.clear();
        removeCalendar(calendarId);
      }
    });
  }

  updateCalendar(String calendarId, String newName) async {
    var client = await getHttpClient();
    var googleCalendar = gc.CalendarApi(client);
    calendar = gc.Calendar();
    calendar.summary = newName;
    try {
      googleCalendar.calendars.update(calendar, calendarId).then((resCalendar) {
        print("Removed a calendar...${resCalendar.summary}");
        return true;
      });
    } catch (e) {
      print('Error while creating event $e');
    }
    return false;
  }

  addEvent(String calendarId, String title, startTime, endTime,
      {String location = ''}) async {
    var client = await getHttpClient();
    var googleCalendar = gc.CalendarApi(client);
    gc.Event event = gc.Event();
    event.summary = title;

    gc.EventDateTime start = gc.EventDateTime();
    start.dateTime = startTime;
    start.timeZone = "GMT+02:00";
    event.start = start;

    gc.EventDateTime end = new gc.EventDateTime();
    end.timeZone = "GMT+02:00";
    end.dateTime = endTime;
    event.end = end;
    event.location = location;

    //try {
    return googleCalendar.events.insert(event, calendarId).catchError((e) {
      print(e);
      if (e.toString().contains('404'))
        return null;
      else {
        //print(e);
        storage.clear();
        addEvent(calendarId, title, startTime, endTime,location: event.location);
      }
    });
    //.then((value) {
    //print("ADDED to calendar...${value.status}");
    //return value;
    // if (value.status == "confirmed") {
    //   print('Your Event added successfully');
    //   return value;
    // } else {
    //   print("Unable to add event");
    // }
    //});
//    } catch (e) {
    //   print('Error while creating event $e');
    // }
  }

  getEvent(
    String calendarId,
    String eventId,
  ) async {
    var client = await getHttpClient();
    var googleCalendar = gc.CalendarApi(client);
    // try {
    return googleCalendar.events.get(calendarId, eventId);
    //   .then((value) {
    //     print("Retrived from calendar...${value.status}");
    //     if (value.status == "confirmed") {
    //       print('Your Event added successfully');
    //       return value;
    //     } else {
    //       print("Unable to add event");
    //     }
    //   });
    // } catch (e) {
    //   print('Error while creating event $e');
    // }
    // return null;
  }

  deleteEvent(
    String calendarId,
    String eventId,
  ) async {
    var client = await getHttpClient();
    var googleCalendar = gc.CalendarApi(client);
    try {
      googleCalendar.events.delete(calendarId, eventId).then((value) {
        print("Removed an event...");
        return true;
      });
    } catch (e) {
      print('Error while creating event $e');
    }
    return false;
  }

  getAllEvents(String calendarId) async {
    var client = await getHttpClient();
    var googleCalendar = gc.CalendarApi(client);

    return googleCalendar.events.list(calendarId).catchError((e) {
      if (e.toString().contains('404'))
        return null;
      else {
        print(e);
        storage.clear();
        getAllEvents(calendarId);
      }
    });
  }
}
