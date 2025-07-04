import 'package:hive/hive.dart';
import 'package:turnotask/modules/home/model/task_model.dart';

class TaskAdapter extends TypeAdapter<Task> {
  @override
  final int typeId = 0;

  @override
  Task read(BinaryReader reader) {
    final id = reader.readInt();
    final title = reader.readString();
    final description = reader.readString();
    final hasDateTime = reader.readBool();
    final dateTime = hasDateTime
        ? DateTime.fromMillisecondsSinceEpoch(reader.readInt())
        : null;

    final isCompleted = reader.readBool();
    final hasCompletionTime = reader.readBool();
    final completionTime = hasCompletionTime
        ? DateTime.fromMillisecondsSinceEpoch(reader.readInt())
        : null;
    final recurrenceIndex = reader.readInt();
    final recurrence = Recurrence.values[recurrenceIndex];

    return Task(
      id: id,
      title: title,
      description: description,
      dateTime: dateTime,
      isCompleted: isCompleted,
      completionTime: completionTime,
      recurrence: recurrence,
    );
  }

  @override
  void write(BinaryWriter writer, Task obj) {
    writer.writeInt(obj.id);
    writer.writeString(obj.title);
    writer.writeString(obj.description);
    if (obj.dateTime != null) {
      writer.writeBool(true);
      writer.writeInt(obj.dateTime!.millisecondsSinceEpoch);
    } else {
      writer.writeBool(false);
    }
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
