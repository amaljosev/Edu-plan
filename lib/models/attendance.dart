class AttendanceModel {
  final int totalWorkingDaysCompleted;
  final DateTime date;
  final int todayPresents;
  final int todayAbsents;

  AttendanceModel(
      {required this.totalWorkingDaysCompleted,
      required this.date,
      required this.todayPresents,
      required this.todayAbsents}); 
}
