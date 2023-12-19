import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:eduplanapp/screens/teacher/tasks/widgets/tasklist_widget.dart';

class ScreenWorks extends StatefulWidget {
  const ScreenWorks({super.key, required this.workName});
  final String workName;

  @override
  State<ScreenWorks> createState() => _ScreenWorksState();
}

bool isHw = false;

class _ScreenWorksState extends State<ScreenWorks> {
  Stream<QuerySnapshot<Object?>> taskListStream = const Stream.empty();
  Stream<QuerySnapshot<Object?>> submittedTaskListStream = const Stream.empty();

  @override
  void initState() {
    isHw = widget.workName == 'Home Works' ? true : false;
    context
        .read<TeacherSecondBloc>()
        .add(FetchTaskDatasEvent(isHw: isHw, isTeacher: true));
    super.initState();
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
      if (state is DeleteEventLoadingState) {
        const CircularProgressIndicator();
      } else if (state is DeleteEventSuccessState) {
        AlertMessages().alertMessageSnakebar(context, 'Deleted', Colors.green);
      } else if (state is DeleteEventErrorState) {
        AlertMessages()
            .alertMessageSnakebar(context, 'Please try again', Colors.red);
      }
    }, builder: (context, state) {
      return StreamBuilder<QuerySnapshot<Object?>>(
        stream: taskListStream,
        builder: (context, snapshot) {
          return StreamBuilder(
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
                      title: Text(widget.workName, style: appbarTextStyle),
                      bottom: TabBar(
                        tabs: <Widget>[
                          Tab(
                            text: 'Given ${widget.workName}',
                          ),
                          Tab(
                            text: 'Submitted ${widget.workName}',
                          ),
                        ],
                      ),
                    ),
                    body: TabBarView(
                      children: <Widget>[
                        TaskListWidgetTeacher(
                            tasks: tasks, widget: widget, isSubmitted: false),
                        TaskListWidgetTeacher(
                            tasks: submittedTasks,
                            widget: widget,
                            isSubmitted: true),
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
        },
      );
    });
  }
}
