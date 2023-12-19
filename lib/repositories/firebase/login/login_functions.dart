import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginFunctions {
  Future<bool> teacherLogin(
      String enteredUsername, String enteredPassword) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .where('email', isEqualTo: enteredUsername)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If a document with the entered username exists, check the password.
      final DocumentSnapshot teacherDoc = querySnapshot.docs.first;
      final String storedPassword = teacherDoc.get('password');

      if (storedPassword == enteredPassword) {
        // Passwords match; user is authenticated.
        final String teacherId = teacherDoc.id;
        SharedPreferences prefsTeacherId =
            await SharedPreferences.getInstance();
        prefsTeacherId.setString('teacherId', teacherId);
        final sharedPrefsIsTeacher = await SharedPreferences.getInstance();
        await sharedPrefsIsTeacher.setBool('is_teacher', true);
        final sharedPrefs = await SharedPreferences.getInstance();
        await sharedPrefs.setBool('user_login', true);

        return true;
      }
    }
    // Username doesn't exist or the password doesn't match.
    return false;
  }

  Future<bool> studentLogin(
      String enteredUsername, String enteredPassword) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('all_users')
        .where('email', isEqualTo: enteredUsername)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      // If a document with the entered username exists, check the password.
      final DocumentSnapshot studentDoc = querySnapshot.docs.first;
      final String storedPassword = studentDoc.get('password');

      if (storedPassword == enteredPassword) {
        // Passwords match; user is authenticated.
        final String teacherId = studentDoc.get('teacher_id');
        SharedPreferences prefsTeacherId =
            await SharedPreferences.getInstance();

        final String studentRgNo = studentDoc.get('register_no');
        prefsTeacherId.setString('teacherId', teacherId);
        final QuerySnapshot querySnapshot2 = await FirebaseFirestore.instance
            .collection('teachers')
            .doc(teacherId)
            .collection('students')
            .where('register_no', isEqualTo: studentRgNo)
            .get();
        final DocumentSnapshot newStudentDoc = querySnapshot2.docs.first;
        final String studentId = newStudentDoc.id;
        SharedPreferences prefsStudentId =
            await SharedPreferences.getInstance();
        prefsStudentId.setString('studentId', studentId);
        final sharedPrefsIsTeacher = await SharedPreferences.getInstance();
        await sharedPrefsIsTeacher.setBool('is_teacher', false);
        final sharedPrefs = await SharedPreferences.getInstance();
        await sharedPrefs.setBool('user_login', true);
        return true;
      }
    }
    // Username doesn't exist or the password doesn't match.
    return false;
  }
}
