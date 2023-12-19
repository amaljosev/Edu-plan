import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/repositories/firebase/database_functions.dart';

class TasksDbFunctionsStudent {
  Stream<QuerySnapshot<Object?>> getEventsDatas(
      {required String teacherId, required String collection}) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection(collection);
    final studentsStream = studentCollection.snapshots();

    return studentsStream;
  }

  Future<bool> addLeaveApplicationWork(
      {required String teacherId,
      required String date,
      required String reason,
      required String name,
      required String studentId}) async {
    try {
      Map<String, dynamic> homeWorkMap = {
        'absent_date': date,
        'reason': reason,
        'name': name,
        'date': DateTime.now()
      };

      final bool resopnse = await DbFunctions().addSubCollection(
          map: homeWorkMap,
          collectionName: 'teachers',
          teacherId: teacherId,
          subCollectionName: 'leave_applications');
      final bool resopnse2 = await DbFunctions().addSubCollectionInStudent(
          map: homeWorkMap,
          teacherCollectionName: 'teachers',
          teacherId: teacherId,
          studentCollectionName: 'students',
          studentId: studentId,
          newCollectionName: 'leave_applications_student');
      return resopnse && resopnse2;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot<Object?>> getStudentLeaveDatas(
      {required String teacherId, required String studentId}) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('students')
        .doc(studentId)
        .collection('leave_applications_student');
    final studentsStream = studentCollection.snapshots();

    return studentsStream;
  }

  Future<bool> submitHomeWork(
      {required String teacherId,
      required String note,
      required String subject,
      required String name,
      required List<String> imageUrlsList,
      required String topic,
      required String studentId}) async {
    try {
      Map<String, dynamic> homeWorkMap = {
        'subject': subject,
        'topic': topic,
        'note': note,
        'name': name,
        'image_url': imageUrlsList, 
        'date': DateTime.now()
      };

      final bool resopnse = await DbFunctions().addSubCollection(
          map: homeWorkMap,
          collectionName: 'teachers',
          teacherId: teacherId,
          subCollectionName: 'submitted_homeworks');
      final bool resopnse2 = await DbFunctions().addSubCollectionInStudent(
          map: homeWorkMap,
          teacherCollectionName: 'teachers',
          teacherId: teacherId,
          studentCollectionName: 'students',
          studentId: studentId,
          newCollectionName: 'submitted_homeworks');
      return resopnse && resopnse2;
    } catch (e) {
      return false;
    }
  }

  Future<bool> submitAssignment(
      {required String teacherId,
      required String note,
      required String subject,
      required String topic,
      required String name,
      required List<String> imageUrlsLiist,
      required String studentId}) async {
    try {
      Map<String, dynamic> homeWorkMap = {
        'subject': subject,
        'topic': topic,
        'note': note,
        'name': name,
        'image_url': imageUrlsLiist,  
        'date': DateTime.now()
      };

      final bool resopnse = await DbFunctions().addSubCollection(
          map: homeWorkMap,
          collectionName: 'teachers',
          teacherId: teacherId,
          subCollectionName: 'submitted_assignments');
      final bool resopnse2 = await DbFunctions().addSubCollectionInStudent(
          map: homeWorkMap,
          teacherCollectionName: 'teachers',
          teacherId: teacherId,
          studentCollectionName: 'students',
          studentId: studentId,
          newCollectionName: 'submitted_assignments');
      return resopnse && resopnse2;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot<Object?>> getSubmittedHomeWorks(
      {required String teacherId, required String studentId}) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('students')
        .doc(studentId)
        .collection('submitted_homeworks');
    final studentsStream = studentCollection.snapshots();

    return studentsStream;
  }

  Stream<QuerySnapshot<Object?>> getSubmittedAssignments(
      {required String teacherId, required String studentId}) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('students')
        .doc(studentId)
        .collection('submitted_assignments');
    final studentsStream = studentCollection.snapshots();

    return studentsStream;
  }

  Future<bool> deleteStudentTask({
    required String teacherId,
    required String studentId,
    required String collection,
    required String taskId,
    required String studentName,
    required String note,
  }) async {
    try {
      final CollectionReference taskCollection = FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('students')
          .doc(studentId)
          .collection(collection);
      final CollectionReference teacherTaskCollection = FirebaseFirestore
          .instance
          .collection('teachers')
          .doc(teacherId)
          .collection(collection);

      final QuerySnapshot teacherTaskQuerySnapshot =
          await FirebaseFirestore.instance
              .collection('teachers')
              .doc(teacherId)
              .collection(collection)
              .where(
                'name',
                isEqualTo: studentName,
              )
              .get();
      if (teacherTaskQuerySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot studentDoc = teacherTaskQuerySnapshot.docs.first;
        final String storedNote = studentDoc.get('note');
        if (storedNote == note) {
          final String teacherTaskId = studentDoc.id;
          await teacherTaskCollection.doc(teacherTaskId).delete();
          await taskCollection.doc(taskId).delete();
        }
      }

      return true;
    } catch (e) {
      log("Error deleting subcollection: $e");
      return false;
    }
  }
}
