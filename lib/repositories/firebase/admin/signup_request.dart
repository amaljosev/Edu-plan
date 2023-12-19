import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/models/teacher_model.dart';
import 'package:eduplanapp/repositories/firebase/database_functions.dart';

class SignUpRequest {
  final CollectionReference teacherDatas =
      FirebaseFirestore.instance.collection('teacher_requests');

  Future<bool> addData(TeacherModel teacherObject) async {
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
      final resopnse = await DbFunctions().addDetails(
        map: teacherMap,
        collectionName: 'teacher_requests',
      );
      return resopnse;
    } catch (e) {
      return false;
    }
  }

  Stream<QuerySnapshot> getTeacherDatas() {
    final teachersStream = teacherDatas.snapshots();
    return teachersStream;
  }

  Future<bool> checkClass(String value, String email) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .where('class_name', isEqualTo: value)
        .get();
    final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('teacher_requests')
        .where('class_name', isEqualTo: value)
        .get();
    final QuerySnapshot teacherMailSnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .where('email', isEqualTo: email)
        .get();
    final QuerySnapshot teacherMailSnapshot2 = await FirebaseFirestore.instance
        .collection('teacher_requests')
        .where('email', isEqualTo: email)
        .get();
    return querySnapshot.docs.isNotEmpty ||
        querySnapshot2.docs.isNotEmpty ||
        teacherMailSnapshot.docs.isNotEmpty ||
        teacherMailSnapshot2.docs.isNotEmpty;
  }

  Future<bool> checkClassAlradyExist(String standard) async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .where('class_name', isEqualTo: standard)
        .get();

    log('${querySnapshot.docs.isNotEmpty}');
    final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
        .collection('teacher_requests')
        .where('class_name', isEqualTo: standard)
        .get();

    log('${querySnapshot2.docs.isNotEmpty}');

    return querySnapshot.docs.isNotEmpty || querySnapshot2.docs.isNotEmpty;
  }
}
