import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/models/class_model.dart';
import 'package:eduplanapp/models/fee_model.dart';
import 'package:eduplanapp/models/student_model.dart';
import 'package:eduplanapp/repositories/firebase/database_functions.dart';
import 'package:eduplanapp/repositories/firebase/teacher/db_functions_teacher.dart';

class StudentDbFunctions {
  final CollectionReference studentsCollection =
      FirebaseFirestore.instance.collection('students');

  Future<bool> addStudent({
    required StudentModel studentData,
    required FeeModel feeDatas,
  }) async {
    try {
      final String? id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      Map<String, dynamic> studentMap = {
        'first_name': studentData.firstName,
        'second_name': studentData.secondName,
        'class_Teacher': studentData.classTeacher,
        'teacher_id': id,
        'roll_no': studentData.rollNo,
        'age': studentData.age,
        'register_no': studentData.registerNo,
        'email': studentData.email,
        'contact_no': studentData.contactNo,
        'guardian_name': studentData.guardianName,
        'password': studentData.password,
        'gender': studentData.gender,
        'standard': studentData.standard,
        'division': studentData.division,
        'total_present_days': 0,
        'total_missed_days': 0,
        'last_attendance': false
      };
      final bool response = await DbFunctions().addSubCollection(
        map: studentMap,
        collectionName: 'teachers',
        teacherId: id as String,
        subCollectionName: 'students',
      );
      final bool response2 = await DbFunctions()
          .addDetails(map: studentMap, collectionName: 'all_users');
      addClassAndFeeData(feeDatas, studentData.registerNo);

      return response && response2;
    } catch (e) {
      return false;
    }
  }

  Future<void> addClassAndFeeData(FeeModel feeDatas, String regNo) async {
    try {
      final String? teacherId =
          await DbFunctionsTeacher().getTeacherIdFromPrefs();

      if (teacherId != null) {
        // Reference to the teacher document
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .collection('students')
            .where('register_no', isEqualTo: regNo)
            .get();
        final studentId = querySnapshot.docs.first.id;

        Map<String, dynamic> studentFeeMap = {
          'total_amount': feeDatas.totalAmount,
          'amount_paid': feeDatas.amountPayed,
          'amount_pending': feeDatas.amountPending,
        };
        DbFunctions().addStudentFeeDetails(
            map: studentFeeMap,
            teacherCollectionName: 'teachers',
            teacherId: teacherId,
            studentCollectionName: 'students',
            studentId: studentId,
            feeCollectionName: 'student_fee');
      }
    } catch (e) {
      // Handle errors, e.g., print or log them
      log('Error updating class data: $e');
    }
  }

  Future<bool> updateClassData(ClassModel classData) async {
    bool response = false;
    try {
      final String? teacherId =
          await DbFunctionsTeacher().getTeacherIdFromPrefs();

      if (teacherId != null) {
        // Reference to the teacher document
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .collection('class')
            .get();
        final classId = querySnapshot.docs.first.id;
        // Reference to the specific document within the subcollection

        // Creating a map of fields you want to update
        Map<String, dynamic> updateData = {
          'class_teacher': classData.classTeacher,
          'standard': classData.standard,
          'total_boys': classData.totalBoys,
          'total_girls': classData.totalGirls,
          'total_students': classData.totalStudents,
        };

        // Update the document in the subcollection
        response = await DbFunctions().updateDetails(
            map: updateData,
            collectionName: 'teachers',
            teacherId: teacherId,
            subCollectionName: 'class',
            classId: classId);
      }
      return response;
    } catch (e) {
      // Handle errors, e.g., print or log them
      log('Error updating class data: $e');
      return false;
    }
  }

  Future<bool> checkRegNo(
      {required String regNo,
      required String email,
      required String teacherId,
      required String rollNo}) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('students')
        .where('register_no', isEqualTo: regNo)
        .get();
    final QuerySnapshot querySnapshot1 = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('students')
        .where('roll_no', isEqualTo: rollNo)
        .get();
    final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('all_users')
        .where('register_no', isEqualTo: regNo)
        .get();

    final QuerySnapshot teacherMailSnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .where('email', isEqualTo: email)
        .get();

    final QuerySnapshot teacherMailSnapshot2 = await FirebaseFirestore.instance
        .collection('all_users')
        .where('email', isEqualTo: email)
        .get();

    return querySnapshot.docs.isNotEmpty ||
        querySnapshot2.docs.isNotEmpty ||
        teacherMailSnapshot.docs.isNotEmpty ||
        teacherMailSnapshot2.docs.isNotEmpty ||
        querySnapshot1.docs.isNotEmpty;
  }

  Future<bool> updateStudentData(
      StudentModel studentData, String studentId) async {
    bool responce = false;
    try {
      final String? teacherId =
          await DbFunctionsTeacher().getTeacherIdFromPrefs();

      if (teacherId != null) {
        Map<String, dynamic> studentMap = {
          'first_name': studentData.firstName,
          'second_name': studentData.secondName,
          'class_Teacher': studentData.classTeacher,
          'roll_no': studentData.rollNo,
          'age': studentData.age,
          'register_no': studentData.registerNo,
          'email': studentData.email,
          'contact_no': studentData.contactNo,
          'guardian_name': studentData.guardianName,
          'password': studentData.password,
          'gender': studentData.gender,
          'standard': studentData.standard,
        };
        responce = await DbFunctions().updateDetails(
            map: studentMap,
            collectionName: 'teachers',
            teacherId: teacherId,
            subCollectionName: 'students',
            classId: studentId);

        final QuerySnapshot allUsersQuerySnapshot =
            await FirebaseFirestore.instance
                .collection('all_users')
                .where(
                  'email',
                  isEqualTo: studentData.email,
                )
                .get();
        if (allUsersQuerySnapshot.docs.isNotEmpty) {
          final DocumentSnapshot studentDoc = allUsersQuerySnapshot.docs.first;
          final String storedPassword = studentDoc.get('password');
          if (storedPassword == studentData.password) {
            final String userId = studentDoc.id;
            final CollectionReference usersCollection =
                FirebaseFirestore.instance.collection('all_users');
            await usersCollection.doc(userId).update(studentMap);
          }
        }
      }
      return responce;
    } catch (e) {
      return false;
    }
  }
}
