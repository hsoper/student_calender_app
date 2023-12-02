import 'package:flutter/material.dart';
import 'package:studnet_calender_app/models/schedulentry.dart';
import 'package:studnet_calender_app/models/student.dart';
import 'package:studnet_calender_app/views/mainpage.dart';

class EditEntryWidget extends StatefulWidget {
  final Student student;
  final ScheduleEntry sEntery;
  final bool? newEntry;
  const EditEntryWidget(
      {super.key, required this.sEntery, required this.student, this.newEntry});

  @override
  State<EditEntryWidget> createState() => _EditEntryWidgetState();
}

class _EditEntryWidgetState extends State<EditEntryWidget> {
  TextEditingController name = TextEditingController();
  TextEditingController type = TextEditingController();
  TextEditingController desc = TextEditingController();
  late DateTime start;
  late DateTime end;

  @override
  void initState() {
    super.initState();
    name.value = TextEditingValue(text: widget.sEntery.name);
    desc.value = TextEditingValue(text: widget.sEntery.desc);
    type.value = TextEditingValue(text: widget.sEntery.type);
    start = widget.sEntery.start;
    end = widget.sEntery.end;
  }

  void reload() {
    super.setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) => MainPage(user: widget.student),
              ));
            },
            icon: const Icon(Icons.keyboard_arrow_left),
          ),
          title: Center(
            child: Text("Viewing/Editing Entry ${widget.sEntery.name}"),
          )),
      body: Center(
        child: Container(
          alignment: Alignment.center,
          width: MediaQuery.sizeOf(context).width * .8,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(controller: name, label: "Name", height: 60),
            TextField(
              controller: desc,
              label: "Description",
              height: 60,
            ),
            TextField(
              controller: type,
              label: "Type",
              height: 60,
            ),
            const SizedBox(
              height: 30,
            ),
            Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
              changeDate(context),
              setTime(context, start, true, end.hour * 60 + end.minute),
              setTime(context, end, false, start.hour * 60 + start.minute)
            ]),
            const SizedBox(height: 30),
            TextButton(
                onPressed: () async {
                  widget.sEntery.changeName(name.value.text);
                  widget.sEntery.changeDesc(desc.value.text);
                  widget.sEntery.changeStart(start);
                  widget.sEntery.changeEnd(end);
                  widget.sEntery.changeType(type.value.text);
                  if (widget.newEntry != null) {
                    widget.student.stSch.addEntry(widget.sEntery);
                  }
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                    builder: (context) {
                      return MainPage(user: widget.student);
                    },
                  ));
                },
                child: const Text("Save"))
          ]),
        ),
      ),
    );
  }

  Column changeDate(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Text(
            "Date: ${start.month}/${start.day}/${start.year}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () async {
            DateTime? w =
                await Navigator.of(context).push(pickDate(context, start));
            if (w == null) return;
            start = DateTime(w.year, w.month, w.day, start.hour, start.minute);
            reload();
          },
          child: const Text("Select new Date"),
        )
      ],
    );
  }

  Column setTime(
      BuildContext context, DateTime time, bool start, int minutesFromOther) {
    return Column(
      children: [
        SizedBox(
          height: 40,
          child: Text(
            "${start ? "Start" : "End"} Time: ${timeDisplay(time.hour, time.minute)}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        TextButton(
          onPressed: () async {
            TimeOfDay? w =
                await Navigator.of(context).push(pickTime(context, time));
            if (!mounted) return;
            if (w == null) return;
            if (w.hour * 60 + w.minute >= minutesFromOther && start) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "You cannot set a time which is greater or equal to the end time.")));
              return;
            } else if (w.hour * 60 + w.minute <= minutesFromOther && !start) {
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "You cannot set a time which is less or equal to the start time.")));
              return;
            }
            time = DateTime(time.year, time.month, time.day, w.hour, w.minute);
            if (start) {
              this.start = time;
            } else {
              end = time;
            }
            reload();
          },
          child: const Text("Select new Date"),
        )
      ],
    );
  }
}

class TextField extends StatelessWidget {
  const TextField(
      {super.key,
      required this.controller,
      required this.label,
      required this.height});

  final String label;
  final double height;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        decoration: InputDecoration(labelText: label),
        controller: controller,
      ),
    );
  }
}

// this is a date picker returns a DateTime or null if user cancels
Route<DateTime> pickDate(
  BuildContext context,
  DateTime day,
) {
  return DialogRoute<DateTime>(
    context: context,
    builder: (BuildContext context) {
      return DatePickerDialog(
        initialEntryMode: DatePickerEntryMode.calendar,
        initialDate: day,
        firstDate: DateTime(day.year),
        lastDate: DateTime(day.year + 1),
      );
    },
  );
}

// this is a time picker returns a TimeOfDay or null if user cancels
Route<TimeOfDay> pickTime(
  BuildContext context,
  DateTime day,
) {
  return DialogRoute<TimeOfDay>(
    context: context,
    builder: (BuildContext context) {
      return TimePickerDialog(
        initialEntryMode: TimePickerEntryMode.dial,
        initialTime: TimeOfDay.fromDateTime(day),
      );
    },
  );
}

String timeDisplay(int hour, int min) {
  String minutes = min < 10 ? "0$min" : "$min";
  if (hour == 0) {
    return "12:$minutes AM";
  } else if (hour > 12) {
    return "${hour - 12}:$minutes PM";
  } else {
    return "$hour${hour == 12 ? ":$minutes PM" : ":$minutes AM"}";
  }
}
