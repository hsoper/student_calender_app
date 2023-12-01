import 'package:studnet_calender_app/models/schedulentry.dart';

class Schedule {
  final int schID;
  final int studentID;
  final String name;
  List<ScheduleEntry>? entries;
  Schedule(this.name, {required this.schID, required this.studentID});
}
