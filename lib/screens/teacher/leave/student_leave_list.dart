import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';

class ScreenLeaveApplications extends StatefulWidget {
  const ScreenLeaveApplications({super.key});

  @override
  State<ScreenLeaveApplications> createState() =>
      _ScreenLeaveApplicationsState();
}

class _ScreenLeaveApplicationsState extends State<ScreenLeaveApplications> {
  Stream<QuerySnapshot<Object?>> leaveListStream = const Stream.empty();
  @override
  void initState() {
    context.read<TeacherSecondBloc>().add(FetchLeaveApplicationsEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherSecondBloc, TeacherSecondState>(
      listener: (context, state) {
        if (state is FetchLeaveApplicationsLoadingState) {
          const CircularProgressIndicator();
        } else if (state is FetchLeaveApplicationsErrorState) {
          AlertMessages()
              .alertMessageSnakebar(context, 'Please Try again', Colors.red);
        } else if (state is FetchLeaveApplicationsSuccessDatas) {
          leaveListStream = state.leaveData;
        }
      },
      builder: (context, state) {
        return StreamBuilder<QuerySnapshot<Object?>>(
            stream: leaveListStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const SizedBox(
                    child: Center(child: CircularProgressIndicator()));
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<DocumentSnapshot> applications = snapshot.data!.docs;
                applications.sort((a, b) {
                  DateTime dateA = (a['date'] as Timestamp).toDate();
                  DateTime dateB = (b['date'] as Timestamp).toDate();
                  return dateB.compareTo(dateA);
                });
                return Scaffold(
                  appBar: myAppbar('Leave Applications'),
                  body: Padding(
                    padding: const EdgeInsets.only(top: 8.0, left: 5, right: 5),
                    child: ListView.builder(
                        itemBuilder: (context, index) {
                          DocumentSnapshot application = applications[index];
                          DateTime date =
                              (application['date'] as Timestamp).toDate();
                          String formattedDate =
                              DateFormat('dd MMM yyyy').format(date);
                          String name = '${application['name']}';
                          String absentDate = '${application['absent_date']}';
                          String reason = '${application['reason']}';
                          return Card(
                            color: appbarColor,
                            child: ListTile(
                              title: Text(name,
                                  style: const TextStyle(
                                    fontSize: 20,
                                          color: contentColor,
                                          fontWeight: FontWeight.bold)),  
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Date of absent : $absentDate', 
                                      style: const TextStyle(

                                          color: contentColor,
                                          fontWeight: FontWeight.bold)),
                                  Text('Reason : $reason', 
                                      style: const TextStyle(
                                        fontSize: 17, 
                                        color: contentColor, 
                                      )),  
                                ],
                              ),
                              trailing: Text(formattedDate),
                            ),
                          );
                        },
                        itemCount: applications.length),
                  ),
                );
              } else {
                return const Text('Something went wrong Try again');
              }
            });
      },
    );
  }
}
