import 'package:T_able/screens/Home_Screen.dart';
import 'package:T_able/screens/add_event_screen.dart';
import 'package:T_able/utils/DateformatingHelper.dart';
import 'package:T_able/utils/vars.dart';
import 'package:T_able/widgets/DropdownMenu.dart';
import 'package:T_able/widgets/day_container.dart';
import 'package:T_able/widgets/unicorndialer_opt.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:unicorndial/unicorndial.dart';
import 'events_screen.dart';
import 'package:image_pickers/image_pickers.dart';

import 'image_screen.dart';

class NavBarScreen extends StatefulWidget {
  @override
  _NavBarScreenState createState() => _NavBarScreenState();
}

class _NavBarScreenState extends State<NavBarScreen> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    HomeScreen(),
    AddEventScreen(),
    EventsScreen(),
    Container(),
    Container(),
  ];
  TextEditingController textController = new TextEditingController(),
      numController;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_currentIndex],
      floatingActionButton: UnicornDialer(
        parentHeroTag: "btn2",
        parentButtonBackground: Colors.grey[700],
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.add),
        childButtons: [
          profileOption(
              tag: 'add',
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
                                          left: 5,
                                          bottom: 5,
                                          top: 10,
                                          right: 10),
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
                                          selectedStartDate =
                                              myDateFormat(value);
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
                                            initialTime:
                                                TimeOfDay.now()
                                                    .replacing(
                                                        hour: TimeOfDay.now()
                                                                .hour +
                                                            1))
                                        .then((value) {
                                      endTime = value;
                                      if (value != null)
                                        setState(() {
                                          selectedEndTime =
                                              value.format(context);
                                        });
                                    }),
                                  ),
                                ),
                                //TODO: add a divider
                                Text('Repeats Every',
                                    textAlign: TextAlign.start),
                                Row(
                                  children: [
                                    Container(
                                      width: 50.0,
                                      height: 50.0,
                                      child: TextField(
                                        showCursor: true,
                                        keyboardType: TextInputType.number,
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
                                                    initialDate: DateTime.now(),
                                                    firstDate: DateTime(1960),
                                                    lastDate: DateTime(2050))
                                                .then((value) {
                                              print(value);
                                              if (value != null)
                                                setState(() {
                                                  endOnDate =
                                                      num2month(value.month) +
                                                          ' ' +
                                                          value.day.toString() +
                                                          ', ' +
                                                          value.year.toString();
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
                                              keyboardType:
                                                  TextInputType.number,
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
                                          /*events.add(Event(
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
                                          ));*/
                                          //events.close();
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
          profileOption(
              tag: 'takephoto',
              iconData: Icons.add_a_photo,
              onPressed: () async {
                ImagePickers.openCamera(
                        cropConfig:
                            CropConfig(enableCrop: false, width: 2, height: 3))
                    .then((Media media) {
                  _listImagePaths.clear();
                  _listImagePaths.add(media);
                  print('photo : ${media.path}');
                  setState(() {});
                  Navigator.push(context,
                      MaterialPageRoute(builder: (BuildContext context) {
                    return ImageScreen(media.path);
                  }));
                });
              }),
          profileOption(
              tag: 'comm',
              iconData: Icons.add_photo_alternate,
              onPressed: () async {
                try {
                  // _galleryMode = GalleryMode.image;
                  _listImagePaths = await ImagePickers.pickerPaths(
                    galleryMode: GalleryMode.image,
                    showGif: false,
                    selectCount: 1,
                    showCamera: true,
                    // cropConfig :CropConfig(enableCrop: true,height: 1,width: 1),
                    compressSize: 500,
                    uiConfig: UIConfig(
                      uiThemeColor: Color(0xffff0000),
                    ),
                  );
                  _listImagePaths.forEach((media) {
                    print(media.path.toString());
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ImageScreen(media.path);
                    }));
                  });
                  setState(() {});
                } on PlatformException {}
              }),
        ],
      ),
      bottomNavigationBar: CurvedNavigationBar(
        // key: _bottomNavigationKey,
        //backgroundColor: Colors.lightGreenAccent,
        items: <Widget>[
          Icon(Icons.home, size: 30),
          Icon(Icons.alarm ,size: 30),
          Icon(Icons.event, size: 30),
          Icon(Icons.chat_rounded, size: 30),
          Icon(Icons.settings, size: 30),
        ],
        onTap: (index) {
          //Handle button tap
          setState(() {
            _currentIndex = index;
          });
          // final CurvedNavigationBarState navBarState =
          //             _bottomNavigationKey.currentState;
          //         navBarState.setPage(1);

          print('Page: $index');
        },
        //color: Colors.green,
      ),
    );
  }

  void _initSheet() {
    // if (textController != null) {
    //   print(textController.text);
    //   textController.clear();
    // }
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
}
