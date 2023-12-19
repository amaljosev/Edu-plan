import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/models/class_model.dart';
import 'package:eduplanapp/models/fee_model.dart';
import 'package:eduplanapp/models/student_model.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/repositories/utils/snakebar_messages.dart';
import 'package:eduplanapp/screens/teacher/controllers/teacherBloc1/teacher_bloc.dart';
import 'package:eduplanapp/screens/teacher/form/newstudent_form.dart';
import 'package:eduplanapp/screens/widgets/text_field_widget.dart';
import '../../../../repositories/core/textstyle.dart';

class TextFieldTilesWidgetAddStudent extends StatelessWidget {
  const TextFieldTilesWidgetAddStudent({
    super.key,
    required this.widget,
    required this.studentFormKey,
    required this.teacher,
    required this.standard,
    required this.studentId,
    required this.gender,
    required this.isTeacher,
    required this.division,
  });

  final ScreenStudentForm widget;
  final GlobalKey<FormState> studentFormKey;
  final String teacher;
  final String standard;
  final String? studentId;
  final Gender? gender;
  final bool isTeacher;
  final String division;

  @override
  Widget build(BuildContext context) {
    final String id = widget.isUpdate ? widget.studentId as String : '';

    gender ?? Gender.female;

    return ListView(
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      padding: const EdgeInsets.all(18),
      children: [
        const SizedBox(
          height: 20,
        ),
        Row(
          children: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context
                      .read<TeacherBloc>()
                      .add(BottomNavigationEvent(currentPageIndex: 0));
                },
                icon: const Icon(Icons.arrow_back)),
            Padding(
              padding: const EdgeInsets.only(left: 50.0),
              child: Center(
                  child: Text(
                      widget.isUpdate
                          ? 'Update Student Details'
                          : 'Add Student to Class',
                      style: const TextStyle(
                          color: headingColor,
                          fontSize: 20,
                          fontWeight: FontWeight.w300))),
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        const CircleAvatar(
          backgroundColor: headingColor,
          radius: 60,
          child: CircleAvatar(
            radius: 55,
            backgroundImage: AssetImage('lib/assets/images/student female.png'),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        SignUpTextFieldWidget(
            icon: const Icon(Icons.person_outline_rounded, color: headingColor),
            fillColor: appbarColor,
            hintText: 'First Name',
            controller: firstNameController,
            keyboardType: TextInputType.name,
            length: null,
            obscureText: false),
        const SizedBox(
          height: 20,
        ),
        SignUpTextFieldWidget(
            icon:
                const Icon(Icons.person_add_alt_outlined, color: headingColor),
            fillColor: appbarColor,
            hintText: 'Second Name',
            controller: secondNameController,
            keyboardType: TextInputType.name,
            length: null,
            obscureText: false),
        const SizedBox(
          height: 20,
        ),
        isTeacher
            ? SignUpTextFieldWidget(
                icon: const Icon(Icons.format_list_numbered_rounded,
                    color: headingColor),
                fillColor: appbarColor,
                hintText: 'Roll No',
                controller: rollNoController,
                keyboardType: TextInputType.number,
                length: 2,
                obscureText: false)
            : const Row(),
        SignUpTextFieldWidget(
            icon: const Icon(Icons.av_timer_rounded, color: headingColor),
            fillColor: appbarColor,
            hintText: 'Age',
            controller: ageController,
            keyboardType: TextInputType.number,
            length: 2,
            obscureText: false),
        isTeacher
            ? SignUpTextFieldWidget(
                icon: const Icon(Icons.list, color: headingColor),
                fillColor: appbarColor,
                hintText: 'Register No',
                controller: registrationNumberController,
                keyboardType: TextInputType.number,
                length: 6,
                obscureText: false)
            : const Row(),
        widget.isUpdate
            ? const Row()
            : SignUpTextFieldWidget(
                icon:
                    const Icon(Icons.mail_outline_rounded, color: headingColor),
                fillColor: appbarColor,
                hintText: 'Email',
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                length: null,
                obscureText: false),
        SizedBox(
          height: widget.isUpdate ? 0 : 20,
        ),
        SignUpTextFieldWidget(
            icon: const Icon(Icons.phone_iphone_rounded, color: headingColor),
            fillColor: appbarColor,
            hintText: 'Contact Number',
            controller: contactController,
            keyboardType: TextInputType.number,
            length: 10,
            obscureText: false),
        const SizedBox(
          height: 5,
        ),
        SignUpTextFieldWidget(
            icon: const Icon(Icons.people_outline, color: headingColor),
            fillColor: appbarColor,
            hintText: "Guardian's Name",
            controller: guardianNameController,
            keyboardType: TextInputType.name,
            length: null,
            obscureText: false),
        SizedBox(
          height: widget.isUpdate ? 0 : 20,
        ),
        widget.isUpdate
            ? const SizedBox()
            : SignUpTextFieldWidget(
                icon:
                    const Icon(Icons.lock_outline_rounded, color: headingColor),
                fillColor: appbarColor,
                hintText: 'Password',
                controller: passwordController,
                keyboardType: TextInputType.emailAddress,
                length: null,
                obscureText: true),
        const SizedBox(
          height: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                Text(
                  'Gender',
                  style: titleTextStyle,
                ),
                Row(
                  children: [
                    Radio<Gender>(
                      value: Gender.female,
                      groupValue: gender,
                      onChanged: (Gender? value) => context
                          .read<TeacherBloc>()
                          .add(RadioButtonEvent(gender: value)),
                    ),
                    const Text('Female'),
                    Radio<Gender>(
                      value: Gender.male,
                      groupValue: gender,
                      onChanged: (Gender? value) => context
                          .read<TeacherBloc>()
                          .add(RadioButtonEvent(gender: value)),
                    ),
                    const Text('Male'),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(
          height: 20,
        ),
        ElevatedButton(
          onPressed: () {
            if (studentFormKey.currentState!.validate()) {
              if (!isValidEmail(emailController.text)) {
                AlertMessages().alertMessageSnakebar(
                    context, 'Please check your email is correct', Colors.red);
                return;
              }
              if (contactController.text.length < 10) {
                AlertMessages().alertMessageSnakebar(
                    context, 'Enter minimum 10 numbers in contact', Colors.red);
                return;
              }
              if (passwordController.text.length < 8) {
                AlertMessages().alertMessageSnakebar(context,
                    'Enter minimum 8 charecters in password', Colors.red);
                return;
              } else {
                onButtonTap(
                    id: id,
                    isUpdate: widget.isUpdate,
                    context: context,
                    teacher: teacher,
                    standard: standard,
                    gender: gender,
                    isTeacher: widget.isTeacher,
                    division: division);
              }
            }
          },
          style: ElevatedButton.styleFrom(
              backgroundColor: buttonColor,
              shape: const ContinuousRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(15)),
              ),
              fixedSize: const Size(150, 50),
              elevation: 10),
          child: Text(
            widget.isUpdate ? 'Update' : 'Submit',
            style: const TextStyle(color: whiteTextColor),
          ),
        ),
        const SizedBox(
          height: 20,
        ),
      ],
    );
  }
}

void onButtonTap(
    {required bool isUpdate,
    required BuildContext context,
    required String teacher,
    required String standard,
    required String division,
    required String id,
    required Gender? gender,
    required isTeacher}) {
  final studentObject = StudentModel(
    firstName: firstNameController.text.trim(),
    secondName: secondNameController.text.trim(),
    classTeacher: teacher.trim(),
    rollNo: rollNoController.text.trim(),
    age: ageController.text.trim(),
    registerNo: registrationNumberController.text.trim(),
    email: emailController.text.trim(),
    contactNo: contactController.text.trim(),
    guardianName: guardianNameController.text.trim(),
    password: passwordController.text.trim(),
    gender: gender.toString(),
    standard: standard,
    division: division,
    totalAbsent: 0,
    totalPresent: 0,
  );
  if (gender == Gender.male) {
    totalBoys += 1;
  } else {
    totalGirls += 1;
  }
  final classObject = ClassModel(
      totalStudents: totalStrength += 1,
      totalBoys: totalBoys,
      totalGirls: totalGirls,
      classTeacher: teacher,
      standard: standard);

  final feeObject = FeeModel(totalAmount: 0, amountPayed: 0, amountPending: 0);

  if (isTeacher) {
    isUpdate
        ? context.read<TeacherBloc>().add(
            UpdateStudentDataEvent(studentData: studentObject, studentId: id))
        : context.read<TeacherBloc>().add(AddStudentEvent(
            studentData: studentObject,
            classDatas: classObject,
            feeData: feeObject));
  }

  firstNameController.text = '';
  secondNameController.text = '';
  rollNoController.text = '';
  guardianNameController.text = '';
  ageController.text = '';
  registrationNumberController.text = '';
  emailController.text = '';
  contactController.text = '';
  passwordController.text = '';
}

bool isValidEmail(String email) {
  // Define a regular expression for basic email validation
  // This is a simple example and may not cover all edge cases
  RegExp emailRegExp =
      RegExp(r'^[a-zA-Z0-9._-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  return emailRegExp.hasMatch(email);
}
