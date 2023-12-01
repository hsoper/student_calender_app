import 'package:studnet_calender_app/models/schedule.dart';

class Student {
  final int studentId;
  final String name;
  final String email;
  final String password;
  final Schedule stSch;
  Student(
      {required this.studentId,
      required this.name,
      required this.email,
      required this.password,
      required this.stSch});
}
