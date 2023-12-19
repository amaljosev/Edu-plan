import 'dart:async';
import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/models/fee_model.dart';
import 'package:eduplanapp/models/teacher_model.dart';
import 'package:eduplanapp/repositories/firebase/database_functions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DbFunctionsTeacher {
  String? id = '';
  final CollectionReference teacherCollection =
      FirebaseFirestore.instance.collection('teachers');

  Stream<DocumentSnapshot> getTeacherData(String teacherId) {
    final teacherDocStream = teacherCollection.doc(teacherId).snapshots();
    return teacherDocStream;
  }

  Future<String?> getTeacherIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('teacherId');

    return prefs.getString('teacherId');
  }

  Future<String?> getStudentIdFromPrefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    id = prefs.getString('studentId');
    return prefs.getString('studentId');
  }

  Stream<QuerySnapshot<Object?>> getStudentsDatas(teacherId) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('students');
    final studentsStream = studentCollection.snapshots();
    return studentsStream;
  }

  Stream<QuerySnapshot<Object?>> getClassDetails(teacherId) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('class');
    final studentsStream = studentCollection.snapshots();

    return studentsStream;
  }

  Stream<QuerySnapshot<Object?>> getCurrentAttendanceData(teacherId) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('attendance');
    final studentsStream = studentCollection.snapshots();

    return studentsStream;
  }

  Future<void> updateStudentFeeDatas(
      FeeModel feeDatas, String studentId) async {
    try {
      final String? teacherId =
          await DbFunctionsTeacher().getTeacherIdFromPrefs();

      if (teacherId != null) {
        // Reference to the teacher document
        final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .collection('students')
            .doc(studentId)
            .collection('student_fee')
            .get();
        final feeId = querySnapshot.docs.first.id;
        // Reference to the specific document within the subcollection

        // Creating a map of fields you want to update
        Map<String, dynamic> studentFeeMap = {
          'total_amount': feeDatas.totalAmount,
          'amount_paid': feeDatas.amountPayed,
          'amount_pending': feeDatas.amountPending,
        };

        // Update the document in the subcollection
        await DbFunctions().updateStudentFeeDetails(
            map: studentFeeMap,
            teacherCollectionName: 'teachers',
            teacherId: teacherId,
            studentCollectionName: 'students',
            studentId: studentId,
            feeId: feeId);
      }
    } catch (e) {
      // Handle errors, e.g., print or log them
      log('Error updating class data: $e');
    }
  }

  Stream<QuerySnapshot<Object?>> getAttendanceHistory(teacherId) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('attendance_history');
    final studentsStream = studentCollection.snapshots();

    return studentsStream;
  }

  Future<bool> updateTeacherData(
      TeacherModel teacherObject, String teacherId) async {
    try {
      Map<String, dynamic> teacherMap = {
        'name': teacherObject.name,
        'class': teacherObject.className,
        'division': teacherObject.division,
        'class_name': teacherObject.className + teacherObject.division,
        'email': teacherObject.email,
        'contact': teacherObject.contact,
        'password': teacherObject.password,
      };
      final resopnse = await DbFunctions().updateSingleCollection(
          map: teacherMap, collectionName: 'teachers', teacherId: teacherId);
      final QuerySnapshot classQuerySnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('class')
          .get();
      if (classQuerySnapshot.docs.isNotEmpty) {
        final String classId = classQuerySnapshot.docs.first.id;

        final CollectionReference classCollection = FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .collection('class');

        await classCollection.doc(classId).update({
          'standard': teacherObject.className,
          'division': teacherObject.division,
        });
      }
      final QuerySnapshot studentsQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('teachers')
          .doc(teacherId)
          .collection('students')
          .get();
      final CollectionReference studentsCollection = FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('students');

      for (QueryDocumentSnapshot studentDoc in studentsQuerySnapshot.docs) {
        await studentsCollection.doc(studentDoc.id).update({
          'standard': teacherObject.className,
          'division': teacherObject.division,
        }); 
      }
      return resopnse;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteSubCollection(
      {required String teacherId,
      required String studentId,
      required String email,
      required String password,
      required String gender}) async {
    try {
      final CollectionReference studentsCollection = FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('students');

      final QuerySnapshot allUsersQuerySnapshot = await FirebaseFirestore
          .instance
          .collection('all_users')
          .where('email', isEqualTo: email)
          .get();
      if (allUsersQuerySnapshot.docs.isNotEmpty) {
        final DocumentSnapshot studentDoc = allUsersQuerySnapshot.docs.first;
        final String storedPassword = studentDoc.get('password');
        if (storedPassword == password) {
          final String userId = studentDoc.id;
          final CollectionReference usersCollection =
              FirebaseFirestore.instance.collection('all_users');
          await usersCollection.doc(userId).delete();
        }
      }

      final QuerySnapshot classQuerySnapshot = await FirebaseFirestore.instance
          .collection('teachers')
          .doc(teacherId)
          .collection('class')
          .get();

      if (classQuerySnapshot.docs.isNotEmpty) {
        final String classId = classQuerySnapshot.docs.first.id;

        final CollectionReference classCollection = FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .collection('class');

        await classCollection.doc(classId).update({
          'total_students': FieldValue.increment(-1),
        });

        if (gender == 'Gender.male') {
          await classCollection.doc(classId).update({
            'total_boys': FieldValue.increment(-1),
          });
        } else {
          await classCollection.doc(classId).update({
            'total_girls': FieldValue.increment(-1),
          });
        }

        await studentsCollection.doc(studentId).delete();
      }
      return true;
    } catch (e) {
      log("Error deleting subcollection: $e");
      return false;
    }
  }
}
