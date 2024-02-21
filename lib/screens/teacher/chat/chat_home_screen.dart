import 'package:eduplanapp/screens/teacher/all_students/allstudents_screen.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';
import 'package:flutter/material.dart';

class ScreenChatHome extends StatelessWidget {
  const ScreenChatHome({super.key}); 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar('Chat'),
      body: ListView(
        children: [
          Center(child: Text('chat screen')),
        ],
      ),
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
