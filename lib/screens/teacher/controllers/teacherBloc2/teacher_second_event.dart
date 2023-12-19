part of 'teacher_second_bloc.dart';

abstract class TeacherSecondEvent {}

final class TeacherSecondActionEvent extends TeacherSecondEvent {}

final class CheckBoxTapEvent extends TeacherSecondActionEvent {
  final bool? isChecked;
  final int index;
  CheckBoxTapEvent({required this.isChecked, required this.index});
}

final class SubmitAttendanceEvent extends TeacherSecondActionEvent {
  final List<DocumentSnapshot> students;
  final List<bool?> checkMarks;
  SubmitAttendanceEvent({required this.checkMarks, required this.students});
}

final class UpdateAttendanceEvent extends TeacherSecondActionEvent {
  final List<DocumentSnapshot> students;
  final List<bool?> checkMarks;
  UpdateAttendanceEvent({required this.checkMarks, required this.students});
}

final class FetchAttendanceHistoryEvent extends TeacherSecondActionEvent {}

final class HomeWorkSendEvent extends TeacherSecondActionEvent {
  String task;
  String subject;
  HomeWorkSendEvent({required this.task, required this.subject});
}

final class DateSelectedEvent extends TeacherSecondActionEvent {
  final DateTime selectedDate;
  DateSelectedEvent({required this.selectedDate});
}

final class AssignmentSendEvent extends TeacherSecondActionEvent {
  String task;
  String subject;
  DateTime selectedDate;
  AssignmentSendEvent(
      {required this.task, required this.subject, required this.selectedDate});
}

final class TaskDropDownEvent extends TeacherSecondActionEvent {
  int index;
  String? value;
  TaskDropDownEvent({required this.index, required this.value});
}

final class LogoutEvent extends TeacherSecondActionEvent {}

final class EditTeacherEvent extends TeacherSecondActionEvent {
  final TeacherModel teacherData;
  EditTeacherEvent({required this.teacherData});
}

final class FetchTaskDatasEvent extends TeacherSecondActionEvent {
  final bool isHw;
  final bool isTeacher;
  FetchTaskDatasEvent({
    required this.isHw,
    required this.isTeacher,
  });
}

final class TeacherNoticeEvent extends TeacherSecondActionEvent {
  final String titleOrDate;
  final String topicOrReason;
  final String studentName;
  final bool isTeacher;

  TeacherNoticeEvent(
      {required this.titleOrDate,
      required this.topicOrReason,
      required this.isTeacher,
      required this.studentName});
}

final class FetchFormDatasEvent extends TeacherSecondActionEvent {
  final bool isTeacher;
  FetchFormDatasEvent({required this.isTeacher});
}

final class FetchLeaveApplicationsEvent extends TeacherSecondActionEvent {}

final class PopupMenuButtonEvent extends TeacherSecondActionEvent {
  final Options item;
  PopupMenuButtonEvent({required this.item});
}

final class DeleteStudentEvent extends TeacherSecondActionEvent {
  final String studentId;
  final String email;
  final String password;
  final String gender;
  DeleteStudentEvent(
      {required this.studentId,
      required this.email,
      required this.password,
      required this.gender});
}

final class EventDeleteEvent extends TeacherSecondActionEvent {
  final String eventId;
  final bool isTeacher;
  final String? studentName;
  final String? reason;

  EventDeleteEvent(
      {required this.eventId,
      required this.isTeacher,
      required this.reason,
      required this.studentName});
}

final class TaskDeleteEvent extends TeacherSecondActionEvent {
  final String taskId;
  final bool isHw;
  TaskDeleteEvent({required this.taskId, required this.isHw});
}
