import 'package:flutter/material.dart';
import 'package:studnet_calender_app/models/schedule.dart';
import 'package:studnet_calender_app/models/schedulentry.dart';
import 'package:studnet_calender_app/models/student.dart';
import 'package:studnet_calender_app/views/mainPage.dart';

void main() async {
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  Schedule schedule =
      Schedule(entries: {}, schID: 1, name: "John's Schedule", studentID: 1);
  Student student = Student(
      courses: {},
      email: "fakeuser@hawk.iit.edu",
      name: "John Smith",
      password: "1234",
      studentId: 1,
      stSch: schedule);
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: MainPage(
      user: student,
    ),
  ));
}
