import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/firebase/teacher/chat/chat_functions.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/chat/bloc/chat_teacher_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';

final messageController = TextEditingController();
bool isLoading = false;

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
        } else if (state is SendMessageErrorState) {
          AlertMessages().alertMessageSnakebar(
              context,
              'Please check your interner connection',
              Colors.red.withOpacity(0.2));
        }
      },
      builder: (context, state) {
        return Scaffold(
            appBar: AppBar(
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
              ],
            ),
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
                        return UnconstrainedBox(
                          alignment: isTeacher
                              ? sender
                                  ? Alignment.bottomRight
                                  : Alignment.bottomLeft
                              : sender
                                  ? Alignment.bottomLeft
                                  : Alignment.bottomRight,
                          child: Padding(
                            padding: const EdgeInsets.all(3.0),
                            child: IntrinsicWidth(
                              child: Container(
                                constraints: BoxConstraints(
                                  maxWidth: size.width * 0.6,
                                ),
                                decoration: BoxDecoration(
                                  color: titleColor,
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(10)),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        chat['message'],
                                        style: TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      Row(
                                        mainAxisAlignment: isTeacher
                                            ? MainAxisAlignment.start
                                            : MainAxisAlignment.end,
                                        children: [
                                          Text(
                                            "${DateFormat('H:mm').format(dateTime)}",
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 10),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
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
            floatingActionButton: Padding(
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
                            border:
                                OutlineInputBorder(borderSide: BorderSide.none),
                            hintText: 'Message',
                            suffixIcon: IconButton(
                                onPressed: isLoading
                                    ? () {}
                                    : () {
                                        if (messageController.text != '') {
                                          context.read<ChatTeacherBloc>().add(
                                              SendMessageEvent(
                                                  isTeacher: isTeacher,
                                                  gender: gender,
                                                  receiverId: studentId,
                                                  name: name,
                                                  message:
                                                      messageController.text));
                                        }
                                      },
                                icon: Icon(
                                  Icons.send,
                                  color: contentColor,
                                ))),
                      ),
                    ),
                  )),
            ));
      },
    );
  }
}
