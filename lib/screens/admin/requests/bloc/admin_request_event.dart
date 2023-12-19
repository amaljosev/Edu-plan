part of 'admin_request_bloc.dart';

abstract class AdminRequestEvent {}

abstract class AdminRequestActionEvent extends AdminRequestEvent {}

final class ViewTeacherEvent extends AdminRequestActionEvent{
  final Map<String, dynamic> teacherData;
  ViewTeacherEvent({required this.teacherData});  
} 

final class AcceptButtonEvent extends AdminRequestActionEvent{
  final String id;
  AcceptButtonEvent({required this.id});
}

final class RejectButtonEvent extends AdminRequestActionEvent{
  final String id;
  RejectButtonEvent({required this.id});
}