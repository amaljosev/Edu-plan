part of 'chat_teacher_bloc.dart';

abstract class ChatTeacherState {}

abstract class ChatTeacherActionState extends ChatTeacherState {}

final class ChatTeacherInitial extends ChatTeacherState {}

final class SendMessageSuccessState extends ChatTeacherActionState {}

final class SendMessageLoadingState extends ChatTeacherActionState {}

final class SendMessageErrorState extends ChatTeacherActionState {}


