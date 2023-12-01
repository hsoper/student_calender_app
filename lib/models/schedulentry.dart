class ScheduleEntry {
  final int _entryId;
  final int _scheduleId;
  String _entryType;
  String _name;
  String _description;
  DateTime _start;
  DateTime _end;

  ScheduleEntry(
      {required int entryId,
      required int scheduleId,
      required String entryType,
      required String description,
      required DateTime start,
      required DateTime end,
      required String name})
      : _end = end,
        _start = start,
        _description = description,
        _name = name,
        _entryType = entryType,
        _scheduleId = scheduleId,
        _entryId = entryId;
  int get entryID => _entryId;
  int get scheduleID => _scheduleId;
  String get type => _entryType;
  String get name => _name;
  String get desc => _description;
  DateTime get start => _start;
  DateTime get end => _end;

  void changeName(String nName) {
    _name = nName;
  }

  void changeType(String type) {
    _entryType = type;
  }

  void changeDesc(String desc) {
    _description = desc;
  }

  void changeStart(DateTime start) {
    _start = start;
  }

  void changeEnd(DateTime end) {
    _end = end;
  }

  @override
  bool operator ==(Object other) {
    return (other is ScheduleEntry) && other._entryId == _entryId;
  }

  @override
  int get hashCode => _entryId;
}
