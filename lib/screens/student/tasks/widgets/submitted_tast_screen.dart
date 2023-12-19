import 'package:flutter/material.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/screens/teacher/tasks/submitted_tasks/full_screen.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';

class ScreenSubmittedTaskStudent extends StatelessWidget {
  const ScreenSubmittedTaskStudent({
    Key? key,
    required this.taskName,
    required this.note,
    required this.files,
    required this.isTeacher,
    required this.subject,
    required this.name,
    required this.task,
  }) : super(key: key);
  final bool isTeacher;
  final String taskName;
  final String note;
  final List files;
  final String subject;
  final String name;
  final String task;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: myAppbar('Submitted  $taskName'), 
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isTeacher
                        ? Text(
                            'Student',
                            style: listViewTextStyle,
                          )
                        : const SizedBox(),
                    isTeacher
                        ? Text(
                            'Subject',
                            style: listViewTextStyle,
                          )
                        : const SizedBox(),
                    Text(
                      'Note',
                      style: listViewTextStyle,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    isTeacher
                        ? Text(
                            ' : $name',
                            style: listViewTextStyle,
                          )
                        : const SizedBox(),
                    isTeacher
                        ? Text(
                            ' : $subject',
                            style: listViewTextStyle,
                          )
                        : const SizedBox(),
                    Text(
                      ' : $note',
                      style: listViewTextStyle,
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: files.isNotEmpty
                ? GridView.builder(
                    padding: const EdgeInsets.all(5),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 5,
                      mainAxisSpacing: 5,
                    ),
                    itemCount: files.length,
                    itemBuilder: (context, index) {
                      final file = files[index];
                      return GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ScreenFullScreenImage(imageUrl: file,isChecking: false),
                          ),
                        ),
                        child: SizedBox(
                          height: 200,
                          width: 200,
                          child: Image.network(
                            file,
                            fit: BoxFit.cover,filterQuality: FilterQuality.high, 
                            loadingBuilder: (BuildContext context, Widget child,
                                ImageChunkEvent? loadingProgress) {
                              if (loadingProgress == null) {
                                return child;
                              } else {
                                return Center(
                                  child: CircularProgressIndicator(
                                    value: loadingProgress.expectedTotalBytes !=
                                            null
                                        ? loadingProgress
                                                .cumulativeBytesLoaded /
                                            (loadingProgress
                                                    .expectedTotalBytes ??
                                                1)
                                        : null,
                                  ),
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  )
                : const Center(child: Text('No file selected')),
          ),
        ],
      ),
    );
  }
}
