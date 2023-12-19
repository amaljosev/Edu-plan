import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';

class AttendenceHistoryWidget extends StatefulWidget {
  const AttendenceHistoryWidget({
    super.key,
  });

  @override
  State<AttendenceHistoryWidget> createState() =>
      _AttendenceHistoryWidgetState();
}

class _AttendenceHistoryWidgetState extends State<AttendenceHistoryWidget> {
  Stream<QuerySnapshot<Object?>> attendenceData = const Stream.empty();
  @override
  void initState() {
    super.initState();
    context.read<TeacherSecondBloc>().add(FetchAttendanceHistoryEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherSecondBloc, TeacherSecondState>(
      listener: (context, state) {
        if (state is FetchAttendanceHistorySuccessState) {
          attendenceData = state.attendenceHistory;
        } else if (state is FetchAttendanceHistoryLoadingState) {
          const SizedBox(
            child: Center(child: CircularProgressIndicator()),
          );
        } else if (state is FetchAttendanceHistoryErrorState) {
          const SizedBox(
            child: Center(child: Text('Try Again')),
          );
        }
      },
      builder: (context, state) {
        return StreamBuilder<QuerySnapshot>(
            stream: attendenceData,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<DocumentSnapshot> attendanceHistory = snapshot.data!.docs;
                attendanceHistory.sort((a, b) {
                  DateTime dateA = (a['date'] as Timestamp).toDate();
                  DateTime dateB = (b['date'] as Timestamp).toDate();
                  return dateB.compareTo(
                      dateA); 
                });
                if (attendanceHistory.isNotEmpty) {
                  return ListView.separated(
                    itemBuilder: (context, index) {
                      DocumentSnapshot attendance = attendanceHistory[index];
                      DateTime date =
                          (attendance['date'] as Timestamp).toDate();
                      String formattedDate =
                          DateFormat('dd MMM yyyy, E').format(date);
                      return ListTile(
                        leading: Text(
                          "${index + 1}",
                          style: listViewTextStyle,
                        ),
                        title: Text(
                          "$formattedDate",
                          style: listViewTextStyle,
                        ),
                        trailing: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              "Total Presents : ${attendance['total_presents']}",
                              style: listViewTextStyle,
                            ),
                            Text(
                              "Total Absents : ${attendance['total_absents']}",
                              style: listViewTextStyle,
                            ),
                          ],
                        ),
                      );
                    },
                    separatorBuilder: (context, index) => const Divider(),
                    itemCount: attendanceHistory.length);
                } else {
                 return const SizedBox(child: Center(child: Text('Attendance History')),);  
                }
              } else {
                return const SizedBox(
                    child: Center(child: Text('Something went wrong')));
              }
            });
      },
    );
  }
}
