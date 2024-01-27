import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/models/attendance.dart';
import 'package:eduplanapp/repositories/firebase/database_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AttendenceFunctions {
  bool responce = false;
  Future<bool> submitAttendance({
    required List<DocumentSnapshot> students,
    required List<bool?> checkMarks,
    required String teacherId,
    required bool isUpdate,
  }) async {
    CollectionReference<Map<String, dynamic>> studentsCollection =
        FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .collection('students');
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('attendance')
        .get();
    final DocumentSnapshot classDoc = querySnapshot.docs.first;
    int totalWorkingDays = classDoc.get('toatal_working_days_completed');

    final String classAttendanceId = classDoc.id;

    try {
      int presentCounter = 0;
      int absentCounter = 0;
      int totalPresentDaysCounter = classDoc.get('total_presents');
      int totalAbsentDaysCounter = classDoc.get('total_absents');

      for (int i = 0; i < students.length; i++) {
        DocumentSnapshot student = students[i];
        bool? isPresent = checkMarks[i];
        int totalPresentDays = student['total_present_days'] ?? 0;
        int totalAbsentDays = student['total_missed_days'] ?? 0;
        bool lastAttendance = student['last_attendance'] ?? 0;

        if (isUpdate) {
          if (lastAttendance == false) {
            if (isPresent == true) {
              totalPresentDays += 1;
              totalAbsentDays -= 1;
              totalPresentDaysCounter += 1;
              totalAbsentDaysCounter >= 0 ? totalAbsentDaysCounter -= 1 : 0;
            }
          } else {
            if (isPresent == false) {
              totalPresentDays -= 1;
              totalAbsentDays += 1;
              totalPresentDaysCounter >= 0 ? totalPresentDaysCounter -= 1 : 0;
              totalAbsentDaysCounter += 1;
            }
          }
        } else {
          if (isPresent == true) {
            totalPresentDays += 1;
            presentCounter += 1;
          } else {
            totalAbsentDays += 1;
            absentCounter += 1;
          }
        }
        if (totalAbsentDays < 0) totalAbsentDays = 0;
        if (totalPresentDays < 0) totalPresentDays = 0;

        await studentsCollection.doc(student.id).update({
          'total_present_days': totalPresentDays,
          'total_missed_days': totalAbsentDays,
          'last_attendance': isPresent
        });
      }

      final totalAttendance = AttendanceModel(
          totalWorkingDaysCompleted:
              isUpdate ? totalWorkingDays : totalWorkingDays += 1,
          todayPresents: isUpdate ? totalPresentDaysCounter : presentCounter,
          todayAbsents: isUpdate ? totalAbsentDaysCounter : absentCounter,
          date: DateTime.now());
      responce = await updateClassAttendanceStatus(
          teacherId, totalAttendance, classAttendanceId, isUpdate);
      return responce;
    } catch (e) {
      log('udation error $e');
      return false;
    }
  }

  Future<bool> updateClassAttendanceStatus(
      String teacherId,
      AttendanceModel attendanceData,
      String attendanceId,
      bool isUpdate) async {
    try {
      int todayAbsents = attendanceData.todayAbsents;
      int todayPresents = attendanceData.todayPresents;
   
      if (todayAbsents < 0) todayAbsents = 0;
      if (todayPresents < 0) todayPresents = 0;
    
      Map<String, dynamic> studentFeeMap = {
        'toatal_working_days_completed':
            attendanceData.totalWorkingDaysCompleted,
        'total_absents': todayAbsents, 
        'total_presents': todayPresents,
      };
      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('attendance')
          .doc(attendanceId)
          .update(studentFeeMap);
      isUpdate
          ? await updateDailyAttendance(attendanceData, teacherId)
          : await addDailyAttendance(attendanceData, teacherId);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> addDailyAttendance(
      AttendanceModel attendanceData, String teacherId) async {
    try {
      Map<String, dynamic> attendanceMap = {
        'total_absents': attendanceData.todayAbsents,
        'total_presents': attendanceData.todayPresents,
        'date': attendanceData.date,
      };
      final prefsDate = await SharedPreferences.getInstance();
      final currentDate = DateTime.now();
      final formattedDate =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      prefsDate.setString('last_updated_date', formattedDate.toString());

      final bool resopnse = await DbFunctions().addAttendance(
          map: attendanceMap,
          collectionName: 'teachers',
          teacherId: teacherId,
          subCollectionName: 'attendance_history',
          subCollectionId: formattedDate.toString());
      return resopnse;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateDailyAttendance(
      AttendanceModel attendanceData, String teacherId) async {
    try {
      Map<String, dynamic> attendanceMap = {
        'total_absents': attendanceData.todayAbsents,
        'total_presents': attendanceData.todayPresents,
        'date': attendanceData.date,
      };
      final prefsDate = await SharedPreferences.getInstance();
      final currentDate = DateTime.now();
      final formattedDate =
          DateTime(currentDate.year, currentDate.month, currentDate.day);
      prefsDate.setString('last_updated_date', formattedDate.toString());

      final bool resopnse = await DbFunctions().updateDetails(
          map: attendanceMap,
          collectionName: 'teachers',
          teacherId: teacherId,
          subCollectionName: 'attendance_history',
          classId: formattedDate.toString());
      return resopnse;
    } catch (e) {
      return false;
    }
  }
}
