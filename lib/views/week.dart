import 'package:calendar_view/calendar_view.dart';
import 'package:flutter/material.dart';
import 'package:studnet_calender_app/models/student.dart';

class WeekWidget extends StatefulWidget {
  final Student student;
  const WeekWidget({super.key, required this.student});

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
  String timeDisplay(int index) {
    if (index == 0) {
      return "12:00 AM";
    } else if (index > 12) {
      return "${index - 12} PM";
    } else {
      return "$index ${index == 12 ? "PM" : "AM"}";
    }
  }

  DateTime currentDay = DateTime(2023, 12, 1, 0, 1);
  DateTime getWeekStart() {
    return currentDay.firstDayOfWeek();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: List.generate(8, (index) {
            if (index == 0) {
              return Container(
                color: Colors.grey[300],
                width: 75,
                height: 56,
              );
            }
            return Container(
              width: (MediaQuery.sizeOf(context).width - 75) / 7,
              color: Colors.grey[300],
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  Text(days[index - 1]),
                  Text(
                      "${getWeekStart().add(Duration(days: index - 1)).month}-${getWeekStart().add(Duration(days: index - 1)).day}")
                ],
              ),
            );
          }),
        ),
        Container(
          height: MediaQuery.sizeOf(context).height - 112,
          child: ListView(
            children: [
              Row(
                children: [
                  Column(
                    children: List.generate(
                        24,
                        (index) => Container(
                            color: Colors.grey[300],
                            height: 60,
                            width: 75,
                            child: Center(
                                child: Text(
                              timeDisplay(index),
                            )))),
                  )
                ],
              )
            ],
          ),
        )
      ],
    );
  }
}
