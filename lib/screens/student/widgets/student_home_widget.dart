import 'package:flutter/material.dart';
import 'package:eduplanapp/repositories/core/colors.dart';
import 'package:eduplanapp/screens/student/widgets/student_fee_widget.dart';
import 'package:eduplanapp/screens/teacher/profile/widgets/student_details_widget.dart';

class StudentHomeWidget extends StatelessWidget {
  const StudentHomeWidget({
    super.key,
    required this.studentId,
    required this.students, 
  });
  final String studentId;
  final Map<String, dynamic> students;
  @override
  Widget build(BuildContext context) {
    final gender = students['gender'];
    return ListView(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: CircleAvatar(
            backgroundColor: headingColor,
            radius: 60,
            child: CircleAvatar(
              radius: 55,
              backgroundImage: AssetImage(gender == 'Gender.male'
                  ? 'lib/assets/images/student male.jpg'
                  : 'lib/assets/images/student female.png'),
            ),
          ),
        ),
        StudentDetailsWidget(
          isTeacher: false,
          studentId: studentId,
          students: students,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Column(
              children: [
                StudentActionWidget(
                    name: 'Home Works',
                    index: 0,
                    assetPath: "lib/assets/images/hw.png",
                    studentsMap: students),
                const SizedBox(
                  height: 20,
                ),
                StudentActionWidget(
                    name: 'Fee Details',
                    index: 1,
                    assetPath: "lib/assets/images/fee.webp",
                    studentsMap: students),
              ],
            ),
            Column(
              children: [
                StudentActionWidget(
                    name: 'Assignments',
                    index: 2,
                    assetPath: "lib/assets/images/assgnment.webp",
                    studentsMap: students),
                const SizedBox(
                  height: 20,
                ),
                StudentActionWidget( 
                    name: 'Attendance',
                    index: 3,
                    assetPath: "lib/assets/images/s_attendace.webp",
                    studentsMap: students),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
