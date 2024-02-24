import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/screens/teacher/chat/private_chat.dart';
import 'package:eduplanapp/screens/widgets/my_appbar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc1/teacher_bloc.dart';

TextEditingController searchController = TextEditingController();

class ScreenSearchStudent extends StatelessWidget {
  const ScreenSearchStudent(
      {Key? key, required this.students, required this.isChat})
      : super(key: key);
  final List<DocumentSnapshot<Object?>> students;
  final bool isChat;
  @override
  Widget build(BuildContext context) {
    searchController.text = '';
    return BlocConsumer<TeacherBloc, TeacherState>(
      listener: (context, state) {
        if (state is SearchStudentScreenState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenSearchStudent(
                    students: state.studentList, isChat: isChat),
              ));
        }
      },
      builder: (context, state) {
        String searchContent =
            (state is PerformSearchState) ? state.searchContent : '';

        List<DocumentSnapshot> filteredStudents = students.where((student) {
          final String name =
              "${student['first_name']}${student['second_name']}";
          return name.toLowerCase().startsWith(
                searchContent.toLowerCase(),
              );
        }).toList();

        return Scaffold(
          appBar: myAppbar('Search Student'),
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: SizedBox(
                    height: 55,
                    child: TextFormField(
                      controller: searchController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: appbarColor,
                        prefixIcon: const Icon(CupertinoIcons.search),
                        prefixIconColor: buttonColor,
                        hintText: 'Enter Student Name',
                        suffixIcon: GestureDetector(
                          onTap: () {
                            searchController.clear();
                            context
                                .read<TeacherBloc>()
                                .add(PerformSearchEvent(searchContent: ''));
                          },
                          child: const Icon(CupertinoIcons.clear),
                        ),
                        suffixIconColor: buttonColor,
                        border: const OutlineInputBorder(
                          borderSide: BorderSide.none,
                          borderRadius: BorderRadius.all(Radius.circular(8)),
                        ),
                      ),
                      onChanged: (value) {
                        context
                            .read<TeacherBloc>()
                            .add(PerformSearchEvent(searchContent: value));
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: SizedBox(
                    child: ListView.separated(
                      itemBuilder: (context, index) {
                        var studentMap = filteredStudents[index].data()
                            as Map<String, dynamic>;
                        final studentFee = filteredStudents[index]
                            .reference
                            .collection('student_fee');
                        final String studentId = filteredStudents[index].id;

                        return ListTile(
                          title: Text(
                            "${filteredStudents[index]['first_name']} ${filteredStudents[index]['second_name']}",
                            style: contentTextStyle,
                          ),
                          onTap: () => isChat
                              ? Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => ScreenChatPrivate(
                                      gender: filteredStudents[index]['gender'],
                                      image: filteredStudents[index]
                                                  ['gender'] ==
                                              'Gender.male'
                                          ? 'lib/assets/images/student male.jpg'
                                          : 'lib/assets/images/student female.png',
                                      name:
                                          "${filteredStudents[index]['first_name']} ${filteredStudents[index]['second_name']}",
                                      studentId: studentId,
                                    ),
                                  ))
                              : context.read<TeacherBloc>().add(
                                    StudentProfileEvent(
                                      studentId: studentId,
                                      students: studentMap,
                                      studentFee: studentFee,
                                    ),
                                  ),
                        );
                      },
                      separatorBuilder: (context, index) => const Divider(),
                      itemCount: filteredStudents.length,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
