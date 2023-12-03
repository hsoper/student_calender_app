import 'package:flutter/material.dart';
import 'package:student_calender_app/models/schedulentry.dart';
import 'package:student_calender_app/models/student.dart';
import 'package:student_calender_app/views/mainpage.dart';

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
          // button to go back to the mainPage
          leading: IconButton(
            onPressed: () {
              Navigator.of(context).pushReplacement(MaterialPageRoute(
                builder: (context) =>
                    MainPage(user: widget.student, day: widget.sEntery.start),
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
            widget.newEntry == null
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SaveButton(
                        widget: widget,
                        name: name,
                        desc: desc,
                        start: start,
                        end: end,
                        type: type,
                      ),
                      DeleteButton(widget: widget)
                    ],
                  )
                : SaveButton(
                    widget: widget,
                    name: name,
                    desc: desc,
                    start: start,
                    end: end,
                    type: type,
                  )
          ]),
        ),
      ),
    );
  }

  // Returns a Widget Column with the current day and a button
  // which sends user to the datePicker.
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

  // builds a widget column with either the start or end time based on the start boolean.
  // It also contains the button which sends users into the timePicker widget
  // Changes either the start or end times based on the start boolean
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
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                  content: Text(
                      "You cannot set a time which is greater or equal to the end time.")));
              return;
            } else if (w.hour * 60 + w.minute <= minutesFromOther && !start) {
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
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

// Builds a button which when pressed will delete the current entry
class DeleteButton extends StatelessWidget {
  const DeleteButton({super.key, required this.widget});

  final EditEntryWidget widget;
  @override
  Widget build(BuildContext context) {
    return TextButton(
        onPressed: () {
          widget.student.stSch.deleteEntry(widget.sEntery);
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) {
            return MainPage(user: widget.student);
          }));
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Center(
            child: Text("Deleted Entry: ${widget.sEntery.name}"),
          )));
        },
        child: const Text("Delete"));
  }
}

// builds a button which when pressed will save the entry which the user is currently working on
class SaveButton extends StatelessWidget {
  const SaveButton({
    super.key,
    required this.widget,
    required this.name,
    required this.desc,
    required this.start,
    required this.end,
    required this.type,
  });

  final EditEntryWidget widget;
  final TextEditingController name;
  final TextEditingController desc;
  final DateTime start;
  final DateTime end;
  final TextEditingController type;

  @override
  Widget build(BuildContext context) {
    return TextButton(
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
              return MainPage(
                user: widget.student,
                day: start,
              );
            },
          ));
          ScaffoldMessenger.of(context).clearSnackBars();
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Center(
            child: Text("Saved Entry: ${widget.sEntery.name}"),
          )));
        },
        child: const Text("Save"));
  }
}

// This builds a user text input which corresponds to a controller which changes a certain
// element of an entry stated in the label input
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

// Converts the 0-23 hour and minutes into human readable 12 hour clock time
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
