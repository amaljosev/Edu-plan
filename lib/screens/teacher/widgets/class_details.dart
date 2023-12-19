import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/constants.dart';
import 'package:eduplanapp/repositories/core/loading.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/attendence/attendence_screen.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc1/teacher_bloc.dart';

Map<String, dynamic>? classDatasGlobel = {};

class ClassDetailsWidget extends StatefulWidget {
  const ClassDetailsWidget({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  State<ClassDetailsWidget> createState() => _ClassDetailsWidgetState();
}

class _ClassDetailsWidgetState extends State<ClassDetailsWidget> {
  bool isVisitedToday = false;
  Stream<QuerySnapshot<Object?>> classDatas = const Stream.empty();
  Stream<QuerySnapshot<Object?>> attendenceData = const Stream.empty();
  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(FetchClassDetailsEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherBloc, TeacherState>(
      listenWhen: (previous, current) => current is TeacherActionState,
      buildWhen: (previous, current) => current is! TeacherActionState,
      listener: (context, state) {
        if (state is AttendenceState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) =>
                    ScreenAttendence(isVisited: state.isVisited),
              ));
        }
        if (state is FetchClassDetailsLoadingState) {
          LoadingWidget().classDataLoadingShimmer();
        }
        if (state is FetchClassDetailsErrorState) {
          AlertMessages().alertMessageSnakebar(
              context, 'Something went wrong', Colors.red);
        }
        if (state is FetchClassDetailsState) {
          classDatas = state.classDatas;
          attendenceData = state.todayAttendenceData;
        }
        if (state is SameDateState) {
          isVisitedToday = state.isVisited;
        }
      },
      builder: (context, state) {
        return StreamBuilder<QuerySnapshot>(
            stream: classDatas,
            builder: (context, classSnapshot) {
              return StreamBuilder<QuerySnapshot>(
                stream: attendenceData,
                builder: (context, attendanceSnapshot) {
                  if (classSnapshot.connectionState ==
                          ConnectionState.waiting ||
                      attendanceSnapshot.connectionState ==
                          ConnectionState.waiting) {
                    return LoadingWidget().classDataLoadingShimmer();
                  } else if (classSnapshot.hasError ||
                      attendanceSnapshot.hasError) {
                    return Text('Error: ${classSnapshot.error}');
                  } else if (classSnapshot.hasData &&
                      attendanceSnapshot.hasData) {
                    List<QueryDocumentSnapshot> documents =
                        classSnapshot.data!.docs;
                    QueryDocumentSnapshot document = documents.first;
                    Map<String, dynamic>? data =
                        document.data() as Map<String, dynamic>;
                    classDatasGlobel = data;
                    List<QueryDocumentSnapshot> attendanceDocuments =
                        attendanceSnapshot.data!.docs;
                    QueryDocumentSnapshot attendanceDoc =
                        attendanceDocuments.first;
                    Map<String, dynamic>? attendanceData =
                        attendanceDoc.data() as Map<String, dynamic>;
                    return Center(
                      child: Container(
                        height: 200,
                        width: widget.size.width * 0.97,
                        decoration: BoxDecoration(
                            color: appbarColor,
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10))),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                right: 8.0,
                                left: 20.0,
                              ),
                              child: Row(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      kHeight,
                                      Text(
                                        "class  ${data['standard']}:${data['division']}",
                                        style: appbarTextStyle,
                                      ),
                                      Text(
                                        'Class Strength ',
                                        style: contentTextStyle,
                                      ),
                                      kHeight,
                                      Text(
                                        'Boys ',
                                        style: contentTextStyle,
                                      ),
                                      kHeight,
                                      Text(
                                        'Girls ',
                                        style: contentTextStyle,
                                      ),
                                      Text(
                                        'Today Presents ',
                                        style: contentTextStyle,
                                      ),
                                      kHeight,
                                      Text(
                                        'Today Absents ',
                                        style: contentTextStyle,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      kHeight,
                                      Text(
                                        '',
                                        style: contentTextStyle,
                                      ),
                                      kHeight,
                                      Text(
                                        ': ${data['total_students']}',
                                        style: contentTextStyle,
                                      ),
                                      kHeight,
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 3.0),
                                        child: Text(
                                          ': ${data['total_boys']}',
                                          style: contentTextStyle,
                                        ),
                                      ),
                                      Text(
                                        ': ${data['total_girls']}',
                                        style: contentTextStyle,
                                      ),
                                      kHeight,
                                      Text(
                                        isVisitedToday
                                            ? ': ${attendanceData['total_presents']}'
                                            : ': 0',
                                        style: contentTextStyle,
                                      ),
                                      kHeight,
                                      Text(
                                        isVisitedToday
                                            ? ': ${attendanceData['total_absents']}'
                                            : ': 0',
                                        style: contentTextStyle,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              child: Container(
                                decoration: const BoxDecoration(
                                  image: DecorationImage(
                                    image: AssetImage(
                                        "lib/assets/images/calender_bg.png"),
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 30),
                                      child: ElevatedButton(
                                          onPressed: () => context
                                              .read<TeacherBloc>()
                                              .add(AttendenceEvent(
                                                  isVisited: isVisitedToday)),
                                          child: Text(isVisitedToday
                                              ? 'Update Attendance'
                                              : 'Take Attendence')),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return const SizedBox(
                      child: Center(child: Text('Something went wrong')),
                    );
                  }
                },
              );
            });
      },
    );
  }
}
