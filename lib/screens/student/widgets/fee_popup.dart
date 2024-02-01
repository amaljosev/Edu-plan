// // ignore_for_file: use_build_context_synchronously

// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:eduplanapp/repositories/firebase/student/db_functions_student.dart';
// import 'package:eduplanapp/repositories/firebase/teacher/db_functions_teacher.dart';
// import 'package:eduplanapp/screens/teacher/profile/widgets/student_feedetails_widget.dart';

// Future<void> feePopupMessage({required BuildContext context}) async {
//   final String? studentId = await DbFunctionsTeacher().getStudentIdFromPrefs();
//   final String? teacherId = await DbFunctionsTeacher().getTeacherIdFromPrefs();
//   CollectionReference<Map<String, dynamic>> studentFee =
//       await DbFunctionsStudent()
//           .getFeeDetails(teacherId as String, studentId as String);
//   return showDialog<void>(
//     context: context,
//     builder: (BuildContext context) {
//       return AlertDialog(
//         actions: <Widget>[
//           StudentFeeDetailsWidget(
//             isTeacher: false,
//             studentFee: studentFee,
//             studentId: studentId,
//           ),
//           TextButton(
//             style: TextButton.styleFrom(
//               textStyle: Theme.of(context).textTheme.labelLarge,
//             ),
//             child: const Text('Discard'),
//             onPressed: () {
//               Navigator.of(context).pop();
//             },
//           ),
//         ], 
//       );
//     },
//   );
// }
