import 'package:flutter/material.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';

class ScreenSubmittedTasksView extends StatelessWidget {
  const ScreenSubmittedTasksView(
      {super.key,
      required this.formattedDate,
      required this.task,
      required this.subject,
      required this.deadline,
      required this.isHw,
      required this.name,
      required this.image,
      required this.note,
      required this.isSubmitted});

  final String formattedDate;
  final String task;
  final String subject;
  final String deadline;
  final bool isHw;
  final bool isSubmitted;
  final String name;
  final String image;
  final String note;

  @override
  Widget build(BuildContext context) {
    final String taskName = isHw ? 'Home Work' : 'Assignment';
    return Scaffold(
      appBar: myAppbar('Submitted $taskName'),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Student Name  : $name', style: listViewTextStyle),
                      Text('Subject               : $subject',
                          style: listViewTextStyle),
                      Text('Topic                   : $task',
                          style: listViewTextStyle),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          if (image.isNotEmpty)
            SizedBox(
              height: 400,
              width: 400,
              child: Image.network(
                image,
                loadingBuilder: (BuildContext context, Widget child,
                    ImageChunkEvent? loadingProgress) {
                  if (loadingProgress == null) {
                    return child;
                  } else {
                    return Center(
                      child: CircularProgressIndicator(
                        value: loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                (loadingProgress.expectedTotalBytes ?? 1)
                            : null,
                      ),
                    );
                  }
                },
              ),
            )
          else
            const SizedBox(),
          const SizedBox(height: 30),
          if (image.isEmpty)
            const SizedBox(
              height: 200,
              width: 200,
              child: Center(child: Text('No file submitted')),
            ),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text('Note : $note', style: listViewTextStyle),
          ),
        ],
      ),
    );
  }
}
