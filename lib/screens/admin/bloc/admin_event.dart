part of 'admin_bloc.dart';

abstract class AdminEvent {}

abstract class AdminActionEvent extends AdminEvent {}

final class StudentCardTapEvent extends AdminActionEvent {
  final String teacherId;
  final String standard;
  final String division;
  StudentCardTapEvent(
      {required this.teacherId,
      required this.standard,
      required this.division});
}

final class TeacherCardTapEvent extends AdminActionEvent {
  final String teacherId;
  final Map<String, dynamic> teacherData;
  TeacherCardTapEvent({required this.teacherData, required this.teacherId});
}

final class RequestTapEvent extends AdminActionEvent {}

final class LogOutEvent extends AdminActionEvent {}

final class FloatingActionButtonTapEvent extends AdminActionEvent {}

final class AcadamicYearCompleteEvent extends AdminActionEvent {}

final class ShowDeleteAlertEvent extends AdminActionEvent {}

final class DeleteTeacherEvent extends AdminActionEvent {
  final String teacherId;
  DeleteTeacherEvent({required this.teacherId});
}
