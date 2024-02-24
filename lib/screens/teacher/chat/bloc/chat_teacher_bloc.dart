import 'dart:async';
import 'dart:developer';

import 'package:eduplanapp/models/chat_model.dart';
import 'package:eduplanapp/repositories/firebase/teacher/chat/chat_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'chat_teacher_event.dart';
part 'chat_teacher_state.dart';

class ChatTeacherBloc extends Bloc<ChatTeacherEvent, ChatTeacherState> {
  ChatTeacherBloc() : super(ChatTeacherInitial()) {
    on<SendMessageEvent>(sendMessageEvent);
  }

  FutureOr<void> sendMessageEvent(
      SendMessageEvent event, Emitter<ChatTeacherState> emit) async {
    emit(SendMessageLoadingState());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String id = prefs.getString('teacherId').toString();
    final messageModel = ChatModel(
        isTeacher: event.isTeacher,
        gender: event.gender,
        message: event.message,
        date: DateTime.now(),
        senderId: id,
        receiverId: event.receiverId,
        name: event.name);
    try {
      final bool response = await ChatFunctions().sendMessage(messageModel);
      if (response) {
        emit(SendMessageSuccessState());
      } else {
        emit(SendMessageSuccessState());
      }
    } catch (e) {
      log('$e');
      emit(SendMessageSuccessState());
    }
  }
}
