import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/screens/student/tasks/widgets/submitted_tast_screen.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import '../../../../repositories/core/textstyle.dart';

class TaskCardWidget extends StatelessWidget {
  const TaskCardWidget(
      {super.key,
      required this.formattedDate,
      required this.task,
      required this.subject,
      required this.deadline,
      required this.isHw,
      required this.name,
      required this.imageList,
      required this.note,
      required this.isSubmitted,
      required this.taskId});

  final String formattedDate;
  final String task;
  final String subject;
  final String deadline;
  final bool isHw;
  final bool isSubmitted;
  final String name;
  final List imageList;
  final String note;
  final String taskId;

  @override
  Widget build(BuildContext context) {
    return Slidable(
      endActionPane: isSubmitted
          ? null
          : ActionPane(motion: const StretchMotion(), children: [
              SlidableAction(
                onPressed: (context) => context
                    .read<TeacherSecondBloc>()
                    .add(TaskDeleteEvent(isHw: isHw, taskId: taskId)),
                backgroundColor: Colors.red,
                icon: Icons.delete,
              )
            ]),
      child: Card(
        child: ListTile(
          trailing: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                  isHw
                      ? "Submitted on : $formattedDate"
                      : isSubmitted
                          ? "Submitted on : $formattedDate"
                          : "Started on : $formattedDate",
                  style: TextStyle(
                      color: isSubmitted ? Colors.green : contentColor)),
              Text(
                  isHw
                      ? isSubmitted
                          ? 'Check Now >'
                          : ""
                      : isSubmitted
                          ? "Check Now >"
                          : "",
                  style: const TextStyle(color: contentColor)),
              isSubmitted
                  ? const SizedBox()
                  : Text(isHw ? "" : "Deadline : $deadline",
                      style: const TextStyle(color: Colors.red)),
            ],
          ),
          title: Text(
            isSubmitted ? name : task,
            style: listViewTextStyle,
          ),
          subtitle: Text(
            subject,
            style: const TextStyle(color: contentColor),
          ),
          onTap: () => isSubmitted
              ? Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ScreenSubmittedTaskStudent(
                        name: name,
                        subject: subject,
                        taskName: isHw?'Home Works':'Assignments',   
                        note: note,
                        files: imageList,
                        isTeacher: true,task: task),
                  ))
              : null,
        ),
      ),
    );
  }
}
