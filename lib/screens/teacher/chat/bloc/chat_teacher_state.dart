part of 'chat_teacher_bloc.dart';

abstract class ChatTeacherState {}

abstract class ChatTeacherActionState extends ChatTeacherState {}

final class ChatTeacherInitial extends ChatTeacherState {}

final class SendMessageSuccessState extends ChatTeacherActionState {}

final class SendMessageLoadingState extends ChatTeacherActionState {}

final class SendMessageErrorState extends ChatTeacherActionState {}

final class SelectMessageState extends ChatTeacherActionState {
  final int index;
  SelectMessageState({required this.index});
}

final class DeleteMessageSuccessState extends ChatTeacherActionState {}

final class DeleteMessageLoadingState extends ChatTeacherActionState {}

final class DeleteMessageErrorState extends ChatTeacherActionState {}

final class EditMessageSuccessState extends ChatTeacherActionState {}

final class EditMessageLoadingState extends ChatTeacherActionState {}

final class EditMessageErrorState extends ChatTeacherActionState {}
