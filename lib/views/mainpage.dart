// ignore_for_file: file_names

import 'package:flutter/material.dart';

class MainPage extends StatefulWidget {
  const MainPage({super.key});

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
      drawer: Drawer(
          child: ListView(
        padding: EdgeInsets.zero,
        children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  "Option",
                  style: TextStyle(color: Colors.white, fontSize: 32),
                ),
                Text("Loggin as Humberto",
                    style: TextStyle(color: Colors.white))
              ],
            )),
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
      )),
    );
  }
}
