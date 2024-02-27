part of 'chat_teacher_bloc.dart';

abstract class ChatTeacherEvent {}

abstract class ChatTeacherActionEvent extends ChatTeacherEvent {}

final class SendMessageEvent extends ChatTeacherActionEvent {
  final String receiverId;
  final String message;
  final String name;
  final String gender;
  final bool isTeacher;
  SendMessageEvent(
      {required this.message,
      required this.gender,
      required this.name,
      required this.receiverId,
      required this.isTeacher});
}

final class SelectMessageEvent extends ChatTeacherActionEvent {
  final int index;
  SelectMessageEvent({required this.index});
}

final class DeleteMessageEvent extends ChatTeacherActionEvent {
  final String messageId;
  final String studentId;
  final String studentName;
  DeleteMessageEvent({
    required this.messageId,
    required this.studentId,
    required this.studentName,
  });
}

final class EditMessageEvent extends ChatTeacherActionEvent {
  final String messageId;
  final String studentId;
  final String studentName;
  EditMessageEvent({
    required this.messageId,
    required this.studentId,
    required this.studentName,
  });
}
