import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/screens/teacher/chat/bloc/chat_teacher_bloc.dart';
import 'package:eduplanapp/screens/teacher/chat/private_chat.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class chatInputField extends StatelessWidget {
  const chatInputField({
    super.key,
    required this.size,
    required this.isTeacher,
    required this.gender,
    required this.studentId,
    required this.name,
  });

  final Size size;
  final bool isTeacher;
  final String gender;
  final String studentId;
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 28.0),
      child: FloatingActionButton.extended(
          onPressed: () {},
          label: SizedBox(
            width: size.width,
            child: Padding(
              padding: const EdgeInsets.all(28.0),
              child: TextFormField(
                controller: messageController,
                showCursor: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(borderSide: BorderSide.none),
                    hintText: 'Message',
                    suffixIcon: IconButton(
                        onPressed: isLoading
                            ? () {}
                            : () { 
                                if (messageController.text != '') { 
                                  isLoading=true;
                                  context.read<ChatTeacherBloc>().add(
                                      SendMessageEvent(
                                          isTeacher: isTeacher,
                                          gender: gender,
                                          receiverId: studentId,
                                          name: name,
                                          message: messageController.text));
                                }
                              },
                        icon: Icon(
                          Icons.send,
                          color: contentColor,
                        ))),
              ),
            ),
          )),
    );
  }
}
