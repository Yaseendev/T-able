import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hello_word/image_screen.dart';
import 'package:hello_word/saved_events_screen.dart';
import 'package:hello_word/widgets/day_container.dart';
import 'package:hello_word/models/event.dart';
import 'package:unicorndial/unicorndial.dart';
import 'package:hello_word/vars.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_pickers/image_pickers.dart';

void main() async {
  await Hive.initFlutter();
  Hive.registerAdapter(EventAdapter());
  events = await Hive.openBox<Event>('eventBox');
  runApp(MyApp());
}

var events;
//List<Event> events = [];
List<String> chosenRepDays = [];
List<String> weekDays = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage('Database Test'),
    );
  }
}

//enum EndingOptions { never, onDate, after }

class MyHomePage extends StatefulWidget {
  MyHomePage(this.title);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  //BuildContext buildctx;
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController textController = new TextEditingController(),
      numController;
  String selectedRep = 'Days';
  String selectedStartDate;
  DateTime stDate;
  String selectedStartTime;
  TimeOfDay stTime;
  String selectedEndTime;
  TimeOfDay endTime;
  String selectedEndDate;
  DateTime endDate;
  String endOnDate;
  bool _radioVal = true;
  String alarmOpSelect;
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

  List<Media> _listImagePaths = List();

  void addAlarmTile(StateSetter setStat) {
    alarmsWidgets.add(alarmTile(setStat));
  }

  DropdownButton<String> androidDropdown(StateSetter setStat) {
    List<DropdownMenuItem<String>> dropdownItems = [
      DropdownMenuItem(
        child: Text('Days'),
        value: 'Days',
      ),
      DropdownMenuItem(
        child: Text('Weeks'),
        value: 'Weeks',
      ),
      DropdownMenuItem(
        child: Text('Years'),
        value: 'Years',
      ),
    ];
    return DropdownButton<String>(
      value: selectedRep,
      items: dropdownItems,
      onChanged: (value) {
        setStat(() {
          selectedRep = value;
        });
      },
    );
  }

  Widget _profileOption({IconData iconData, Function onPressed, String tag}) {
    return UnicornButton(
        currentButton: FloatingActionButton(
      heroTag: tag,
      backgroundColor: Colors.grey[500],
      mini: true,
      child: Icon(iconData),
      onPressed: onPressed,
    ));
  }

  String weeknum2Text(int num) {
    switch (num) {
      case 1:
        return 'Mon';
      case 2:
        return 'Tue';
      case 3:
        return 'Wed';
      case 4:
        return 'Thu';
      case 5:
        return 'Fri';
      case 6:
        return 'Sat';
      case 7:
        return 'Sun';
      default:
        return 'Undefined';
    }
  }

  String num2month(int num) {
    switch (num) {
      case 1:
        return 'January';
      case 2:
        return 'Febreuary';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return 'Undefined';
    }
  }

  String myDateFormat(DateTime date) {
    return weeknum2Text(date.weekday) +
        ', ' +
        date.day.toString() +
        ' ' +
        num2month(date.month) +
        ' ' +
        date.year.toString();
  }

  Color selectColor = Color(0xFFEFF3F2);
  bool selected = false;

  List<Widget> displayRepDays() {
    List<Widget> days = [];
    weekDays.forEach((day) {
      days.add(
        DayCircleWidget(day),
      );
    });
    return days;
  }

  @override
  Widget build(BuildContext context) {
    //buildctx = context;
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(children: [
          RaisedButton(
            child: Text('Saved Events'),
            onPressed: () =>
                Navigator.push(context, MaterialPageRoute(builder: (context) {
              return SavedEventsScreen(events);
            })),
          ),
        ]),
      ),
      floatingActionButton: UnicornDialer(
        parentHeroTag: "btn2",
        parentButtonBackground: Colors.grey[700],
        orientation: UnicornOrientation.VERTICAL,
        parentButton: Icon(Icons.add),
        childButtons: [
          _profileOption(
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
                                      child: androidDropdown(setState),
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
                                          events.add(Event(
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
          _profileOption(
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
          _profileOption(
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
    );
  }

  Widget alarmTile(StateSetter setStat) {
    return ListTile(
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
          controller: textController,
        ),
      ),
      trailing: DropdownButton<String>(
        value: alarmOpSelect,
        items: s,
        onChanged: (val) {
          setStat(() {
            alarmOpSelect = val;
          });

          print(alarmOpSelect);
        },
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

  CupertinoPicker iOSPicker() {
    List<Text> pickerItems = [
      Text('Days'),
      Text('Weeks'),
      Text('Months'),
      Text('Years')
    ];

    return CupertinoPicker(
      backgroundColor: Colors.grey,
      itemExtent: 32.0,
      onSelectedItemChanged: (selectedIndex) {
        setState(() {
          //selectedCurrency = currenciesList[selectedIndex];
        });
      },
      children: pickerItems,
    );
  }
}
