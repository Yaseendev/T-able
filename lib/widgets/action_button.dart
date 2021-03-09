import 'dart:io';
import 'dart:math';
import 'package:T_able/models/Event/event.dart';
import 'package:T_able/models/calendar/calendar.dart';
import 'package:T_able/screens/image_screen.dart';
import 'package:T_able/utils/DateformatingHelper.dart';
import 'package:T_able/utils/bloc/calendarsList/calendarList_event.dart';
import 'package:T_able/utils/google_calender_handler.dart';
import 'package:T_able/utils/vars_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hive/hive.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:location/location.dart';
//import 'package:provider/provider.dart';
import 'package:unicorndial/unicorndial.dart';
import 'DropdownMenu.dart';
import 'day_container.dart';
import 'unicorndialer_opt.dart';
import 'package:progress_dialog/progress_dialog.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CustomActionButton extends StatefulWidget {
  final Calendar calendar;
  //final bloc;
  //inal calendars;
  final sKey;
  // ignore: avoid_init_to_null
  CustomActionButton({this.calendar = null, this.sKey});
  @override
  _CustomActionButtonState createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  TextEditingController textController = new TextEditingController(),
      numController,
      calendarController = new TextEditingController();
  TextEditingController _locationTextController;
  String selectedStartDate,
      selectedStartTime,
      selectedEndTime,
      selectedEndDate,
      endOnDate,
      alarmOpSelect,
      selectedAlarmTime;
  DateTime stDate, endDate;
  TimeOfDay stTime, endTime, alarmTime;
  EndingOptions _options;
  List<Widget> alarmsWidgets = [];
  List<DropdownMenuItem<String>> s = [
    DropdownMenuItem(
      child: Text('Minutes'),
      value: 'Minutes',
    ),
    DropdownMenuItem(
      child: Text('Hours'),
      value: 'Hours',
    ),
    DropdownMenuItem(
      child: Text('Days'),
      value: 'Days',
    ),
    DropdownMenuItem(
      child: Text('Weeks'),
      value: 'Weeks',
    ),
  ];
  List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  List<Media> _listImagePaths = List();
  bool isRepeated, alarmEnabled;
  List<bool> _alarmOptSelection;
  String _selectedCalendar;
  List<DropdownMenuItem<String>> _calendarDropdownItems;
  int _calIndex;
  final gcCalendar = GoogleCalendar();
  var settingsBox = Hive.box('settings');
  var showAlert;
  var gcSync;
  bool isGcEnabled;
  ProgressDialog pr;
  bool _showMap = false;
  var currentPosition;
  CameraPosition _kInitialPosition;
  GoogleMapController mapController;
  ScrollController scrollController;
  bool _enableSA;
  String _sAText;

  @override
  void initState() {
    super.initState();
    getGeoLocation();
    Geolocator.getCurrentPosition().then((value) => currentPosition = value);
    print(currentPosition);
    _kInitialPosition =
        CameraPosition(target: LatLng(33.5138073, 36.2765279), zoom: 11.0);
  }

  void getGeoLocation() async {
    currentPosition = await Geolocator.getCurrentPosition();
  }

  void onMapCreated(GoogleMapController controller) async {
    setState(() {
      mapController = controller;
    });
  }

  @override
  Widget build(BuildContext context) {
    // var allCalendars = Provider.of<ValueNotifier<List<Calendar>>>(context);
    //_initProgressDialog(pr, 'Retrieving Calendar...');
    print(currentPosition);

    return UnicornDialer(
      parentHeroTag: "btn2",
      parentButtonBackground: primaryColor4,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add),
      childButtons: [
        //Add calendar option
        profileOption(
          tag: 'add_cal',
          iconData: Icons.calendar_today_rounded,
          onPressed: () {
            Platform.isAndroid
                ? showDialog(
                    context: context,
                    barrierDismissible: true,
                    builder: (_) => StatefulBuilder(builder:
                            (BuildContext context,
                                StateSetter setState /*You can rename this!*/) {
                          return AlertDialog(
                            title: Text('Add a calendar'),
                            actions: [
                              Center(
                                child: FlatButton(
                                    onPressed: () {
                                      Navigator.pop(_);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (ctx) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          elevation: 24.0,
                                          title: Text('New Calendar'),
                                          content: TextField(
                                            autocorrect: true,
                                            autofocus: true,
                                            enableInteractiveSelection: true,
                                            enableSuggestions: true,
                                            decoration: new InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 5,
                                                    bottom: 5,
                                                    top: 10,
                                                    right: 10),
                                                hintText: 'Calendar name'),
                                            controller: calendarController,
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text('Add'),
                                              onPressed: () async {
                                                Navigator.pop(ctx);
                                                //Show suync dialog

                                                await showMaterialSyncAlert(
                                                    ctx);
                                                //showToast();
                                                // setState(() {
                                                String calTitle =
                                                    calendarController.text;
                                                String rootCal;

                                                if (widget.calendar == null) {
                                                  //setState(() {
                                                  addRootCalLocal(calTitle);
                                                  var gCalendar;
                                                  if (isGcEnabled || gcSync) {
                                                    await gcCalendar
                                                        .addCalendar(calTitle)
                                                        .then((value) =>
                                                            gCalendar = value);
                                                    if (gCalendar != null) {
                                                      allCalendars.put(
                                                          calTitle,
                                                          Calendar(
                                                            title: calTitle,
                                                            content: [],
                                                            events: [],
                                                            rootCalendarTitle:
                                                                rootCal,
                                                            googleCalendarId:
                                                                gCalendar.id,
                                                          ));
                                                      showToast(
                                                          'Calendar added to google calendar');
                                                    } else
                                                      showToast(
                                                          'Could not add the calendar to google calendar (Check the availability of the google calendar)');
                                                  }
                                                  //});
                                                  // notifyListeners();
                                                } else {
                                                  rootCal = widget.calendar
                                                      .rootCalendarTitle;
                                                  var gCalendar;
                                                  // widget.calendar.content
                                                  //     .add(Calendar(
                                                  //   title: calTitle,
                                                  //   content: [],
                                                  //   events: [],
                                                  //   rootCalendarTitle: rootCal,
                                                  // ));
                                                  if (isGcEnabled || gcSync) {
                                                    await gcCalendar
                                                        .addCalendar(calTitle)
                                                        .then((value) =>
                                                            gCalendar = value);
                                                    if (gCalendar == null)
                                                      showToast(
                                                          'Could not add the calendar to google calendar');
                                                  }
                                                  //if (gCalendar != null)
                                                  widget.sKey.currentState
                                                      .setState(() {
                                                    widget.calendar.content
                                                        .add(Calendar(
                                                      title: calTitle,
                                                      content: [],
                                                      events: [],
                                                      rootCalendarTitle:
                                                          rootCal,
                                                      googleCalendarId:
                                                          gCalendar != null
                                                              ? gCalendar.id
                                                              : null,
                                                    ));
                                                  });
                                                  if (gCalendar != null) {
                                                    showToast(
                                                        'Calendar added to google calendar');
                                                    print(
                                                        'added to GC $calTitle: ${gCalendar.id}');
                                                  } else {}
                                                  allCalendars.put(
                                                      rootCal,
                                                      allCalendars
                                                          .get(rootCal));
                                                }
                                                //});
                                                print(calendarController.text);
                                                calendarController.clear();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('Cancel'),
                                              onPressed: () =>
                                                  Navigator.pop(ctx),
                                            )
                                          ],
                                        ),
                                      );
                                    },
                                    child: Text('Manully')),
                              ),
                              Center(
                                child: FlatButton(
                                    onPressed: () async {
                                      Navigator.pop(_);
                                      try {
                                        _listImagePaths =
                                            await ImagePickers.pickerPaths(
                                          galleryMode: GalleryMode.image,
                                          showGif: false,
                                          selectCount: 1,
                                          showCamera: true,
                                          // cropConfig :CropConfig(enableCrop: true,height: 1,width: 1),
                                          compressSize: 500,
                                          uiConfig: UIConfig(
                                            uiThemeColor: primaryColor1,
                                          ),
                                        );
                                        _listImagePaths.forEach((media) {
                                          print(media.path.toString());
                                          Navigator.push(context,
                                              MaterialPageRoute(builder:
                                                  (BuildContext context) {
                                            return ImageScreen(media.path);
                                          }));
                                        });
                                        setState(() {});
                                      } on PlatformException {}
                                    },
                                    child: Text(
                                      'From image',
                                      textDirection: TextDirection.ltr,
                                    )),
                              ),
                              Center(
                                child: FlatButton(
                                    onPressed: () {
                                      Navigator.pop(_);
                                      showDialog(
                                        context: context,
                                        barrierDismissible: false,
                                        builder: (ctx) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.all(
                                                  Radius.circular(20.0))),
                                          elevation: 24.0,
                                          title: Text('New Calendar'),
                                          content: TextField(
                                            autocorrect: true,
                                            autofocus: true,
                                            enableInteractiveSelection: true,
                                            enableSuggestions: true,
                                            decoration: new InputDecoration(
                                                contentPadding: EdgeInsets.only(
                                                    left: 5,
                                                    bottom: 5,
                                                    top: 10,
                                                    right: 10),
                                                hintText: 'Calendar ID'),
                                            controller: calendarController,
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text('Add'),
                                              onPressed: () async {
                                                Navigator.pop(ctx);
                                                _initProgressDialog(
                                                    'Retrieving Calendar...');
                                                pr.show();
                                                await gcCalendar
                                                    .getCalendar(
                                                        calendarController.text)
                                                    .then((resCal) async {
                                                  if (resCal != null) {
                                                    if (widget.calendar ==
                                                        null) {
                                                      Calendar localCal =
                                                          Calendar(
                                                        title: resCal.summary,
                                                        content: [],
                                                        events: [],
                                                        rootCalendarTitle:
                                                            resCal.id,
                                                        location:
                                                            resCal.location,
                                                        googleCalendarId:
                                                            resCal.id,
                                                      );
                                                      List<Event> resEv = [];
                                                      await extractGcEvents(
                                                              resCal.id)
                                                          .then((value) =>
                                                              resEv = value);
                                                      localCal.events
                                                          .addAll(resEv);
                                                      allCalendars.put(
                                                          resCal.summary,
                                                          localCal);
                                                    } else {
                                                      String rootCal = widget
                                                          .calendar
                                                          .rootCalendarTitle;
                                                      Calendar localCal =
                                                          Calendar(
                                                        title: resCal.summary,
                                                        notes:
                                                            resCal.description,
                                                        content: [],
                                                        events: [],
                                                        rootCalendarTitle:
                                                            rootCal,
                                                        googleCalendarId:
                                                            resCal.id,
                                                        location:
                                                            resCal.location,
                                                      );
                                                      List<Event> resEv = [];
                                                      await extractGcEvents(
                                                              resCal.id)
                                                          .then((value) =>
                                                              resEv = value);
                                                      localCal.events
                                                          .addAll(resEv);
                                                      widget.calendar.content
                                                          .add(localCal);
                                                      allCalendars.put(
                                                          rootCal,
                                                          allCalendars
                                                              .get(rootCal));
                                                    }
                                                  }
                                                  pr.hide().whenComplete(() {
                                                    resCal != null
                                                        ? showToast(
                                                            'Calendar ${resCal.summary} fetched from google calendar')
                                                        : showToast(
                                                            'Could not find the calendar');
                                                  });
                                                });
                                                calendarController.clear();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('Cancel'),
                                              onPressed: () =>
                                                  Navigator.pop(ctx),
                                            ),
                                          ],
                                        ),
                                      );
                                    },
                                    child: Text('From google calendar')),
                              ),
                            ],
                            shape: RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20.0))),
                            elevation: 24.0,
                          );
                        }))
                : showCupertinoModalPopup(
                    context: context,
                    builder: (_) => CupertinoActionSheet(
                      title: Text('Add a calendar'),
                      message: Text('Select how you want to add a calendar'),
                      actions: [
                        CupertinoActionSheetAction(
                            onPressed: () {
                              Navigator.pop(_);
                              showCupertinoDialog(
                                  context: context,
                                  barrierDismissible: false,
                                  builder: (ctx) =>
                                      StatefulBuilder(builder: (BuildContext
                                              ctx,
                                          StateSetter
                                              setState /*You can rename this!*/) {
                                        return CupertinoAlertDialog(
                                          title: Text('New Calendar'),
                                          content: CupertinoTextField(
                                            autocorrect: true,
                                            autofocus: true,
                                            enableInteractiveSelection: true,
                                            enableSuggestions: true,
                                            placeholder: 'Calendar name',
                                            controller: calendarController,
                                          ),
                                          actions: [
                                            FlatButton(
                                              child: Text('Add'),
                                              onPressed: () async {
                                                Navigator.pop(ctx);
                                                await showCupertSyncAlert(ctx);
                                                //setState(() {
                                                String calTitle =
                                                    calendarController.text;
                                                String rootCal;
                                                if (widget.calendar == null) {
                                                  // setState(() {
                                                  rootCal = calTitle;
                                                  var gCalendar;
                                                  allCalendars.put(
                                                      calTitle,
                                                      Calendar(
                                                        title: calTitle,
                                                        content: [],
                                                        events: [],
                                                        rootCalendarTitle:
                                                            rootCal,
                                                      ));
                                                  if (isGcEnabled || gcSync) {
                                                    await gcCalendar
                                                        .addCalendar(calTitle)
                                                        .then((value) =>
                                                            gCalendar = value);
                                                    if (gCalendar != null) {
                                                      allCalendars.put(
                                                          calTitle,
                                                          Calendar(
                                                            title: calTitle,
                                                            content: [],
                                                            events: [],
                                                            rootCalendarTitle:
                                                                rootCal,
                                                            googleCalendarId:
                                                                gCalendar.id,
                                                          ));
                                                      showToast(
                                                          'Calendar added to google calendar');
                                                    } else
                                                      showToast(
                                                          'Could not add the calendar to google calendar');
                                                  }
                                                  //});
                                                  // allCalendars.value.add(Calendar(
                                                  //   title: calendarController.text,
                                                  // ));
                                                } else {
                                                  rootCal = widget.calendar
                                                      .rootCalendarTitle;
                                                  var gCalendar;
                                                  if (isGcEnabled || gcSync) {
                                                    await gcCalendar
                                                        .addCalendar(calTitle)
                                                        .then((value) =>
                                                            gCalendar = value);
                                                  }
                                                  widget.calendar.content
                                                      .add(Calendar(
                                                    title: calTitle,
                                                    content: [],
                                                    events: [],
                                                    rootCalendarTitle: rootCal,
                                                    googleCalendarId:
                                                        gCalendar != null
                                                            ? gCalendar.id
                                                            : null,
                                                  ));
                                                  if (gCalendar != null) {
                                                    showToast(
                                                        'Calendar added to google calendar');
                                                    print(
                                                        'added to GC $calTitle: ${gCalendar.id}');
                                                  } else {
                                                    showToast(
                                                        'Could not add the calendar to google calendar');
                                                  }
                                                  allCalendars.put(
                                                      rootCal,
                                                      allCalendars
                                                          .get(rootCal));
                                                }
                                                calendarController.clear();
                                              },
                                            ),
                                            FlatButton(
                                              child: Text('Cancel'),
                                              onPressed: () =>
                                                  Navigator.pop(ctx),
                                            )
                                          ],
                                        );
                                      }));
                            },
                            child: Text('Add Manully')),
                        CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(_),
                            child: Text('Add from image')),
                        CupertinoActionSheetAction(
                            onPressed: () => Navigator.pop(_),
                            child: Text('Add from google calendar')),
                      ],
                      cancelButton: CupertinoActionSheetAction(
                        child: Text('Cancel'),
                        onPressed: () => Navigator.pop(_),
                      ),
                    ),
                  );
          },
        ),
        //Add event option
        profileOption(
            tag: 'add_events',
            iconData: Icons.add_alarm,
            onPressed: () {
              // textController.text = '1';
              _initSheet();
              showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return StatefulBuilder(
                    builder: (BuildContext context,
                        StateSetter setState /*You can rename this!*/) {
                      return Container(
                        padding: EdgeInsets.all(10),
                        height: MediaQuery.of(context).size.height - 80.0,
                        //color: Colors.blueAccent,
                        child: SingleChildScrollView(
                          controller: scrollController,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.drag_handle,
                                    color: Colors.grey,
                                  ),
                                ],
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              TextFormField(
                                autocorrect: true,
                                enableInteractiveSelection: true,
                                enableSuggestions: true,
                                showCursor: true,
                                cursorColor: Colors.black,
                                keyboardType: TextInputType.text,
                                decoration: new InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        left: 5, bottom: 5, top: 10, right: 10),
                                    hintText: "Add title"),
                                controller: textController,
                              ),
                              //TODO: Addd a divider
                              SizedBox(
                                height: 15.0,
                              ),
                              ListTile(
                                leading: Text('From'),
                                title: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xFFEFF3F2),
                                    child: Text(selectedStartDate),
                                  ),
                                  onTap: () => showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1960),
                                          lastDate: DateTime(2050))
                                      .then((value) {
                                    print(value);
                                    stDate = value;
                                    if (value != null)
                                      setState(() {
                                        selectedStartDate = myDateFormat(value);
                                      });
                                  }),
                                ),
                                trailing: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xFFEFF3F2),
                                    child: Text(selectedStartTime),
                                  ),
                                  onTap: () => showTimePicker(
                                          context: context,
                                          initialTime: TimeOfDay.now())
                                      .then((value) {
                                    print(value.hour);
                                    stTime = value;
                                    alarmTime = stTime;
                                    if (value != null)
                                      setState(() {
                                        selectedStartTime =
                                            value.format(context);
                                        selectedAlarmTime = selectedStartTime;
                                      });
                                  }),
                                ),
                              ),
                              ListTile(
                                leading: Text('To'),
                                title: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xFFEFF3F2),
                                    child: Text(selectedEndDate),
                                  ),
                                  onTap: () => showDatePicker(
                                          context: context,
                                          initialDate: DateTime.now(),
                                          firstDate: DateTime(1960),
                                          lastDate: DateTime(2050))
                                      .then((value) {
                                    print(value);
                                    endDate = value;
                                    if (value != null)
                                      setState(() {
                                        selectedEndDate = myDateFormat(value);
                                      });
                                  }),
                                ),
                                trailing: InkWell(
                                  child: Container(
                                    padding: EdgeInsets.all(5),
                                    color: Color(0xFFEFF3F2),
                                    child: Text(selectedEndTime),
                                  ),
                                  onTap: () => showTimePicker(
                                          context: context,
                                          initialEntryMode:
                                              TimePickerEntryMode.input,
                                          initialTime: TimeOfDay.now()
                                              .replacing(
                                                  hour: TimeOfDay.now().hour ==
                                                          23
                                                      ? 0
                                                      : TimeOfDay.now().hour +
                                                          1))
                                      .then((value) {
                                    endTime = value;
                                    if (value != null)
                                      setState(() {
                                        selectedEndTime = value.format(context);
                                      });
                                  }),
                                ),
                              ),
                              //TODO: add a divider
                              ListTile(
                                leading: Switch(
                                  value: isRepeated,
                                  onChanged: (value) {
                                    setState(() {
                                      isRepeated = value;
                                    });
                                  },
                                ),
                                title: Text('Repeat'),
                              ),
                              isRepeated
                                  ? Column(children: [
                                      Text('Repeats Every',
                                          textAlign: TextAlign.start),
                                      Row(
                                        children: [
                                          Container(
                                            width: 50.0,
                                            height: 50.0,
                                            child: TextField(
                                              showCursor: true,
                                              keyboardType:
                                                  TextInputType.number,
                                              maxLength: 2,
                                              textAlign: TextAlign.center,
                                              maxLengthEnforced: true,
                                              controller: numController,
                                            ),
                                          ),
                                          SizedBox(
                                            width: 50.0,
                                          ),
                                          Container(
                                            width: 100.0,
                                            height: 50.0,
                                            child: dropdownmenu(setState),
                                          ),
                                        ],
                                      ),
                                      Divider(color: Colors.grey),
                                      Column(
                                        children: [
                                          Text(
                                            'Repeat On',
                                            textAlign: TextAlign.left,
                                          ),
                                          SizedBox(
                                            height: 20.0,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: displayRepDays(),
                                          ),
                                        ],
                                      ),
                                      Divider(color: Colors.grey),
                                      Text('Ends', textAlign: TextAlign.left),
                                      Column(
                                        children: [
                                          ListTile(
                                            title: Text('Never'),
                                            leading: Radio(
                                                value: EndingOptions.never,
                                                groupValue: _options,
                                                onChanged: (EndingOptions val) {
                                                  setState(() {
                                                    _options = val;
                                                  });
                                                }),
                                          ),
                                          ListTile(
                                            title: Row(
                                              // mainAxisAlignment:
                                              //MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text('On'),
                                                SizedBox(width: 10.0),
                                                InkWell(
                                                  child: Container(
                                                    padding: EdgeInsets.all(5),
                                                    color: Color(0xFFEFF3F2),
                                                    child: Text(endOnDate),
                                                  ),
                                                  onTap: () => showDatePicker(
                                                          context: context,
                                                          initialDate:
                                                              DateTime.now(),
                                                          firstDate:
                                                              DateTime(1960),
                                                          lastDate:
                                                              DateTime(2050))
                                                      .then((value) {
                                                    print(value);
                                                    if (value != null)
                                                      setState(() {
                                                        endOnDate = num2month(
                                                                value.month) +
                                                            ' ' +
                                                            value.day
                                                                .toString() +
                                                            ', ' +
                                                            value.year
                                                                .toString();
                                                      });
                                                  }),
                                                ),
                                              ],
                                            ),
                                            leading: Radio(
                                                value: EndingOptions.onDate,
                                                groupValue: _options,
                                                onChanged: (EndingOptions val) {
                                                  setState(() {
                                                    _options = val;
                                                  });
                                                }),
                                          ),
                                          ListTile(
                                            title: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              children: [
                                                Text('After'),
                                                Container(
                                                  width: 50.0,
                                                  height: 50.0,
                                                  child: TextField(
                                                    showCursor: true,
                                                    keyboardType:
                                                        TextInputType.number,
                                                    maxLength: 3,
                                                    textAlign: TextAlign.center,
                                                    maxLengthEnforced: true,
                                                    //controller: textController,
                                                  ),
                                                ),
                                                Text('Occurence'),
                                              ],
                                            ),
                                            leading: Radio(
                                                value: EndingOptions.after,
                                                groupValue: _options,
                                                onChanged: (EndingOptions val) {
                                                  setState(() {
                                                    _options = val;
                                                  });
                                                }),
                                          ),
                                        ],
                                      ),
                                    ])
                                  : Container(),
                              ListTile(
                                leading: Switch(
                                  value: alarmEnabled,
                                  onChanged: (value) {
                                    setState(() {
                                      alarmEnabled = value;
                                    });
                                  },
                                ),
                                title: Text('Alarm'),
                              ),
                              alarmEnabled
                                  ? Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        RaisedButton(
                                            child: Text(_sAText),
                                            onPressed: () async {
                                              var prefBox =
                                                  Hive.box('preferences');
                                              if (_enableSA) {
                                                setState(() {
                                                  _sAText =
                                                      'Turn Off Smart Alarm';
                                                  _enableSA = false;
                                                });
                                                if (_locationTextController
                                                        .text !=
                                                    null) {
                                                  var lat, long;
                                                  await Location.instance
                                                      .getLocation()
                                                      .then((value) {
                                                    lat = value.latitude;
                                                    long = value.longitude;
                                                    print(value.latitude
                                                        .toString());
                                                  });
                                                  var queryParameters = {
                                                    'origin':
                                                        '40.78382,-73.97536', //'$lat,$long',
                                                    'destination':
                                                        '40.70390,-73.98690', //_locationTextController.text,
                                                    'modes': 'foot,car',
                                                    'units': 'metric'
                                                  };
                                                  var uri = Uri.https(
                                                      'api.radar.io',
                                                      '/v1/route/distance',
                                                      queryParameters);
                                                  _initProgressDialog(
                                                      'Suggesting a Time...');
                                                  pr.show();
                                                  http.Response response =
                                                      await http.get(uri,
                                                          headers: {
                                                        'Authorization':
                                                            kDistanceApiKey
                                                      });
                                                  final Map responseBody = json
                                                      .decode(response.body);
                                                  final int statusCode =
                                                      response.statusCode;
                                                  if (statusCode != 200 ||
                                                      responseBody == null) {
                                                    print('falied');
                                                    setState(() {
                                                      _sAText =
                                                          'Turn On Smart Alarm';
                                                      _enableSA = true;
                                                    });
                                                  } else {
                                                    print(
                                                        'String: ${response.body}');
                                                    var carDurTxt =
                                                        responseBody['routes']
                                                                    ['car']
                                                                ['duration']
                                                            ['text'];
                                                    var footDurTxt =
                                                        responseBody['routes']
                                                                    ['foot']
                                                                ['duration']
                                                            ['text'];
                                                    var carDurVal =
                                                        responseBody['routes']
                                                                    ['car']
                                                                ['duration']
                                                            ['value'];
                                                    var footDurVal =
                                                        responseBody['routes']
                                                                    ['foot']
                                                                ['duration']
                                                            ['value'];
                                                    var dist =
                                                        responseBody['routes']
                                                                    ['car']
                                                                ['distance']
                                                            ['text'];
                                                    var bestTime = min(
                                                        double.parse(carDurVal),
                                                        double.parse(
                                                            footDurVal));
                                                    var readyTime = prefBox.get(
                                                        'readyTime',
                                                        defaultValue: 60);
                                                    print(bestTime);
                                                    var recommendedTime =
                                                        bestTime + readyTime;
                                                    showDialog(
                                                        context: context,
                                                        barrierDismissible:
                                                            true,
                                                        builder:
                                                            (ctx) =>
                                                                AlertDialog(
                                                                  shape: RoundedRectangleBorder(
                                                                      borderRadius:
                                                                          BorderRadius.all(
                                                                              Radius.circular(20.0))),
                                                                  elevation:
                                                                      24.0,
                                                                  title: Text(
                                                                      'Alarm Suggestion Summary'),
                                                                  content: Text('The destination between your location and the event location is $dist\n' +
                                                                      'Travel duration by car is $carDurTxt\n' +
                                                                      'Travel duration by foot is $footDurTxt\n' +
                                                                      'Your alarm will be set ${recommendedTime / 60} hours before this event start time'),
                                                                  actions: [
                                                                    FlatButton(
                                                                        child: Text(
                                                                            'Ok'),
                                                                        onPressed:
                                                                            () {
                                                                          Navigator.pop(
                                                                              ctx);
                                                                          alarmTime =
                                                                              stTime.replacing(minute: stTime.hour * 60 + stTime.minute + recommendedTime.round());
                                                                        })
                                                                  ],
                                                                ));
                                                  }
                                                  pr.hide().whenComplete(() {});
                                                }
                                              } else {
                                                setState(() {
                                                  _sAText =
                                                      'Turn On Smart Alarm';
                                                  _enableSA = true;
                                                });
                                              }
                                            }),
                                        InkWell(
                                          child: Container(
                                            padding: EdgeInsets.all(5),
                                            color: Color(0xFFEFF3F2),
                                            child: Text(selectedAlarmTime),
                                          ),
                                          onTap: () => showTimePicker(
                                                  context: context,
                                                  initialTime: stTime)
                                              .then((value) {
                                            if (value != null) {
                                              alarmTime = value;
                                              setState(() {
                                                selectedAlarmTime =
                                                    value.format(context);
                                              });
                                            }
                                          }),
                                        ),
                                      ],

                                      //Center(
                                      //     child: ToggleButtons(
                                      //       children: [
                                      //         Icon(Icons.ac_unit),
                                      //         Icon(Icons.access_alarms_sharp),
                                      //         Icon(Icons.account_balance_wallet),
                                      //       ],
                                      //       isSelected: _alarmOptSelection,
                                      //       onPressed: (index) {
                                      //         if (_alarmOptSelection
                                      //                 .contains(true) &&
                                      //             _alarmOptSelection[index] != true)
                                      //           print('More then one selected');
                                      //         else {
                                      //           setState(() {
                                      //             _alarmOptSelection[index] =
                                      //                 !_alarmOptSelection[index];
                                      //           });
                                      //         }
                                      //       },
                                      //       borderRadius: BorderRadius.all(
                                      //           Radius.circular(30.0)),
                                      //       borderWidth: 5,
                                      //     ),
                                    )
                                  : Container(),
                              Divider(
                                color: Colors.grey,
                              ),
                              ListTile(
                                leading: Icon(Icons.location_on),
                                title: TextFormField(
                                  autocorrect: true,
                                  enableInteractiveSelection: true,
                                  enableSuggestions: true,
                                  showCursor: true,
                                  cursorColor: Colors.black,
                                  keyboardType: TextInputType.text,
                                  decoration: new InputDecoration(
                                      contentPadding: EdgeInsets.only(
                                          left: 5,
                                          bottom: 5,
                                          top: 10,
                                          right: 10),
                                      hintText: "Add Location"),
                                  controller: _locationTextController,
                                ),
                                trailing: IconButton(
                                  icon: Icon(Icons.map),
                                  onPressed: () {
                                    setState(() {
                                      _showMap = !_showMap;
                                    });
                                  },
                                ),
                              ),
                              _showMap
                                  ? Container(
                                      height: 300,
                                      child: GoogleMap(
                                        buildingsEnabled: true,
                                        compassEnabled: true,
                                        mapToolbarEnabled: true,
                                        myLocationButtonEnabled: true,
                                        myLocationEnabled: true,
                                        trafficEnabled: true,
                                        rotateGesturesEnabled: true,
                                        scrollGesturesEnabled: true,
                                        zoomGesturesEnabled: true,
                                        onMapCreated:
                                            (GoogleMapController controller) {
                                          setState(() {
                                            mapController = controller;
                                          });
                                        },
                                        initialCameraPosition:
                                            _kInitialPosition,
                                        onTap: (LatLng pos) {
                                          print(pos);
                                          setState(() {
                                            // _lastTap = pos;
                                            _locationTextController.text =
                                                '${pos.latitude},${pos.longitude}';
                                          });
                                        },
                                      ),
                                    )
                                  : Container(),
                              Divider(
                                color: Colors.grey,
                              ),
                              ListTile(
                                leading: Icon(Icons.notifications_on),
                                title: Column(
                                  children: alarmsWidgets,
                                ),
                                trailing: InkWell(
                                  child: Icon(Icons.add),
                                  onTap: () {
                                    setState(() {
                                      //addAlarmTile(setState);
                                      alarmsWidgets.add(ListTile(
                                        leading: Text('Before'),
                                        title: Container(
                                          width: 50.0,
                                          height: 50.0,
                                          child: TextField(
                                            showCursor: true,
                                            keyboardType: TextInputType.number,
                                            maxLength: 3,
                                            textAlign: TextAlign.center,
                                            maxLengthEnforced: true,
                                            //controller: textController,
                                          ),
                                        ),
                                        trailing: DropdownButton<String>(
                                          elevation: 5,
                                          value: alarmOpSelect,
                                          items: s,
                                          onChanged: (val) {
                                            setState(() {
                                              alarmOpSelect = val;
                                            });

                                            print(alarmOpSelect);
                                          },
                                        ),
                                      ));
                                    });
                                  },
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              widget.calendar == null
                                  ? ListTile(
                                      leading: Text('Calendar : '),
                                      title: DropdownButton<String>(
                                        value: _selectedCalendar,
                                        items: _calendarDropdownItems,
                                        onChanged: (val) {
                                          setState(() {
                                            _selectedCalendar = val;
                                          });
                                        },
                                      ),
                                    )
                                  : Container(),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  RaisedButton(
                                      child: Text('Cancel'),
                                      onPressed: () {
                                        Navigator.pop(context);
                                        //showToast();
                                      }),
                                  RaisedButton(
                                      color: Colors.lightBlue,
                                      child: Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () async {
                                        print(textController.text);
                                        print('Date : $stDate');
                                        print(
                                            'Time : ${stTime.format(context)}');
                                        showAlert = settingsBox.get('showAlert',
                                            defaultValue: true);
                                        gcSync = settingsBox.get('gcSync',
                                            defaultValue: false);
                                        isGcEnabled = false;
                                        if (showAlert && !gcSync)
                                          await showGeneralDialog(
                                            context: context,
                                            pageBuilder: (context, animation1,
                                                animation2) {},
                                            transitionBuilder:
                                                (ctx, p1, p2, widget) {
                                              return Transform.scale(
                                                scale: p1.value,
                                                child: Opacity(
                                                  opacity: p1.value,
                                                  child: AlertDialog(
                                                    shape: OutlineInputBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(
                                                                    16.0)),
                                                    title: Text('Alert'),
                                                    content: Text(
                                                        'Do you want to also add it to your google calendar ?'),
                                                    //'Your calendars and events are synchronized with Google calendar\n(you may get asked once in a while to grant acess to your google account)'),
                                                    actions: [
                                                      FlatButton(
                                                          child: Text('Yes'),
                                                          onPressed: () {
                                                            isGcEnabled = true;
                                                            Navigator.pop(ctx);
                                                          }),
                                                      FlatButton(
                                                          child: Text(
                                                              'Yes,and always for all calendars'),
                                                          onPressed: () {
                                                            settingsBox.put(
                                                                'showAlert',
                                                                false);
                                                            settingsBox.put(
                                                                'gcSync', true);
                                                            gcSync = true;
                                                            Navigator.pop(ctx);
                                                          }),
                                                      FlatButton(
                                                          child: Text('No'),
                                                          onPressed: () {
                                                            Navigator.pop(ctx);
                                                          }),
                                                    ],
                                                  ),
                                                ),
                                              );
                                            },
                                            transitionDuration:
                                                Duration(milliseconds: 400),
                                            barrierDismissible: true,
                                            barrierLabel: '',
                                          );
                                           String parsedMonth = stDate.month < 10
                                              ? '0${stDate.month}'
                                              : '${stDate.month}';
                                          String parsedDay = stDate.day < 10
                                              ? '0${stDate.day}'
                                              : '${stDate.day}';
                                          var alarmDate = DateTime.parse(
                                              '${stDate.year}-$parsedMonth-$parsedDay ${alarmTime.hour}:${alarmTime.minute}:00');
                                        if (widget.calendar == null) {
                                          var gEvent;
                                          Calendar currentCal =
                                              allCalendars.getAt(_calIndex);

                                          // currentCal.events.add(Event(
                                          //   title: textController.text,
                                          //   startTime: stDate.add(Duration(
                                          //       hours: stTime.hour,
                                          //       minutes: stTime.minute)),
                                          //   endTime: endDate.add(Duration(
                                          //       hours: endTime.hour,
                                          //       minutes: endTime.minute)),
                                          //   alarms: [],
                                          //   ending: {},
                                          //   location: '',
                                          //   notes: '',
                                          //   repDays: [],
                                          //   repetitionCycle: {},
                                          // ));
                                          // allCalendars.put(
                                          //     currentCal
                                          //         .title,
                                          //     currentCal);
                                         
                                          Event newEvent = Event(
                                            title: textController.text,
                                            startTime: stDate,
                                            endTime: endDate,
                                            alarms: [],
                                            ending: {},
                                            location: _locationTextController !=
                                                    null
                                                ? _locationTextController.text
                                                : '',
                                            notes: '',
                                            repDays: [],
                                            repetitionCycle: {},
                                            alarmTime: alarmEnabled
                                                ? alarmDate
                                                : null,
                                            isSmartAlarm: _enableSA,
                                          );
                                          if (isGcEnabled || gcSync) {
                                            String gcId;
                                            if (currentCal.title == 'other')
                                              gcId = 'primary';
                                            else
                                              gcId =
                                                  currentCal.googleCalendarId;
                                            if (gcId == null) {
                                              var gCalendar =
                                                  await gcCalendar.addCalendar(
                                                      currentCal.title);
                                              if (gCalendar != null) {
                                                gcId = gCalendar.id;
                                                currentCal.googleCalendarId =
                                                    gcId;
                                                allCalendars.put(
                                                    currentCal.title,
                                                    currentCal);
                                              }
                                              gcId != null
                                                  ? showToast(
                                                      'This Calendar was not in your google calendar and it should be added now')
                                                  : showToast(
                                                      'Could not add the calendar to google calendar (Check the availability of the google calendar)');
                                            }
                                            await gcCalendar
                                                .addEvent(
                                                    gcId,
                                                    textController.text,
                                                    stDate,
                                                    endDate)
                                                .then((ev) {
                                              gEvent = ev;
                                            });

                                            // allCalendars.put(
                                            //     currentCal.title, currentCal);
                                            if (gEvent != null) {
                                              newEvent.googleCalendarEventId =
                                                  gEvent.id;
                                              showToast(
                                                  'Event added to your google calendar');
                                            } else
                                              showToast(
                                                  'Could not add the Event to google calendar (Check the availability of the google calendar)');
                                          }
                                          currentCal.events.add(newEvent);
                                          allCalendars.put(
                                              currentCal.title, currentCal);
                                        } else {
                                          //events.add(Event(
                                          var rootCal =
                                              widget.calendar.rootCalendarTitle;
                                          var gEvent;
                                          Calendar currentCal = widget.calendar;
                                          // currentCal.events.add(Event(
                                          //   title: textController.text,
                                          //   startTime: stDate.add(Duration(
                                          //       hours: stTime.hour,
                                          //       minutes: stTime.minute)),
                                          //   endTime: endDate.add(Duration(
                                          //       hours: endTime.hour,
                                          //       minutes: endTime.minute)),
                                          //   alarms: [],
                                          //   ending: {},
                                          //   location: '',
                                          //   notes: '',
                                          //   repDays: [],
                                          //   repetitionCycle: {},
                                          // ));
                                          // allCalendars.put(rootCal,
                                          //     allCalendars.get(rootCal));
                                          Event newEvent = Event(
                                            title: textController.text,
                                            startTime: stDate,
                                            endTime: endDate,
                                            alarms: [],
                                            ending: {},
                                            location: '',
                                            notes: '',
                                            repDays: [],
                                            repetitionCycle: {},
                                            alarmTime: alarmEnabled
                                                ? alarmDate
                                                : null,
                                            isSmartAlarm: _enableSA,
                                          );
                                          if (isGcEnabled || gcSync) {
                                            String gcId;
                                            if (currentCal.title == 'other')
                                              gcId = 'primary';
                                            else
                                              gcId =
                                                  currentCal.googleCalendarId;
                                            if (gcId == null) {
                                              var gCalendar =
                                                  await gcCalendar.addCalendar(
                                                      currentCal.title);
                                              if (gCalendar != null) {
                                                gcId = gCalendar.id;
                                                currentCal.googleCalendarId =
                                                    gcId;
                                                allCalendars.put(
                                                    currentCal.title,
                                                    currentCal);
                                              }
                                              gcId != null
                                                  ? showToast(
                                                      'This Calendar was not in your google calendar and it should be added now')
                                                  : showToast(
                                                      'Could not add the calendar to google calendar (Check the availability of the google calendar)');
                                            }
                                            await gcCalendar
                                                .addEvent(
                                                    gcId,
                                                    textController.text,
                                                    stDate,
                                                    endDate)
                                                .then((evt) => gEvent = evt);
                                            if (gEvent != null) {
                                              newEvent.googleCalendarEventId =
                                                  gEvent.id;

                                              showToast(
                                                  'Event added to your google calendar');
                                            } else
                                              showToast(
                                                  'Could not add the Event to google calendar (Check the availability of the google calendar)');
                                          }
                                          currentCal.events.add(newEvent);
                                          allCalendars.put(rootCal,
                                              allCalendars.get(rootCal));
                                          //events.close();
                                          Navigator.pop(context);
                                        }

                                        Navigator.pop(context);
                                      }),
                                ],
                              )
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              );
            }),
      ],
    );
  }

  void _initSheet() {
    //scrollController.
    if (textController != null) {
      print(textController.text);
      textController.clear();
    }
    int curH = TimeOfDay.now().hour;
    stDate = DateTime.now();
    endDate = DateTime.now();
    stTime = TimeOfDay.now();
    curH == 23
        ? endTime = TimeOfDay.now().replacing(hour: 0)
        : endTime = TimeOfDay.now().replacing(hour: curH + 1);
    selectedStartDate = myDateFormat(stDate);
    selectedStartTime = TimeOfDay.now().format(context);
    selectedEndDate = myDateFormat(DateTime.now());
    selectedEndTime = TimeOfDay.now()
        .replacing(hour: curH == 23 ? 0 : curH + 1)
        .format(context);
    endOnDate = num2month(DateTime.now().add(Duration(days: 120)).month) +
        ' ' +
        DateTime.now().add(Duration(days: 120)).day.toString() +
        ', ' +
        DateTime.now().add(Duration(days: 120)).year.toString();
    selectedAlarmTime = selectedStartTime;
    alarmTime = stTime;
    _showMap = false;
    _locationTextController = TextEditingController();

    _options = EndingOptions.never;
    alarmsWidgets = [];
    alarmOpSelect = 'Minutes';
    isRepeated = false;
    alarmEnabled = false;
    _calendarDropdownItems = [];
    _alarmOptSelection = List.generate(3, (_) => false);
    _selectedCalendar = 'other';
    for (int i = 0; i < allCalendars.length; i++) {
      //for (Calendar calendar in allCalendars) {
      _calendarDropdownItems.add(DropdownMenuItem(
        value: allCalendars.getAt(i).title,
        child: Text(allCalendars.getAt(i).title),
        onTap: () {
          _calIndex = i;
          print(_calIndex);
        },
      ));
      if (allCalendars.getAt(i).title == 'other') _calIndex = i;
    }
    _sAText = 'Turn On Smart Alarm';
    _enableSA = false;
  }

  List<Widget> displayRepDays() {
    List<Widget> days = [];
    weekDays.forEach((day) {
      days.add(
        DayCircleWidget(day),
      );
    });
    return days;
  }

  Future<void> showMaterialSyncAlert(BuildContext ctx) async {
    showAlert = settingsBox.get('showAlert', defaultValue: true);
    gcSync = settingsBox.get('gcSync', defaultValue: false);
    isGcEnabled = false;
    if (showAlert && !gcSync)
      await showGeneralDialog(
        context: ctx,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {},
        transitionBuilder: (contex, p1, p2, widget) {
          return Transform.scale(
            scale: p1.value,
            child: Opacity(
              opacity: p1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                title: Text('Alert'),
                content:
                    Text('Do you want to also add it to google calendar ?'),
                //'Your calendars and events are synchronized with Google calendar\n(you may get asked once in a while to grant acess to your google account)'),
                actions: [
                  FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        isGcEnabled = true;
                        Navigator.pop(contex);
                      }),
                  FlatButton(
                      child: Text('Yes,and always for all calendars'),
                      onPressed: () {
                        settingsBox.put('showAlert', false);
                        settingsBox.put('gcSync', true);
                        gcSync = true;
                        Navigator.pop(contex);
                      }),
                  FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.pop(contex);
                      }),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 400),
        barrierDismissible: true,
        barrierLabel: '',
      );
  }

  Future<void> showCupertSyncAlert(BuildContext ctx) async {
    showAlert = settingsBox.get('showAlert', defaultValue: true);
    gcSync = settingsBox.get('gcSync', defaultValue: false);
    isGcEnabled = false;
    if (showAlert && !gcSync)
      await showGeneralDialog(
        context: ctx,
        // ignore: missing_return
        pageBuilder: (context, animation1, animation2) {},
        transitionBuilder: (contex, p1, p2, widget) {
          return Transform.scale(
            scale: p1.value,
            child: Opacity(
              opacity: p1.value,
              child: CupertinoAlertDialog(
                title: Text('Alert'),
                content:
                    Text('Do you want to also add it to google calendar ?'),
                //'Your calendars and events are synchronized with Google calendar\n(you may get asked once in a while to grant acess to your google account)'),
                actions: [
                  FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        isGcEnabled = true;
                        Navigator.pop(contex);
                      }),
                  FlatButton(
                      child: Text('Yes,and always for all calendars'),
                      onPressed: () {
                        settingsBox.put('showAlert', false);
                        settingsBox.put('gcSync', true);
                        gcSync = true;
                        Navigator.pop(contex);
                      }),
                  FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.pop(contex);
                      }),
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 300),
        barrierDismissible: true,
        barrierLabel: '',
      );
  }

  void showToast(String m) {
    if (widget.sKey.currentContext != null) {
      final snackBar = SnackBar(content: Text(m));
      widget.sKey.currentState.showSnackBar(snackBar);
      //final scaffold = Scaffold.of(widget.sKey.currentContext);
      //scaffold.showSnackBar(
      //SnackBar(
      //content: Text(m),
      //),
      //);
    }
  }

  void _initProgressDialog(String message) {
    pr = ProgressDialog(widget.sKey.currentContext);
    pr.style(
        message: message,
        borderRadius: 10.0,
        backgroundColor: Colors.white,
        progressWidget: CircularProgressIndicator(),
        elevation: 10.0,
        insetAnimCurve: Curves.easeInOut,
        padding: const EdgeInsets.all(8.0),
        messageTextStyle: TextStyle(
          color: Colors.black,
          fontSize: 17.0,
        ));
  }

  void addRootCalLocal(String calTitle) {
    allCalendars.put(
        calTitle,
        Calendar(
          title: calTitle,
          content: [],
          events: [],
          rootCalendarTitle: calTitle,
        ));
  }

  Future<List<Event>> extractGcEvents(String gCId) async {
    var gCList = await gcCalendar.getAllEvents(gCId);
    List<Event> events = [];
    if (gCList != null)
      for (var item in gCList.items) {
        events.add(Event(
          title: item.summary,
          startTime: item.start.dateTime,
          endTime: item.end.dateTime,
          location: item.location,
          notes: item.description,
          //TODO: add reccurence
        ));
      }
    return events;
  }

  void showAndroidAlertDialog() {}

  // @override
  // void dispose() {
  //   super.dispose();
  //   if(widget.bloc != null)
  //   widget.bloc.dispose();
  // }

}
