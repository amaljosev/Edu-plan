import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/core/constants.dart';
import 'package:eduplanapp/repositories/core/textstyle.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc2/teacher_second_bloc.dart';
import 'package:eduplanapp/screens/teacher/form/newstudent_form.dart';
import 'package:url_launcher/url_launcher.dart';

enum Options { edit, delete }

class StudentDetailsWidget extends StatelessWidget {
  const StudentDetailsWidget({
    super.key,
    required this.isTeacher,
    required this.students,
    required this.studentId,
  });
  final bool isTeacher;
  final Map<String, dynamic> students;
  final String studentId;
  @override
  Widget build(BuildContext context) {
    Options options = Options.edit;
    final String studentName =
        "${students['first_name']} ${students['second_name']}";
    final String email = "${students['email']}";
    final String password = "${students['password']}";
    final String gender = "${students['gender']}";
    return BlocConsumer<TeacherSecondBloc, TeacherSecondState>(
      listener: (context, state) {
        if (state is PopupMenuButtonEditState) {
          Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenStudentForm(
                    isUpdate: true,
                    students: students,
                    studentId: studentId,
                    isTeacher: isTeacher),
              ));
        } else if (state is PopupMenuButtonDeleteState) {
          context.read<TeacherSecondBloc>().add(DeleteStudentEvent(
              studentId: studentId,
              email: email,
              password: password,
              gender: gender));
        }
        if (state is DeleteStudentLoadingState) {
          const CircularProgressIndicator();
        } else if (state is DeleteStudentSuccessState) {
          AlertMessages().alertMessageSnakebar(
              context, 'Deleted Student Successfully', Colors.green);
          Navigator.pop(context);
        } else if (state is DeleteStudentErrorState) {
          AlertMessages()
              .alertMessageSnakebar(context, 'Please try again', Colors.red);
          Navigator.pop(context);
        }
      },
      builder: (context, state) {
        return Padding(
          padding: isTeacher
              ? const EdgeInsets.all(8)
              : const EdgeInsets.only(top: 15.0),
          child: Container(
            height: isTeacher ? 280 : 250,
            width: double.infinity,
            decoration: BoxDecoration(
                color: isTeacher ? appbarColor : null,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: isTeacher
                      ? MainAxisAlignment.end
                      : MainAxisAlignment.center,
                  children: [
                    Text(isTeacher ? "" : studentName.toUpperCase(),
                        style: appbarTextStyle),
                    isTeacher
                        ? PopupMenuButton<Options>(
                            initialValue: options,
                            onSelected: (Options item) {
                              context
                                  .read<TeacherSecondBloc>()
                                  .add(PopupMenuButtonEvent(item: item));
                            },
                            itemBuilder: (BuildContext context) =>
                                <PopupMenuEntry<Options>>[
                              const PopupMenuItem<Options>(
                                value: Options.edit,
                                child: Text('Edit'),
                              ),
                              const PopupMenuItem<Options>(
                                value: Options.delete,
                                child: Text('Delete'),
                              ),
                            ],
                          )
                        : const SizedBox()
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("RollNo ", style: studentProfileTextStyle),
                        kHeight,
                        Text('Class Teacher ', style: studentProfileTextStyle),
                        kHeight,
                        Text('Age ', style: studentProfileTextStyle),
                        kHeight,
                        Text('Class ', style: studentProfileTextStyle),
                        kHeight,
                        Text('RegisterNo ', style: studentProfileTextStyle),
                        kHeight,
                        Text('ContactNo ', style: studentProfileTextStyle),
                        kHeight,
                        Text('Guardian Name ', style: studentProfileTextStyle),
                        kHeight,
                        Text('Email ', style: studentProfileTextStyle),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(": ${students['roll_no']}",
                            style: studentProfileTextStyle),
                        kHeight,
                        Text(": ${students['class_Teacher']}",
                            style: studentProfileTextStyle),
                        kHeight,
                        Text(": ${students['age']} ",
                            style: studentProfileTextStyle),
                        kHeight,
                        Text(
                            ": ${students['standard']}-${students['division']}",
                            style: studentProfileTextStyle),
                        kHeight,
                        Text(": ${students['register_no']} ",
                            style: studentProfileTextStyle),
                        kHeight,
                        isTeacher
                            ? GestureDetector(
                                onTap: () async {
                                  final Uri url = Uri(
                                      scheme: 'tel',
                                      path: ": ${students['contact_no']}");
                                  if (await canLaunchUrl(url)) {
                                    await launchUrl(url);
                                  } else {
                                    log("can't call");
                                  }
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      ': ',
                                      style: listViewTextStyle,
                                    ),
                                    Text("${students['contact_no']} ",
                                        style: GoogleFonts.ubuntu(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold,
                                            color: contentColor,
                                            textStyle: const TextStyle(
                                                decoration:
                                                    TextDecoration.underline,
                                                decorationColor:
                                                    contentColor))),
                                  ],
                                ),
                              )
                            : Text(": ${students['contact_no']} ",
                                style: GoogleFonts.ubuntu(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: contentColor,
                                )), 
                        kHeight,
                        Text(": ${students['guardian_name']} ",
                            style: studentProfileTextStyle),
                        kHeight,
                        Text(": ${students['email']} ",
                            style: studentProfileTextStyle),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  } 
}
