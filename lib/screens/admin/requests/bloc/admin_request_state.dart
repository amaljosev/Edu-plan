part of 'admin_request_bloc.dart';

abstract class AdminRequestState {}

abstract class AdminRequestActionState extends AdminRequestState {}

final class AdminRequestInitial extends AdminRequestState {}

final class ViewTeacherState extends AdminRequestActionState {
  final Map<String, dynamic> teacherData;
  ViewTeacherState({required this.teacherData});
}

final class AcceptRequestState extends AdminRequestActionState {}

final class RejectRequestState extends AdminRequestActionState {}
