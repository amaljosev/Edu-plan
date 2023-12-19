
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/screens/student/bloc/student_bloc.dart';
import 'package:eduplanapp/screens/student/tasks/student_tasks_screen.dart';
import 'package:eduplanapp/screens/student/tasks/submit_task_screen.dart';
import 'package:eduplanapp/screens/student/tasks/widgets/submitted_tast_screen.dart';

class TaskListWidget extends StatelessWidget {
  const TaskListWidget({
    super.key,
    required this.tasks,
    required this.widget,
    required this.name,
    required this.isSubmitted,
  });

  final List<DocumentSnapshot<Object?>> tasks;
  final ScreenStudentTasks widget;
  final String name;
  final bool isSubmitted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 10.0,
        left: 5.0,
        right: 5.0,
      ),
      child: SizedBox(
        child: ListView(
          children: List.generate(tasks.length, (index) {
            if (tasks.isEmpty) {
              return Text('Given ${widget.taskName} are list here');
            } else {
              DocumentSnapshot work = tasks[index];
              final String note = isSubmitted ? "${work['note']}" : '';
              final String taskId = work.id;
              DateTime date = (work['date'] as Timestamp).toDate();
              String formattedDate = DateFormat('dd MMM yyyy').format(date);

              String topic =
                  isSubmitted ? '${work['note']}' : '${work['task']}';
              String subject = '${work['subject']}';
              String assignmentDeadline = '';
              DateTime deadLineDate = DateTime.now();
              if (isHw == false && isSubmitted == false) {
                deadLineDate = (work['deadline'] as Timestamp).toDate();
                assignmentDeadline = DateFormat('dd MMM yyyy').format(deadLineDate); 
               
              }

              return Slidable(
                  endActionPane: isSubmitted
                      ? ActionPane(motion: const StretchMotion(), children: [
                          SlidableAction(
                            onPressed: (context) => context
                                .read<StudentBloc>()
                                .add(DeleteTaskEvent(
                                    taskId: taskId,
                                    isHw: isHw,
                                    note: note,
                                    studentName: name)),
                            backgroundColor: Colors.red,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            icon: Icons.delete,
                          ),
                        ])
                      : null,
                  child: Card(
                      child: ListTile(
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                  isHw
                                      ? formattedDate
                                      : isSubmitted
                                          ? ''
                                          : "Started on : $formattedDate",
                                  style: const TextStyle(color: contentColor)),
                              Text(
                                  isHw
                                      ? ""
                                      : isSubmitted
                                          ? "subimtted on : $formattedDate"
                                          : "Deadline : $assignmentDeadline",
                                  style: TextStyle(
                                      color: isSubmitted
                                          ? Colors.green
                                          : Colors.red)),
                              Text(
                                isSubmitted
                                    ? ''
                                    : isHw
                                        ? "Tap to Submit"
                                        : DateTime.now().isBefore(deadLineDate)
                                            ? "Tap to Submit >"
                                            : DateTime.now().day ==
                                                        deadLineDate.day &&
                                                    DateTime.now().month ==
                                                        deadLineDate.month &&
                                                    DateTime.now().year ==
                                                        deadLineDate.year
                                                ? "Tap to Submit"
                                                : '',
                                style: TextStyle(
                                    color: Colors.green.shade900, fontSize: 15),
                              ),
                            ],
                          ),
                          title: Text(
                            topic,
                            style: listViewTextStyle,
                          ),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                subject,
                                style: const TextStyle(color: contentColor),
                              ),
                            ],
                          ),
                          onTap: () {
                            isHw
                                ? !isSubmitted
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ScreenSubmitTask(
                                            topic: topic,
                                            subject: subject,
                                            widget: widget,
                                            name: name,
                                          ),
                                        ),
                                      )
                                    : Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ScreenSubmittedTaskStudent(
                                                  isTeacher: false,
                                                  name: note,
                                                  subject: subject,
                                                  taskName: widget.taskName,
                                                  note: work['note'],
                                                  files: work['image_url'],
                                                  task: widget.taskName),
                                        ),
                                      )
                                : null;
                            !isSubmitted &&
                                    DateTime.now().isBefore(deadLineDate)
                                ? Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) => ScreenSubmitTask(
                                        topic: topic,
                                        subject: subject,
                                        widget: widget,
                                        name: name,
                                      ),
                                    ),
                                  )
                                : !isHw&&isSubmitted 
                                    ? Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              ScreenSubmittedTaskStudent( 
                                                  isTeacher: false,
                                                  name: name,
                                                  subject: subject,
                                                  taskName: widget.taskName,
                                                  note: work['note'],
                                                  files: work['image_url'],
                                                  task: widget.taskName),
                                        ),
                                      )
                                    : null;
                          })));
            }
          }),
        ),
      ),
    );
  }
}
