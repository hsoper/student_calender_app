import 'package:student_calender_app/models/course.dart';
import 'package:student_calender_app/models/schedule.dart';

class Student {
  final int studentId;
  final String name;
  final String email;
  final String password;
  final Schedule stSch;
  final Set<Course> courses;
  Student(
      {required this.studentId,
      required this.name,
      required this.email,
      required this.password,
      required this.stSch,
      required this.courses});
  void addCourse(Course course) {
    courses.add(course);
  }

  void deleteCourse(Course course) {
    courses.remove(course);
  }
}
