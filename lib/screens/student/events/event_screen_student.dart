import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/student/bloc/student_bloc.dart';

class ScreenEventsStudent extends StatefulWidget {
  const ScreenEventsStudent({super.key});

  @override
  State<ScreenEventsStudent> createState() => _ScreenEventsStudentState();
}

class _ScreenEventsStudentState extends State<ScreenEventsStudent> {
  Stream<QuerySnapshot<Object?>> eventsListStream = const Stream.empty();
  @override
  void initState() {
    context.read<StudentBloc>().add(FetchEventsDataEvent());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<StudentBloc, StudentState>(
      listener: (context, state) {
        if (state is FetchEventsDatasLoadingState) {
          const CircularProgressIndicator();
        } else if (state is FetchEventsDatasErrorState) {
          AlertMessages()
              .alertMessageSnakebar(context, 'Please Try again', Colors.red);
        } else if (state is FetchEventsDatasSuccessDatas) {
          eventsListStream = state.eventsData;
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: StreamBuilder<QuerySnapshot<Object?>>(
              stream: eventsListStream,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                      child: Center(child: CircularProgressIndicator()));
                } else if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                } else if (snapshot.hasData) {
                  List<DocumentSnapshot> events = snapshot.data!.docs;
                  events.sort((a, b) {
                    DateTime dateA = (a['date'] as Timestamp).toDate();
                    DateTime dateB = (b['date'] as Timestamp).toDate();
                    return dateB.compareTo(dateA);
                  });
                  return ListView.builder(
                      padding:
                          const EdgeInsets.only(top: 10, left: 5, right: 5),
                      itemBuilder: (context, index) {
                        DocumentSnapshot data = events[index];
                        DateTime date = (data['date'] as Timestamp).toDate();
                        String formattedDate =
                            DateFormat('dd MMM yyyy').format(date);
                        String title = '${data['title']}';
                        String topic = '${data['topic']}';
                        return Card(
                          color: appbarColor,
                          child: ListTile(
                            title: Text(title, style: listViewTextStyle),
                            subtitle: Text(
                              topic,
                              style: const TextStyle(color: contentColor),
                            ),
                            trailing: Text(
                              formattedDate,
                              style: const TextStyle(color: contentColor),
                            ),
                          ),
                        );
                      },
                      itemCount: events.length);
                } else {
                  return const Text('Something went wrong Try again');
                }
              }),
        );
      },
    );
  }
}
