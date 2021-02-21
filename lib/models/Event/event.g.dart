// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'event.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class EventAdapter extends TypeAdapter<Event> {
  @override
  final int typeId = 1;

  @override
  Event read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Event(
      title: fields[3] as String,
      startTime: fields[0] as DateTime,
      endTime: fields[1] as DateTime,
      location: fields[2] as String,
      notes: fields[8] as String,
      repetitionCycle: (fields[4] as Map)?.cast<String, int>(),
      repDays: (fields[5] as List)?.cast<String>(),
      ending: (fields[6] as Map)?.cast<EndingOptions, int>(),
      alarms: (fields[7] as List)?.cast<Alarm>(),
    );
  }

  @override
  void write(BinaryWriter writer, Event obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.location)
      ..writeByte(3)
      ..write(obj.title)
      ..writeByte(4)
      ..write(obj.repetitionCycle)
      ..writeByte(5)
      ..write(obj.repDays)
      ..writeByte(6)
      ..write(obj.ending)
      ..writeByte(7)
      ..write(obj.alarms)
      ..writeByte(8)
      ..write(obj.notes);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is EventAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
