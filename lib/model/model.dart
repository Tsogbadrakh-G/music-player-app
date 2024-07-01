import 'package:hive/hive.dart';

@HiveType(typeId: 1, adapterName: 'AudioAdapter')
class Audio {
  @HiveField(0)
  final int id;
  @HiveField(1)
  final String name;

  @HiveField(2)
  final String path;

  Audio({
    required this.id,
    required this.name,
    required this.path,
  });
}

class AudioAdapter extends TypeAdapter<Audio> {
  @override
  final typeId = 2;

  @override
  Audio read(BinaryReader reader) {
    Audio model = Audio(
      id: reader.readInt(),
      name: reader.readString(),
      path: reader.readString(),
    );

    return model;
  }

  @override
  void write(BinaryWriter writer, Audio obj) {
    writer
      ..writeInt(obj.id)
      ..writeString(obj.name)
      ..writeString(obj.path);
  }
}
