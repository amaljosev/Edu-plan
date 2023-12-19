import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/student/tasks/widgets/students_taskslist_widget.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';

class ScreenStudentTasks extends StatefulWidget { 
  const ScreenStudentTasks(
      {super.key, required this.taskName, required this.studentName});
  final String taskName;
  final String studentName;

  @override
  State<ScreenStudentTasks> createState() => _ScreenStudentTasksState();
}

bool isHw = false;

int index = 0;

class _ScreenStudentTasksState extends State<ScreenStudentTasks> {
  Stream<QuerySnapshot<Object?>> taskListStream = const Stream.empty();
  Stream<QuerySnapshot<Object?>> submittedTaskListStream = const Stream.empty();

  @override
  void initState() {
    super.initState();
    isHw = widget.taskName == 'Home Work';
    context.read<TeacherSecondBloc>().add(FetchTaskDatasEvent(isHw: isHw,isTeacher: false));
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherSecondBloc, TeacherSecondState>(
      listener: (context, state) {
        if (state is FetchTaskLoadingDatas) {
          const CircularProgressIndicator();
        } else if (state is FetchTaskSuccessDatas) {
          taskListStream = state.taskData;
          submittedTaskListStream = state.submittedTasks;
        } else if (state is FetchTaskErrorDatas) {
          AlertMessages()
              .alertMessageSnakebar(context, 'Please try again', Colors.red);
        }
      },
      builder: (context, state) {
        return StreamBuilder<QuerySnapshot<Object?>>(
            stream: taskListStream,
            builder: (context, snapshot) {
              return StreamBuilder<QuerySnapshot<Object?>>(
                stream: submittedTaskListStream,
                builder: (context, submittedSnapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting ||
                      submittedSnapshot.connectionState ==
                          ConnectionState.waiting) {
                    return const SizedBox(
                        child: Center(child: CircularProgressIndicator()));
                  } else if (snapshot.hasError || submittedSnapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.hasData && submittedSnapshot.hasData) {
                    List<DocumentSnapshot> tasks = snapshot.data!.docs;
                    List<DocumentSnapshot> submittedTasks =
                        submittedSnapshot.data!.docs;

                    tasks.sort((a, b) {
                      DateTime dateA = (a['date'] as Timestamp).toDate();
                      DateTime dateB = (b['date'] as Timestamp).toDate();
                      return dateB.compareTo(dateA);
                    });
                    submittedTasks.sort((a, b) {
                      DateTime dateA = (a['date'] as Timestamp).toDate();
                      DateTime dateB = (b['date'] as Timestamp).toDate();
                      return dateB.compareTo(dateA);
                    });
                    return DefaultTabController(
                      initialIndex: 0,
                      length: 2,
                      child: Scaffold(
                        appBar: AppBar(
                          backgroundColor: appbarColor,
                          title:
                              Text(widget.taskName, style: appbarTextStyle),
                          bottom: TabBar(
                            tabs: <Widget>[
                              Tab(
                                text: 'Given ${widget.taskName}s',
                              ),
                              Tab(
                                text: 'Submitted ${widget.taskName}s',
                              ),
                            ],
                          ),
                        ),
                        body: TabBarView(
                          children: <Widget>[
                            TaskListWidget(
                                isSubmitted: false,
                                tasks: tasks,
                                widget: widget,
                                name: widget.studentName),
                            TaskListWidget(
                                isSubmitted: true,
                                tasks: submittedTasks,
                                widget: widget,
                                name: widget.studentName),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(
                        child: Center(child: Text('Something went wrong')));
                  }
                },
              );
            });
      },
    );
  }
}
