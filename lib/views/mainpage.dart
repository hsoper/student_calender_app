// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:studnet_calender_app/models/student.dart';

class MainPage extends StatefulWidget {
  final Student user;
  const MainPage({super.key, required this.user});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool hasWifi = true;
  void toggleWifi() {
    setState(() {
      hasWifi = !hasWifi;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Center(child: Text("Week Planner"))),
      drawer: makeDrawer(context, widget.user.name, widget.user.email),
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
