import 'package:hive/hive.dart';
import 'package:timetable/timetable.dart' as t;
import 'package:timetable/timetable.dart';

part 'timeMachineHive.g.dart';

@HiveType(typeId: 3)
class TimeMachineEvents extends HiveObject {
  @HiveField(0)
  List<t.BasicEvent> dynamicEventList = [];
  @HiveField(1)
  int eId;
  TimeMachineEvents(this.dynamicEventList,this.eId);
}
