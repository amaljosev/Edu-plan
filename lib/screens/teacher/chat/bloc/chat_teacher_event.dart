part of 'chat_teacher_bloc.dart';

abstract class ChatTeacherEvent {}

abstract class ChatTeacherActionEvent extends ChatTeacherEvent {}

final class SendMessageEvent extends ChatTeacherActionEvent {
  final String receiverId;
  final String message;
  final String name;
  final String gender;
  SendMessageEvent(
      {required this.message,
      required this.gender,
      required this.name,
      required this.receiverId});
}

