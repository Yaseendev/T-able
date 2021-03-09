import 'package:flutter/material.dart' show required;
import '../../utils/vars_consts.dart';
import '../alarm.dart';
import 'package:hive/hive.dart';
import '../../utils/DateformatingHelper.dart';

part 'event.g.dart';

//enum EndingOptions  { never, onDate, after }
@HiveType(typeId: 1)
class Event extends HiveObject {
  @HiveField(0)
  DateTime startTime;
  @HiveField(1)
  DateTime endTime;
  @HiveField(2)
  String location;
  @HiveField(3)
  String title;
  @HiveField(4)
  Map<String, int> repetitionCycle;
  @HiveField(5)
  List<String> repDays;
  @HiveField(6)
  Map<EndingOptions, int> ending;
  @HiveField(7)
  List<Alarm> alarms;
  @HiveField(8)
  String notes;
  @HiveField(9)
  String googleCalendarEventId;
  @HiveField(10)
  DateTime alarmTime;
  @HiveField(11)
  bool isSmartAlarm;


  Event(
      {this.title,
      @required this.startTime,
      @required this.endTime,
      this.location,
      this.notes,
      this.repetitionCycle,
      this.repDays,
      this.ending,
      this.alarms,
      this.googleCalendarEventId,this.alarmTime,this.isSmartAlarm=false});

  get getStartDate => myDateFormat(startTime);
  //get getStartTime =>
  get getEndDate => myDateFormat(startTime);
  //get getEndTime => 

}
