import 'dart:convert';

class TaskModel {
  String? id;
  String? title;
  String? note;
  String? date;
  String? time;
  int? reminder;
  int? colorIndex;

  TaskModel({
    this.id,
    this.title,
    this.note,
    this.date,
    this.time,
    this.reminder,
    this.colorIndex,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'note': note,
      'date': date,
      'time': time,
      'reminder': reminder,
      'colorIndex': colorIndex,
    };
  }

  factory TaskModel.fromMap(Map<String, dynamic> map) {
    return TaskModel(
      id: map['id'],
      title: map['title'],
      note: map['note'],
      date: map['date'],
      time: map['time'],
      reminder: map['reminder']?.toInt(),
      colorIndex: map['colorIndex']?.toInt(),
    );
  }

  String toJson() => json.encode(toMap());

  factory TaskModel.fromJson(String source) =>
      TaskModel.fromMap(json.decode(source));

  @override
  String toString() {
    return 'TaskModel(id: $id, title: $title, note: $note, date: $date, time: $time, reminder: $reminder, colorIndex: $colorIndex)';
  }
}
