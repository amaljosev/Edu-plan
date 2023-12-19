part of 'admin_bloc.dart';

abstract class AdminState {}

abstract class AdminActionState extends AdminState {}

final class AdminInitial extends AdminState {}

final class StudentCardTapState extends AdminActionState {
  final Stream<QuerySnapshot> studentList;
  final String standard;
  final String division;
  StudentCardTapState(
      {required this.studentList,
      required this.standard,
      required this.division});
}

final class TeacherCardTapState extends AdminActionState {
  final Map<String, dynamic> teacherData;
  final String teacherId;

  TeacherCardTapState({required this.teacherData, required this.teacherId});
}

final class RequestTapState extends AdminActionState {}

final class LogOutState extends AdminActionState {}

final class SettingsState extends AdminActionState {}

final class ShowDialogState extends AdminActionState {}

final class DeleteTeacherSuccessState extends AdminActionState {}

final class DeleteTeacherLoadingState extends AdminActionState {}

final class DeleteTeacherErrorState extends AdminActionState {}
