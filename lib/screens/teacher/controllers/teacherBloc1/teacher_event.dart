part of 'teacher_bloc.dart';

abstract class TeacherEvent {}

abstract class TeacherActionEvent extends TeacherEvent {}

final class HomeEvent extends TeacherActionEvent {}

final class FormStudentEvent extends TeacherActionEvent {}

final class AddStudentEvent extends TeacherActionEvent {
  FeeModel feeData;
  StudentModel studentData;
  ClassModel classDatas;

  AddStudentEvent({
    required this.studentData,
    required this.classDatas,
    required this.feeData,
  });
}

final class AttendenceEvent extends TeacherActionEvent {
  final bool isVisited;
  AttendenceEvent({required this.isVisited});
}

final class StudentProfileEvent extends TeacherActionEvent {
  final Map<String, dynamic> students;
  final CollectionReference<Map<String, dynamic>> studentFee;
  final String studentId;
  StudentProfileEvent({
    required this.students,
    required this.studentFee,
    required this.studentId,
  });
}

final class BottomNavigationEvent extends TeacherActionEvent {
  int currentPageIndex;
  BottomNavigationEvent({
    required this.currentPageIndex,
  });
}

final class SchoolEventsEvent extends TeacherActionEvent {}

final class TeacherAssignmentEvent extends TeacherActionEvent {}

final class TeacherHomeWorkEvent extends TeacherActionEvent {}

final class TeacherLeaveApplicationEvent extends TeacherActionEvent {}

final class FetchTeacherDatasEvent extends TeacherActionEvent {}

final class RadioButtonEvent extends TeacherActionEvent {
  final Gender? gender;
  RadioButtonEvent({required this.gender});
}

final class FetchStudentDatasEvent extends TeacherActionEvent {}

final class FetchClassDetailsEvent extends TeacherActionEvent {}

final class UpdateFeeScreenEvent extends TeacherActionEvent {
  final Map<String, dynamic> feeData;
  final String studentId;
  final bool isOfflinePaymet;
  UpdateFeeScreenEvent(
      {required this.feeData,
      required this.studentId,
      required this.isOfflinePaymet});
}

final class UpdateStudentFeeEvent extends TeacherActionEvent {
  final FeeModel feeData;
  final String studentId;
  UpdateStudentFeeEvent({
    required this.feeData,
    required this.studentId,
  });
}

final class UpdateStudentDataEvent extends TeacherActionEvent {
  final StudentModel studentData;
  final String studentId;

  UpdateStudentDataEvent({required this.studentData, required this.studentId});
}

final class FetchAllStudentsEvent extends TeacherActionEvent {}

final class SearchStudentScreenEvent extends TeacherActionEvent {
  final List<DocumentSnapshot<Object?>> studentList;
  SearchStudentScreenEvent({required this.studentList});
}

final class PerformSearchEvent extends TeacherActionEvent {
  final String searchContent;
  PerformSearchEvent({required this.searchContent});
}
