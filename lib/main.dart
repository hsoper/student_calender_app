import 'package:flutter/material.dart';
import 'package:studnet_calender_app/models/schedule.dart';
import 'package:studnet_calender_app/models/schedulentry.dart';
import 'package:studnet_calender_app/models/student.dart';
import 'package:studnet_calender_app/views/mainpage.dart';

void main() async {
  // Run the app and pass in the SettingsController. The app listens to the
  // SettingsController for changes, then passes it further down to the
  // SettingsView.
  ScheduleEntry entry = ScheduleEntry(
      entryId: 1,
      scheduleId: 1,
      entryType: "Study",
      description: "Study hours for CS487",
      start: DateTime(2023, 12, 1, 13, 15),
      end: DateTime(2023, 12, 1, 15, 15),
      name: "Study Time");
  ScheduleEntry entry2 = ScheduleEntry(
      entryId: 2,
      scheduleId: 1,
      entryType: "Study",
      description: "Study hours for CS487",
      start: DateTime(2023, 11, 22, 13, 15),
      end: DateTime(2023, 11, 22, 15, 15),
      name: "Study Time");
  Schedule schedule = Schedule(
      entries: {entry, entry2},
      schID: 1,
      name: "John's Schedule",
      studentID: 1);
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
