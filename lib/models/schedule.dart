import 'package:studnet_calender_app/models/schedulentry.dart';

class Schedule {
  final int _schID;
  final int _studentID;
  String _name;
  final Set<ScheduleEntry> _entries;
  Schedule(
      {required Set<ScheduleEntry> entries,
      required int schID,
      required String name,
      required int studentID})
      : _entries = entries,
        _name = name,
        _studentID = studentID,
        _schID = schID;

  int get id => _schID;
  int get sid => _studentID;
  String get name => _name;
  Set<ScheduleEntry> get entries => _entries;
  void addEntry(ScheduleEntry entry) {
    _entries.add(entry);
  }

  void deleteEntry(ScheduleEntry entry) {
    _entries.remove(entry);
  }

  void changeName(String newName) {
    _name = newName;
  }
}
