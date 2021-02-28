// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarAdapter extends TypeAdapter<Calendar> {
  @override
  final int typeId = 2;

  @override
  Calendar read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Calendar(
      title: fields[0] as String,
      start: fields[1] as DateTime,
      end: fields[2] as DateTime,
      type: fields[3] as String,
      notes: fields[4] as String,
      content: (fields[5] as List)?.cast<Calendar>(),
      events: (fields[6] as List)?.cast<Event>(),
      rootCalendarTitle: fields[7] as String,
      googleCalendarId: fields[8] as String,
    )..location = fields[9] as String;
  }

  @override
  void write(BinaryWriter writer, Calendar obj) {
    writer
      ..writeByte(10)
      ..writeByte(0)
      ..write(obj.title)
      ..writeByte(1)
      ..write(obj.start)
      ..writeByte(2)
      ..write(obj.end)
      ..writeByte(3)
      ..write(obj.type)
      ..writeByte(4)
      ..write(obj.notes)
      ..writeByte(5)
      ..write(obj.content)
      ..writeByte(6)
      ..write(obj.events)
      ..writeByte(7)
      ..write(obj.rootCalendarTitle)
      ..writeByte(8)
      ..write(obj.googleCalendarId)
      ..writeByte(9)
      ..write(obj.location);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
