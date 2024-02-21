import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/models/new_payment_model.dart';
import 'package:eduplanapp/repositories/firebase/database_functions.dart';
import 'package:eduplanapp/repositories/firebase/teacher/db_functions_teacher.dart';

class PaymentFunctionsTeacher {
  Future<bool> giveNewPayment(
      NewPaymentModel paymentData, String studentId) async {
    final String? teacherId =
        await DbFunctionsTeacher().getTeacherIdFromPrefs();
    try {
      Map<String, dynamic> paymentMap = {
        'date': DateTime.now(),
        'note': paymentData.note,
        'new-payment': paymentData.newPayment,
        'isPayed': paymentData.isPayed,
      };

      final bool resopnse = await DbFunctions().newPayment(
          map: paymentMap,
          teacherCollectionName: 'teachers',
          teacherId: teacherId.toString(),
          studentCollectionName: 'students',
          studentId: studentId,
          newCollectionName: 'payment_data');
      return resopnse;
    } catch (e) {
      return false;
    }
  }

  Future<bool> offlinePayment(String amount, String studentId) async {
    final String? teacherId =
        await DbFunctionsTeacher().getTeacherIdFromPrefs();
    try {
      Map<String, dynamic> paymentMap = {
        'date': DateTime.now(),
        'new-payment': amount,
      };

      final bool resopnse = await DbFunctions().newPayment(
          map: paymentMap,
          teacherCollectionName: 'teachers',
          teacherId: teacherId.toString(),
          studentCollectionName: 'students',
          studentId: studentId,
          newCollectionName: 'offline_payments');
      return resopnse;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updatePayment(
      String studentId, String paymentId, String note, int newPayment) async {
    final String? teacherId =
        await DbFunctionsTeacher().getTeacherIdFromPrefs();
    try {
      Map<String, dynamic> paymentMap = {
        'date': DateTime.now(),
        'note': note,
        'new-payment': newPayment,
        'isPayed': true,
      };
      log(paymentId);

      await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId as String)
          .collection('students')
          .doc(studentId)
          .collection('payment_data')
          .doc(paymentId)
          .update(paymentMap);

      return true;
    } catch (e) {
      return false;
    }
  }
}
