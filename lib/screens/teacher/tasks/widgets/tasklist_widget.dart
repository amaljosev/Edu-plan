
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:eduplanapp/screens/teacher/tasks/widgets/task_card_widget.dart';
import 'package:eduplanapp/screens/teacher/tasks/works_widget.dart';

class TaskListWidgetTeacher extends StatelessWidget {
  const TaskListWidgetTeacher({
    super.key,
    required this.tasks,
    required this.widget,
    required this.isSubmitted,
  });

  final List<DocumentSnapshot<Object?>> tasks;
  final ScreenWorks widget;
  final bool isSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListView(
        children: List.generate(tasks.length, (index) {
          if (tasks.isEmpty) {  
            return Center(child: Text('${widget.workName} are list here'));  
          } else {
            DocumentSnapshot work = tasks[index];
            final String taskId=work.id;
            DateTime date = (work['date'] as Timestamp).toDate();
            String formattedDate = DateFormat('dd MMM yyyy').format(date);
            String topic = isSubmitted ? '${work['topic']}' : '${work['task']}';
            String subject = '${work['subject']}';
            String name = '';
            List imageList = [];
            String note = '';
            if (isSubmitted) {
              name = '${work['name']}';
              imageList.addAll(work['image_url']);  
              note = '${work['note']}';
            }
            String assignmentDeadline = '';
            if (isHw == false && isSubmitted == false) {
              DateTime date = (work['deadline'] as Timestamp).toDate();
              assignmentDeadline = DateFormat('dd MMM yyyy').format(date);
             
            }

            return TaskCardWidget( 
              isSubmitted: isSubmitted,
              formattedDate: formattedDate,
              task: topic,
              subject: subject,
              deadline: assignmentDeadline,
              isHw: isHw,
              imageList: imageList,
              name: name,
              note: note,taskId: taskId, 
            );
          }
        }),
      ),
    );
  }
}
