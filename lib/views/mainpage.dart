// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:studnet_calender_app/models/schedulentry.dart';
import 'package:studnet_calender_app/models/student.dart';
import 'package:studnet_calender_app/views/blackboard.dart';
import 'package:studnet_calender_app/views/editEntry.dart';
import 'package:studnet_calender_app/views/week.dart';

class MainPage extends StatefulWidget {
  final Student user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool hasWifi = true;
  int current = 3;

  // this will normally be the current day, but hardcoded for UI prototype
  DateTime curDay = DateTime(2023, 12, 1, 0, 1);
  void toggleWifi() {
    setState(() {
      hasWifi = !hasWifi;
    });
  }

  void goBackAWeek() {
    super.setState(() {
      curDay = curDay.subtract(const Duration(days: 7));
    });
  }

  void goFowardAWeek() {
    super.setState(() {
      curDay = curDay.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Center(child: Text("Week Planner")), actions: [
        IconButton(
            onPressed: () {
              goBackAWeek();
            },
            icon: const Icon(Icons.keyboard_arrow_left)),
        IconButton(
            onPressed: () {
              goFowardAWeek();
            },
            icon: const Icon(Icons.keyboard_arrow_right))
      ]),
      drawer: makeDrawer(context, widget.user.name, widget.user.email),
      body: WeekWidget(
        student: widget.user,
        day: curDay,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return EditEntryWidget(
                sEntery: ScheduleEntry(
                    entryId: current,
                    scheduleId: widget.user.stSch.id,
                    entryType: "",
                    description: "",
                    start: DateTime.now(),
                    end: DateTime.now().add(const Duration(minutes: 10)),
                    name: ""),
                student: widget.user,
                newEntry: true,
              );
            },
          ));
        },
        child: const Icon(Icons.add),
      ),
    );
  }

  Drawer makeDrawer(BuildContext context, String name, String email) {
    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          decoration: const BoxDecoration(
            color: Colors.blue,
          ),
          child: DrawerTitle(
            name: name,
            email: email,
          ),
        ),
        ListTile(
          leading: const Icon(Icons.add),
          title: const Text("Blackboard import"),
          onTap: () {
            if (!hasWifi) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Online Mode Only")));
            }
            Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return Blackboard(student: widget.user);
              },
            ));
          },
        ),
        ListTile(
          leading: Icon(hasWifi ? Icons.wifi_off : Icons.wifi),
          title: Text(hasWifi ? "Offline Mode" : "Online Mode"),
          onTap: () async {
            toggleWifi();
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text("Logout"),
          onTap: () async {},
        ),
      ],
    ));
  }
}

class DrawerTitle extends StatelessWidget {
  final String name;
  final String email;
  const DrawerTitle({super.key, required this.name, required this.email});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        const Text(
          "Option",
          style: TextStyle(color: Colors.white, fontSize: 32),
        ),
        Text("Logged in as $name\nemail:$email",
            style: const TextStyle(color: Colors.white))
      ],
    ));
  }
}
