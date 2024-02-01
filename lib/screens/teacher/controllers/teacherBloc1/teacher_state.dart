part of 'teacher_bloc.dart';

abstract class TeacherState {}

abstract class TeacherActionState extends TeacherState {}

final class TeacherInitial extends TeacherState {}

final class HomeState extends TeacherActionState {}

final class FormStudentState extends TeacherActionState {}

final class AddStudentSuccessState extends TeacherActionState {}

final class AddStudentLoadingState extends TeacherActionState {}

final class AddStudentErrorState extends TeacherActionState {}

final class StudentExistState extends TeacherActionState {}

final class AttendenceState extends TeacherActionState {
  final bool isVisited;
  AttendenceState({required this.isVisited});
}

final class StudentProfileState extends TeacherActionState {
  final Map<String, dynamic> students;
  final String studentId;
  final CollectionReference<Map<String, dynamic>> studentFee;
  final int totalWorkingDays;
  StudentProfileState(
      {required this.students,
      required this.studentFee,
      required this.studentId,
      required this.totalWorkingDays});
}

final class BottomNavigationState extends TeacherActionState {
  final int currentPageIndex;
  BottomNavigationState({required this.currentPageIndex});
}

final class SchoolEventsState extends TeacherActionState {}

final class TeacherAssignmetState extends TeacherActionState {}

final class TeacherHomeWorkState extends TeacherActionState {}

final class TeacherLeaveApplicationState extends TeacherActionState {}

final class FetchTeacherDataState extends TeacherActionState {
  Stream<DocumentSnapshot<Object?>>? teacherDatas;
  FetchTeacherDataState({required this.teacherDatas});
}

final class SameDateState extends TeacherActionState {
  final bool isVisited;
  SameDateState({required this.isVisited});
}

final class RadioButtonState extends TeacherActionState {
  final Gender? gender;
  RadioButtonState({required this.gender});
}

final class FetchStudentDataSuccessState extends TeacherActionState {
  final Stream<QuerySnapshot<Object?>> studetDatas;
  FetchStudentDataSuccessState({required this.studetDatas});
}

final class FetchStudentDataLoadingState extends TeacherActionState {}

final class FetchStudentDataErrorState extends TeacherActionState {}

final class FetchClassDetailsState extends TeacherActionState {
  final Stream<QuerySnapshot<Object?>> classDatas;
  final Stream<QuerySnapshot<Object?>> todayAttendenceData;

  FetchClassDetailsState(
      {required this.classDatas, required this.todayAttendenceData});
}

final class FetchClassDetailsErrorState extends TeacherActionState {}

final class FetchClassDetailsLoadingState extends TeacherActionState {}

final class UpdateFeeScreenState extends TeacherActionState {
  final Map<String, dynamic> feeData;
  final String studentId;
  final bool isOfflinePaymet;
  UpdateFeeScreenState({
    required this.feeData,
    required this.studentId,
    required this.isOfflinePaymet,
  });
}

final class UpdateStudentFeeState extends TeacherActionState {}

final class UpdateStudentDataSuccessState extends TeacherActionState {}

final class UpdateStudentDataErrorState extends TeacherActionState {}

final class UpdateStudentDataLoadingState extends TeacherActionState {}

final class FetchAllStudentsSuccessState extends TeacherActionState {
  final Stream<QuerySnapshot<Object?>> studentDatas;
  FetchAllStudentsSuccessState({required this.studentDatas});
}

final class FetchAllStudentsErrorState extends TeacherActionState {}

final class FetchAllStudentsLoadingState extends TeacherActionState {}

final class SearchStudentScreenState extends TeacherActionState {
  final List<DocumentSnapshot<Object?>> studentList;
  SearchStudentScreenState({required this.studentList});
}

final class PerformSearchState extends TeacherActionState {
  final String searchContent;
  PerformSearchState({required this.searchContent});
}
