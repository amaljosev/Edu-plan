import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/firebase/teacher/chat/chat_functions.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/chat/bloc/chat_teacher_bloc.dart';
import 'package:eduplanapp/screens/teacher/chat/widgets/chat_input_field.dart';
import 'package:eduplanapp/screens/teacher/chat/widgets/chat_tile_widget.dart';
import 'package:eduplanapp/screens/teacher/chat/widgets/chat_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final messageController = TextEditingController();
bool isLoading = false;
bool isSelected = false;
int selectedIndex = -1;
String messageId = '';

class ScreenChatPrivate extends StatelessWidget {
  const ScreenChatPrivate(
      {super.key,
      required this.name,
      required this.image,
      required this.studentId,
      required this.gender,
      required this.isTeacher,
      required this.teacherName});
  final String gender;
  final String name;
  final String image;
  final String studentId;
  final bool isTeacher;
  final String? teacherName;

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return BlocConsumer<ChatTeacherBloc, ChatTeacherState>(
      listener: (context, state) {
        if (state is SendMessageSuccessState) {
          messageController.text = '';
          isLoading = false;
        } else if (state is SendMessageErrorState) {
          AlertMessages().alertMessageSnakebar(
              context, 'Please check your interner connection', Colors.red);
        }
        if (state is SelectMessageState) {
          if (state.index == selectedIndex) {
            selectedIndex = -1;
          } else {
            selectedIndex = state.index;
          }
        }
        if (state is DeleteMessageSuccessState) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            behavior: SnackBarBehavior.floating,
            padding: const EdgeInsets.all(10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(10))),
            duration: const Duration(seconds: 1),
            content: Center(
              child: Text(
                'Deleted',
                style:
                    TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
          ));
          selectedIndex = -1;
        } else if (state is DeleteMessageErrorState) {
          AlertMessages().alertMessageSnakebar(
              context, 'Please check your interner connection', Colors.red);
          selectedIndex = -1;
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: chatAppbar(
                context: context,
                image: image,
                isTeacher: isTeacher,
                messageId: messageId,
                name: name,
                selectedIndex: selectedIndex,
                studentId: studentId,
                teacherName: teacherName,
                titleTextStyle: titleTextStyle),
            body: Padding(
              padding: EdgeInsets.only(
                left: 8.0,
                right: 8.0,
                top: 8.0,
                bottom: size.height * 0.1,
              ),
              child: StreamBuilder(
                stream: ChatFunctions().getStudentChat(studentId, name),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox(
                        child: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasData) {
                    List<DocumentSnapshot> chats = snapshot.data!.docs;
                    chats.sort((a, b) {
                      Timestamp timestampA = a['date'];
                      Timestamp timestampB = b['date'];
                      return timestampB.compareTo(timestampA);
                    });
                    return ListView.builder(
                      reverse: true,
                      itemBuilder: (context, index) {
                        DocumentSnapshot chat = chats[index];
                        Timestamp timestamp = chat['date'];
                        DateTime dateTime = timestamp.toDate();
                        bool sender = chat['is_teacher'];
                        return GestureDetector(
                          onLongPress: () {
                            if (isTeacher ? sender : !sender) {
                              messageId = chat.id;
                              context
                                  .read<ChatTeacherBloc>()
                                  .add(SelectMessageEvent(index: index));
                            }
                          },
                          child: chatTile(sender,
                              index: index,
                              size: size,
                              chat: chat,
                              dateTime: dateTime,
                              isTeacher: isTeacher,
                              isSelected: isSelected),
                        );
                      },
                      itemCount: chats.length,
                    );
                  } else if (snapshot.hasError) {
                    return SizedBox(
                      child: Center(child: CircularProgressIndicator()),
                    );
                  } else {
                    return SizedBox(
                      child: Center(
                        child: Center(
                            child:
                                Text('Please check your internet connection')),
                      ),
                    );
                  }
                },
              ),
            ),
            floatingActionButton: chatInputField(
                size: size,
                isTeacher: isTeacher,
                gender: gender,
                studentId: studentId,
                name: name));
      },
    );
  }

  bool isSelected(int index) => selectedIndex == index;
}
