import 'package:flutter/material.dart';
import 'package:studnet_calender_app/models/course.dart';
import 'package:studnet_calender_app/models/homework.dart';
import 'package:studnet_calender_app/models/student.dart';
import 'package:studnet_calender_app/views/mainpage.dart';

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
    courses.add(Course(
        courseId: 1,
        name: "CS-450",
        professor: 'Micheal',
        description: "Systems Programing",
        end: DateTime(2023, 8, 20),
        start: DateTime(2023, 12, 10),
        subject: "Computer Science",
        homework: {
          Homework(
              homeworkID: 001,
              courseID: 001,
              description: "Make a simple Cache",
              dueDate: DateTime(2023, 10, 23),
              name: "Cache Lab")
        },
        classStart: const TimeOfDay(hour: 11, minute: 15),
        classEnd: const TimeOfDay(hour: 12, minute: 50)));
  }

  void reload() {
    super.setState(() {});
  }

  Row courseWidget(BuildContext context, Course course) {
    return Row(mainAxisAlignment: MainAxisAlignment.center, children: [
      Column(
        children: [
          Card(
            margin: const EdgeInsets.all(20),
            child: SizedBox(
              height: 50,
              child: Center(
                child: Text(course.name),
              ),
            ),
          )
        ],
      ),
      widget.student.courses.contains(course)
          ? Column(
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.refresh)),
                IconButton(
                    onPressed: () {
                      widget.student.deleteCourse(course);
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          duration: const Duration(seconds: 3),
                          content: Text(
                              "Course with the course ID: ${course.courseId} deleted")));
                      reload();
                    },
                    icon: const Icon(Icons.delete_forever))
              ],
            )
          : IconButton(
              onPressed: () {
                widget.student.addCourse(course);
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    duration: const Duration(seconds: 3),
                    content: Text(
                        "Course with the course ID: ${course.courseId} added")));
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
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) {
                  return MainPage(user: widget.student);
                },
              ));
            },
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          title: const Center(child: Text("Blackboard"))),
      body: ListView(
        children: List.generate(courses.length, (index) {
          return courseWidget(context, courses[index]);
        }),
      ),
    );
  }
}
