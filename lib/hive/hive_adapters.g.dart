// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hive_adapters.dart';

// **************************************************************************
// AdaptersGenerator
// **************************************************************************

class BetAdapter extends TypeAdapter<Bet> {
  @override
  final typeId = 0;

  @override
  Bet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Bet(
      id: fields[0] as String,
      title: fields[1] as String,
      description: fields[2] as String,
      odds: (fields[3] as num).toDouble(),
      startTime: fields[4] as DateTime,
      endTime: fields[5] as DateTime,
      dataBet: fields[6] as DataBet,
    );
  }

  @override
  void write(BinaryWriter writer, Bet obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.title)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.odds)
      ..writeByte(4)
      ..write(obj.startTime)
      ..writeByte(5)
      ..write(obj.endTime)
      ..writeByte(6)
      ..write(obj.dataBet);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is BetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DataBetAdapter extends TypeAdapter<DataBet> {
  @override
  final typeId = 1;

  @override
  DataBet read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DataBet(
      id: fields[0] as String,
      videoUrl: fields[1] as String,
      imgUrl: fields[2] as String,
      metadata: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, DataBet obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.videoUrl)
      ..writeByte(2)
      ..write(obj.imgUrl)
      ..writeByte(3)
      ..write(obj.metadata);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DataBetAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
