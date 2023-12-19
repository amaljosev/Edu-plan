import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';

class StudentLeaveDbFunctions {
  Future<bool> deleteLeaveApplication({
    required String teacherId,
    required String studntId,
    required String applicationId,
    required String studentName,
    required String reason,
  }) async {
    try {
      final CollectionReference eventCollection = FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('students')
          .doc(studntId)
          .collection('leave_applications_student');

      final CollectionReference teacherApplicationCollection = FirebaseFirestore
          .instance
          .collection('teachers')
          .doc(teacherId)
          .collection('leave_applications');

      final QuerySnapshot teacherTaskQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('teachers')
              .doc(teacherId)
              .collection('leave_applications')
              .where(
                'name',
                isEqualTo: studentName,
              )
              .get();
      if (teacherTaskQuerySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot studentDoc = teacherTaskQuerySnapshot.docs.first;
        final String storedReason = studentDoc.get('reason');
        if (storedReason == reason) {
          final String teacherApplicationId = studentDoc.id;
          await teacherApplicationCollection.doc(teacherApplicationId).delete();
          await eventCollection.doc(applicationId).delete();
        }
      }

      return true;
    } catch (e) {
      log("Error deleting subcollection: $e");
      return false;
    }
  }
}
