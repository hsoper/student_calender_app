class Homework {
  final int homeworkID;
  final int courseID;
  final String name;
  final String description;
  final DateTime dueDate;
  Homework(
      {required this.homeworkID,
      required this.courseID,
      required this.description,
      required this.dueDate,
      required this.name});
  @override
  bool operator ==(Object other) {
    return (other is Homework) && other.homeworkID == homeworkID;
  }

  @override
  int get hashCode => homeworkID;
}
