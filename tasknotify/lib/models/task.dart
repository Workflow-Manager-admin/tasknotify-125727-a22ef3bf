import 'package:uuid/uuid.dart';

class Task {
  final String id;
  String title;
  String description;
  DateTime scheduledTime;
  bool isCompleted;

  Task({
    String? id,
    required this.title,
    required this.description,
    required this.scheduledTime,
    this.isCompleted = false,
  }) : id = id ?? const Uuid().v4();

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'scheduledTime': scheduledTime.toIso8601String(),
      'isCompleted': isCompleted,
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      id: json['id'],
      title: json['title'],
      description: json['description'],
      scheduledTime: DateTime.parse(json['scheduledTime']),
      isCompleted: json['isCompleted'],
    );
  }
}
