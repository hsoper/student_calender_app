import 'package:studnet_calender_app/models/homework.dart';

class Course {
  final int courseId;
  final String name;
  final String professor;
  final String description;
  final DateTime start;
  final DateTime end;
  final String subject;
  final Set<Homework> homework;
  Course(
      {required this.courseId,
      required this.name,
      required this.professor,
      required this.description,
      required this.end,
      required this.start,
      required this.subject,
      required this.homework});

  void addHomework(Homework work) {
    homework.add(work);
  }

  @override
  bool operator ==(Object other) {
    return (other is Course) && other.courseId == courseId;
  }

  @override
  int get hashCode => courseId;
}
