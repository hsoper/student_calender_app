import 'package:flutter/material.dart';
import 'package:student_calender_app/models/course.dart';
import 'package:student_calender_app/models/homework.dart';
import 'package:student_calender_app/views/blackboard.dart';
import 'package:student_calender_app/views/editentry.dart';

// main page which displays course information
class CourseView extends StatelessWidget {
  final Course course;
  const CourseView({super.key, required this.course});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child:
              Title(color: Colors.black, child: Text("Course: ${course.name}")),
        ),
      ),
      body: Center(
        child: CourseWidget(
          course: course,
          fontSize: 32,
        ),
      ),
    );
  }
}

// A main page which will hold homework information
class HomeworkView extends StatelessWidget {
  final Homework homework;
  const HomeworkView({super.key, required this.homework});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Title(
              color: Colors.black, child: Text("Homework: ${homework.name}")),
        ),
      ),
      body: Center(
        child: HomeworkWidget(course: homework, fontSize: 32),
      ),
    );
  }
}

// builds a widget which displays course information
class CourseWidget extends StatelessWidget {
  final Course course;
  final double fontSize;
  const CourseWidget({super.key, required this.course, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.green[100],
      margin: const EdgeInsets.all(40),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Text(course.name, style: TextStyle(fontSize: fontSize)),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
              child: Text(
            "Subject: ${course.subject}",
            style: TextStyle(fontSize: fontSize),
          )),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
              child: Text("Professor: ${course.professor}",
                  style: TextStyle(fontSize: fontSize))),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
              child: Text("Description: ${course.description}",
                  style: TextStyle(fontSize: fontSize))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text("Class Start Date: ",
                  style: TextStyle(fontSize: fontSize)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(readableDate(course.start),
                  style: TextStyle(fontSize: fontSize)),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Class End Date: ",
                  style: TextStyle(fontSize: fontSize)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(readableDate(course.end),
                  style: TextStyle(fontSize: fontSize)),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Class Time: ", style: TextStyle(fontSize: fontSize)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                  "${timeDisplay(course.classStart.hour, course.classStart.minute)}-${timeDisplay(course.classEnd.hour, course.classEnd.minute)}",
                  style: TextStyle(fontSize: fontSize)),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Text("Class days:", style: TextStyle(fontSize: fontSize)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
              child: Text(readableDays(course.weekdays),
                  style: TextStyle(fontSize: fontSize)),
            )
          ],
        )
      ]),
    );
  }
}

// builds a widget which displays homework information
class HomeworkWidget extends StatelessWidget {
  final Homework course;
  final double fontSize;
  const HomeworkWidget(
      {super.key, required this.course, required this.fontSize});

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.red[100],
      margin: const EdgeInsets.all(40),
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
            child: Text(course.name, style: TextStyle(fontSize: fontSize)),
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          child: Center(
              child: Text("Description: ${course.description}",
                  style: TextStyle(fontSize: fontSize))),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text("Due Date: ", style: TextStyle(fontSize: fontSize)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(readableDate(course.dueDate),
                  style: TextStyle(fontSize: fontSize)),
            )
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: Text("Due Time: ", style: TextStyle(fontSize: fontSize)),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              child: Text(
                  timeDisplay(course.dueDate.hour, course.dueDate.minute),
                  style: TextStyle(fontSize: fontSize)),
            )
          ],
        ),
      ]),
    );
  }
}

// makes the date readable in month/day/year formate
String readableDate(DateTime day) => "${day.month}/${day.day}/${day.year}";

// convers a set of ints which contain ints between 0-6 which each correspond to a day of the week
String readableDays(Set<int> day) {
  List<String> d = [];
  for (int i in day) {
    d.add(days[i]);
  }
  return d.join(", ");
}
