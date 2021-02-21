import 'dart:io';

import 'package:T_able/models/Event/event.dart';
import 'package:T_able/models/calendar/calendar.dart';
import 'package:T_able/screens/image_screen.dart';
import 'package:T_able/utils/DateformatingHelper.dart';
import 'package:T_able/utils/bloc/calendarsList/calendarList_event.dart';
import 'package:T_able/utils/vars_consts.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_pickers/image_pickers.dart';
import 'package:provider/provider.dart';
import 'package:unicorndial/unicorndial.dart';

import 'DropdownMenu.dart';
import 'day_container.dart';
import 'unicorndialer_opt.dart';

class CustomActionButton extends StatefulWidget {
  Calendar calendar;
  //final bloc;
  //inal calendars;
  // ignore: avoid_init_to_null
  CustomActionButton({this.calendar = null});
  @override
  _CustomActionButtonState createState() => _CustomActionButtonState();
}

class _CustomActionButtonState extends State<CustomActionButton> {
  TextEditingController textController = new TextEditingController(),
      numController,
      calendarController = new TextEditingController();
  String selectedStartDate,
      selectedStartTime,
      selectedEndTime,
      selectedEndDate,
      endOnDate,
      alarmOpSelect;
  DateTime stDate, endDate;
  TimeOfDay stTime, endTime;
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
  @override
  Widget build(BuildContext context) {
    // var allCalendars = Provider.of<ValueNotifier<List<Calendar>>>(context);
    return UnicornDialer(
      parentHeroTag: "btn2",
      parentButtonBackground: primaryColor4,
      orientation: UnicornOrientation.VERTICAL,
      parentButton: Icon(Icons.add),
      childButtons: [
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
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                                // setState(() {
                                                String calTitle =
                                                    calendarController.text;
                                                String rootCal;
                                                if (widget.calendar == null) {
                                                  //setState(() {
                                                  rootCal = calTitle;
                                                  allCalendars.put(
                                                      calTitle,
                                                      Calendar(
                                                        title: calTitle,
                                                        content: [],
                                                        events: [],
                                                        rootCalendarTitle:
                                                            rootCal,
                                                      ));
                                                  //});
                                                  // allCalendars.value.add(Calendar(
                                                  //   title: calendarController.text,
                                                  //   content: [],
                                                  //   events: [],
                                                  // ));
                                                  // notifyListeners();
                                                } else {
                                                  rootCal = widget.calendar
                                                      .rootCalendarTitle;
                                                  widget.calendar.content
                                                      .add(Calendar(
                                                    title: calTitle,
                                                    content: [],
                                                    events: [],
                                                    rootCalendarTitle: rootCal,
                                                  ));
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
                                    onPressed: () => Navigator.pop(_),
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
                                              onPressed: () {
                                                Navigator.pop(ctx);
                                                //setState(() {
                                                String calTitle =
                                                    calendarController.text;
                                                String rootCal;
                                                if (widget.calendar == null) {
                                                  // setState(() {
                                                    rootCal = calTitle;
                                                  allCalendars.put(
                                                      calTitle,
                                                      Calendar(
                                                        title: calTitle,
                                                        content: [],
                                                        events: [],
                                                        rootCalendarTitle:
                                                            rootCal,
                                                      ));
                                                  //});
                                                  // allCalendars.value.add(Calendar(
                                                  //   title: calendarController.text,
                                                  // ));
                                                } else {
                                                  rootCal = widget.calendar
                                                      .rootCalendarTitle;
                                                  widget.calendar.content
                                                      .add(Calendar(
                                                    title: calTitle,
                                                     content: [],
                                                    events: [],
                                                    rootCalendarTitle: rootCal,
                                                  ));
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
                          //controller: scrollController,
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
                                    if (value != null)
                                      setState(() {
                                        selectedStartTime =
                                            value.format(context);
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
                                                  hour:
                                                      TimeOfDay.now().hour + 1))
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
                                  ? Center(
                                      child: ToggleButtons(
                                        children: [
                                          Icon(Icons.ac_unit),
                                          Icon(Icons.access_alarms_sharp),
                                          Icon(Icons.account_balance_wallet),
                                        ],
                                        isSelected: _alarmOptSelection,
                                        onPressed: (index) {
                                          if (_alarmOptSelection
                                                  .contains(true) &&
                                              _alarmOptSelection[index] != true)
                                            print('More then one selected');
                                          else {
                                            setState(() {
                                              _alarmOptSelection[index] =
                                                  !_alarmOptSelection[index];
                                            });
                                          }
                                        },
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(30.0)),
                                        borderWidth: 5,
                                      ),
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
                                ),
                              ),
                              Divider(
                                color: Colors.grey,
                              ),
                              ListTile(
                                leading: Icon(Icons.access_alarm),
                                title: Column(
                                  children: alarmsWidgets,
                                ),
                                trailing: InkWell(
                                  child: Icon(Icons.add),
                                  onTap: () {
                                    //TODO
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
                                      }),
                                  RaisedButton(
                                      color: Colors.lightBlue,
                                      child: Text(
                                        'Save',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                      onPressed: () {
                                        print(textController.text);
                                        if (widget.calendar == null) {
                                          allCalendars
                                              .getAt(_calIndex)
                                              .events
                                              .add(Event(
                                                title: textController.text,
                                                startTime: stDate.add(Duration(
                                                    hours: stTime.hour,
                                                    minutes: stTime.minute)),
                                                endTime: endDate.add(Duration(
                                                    hours: endTime.hour,
                                                    minutes: endTime.minute)),
                                                alarms: [],
                                                ending: {},
                                                location: '',
                                                notes: '',
                                                repDays: [],
                                                repetitionCycle: {},
                                              ));
                                        } else {
                                          //events.add(Event(
                                          widget.calendar.events.add(Event(
                                            title: textController.text,
                                            startTime: stDate.add(Duration(
                                                hours: stTime.hour,
                                                minutes: stTime.minute)),
                                            endTime: endDate.add(Duration(
                                                hours: endTime.hour,
                                                minutes: endTime.minute)),
                                            alarms: [],
                                            ending: {},
                                            location: '',
                                            notes: '',
                                            repDays: [],
                                            repetitionCycle: {},
                                          ));
                                        }
                                        //events.close();
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
    if (textController != null) {
      print(textController.text);
      textController.clear();
    }
    int curH = TimeOfDay.now().hour;
    selectedStartDate = myDateFormat(DateTime.now());
    selectedStartTime = TimeOfDay.now().format(context);
    selectedEndDate = myDateFormat(DateTime.now());
    selectedEndTime = TimeOfDay.now().replacing(hour: curH + 1).format(context);
    endOnDate = num2month(DateTime.now().add(Duration(days: 120)).month) +
        ' ' +
        DateTime.now().add(Duration(days: 120)).day.toString() +
        ', ' +
        DateTime.now().add(Duration(days: 120)).year.toString();
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
    }
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

  // @override
  // void dispose() {
  //   super.dispose();
  //   if(widget.bloc != null)
  //   widget.bloc.dispose();
  // }
}
