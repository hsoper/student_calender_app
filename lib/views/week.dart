import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:student_calender_app/models/course.dart';
import 'package:student_calender_app/models/homework.dart';
import 'package:student_calender_app/models/schedulentry.dart';
import 'package:student_calender_app/models/student.dart';
import 'package:student_calender_app/views/course.dart';
import 'package:student_calender_app/views/editentry.dart';

class WeekWidget extends StatefulWidget {
  final Student student;
  final DateTime day;
  const WeekWidget({super.key, required this.student, required this.day});

  @override
  State<WeekWidget> createState() => _WeekWidgetState();
}

class _WeekWidgetState extends State<WeekWidget> {
  List<String> days = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
    "Saturaday",
    "Sunday"
  ];

  void reload() {
    super.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Builds the first row of the app
        Row(
          children: List.generate(8, (index) {
            if (index == 0) {
              return const EmptyPlaceholder();
            }
            return DayWidget(
              days: days,
              curDay: widget.day,
              index: index,
            );
          }),
        ),
        // Sets up the scrollable portion of the app
        SizedBox(
          height: MediaQuery.sizeOf(context).height - 112,
          child: ListView(
            controller: ScrollController(initialScrollOffset: 8 * 120),
            children: [
              Row(
                children: List.generate(8, (index) {
                  if (index == 0) {
                    return const TimeColumn();
                  }
                  return ScheduleSpaceWidget(
                    day:
                        getWeekStart(widget.day).add(Duration(days: index - 1)),
                    student: widget.student,
                  );
                }),
              )
            ],
          ),
        )
      ],
    );
  }
}

// this the the widget which draws 15 minute intervals and the schedule entries
class ScheduleSpaceWidget extends StatelessWidget {
  final DateTime day;
  final Student student;
  const ScheduleSpaceWidget(
      {super.key, required this.day, required this.student});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: (MediaQuery.sizeOf(context).width - 60) / 7,
      child: Stack(children: dividersWithEntries(student, day)),
    );
  }

  List<Widget> dividersWithEntries(Student student, DateTime day) {
    List<Widget> temp = [
      Column(children: timeDividers(120 * 24, 24, 15))
    ]; // time dividers
    for (ScheduleEntry entry in student.stSch.entries) {
      // schedule entries
      if (entry.start.getDayDifference(day) == 0) {
        double size = (entry.end.hour * 120 + entry.end.minute * 2) -
            (entry.start.hour * 120 + entry.start.minute * 2);
        temp.add(EntryWidget(
          entry: entry,
          start: (entry.start.hour * 120 + entry.start.minute * 2),
          size: size,
          student: student,
        ));
      }
    }
    for (Course course in student.courses) {
      // course entries
      if (course.weekdays.contains(day.weekday - 1) &&
          course.start.compareTo(day) <= 0 &&
          course.end.compareTo(day) >= 0) {
        double size =
            (course.classEnd.hour * 120 + course.classEnd.minute * 2) -
                (course.classStart.hour * 120 + course.classStart.minute * 2);
        temp.add(CourseEntryWidget(
          entry: course,
          start: (course.classStart.hour * 120 + course.classStart.minute * 2),
          size: size,
        ));
      }
      for (Homework work in course.homework) {
        // homework entries
        if (work.dueDate.compareWithoutTime(day)) {
          temp.add(CourseEntryWidget(
            entry: course,
            size: 20,
            start: work.dueDate.hour * 120 + work.dueDate.minute * 2,
            homework: work,
          ));
        }
      }
    }

    return temp;
  }

  // this produces a list of widgets which divide time based off of the max height, current hour range, and interval in minutes
  List<Widget> timeDividers(heightMax, hourRange, minutes) {
    return List.generate(heightMax ~/ (heightMax / (60 * hourRange) * minutes),
        (index) {
      return Container(
        height: heightMax / (60 * hourRange) * minutes,
        decoration: const BoxDecoration(
            border: Border(
                right: BorderSide(color: Colors.grey),
                bottom: BorderSide(color: Colors.grey))),
      );
    });
  }
}

// This will build a display of the Entry with the entry's name in the display.
// It is a yellow block which users can click to see details or edit.
class EntryWidget extends StatelessWidget {
  final ScheduleEntry entry;
  final Student student;
  final double start;
  final double size;
  const EntryWidget(
      {super.key,
      required this.entry,
      required this.size,
      required this.start,
      required this.student});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: start,
      left: 0,
      child: InkWell(
          onTap: () {
            Navigator.of(context).pushReplacement(MaterialPageRoute(
              builder: (context) {
                return EditEntryWidget(
                  sEntery: entry,
                  student: student,
                );
              },
            ));
          },
          child: Container(
            height: size,
            width: (MediaQuery.sizeOf(context).width - 60) / 7,
            color: Colors.yellow,
            child: Center(
                child: Text(
              entry.name,
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            )),
          )),
    );
  }
}

// Builds a entry widget for either a homework or course
class CourseEntryWidget extends StatelessWidget {
  final Course entry;
  final double start;
  final double size;
  final Homework? homework;
  const CourseEntryWidget(
      {super.key,
      required this.entry,
      required this.size,
      required this.start,
      this.homework});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: start,
      left: 0,
      child: InkWell(
          onTap: () {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                if (homework == null) {
                  return CourseView(course: entry);
                } else {
                  return HomeworkView(homework: homework!);
                }
              },
            ));
          },
          child: Container(
            height: size,
            width: (MediaQuery.sizeOf(context).width - 60) / 7,
            color: homework == null ? Colors.green[300] : Colors.red[300],
            child: Center(
                child: Text(
              "${entry.name}${homework != null ? ": ${homework!.name}" : ""}",
              style: const TextStyle(
                  color: Colors.black, fontWeight: FontWeight.bold),
            )),
          )),
    );
  }
}

// this widget holds nothing, but is needed to keep structure
class EmptyPlaceholder extends StatelessWidget {
  const EmptyPlaceholder({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border(
              bottom: BorderSide(color: Colors.grey[800]!),
              right: BorderSide(color: Colors.grey[800]!))),
      width: 60,
      height: 56,
    );
  }
}

// this widget draws the container which holds the day and date inputed
class DayWidget extends StatelessWidget {
  const DayWidget(
      {super.key,
      required this.days,
      required this.curDay,
      required this.index});
  final int index;
  final List<String> days;
  final DateTime curDay;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: (MediaQuery.sizeOf(context).width - 60) / 7,
      height: 56,
      decoration: BoxDecoration(
          color: Colors.grey[300],
          border: Border(
              bottom: BorderSide(color: Colors.grey[800]!),
              right: BorderSide(color: Colors.grey[800]!))),
      padding: const EdgeInsets.symmetric(vertical: 7.5),
      child: Column(
        children: [
          Text(overflow: TextOverflow.ellipsis, days[index - 1]),
          Text(
              overflow: TextOverflow.fade,
              "${getWeekStart(curDay).add(Duration(days: index - 1)).month}-${getWeekStart(curDay).add(Duration(days: index - 1)).day}")
        ],
      ),
    );
  }
}

// runs the firstDayOfWeek() function which returns the first day of the week correspoding to the curDay input
DateTime getWeekStart(DateTime curDay) {
  return curDay.firstDayOfWeek();
}

// converts a [0..23] index into the 12 hour clock
String timeDisplay(int index) {
  if (index == 0) {
    return "12 AM";
  } else if (index > 12) {
    return "${index - 12} PM";
  } else {
    return "$index ${index == 12 ? "PM" : "AM"}";
  }
}

// builds the First column which just displaying the time of day starting at 12am and ending at 11pm
class TimeColumn extends StatelessWidget {
  const TimeColumn({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(
          24,
          (index) => Container(
              height: 120,
              width: 60,
              decoration: BoxDecoration(
                  color: Colors.grey[300],
                  border: Border(
                      right: BorderSide(color: Colors.grey[800]!),
                      bottom: BorderSide(color: Colors.grey[800]!))),
              child: Center(
                  child: Text(
                timeDisplay(index),
              )))),
    );
  }
}
