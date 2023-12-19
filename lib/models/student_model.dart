class StudentModel {
  final String firstName;
  final String secondName;
  final String classTeacher;
  final String rollNo;
  final String age;
  final String registerNo;
  final String email;
  final String contactNo;
  final String guardianName;
  final String password;
  final String gender;
  final String standard;
  final String division;
  final int totalPresent;
  final int totalAbsent;

  StudentModel(
      {required this.firstName,
      required this.secondName,
      required this.classTeacher,
      required this.rollNo,
      required this.age,
      required this.registerNo,
      required this.email,
      required this.contactNo,
      required this.guardianName,
      required this.password,
      required this.gender,
      required this.standard,
      required this.division,
      required this.totalPresent,
      required this.totalAbsent});
}
