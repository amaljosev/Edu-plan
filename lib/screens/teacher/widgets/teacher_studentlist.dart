import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/loading.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc1/teacher_bloc.dart';
import 'package:eduplanapp/screens/teacher/form/newstudent_form.dart';
import 'package:eduplanapp/screens/teacher/profile/student_profile.dart';

class TeacherStudentsList extends StatefulWidget {
  const TeacherStudentsList({
    super.key,
  });

  @override
  State<TeacherStudentsList> createState() => _TeacherStudentsListState();
}

class _TeacherStudentsListState extends State<TeacherStudentsList> {
  late Stream<QuerySnapshot<Object?>> studentDatasStream = const Stream.empty();
  @override
  void initState() {
    super.initState();
    context.read<TeacherBloc>().add(FetchStudentDatasEvent());
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is FetchStudentDataSuccessState) {
          studentDatasStream = state.studetDatas;
        } else if (state is FetchAllStudentsLoadingState) {
          const CircularProgressIndicator();
        } else if (state is FetchAllStudentsErrorState) {
          AlertMessages().alertMessageSnakebar(
              context, 'Something went wrong', Colors.red);
        }
        if (state is FormStudentState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ScreenStudentForm(
                    isUpdate: false,
                    students: null,
                    studentId: null,
                    isTeacher: true),
              ));
        }
        if (state is StudentProfileState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenStudentProfileTeacher(
                  totalWorkingDays: state.totalWorkingDays,
                  studentId: state.studentId,
                  studentFee: state.studentFee,
                  studentsMap: state.students,
                ),
              ));
        }
      },
      builder: (context, state) {
        return StreamBuilder(
            stream: studentDatasStream,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return LoadingWidget().studentCircleShimmer();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else if (snapshot.hasData) {
                List<DocumentSnapshot> students = snapshot.data!.docs;
                students.sort((a, b) {
                  String nameA = "${a['first_name']} ${a['second_name']}";
                  String nameB = "${b['first_name']} ${b['second_name']}";
                  return nameA.compareTo(nameB);
                });

                return SizedBox(
                    height: 130,
                    child: Row(
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              GestureDetector(
                                onTap: () => context
                                    .read<TeacherBloc>()
                                    .add(FormStudentEvent()),
                                child: CircleAvatar(
                                  backgroundColor: appbarColor,
                                  radius: 40,
                                  child: const Icon(Icons.add,
                                      size: 40, color: Colors.white),
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Add Student',
                                style: teacherAddStudentTextStyle,
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: ListView.separated(
                            padding: const EdgeInsets.all(8.0),
                            scrollDirection: Axis.horizontal,
                            itemCount: students.length,
                            itemBuilder: (context, index) {
                              var student = students[index].data()
                                  as Map<String, dynamic>;
                              final studentFee = students[index]
                                  .reference
                                  .collection('student_fee');
                              final studentGender = student['gender'];
                              final name = student['first_name'];
                              final String studentId = students[index].id;
                              return Column(
                                children: [
                                  GestureDetector(
                                    onTap: () => context
                                        .read<TeacherBloc>()
                                        .add(StudentProfileEvent(
                                            studentId: studentId,
                                            students: student,
                                            studentFee: studentFee)),
                                    child: CircleAvatar(
                                      backgroundColor: appbarColor,
                                      backgroundImage: AssetImage(studentGender ==
                                              'Gender.male'
                                          ? 'lib/assets/images/student male.jpg'
                                          : 'lib/assets/images/student female.png'),
                                      radius: 40,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    name,
                                    style: teacherAddStudentTextStyle,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const SizedBox(
                              width: 10,
                            ),
                          ),
                        ),
                      ],
                    ));
              } else {
                return const SizedBox(
                  child: Center(child: Text('Data not found')),
                );
              }
            });
      },
    );
  }
}
