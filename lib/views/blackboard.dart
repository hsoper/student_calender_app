import 'package:flutter/material.dart';
import 'package:studnet_calender_app/models/course.dart';
import 'package:studnet_calender_app/models/homework.dart';
import 'package:studnet_calender_app/models/student.dart';

import 'course.dart';

List<String> days = [
  "Monday",
  "Tuesday",
  "Wednesday",
  "Thursday",
  "Friday",
  "Saturaday",
  "Sunday"
];

class Blackboard extends StatefulWidget {
  final Student student;
  const Blackboard({super.key, required this.student});

  @override
  State<Blackboard> createState() => _BlackboardState();
}

class _BlackboardState extends State<Blackboard> {
  List<Course> courses = [];

  @override
  void initState() {
    super.initState();

    // hardcode the course as we didn't implement Blackboard API for prototype
    courses.add(Course(
        courseId: 1,
        weekdays: {0, 2, 4},
        name: "CS-450",
        professor: 'Micheal',
        description: "Systems Programing",
        start: DateTime(2023, 11, 6),
        end: DateTime(2023, 12, 10),
        subject: "Computer Science",
        homework: {
          Homework(
              homeworkID: 001,
              courseID: 001,
              description: "Make a simple Cache",
              dueDate: DateTime(2023, 12, 3, 12),
              name: "Cache Lab")
        },
        classStart: const TimeOfDay(hour: 11, minute: 15),
        classEnd: const TimeOfDay(hour: 12, minute: 50)));
  }

  void reload() {
    super.setState(() {});
  }

  // builds a widget which shows course information and related action buttons
  Row courseWidget(BuildContext context, Course course) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      CourseWidget(
        course: course,
        fontSize: 14,
      ),
      widget.student.courses.contains(course)
          ? Column(
              children: [
                // refreshes the course with new information
                IconButton(
                    onPressed: () {
                      widget.student.deleteCourse(course);
                      widget.student.addCourse(course);
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Center(
                        child: Text(
                            "Refreshed course with course ID: ${course.courseId}"),
                      )));
                    },
                    icon: const Icon(Icons.refresh)),
                // deletes the course from the users schedule
                IconButton(
                    onPressed: () {
                      widget.student.deleteCourse(course);
                      ScaffoldMessenger.of(context).removeCurrentSnackBar();
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 2),
                          content: Center(
                            child: Text(
                                "Course with the course ID: ${course.courseId} deleted"),
                          )));
                      reload();
                    },
                    icon: const Icon(Icons.delete_forever))
              ],
            )
          : IconButton(
              // adds the course to the users
              onPressed: () {
                widget.student.addCourse(course);
                ScaffoldMessenger.of(context).removeCurrentSnackBar();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(seconds: 1),
                    content: Center(
                      child: Text(
                          "Course with the course ID: ${course.courseId} added"),
                    )));
                reload();
              },
              icon: const Icon(Icons.add))
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          title: const Center(child: Text("Blackboard"))),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        children: List.generate(courses.length, (index) {
          return courseWidget(context, courses[index]);
        }),
      ),
    );
  }
}
