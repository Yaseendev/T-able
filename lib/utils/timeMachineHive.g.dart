// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeMachineHive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TimeMachineEventsAdapter extends TypeAdapter<TimeMachineEvents> {
  @override
  final int typeId = 3;

  @override
  TimeMachineEvents read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TimeMachineEvents(
      (fields[0] as List)?.cast<BasicEvent>(),
      fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, TimeMachineEvents obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.dynamicEventList)
      ..writeByte(1)
      ..write(obj.eId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TimeMachineEventsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
