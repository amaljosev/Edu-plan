
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminDb {
   
  Stream<QuerySnapshot<Object?>> getStudentsDatas(teacherId) { 
    final CollectionReference studentCollection = FirebaseFirestore.instance
      .collection('teachers')
      .doc(teacherId) 
      .collection('students');
    final studentsStream = studentCollection.snapshots(); 
    return studentsStream;   
  }
  
}