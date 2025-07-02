enum Recurrence { once, daily, weekly, monthly }

class Task {
  final int id;
  final String title;
  final String description;
  final DateTime dateTime;
  bool isCompleted;
  DateTime? completionTime;
  final Recurrence recurrence;

  Task({
    required this.id,
    required this.title,
    required this.description,
    required this.dateTime,
    this.isCompleted = false,
    this.completionTime,
    this.recurrence = Recurrence.once,
  });
}
