import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DbFunctionsStudent {
  Stream<DocumentSnapshot<Object?>> getStudentsDatas(
      String teacherId, String studentId) {
    try {
      final DocumentReference studentDocument = FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('students')
          .doc(studentId);

      final studentsStream = studentDocument.snapshots();
      return studentsStream;
    } catch (error) {
      rethrow;
    }
  }

 
  
  Stream<QuerySnapshot<Object?>> getPayment( 
      {required String teacherId, required String studentId}) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('students')
        .doc(studentId)
        .collection('payment_data');
    final studentsStream = studentCollection.snapshots();

    return studentsStream;
  }
  Stream<QuerySnapshot<Object?>> getFeeDetails( 
      {required String teacherId, required String studentId}) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('students')
        .doc(studentId)
        .collection('student_fee');
    final studentsStream = studentCollection.snapshots();

    return studentsStream;
  }
  Stream<QuerySnapshot<Object?>> getOfflineFee( 
      {required String teacherId, required String studentId}) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('students')
        .doc(studentId)
        .collection('offline_payments'); 
    final studentsStream = studentCollection.snapshots();

    return studentsStream;
  }
}
