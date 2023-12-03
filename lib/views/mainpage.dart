import 'dart:math';
import 'package:flutter/material.dart';
import 'package:studnet_calender_app/models/schedulentry.dart';
import 'package:studnet_calender_app/models/student.dart';
import 'package:studnet_calender_app/views/blackboard.dart';
import 'package:studnet_calender_app/views/editentry.dart';
import 'package:studnet_calender_app/views/week.dart';

class MainPage extends StatefulWidget {
  final Student user;
  final DateTime? day;
  const MainPage({super.key, required this.user, this.day});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  late bool hasWifi;

  // this will normally be the current day, but hardcoded for UI prototype
  late DateTime curDay;

  @override
  void initState() {
    super.initState();
    hasWifi = true;
    if (widget.day == null) {
      curDay = DateTime(2023, 12, 1, 0, 1);
    } else {
      curDay = widget.day!;
    }
  }

  // rebuilds the current page
  void reload() {
    super.setState(() {});
  }

  // changes the hasWifi state (once implemented will be based on the users touch and actual wifi usuage)
  void toggleWifi() {
    setState(() {
      hasWifi = !hasWifi;
    });
  }

  // Moves the current day a week back
  void goBackAWeek() {
    super.setState(() {
      curDay = curDay.subtract(const Duration(days: 7));
    });
  }

  // Moves the current day a week forward
  void goFowardAWeek() {
    super.setState(() {
      curDay = curDay.add(const Duration(days: 7));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          // AppBar is the top of the app which shows the options button, title, and action buttons
          AppBar(title: const Center(child: Text("Week Planner")), actions: [
        // button to go back a week
        IconButton(
            onPressed: () {
              goBackAWeek();
            },
            icon: const Icon(Icons.keyboard_arrow_left)),
        // button to go forward a week
        IconButton(
            onPressed: () {
              goFowardAWeek();
            },
            icon: const Icon(Icons.keyboard_arrow_right))
      ]),
      drawer: makeDrawer(
          context, widget.user.name, widget.user.email), // options menu
      body: WeekWidget(
        student: widget.user,
        day: curDay,
      ),
      // this is button for when users want to add a new schedule entry
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushReplacement(MaterialPageRoute(
            builder: (context) {
              return EditEntryWidget(
                sEntery: ScheduleEntry(
                    entryId: Random().nextInt(1000),
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

  // method which returns the option menu based on the name and email of the user
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
          onTap: () async {
            if (!hasWifi) {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).removeCurrentSnackBar();
              ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text("Online Mode Only")));
              return;
            }
            Navigator.of(context).pop();
            await Navigator.of(context).push(MaterialPageRoute(
              builder: (context) {
                return Blackboard(student: widget.user);
              },
            ));
            reload();
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

// builds the title for the options menu.
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
