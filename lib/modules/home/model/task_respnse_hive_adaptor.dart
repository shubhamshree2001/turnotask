import 'package:hive/hive.dart';
import 'package:turnotask/modules/home/model/task_model.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    return Task(
      id: reader.readInt(),
      title: reader.readString(),
      description: reader.readString(),
      dateTime: DateTime.fromMillisecondsSinceEpoch(reader.readInt()),
      isCompleted: reader.readBool(),
      completionTime: reader.readBool() ? DateTime.fromMillisecondsSinceEpoch(reader.readInt()) : null,
      recurrence: Recurrence.values[reader.readInt()],
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    writer.writeInt(obj.dateTime.millisecondsSinceEpoch);
    writer.writeBool(obj.isCompleted);
    if (obj.completionTime != null) {
      writer.writeBool(true);
      writer.writeInt(obj.completionTime!.millisecondsSinceEpoch);
    } else {
      writer.writeBool(false);
    }
    writer.writeInt(obj.recurrence.index);
  }
}
