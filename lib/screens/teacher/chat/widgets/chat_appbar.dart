import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/screens/teacher/chat/bloc/chat_teacher_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

AppBar chatAppbar(
    {required BuildContext context,
    required String image,
    required bool isTeacher,
    required int selectedIndex,
    required String name,
    required teacherName,
    required TextStyle titleTextStyle,
    required String messageId,
    required String studentId}) {
  return AppBar(
    backgroundColor: appbarColor,
    leading: Row(),
    actions: [
      IconButton(
          onPressed: () => Navigator.pop(context),
          icon: Icon(Icons.arrow_back)),
      CircleAvatar(backgroundImage: AssetImage(image)),
      Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Text(
          isTeacher ? name : teacherName ?? '',
          style: titleTextStyle,
        ),
      ),
      Spacer(),
      selectedIndex != -1
          ? IconButton(
              onPressed: () => context.read<ChatTeacherBloc>().add(
                  DeleteMessageEvent(
                      messageId: messageId,
                      studentId: studentId,
                      studentName: name)),
              icon: Icon(
                Icons.delete,
                color: contentColor,
              ))
          : Row()
    ],
  );
}
