import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/screens/student/bloc/student_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:eduplanapp/screens/widgets/application_form.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';

class ScreenSchoolEvents extends StatefulWidget {
  const ScreenSchoolEvents(
      {super.key, required this.isTeacher, required this.name});
  final bool isTeacher;
  final String name;
  @override
  State<ScreenSchoolEvents> createState() => _ScreenSchoolEventsState();
}

class _ScreenSchoolEventsState extends State<ScreenSchoolEvents> {
  Stream<QuerySnapshot<Object?>> formStream = const Stream.empty();

  @override
  void initState() {
    context
        .read<TeacherSecondBloc>()
        .add(FetchFormDatasEvent(isTeacher: widget.isTeacher));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (didPop) async {
        if (!didPop) {
          context.read<StudentBloc>().add(
                        StudentBottomNavigationEvent(currentPageIndex: 0)); 
        }
      },
      child: BlocConsumer<TeacherSecondBloc, TeacherSecondState>(
          listener: (context, state) {
        if (state is FetchFormDatasLoadingState) {
          const CircularProgressIndicator();
        } else if (state is FetchFormDatasSuccessDatas) {
          formStream = state.formData;
        } else if (state is FetchFormDatasErrorState) {
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
            stream: formStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<DocumentSnapshot> formDatas = snapshot.data!.docs;
                formDatas.sort((a, b) {
                  DateTime dateA = (a['date'] as Timestamp).toDate();
                  DateTime dateB = (b['date'] as Timestamp).toDate();
                  return dateB.compareTo(dateA);
                });
      
                return Scaffold(
                    appBar: widget.isTeacher ? myAppbar('Upcoming Events') : null,
                    body: SafeArea(
                      child: Column(
                        children: [
                          ApplicationWidget(
                              isTeacher: widget.isTeacher, name: widget.name),
                          Expanded(
                              child: SizedBox(
                            height: MediaQuery.of(context).size.height * 0.5,
                            child: ListView.builder(
                                padding: const EdgeInsets.only(
                                    top: 10, left: 5, right: 5),
                                itemBuilder: (context, index) {
                                  DocumentSnapshot data = formDatas[index];
                                  final String eventId = data.id;
                                  String name = '';
                                  if (widget.isTeacher == false) {
                                    name = '${data['name']}';
                                  }
      
                                  DateTime date =
                                      (data['date'] as Timestamp).toDate();
                                  String formattedDate =
                                      DateFormat('dd MMM yyyy').format(date);
                                  String title =
                                      '${data[widget.isTeacher ? 'title' : 'absent_date']}';
                                  String topic =
                                      '${data[widget.isTeacher ? 'topic' : 'reason']}';
      
                                  return Card(
                                    color: appbarColor,
                                    child: ListTile(
                                      title:
                                          Text(title, style: listViewTextStyle),
                                      subtitle: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          widget.isTeacher
                                              ? const SizedBox()
                                              : Text(
                                                  name,
                                                  style: const TextStyle(
                                                      color: contentColor,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                          Text(
                                            topic,
                                            style: const TextStyle(
                                                color: contentColor),
                                          ),
                                        ],
                                      ),
                                      trailing: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          GestureDetector(
                                            onTap: () => context
                                                .read<TeacherSecondBloc>()
                                                .add(EventDeleteEvent(
                                                    reason: widget.isTeacher
                                                        ? ''
                                                        : topic,
                                                    studentName: widget.isTeacher
                                                        ? ''
                                                        : name,
                                                    eventId: eventId,
                                                    isTeacher: widget.isTeacher)),
                                            child: Icon(
                                              Icons.close,
                                              color: buttonColor,
                                            ),
                                          ),
                                          Text(
                                            formattedDate,
                                            style: const TextStyle(
                                                color: contentColor),
                                          ),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                                itemCount: formDatas.length),
                          )),
                        ],
                      ),
                    ));
              } else {
                return SizedBox(
                    child: Center(child: Text('Error: ${snapshot.error}')));
              }
            });
      }),
    );
  }
}
