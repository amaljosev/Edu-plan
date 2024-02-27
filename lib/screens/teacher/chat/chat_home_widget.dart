import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/repositories/firebase/teacher/chat/chat_functions.dart';
import 'package:eduplanapp/screens/teacher/all_students/allstudents_screen.dart';
import 'package:eduplanapp/screens/teacher/chat/private_chat.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class ScreenChatHome extends StatelessWidget {
  const ScreenChatHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar('Chat'),
      body: StreamBuilder(
          stream: ChatFunctions().getMessages(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const SizedBox(
                  child: Center(child: CircularProgressIndicator()));
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else if (snapshot.hasData) {
              List<DocumentSnapshot> students = snapshot.data!.docs;
              return ListView.builder(
                itemBuilder: (context, index) {
                  DocumentSnapshot student = students[index];
                  final String studentId = students[index].id;
                  final name = student['name'];
                  final gender = student['gender'];
                  final String img = gender == 'Gender.male'
                      ? 'lib/assets/images/student male.jpg'
                      : 'lib/assets/images/student female.png';
                  return ListTile(
                    leading: CircleAvatar(
                      backgroundImage: AssetImage(img),
                    ),
                    title: Text(name),
                    onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ScreenChatPrivate(
                            teacherName: null,
                            isTeacher: true,
                              name: name,
                              image: img,
                              studentId: studentId,
                              gender: gender),
                        )),
                  );
                },
                itemCount: students.length,
              );
            } else {
              return const SizedBox(
                child: Center(
                  child: Text('Please check your internet connection'),
                ),
              );
            }
          }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ScreenAllStudentsTeacher(isChat: true),
            )),
        child: Icon(Icons.chat_outlined),
      ),
    );
  }
}
