import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/models/class_model.dart';
import 'package:eduplanapp/models/fee_model.dart';
import 'package:eduplanapp/models/student_model.dart';
import 'package:eduplanapp/repositories/firebase/teacher/add_student_functions.dart';
import 'package:eduplanapp/repositories/firebase/teacher/db_functions_teacher.dart';
import 'package:eduplanapp/screens/teacher/form/newstudent_form.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'teacher_event.dart';
part 'teacher_state.dart';

class TeacherBloc extends Bloc<TeacherEvent, TeacherState> {
  String? id = '';
  TeacherBloc() : super(TeacherInitial()) {
    on<TeacherEvent>(teacherEvent);
    on<FormStudentEvent>(formStudentEvent);
    on<AddStudentEvent>(addStudentEvent);
    on<AttendenceEvent>(attendenceEvent);
    on<StudentProfileEvent>(studentProfileEvent);
    on<BottomNavigationEvent>(bottomNavigationEvent);
    on<SchoolEventsEvent>(schoolEventsEvent);
    on<TeacherAssignmentEvent>(teacherAssignmentEvent);
    on<TeacherLeaveApplicationEvent>(teacherLeaveApplicationEvent);
    on<TeacherHomeWorkEvent>(teacherHomeWorkEvent);
    on<FetchTeacherDatasEvent>(fetchTeacherDatasEvent);
    on<RadioButtonEvent>(radioButtonEvent);
    on<FetchStudentDatasEvent>(fetchStudentDatasEvent);
    on<FetchClassDetailsEvent>(fetchClassDetailsEvent);
    on<UpdateFeeScreenEvent>(updateFeeScreenEvent);
    on<UpdateStudentFeeEvent>(updateStudentFeeEvent);
    on<UpdateStudentDataEvent>(updateStudentDataEvent);
    on<FetchAllStudentsEvent>(fetchAllStudentsEvent);
    on<SearchStudentScreenEvent>(searchStudentScreenEvent);
    on<PerformSearchEvent>(performSearchEvent);
  }

  FutureOr<void> formStudentEvent(
      FormStudentEvent event, Emitter<TeacherState> emit) {
    emit(FormStudentState());
  }

  FutureOr<void> addStudentEvent(
      AddStudentEvent event, Emitter<TeacherState> emit) async {
    emit(AddStudentLoadingState());
    try {
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final bool isExist = await StudentDbFunctions().checkRegNo(
          rollNo: event.studentData.rollNo,
          regNo: event.studentData.registerNo,
          email: event.studentData.email,
          teacherId: id as String);
      if (isExist) {
        emit(StudentExistState());
      } else {
        final bool response = await StudentDbFunctions().addStudent(
          studentData: event.studentData,
          feeDatas: event.feeData,
        );
        final bool updateResponse =
            await StudentDbFunctions().updateClassData(event.classDatas);
        if (response && updateResponse) {
          emit(AddStudentSuccessState());
        } else {
          emit(AddStudentErrorState());
        }
      }
    } catch (e) {
      emit(AddStudentErrorState());
    }
  }

  FutureOr<void> attendenceEvent(
      AttendenceEvent event, Emitter<TeacherState> emit) {
    emit(AttendenceState(isVisited: event.isVisited));
  }

  FutureOr<void> studentProfileEvent(
      StudentProfileEvent event, Emitter<TeacherState> emit) async {
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(id)
        .collection('attendance')
        .get();
    final DocumentSnapshot classDoc = querySnapshot.docs.first;
    int totalWorkingDays = classDoc.get('toatal_working_days_completed');
    emit(StudentProfileState(
        totalWorkingDays: totalWorkingDays,
        studentId: event.studentId,
        students: event.students,
        studentFee: event.studentFee));
  }

  FutureOr<void> bottomNavigationEvent(
      BottomNavigationEvent event, Emitter<TeacherState> emit) {
    emit(BottomNavigationState(currentPageIndex: event.currentPageIndex));
  }

  FutureOr<void> teacherEvent(TeacherEvent event, Emitter<TeacherState> emit) {
    emit(HomeState());
  }

  FutureOr<void> schoolEventsEvent(
      SchoolEventsEvent event, Emitter<TeacherState> emit) {
    emit(SchoolEventsState());
  }

  FutureOr<void> teacherAssignmentEvent(
      TeacherAssignmentEvent event, Emitter<TeacherState> emit) {
    emit(TeacherAssignmetState());
  }

  FutureOr<void> teacherLeaveApplicationEvent(
      TeacherLeaveApplicationEvent event, Emitter<TeacherState> emit) {
    emit(TeacherLeaveApplicationState());
  }

  FutureOr<void> teacherHomeWorkEvent(
      TeacherHomeWorkEvent event, Emitter<TeacherState> emit) {
    emit(TeacherHomeWorkState());
  }

  FutureOr<void> fetchTeacherDatasEvent(
      FetchTeacherDatasEvent event, Emitter<TeacherState> emit) async {
    id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
    Stream<DocumentSnapshot<Object?>>? teacherDatas =
        DbFunctionsTeacher().getTeacherData(id as String);
    emit(FetchTeacherDataState(teacherDatas: teacherDatas));
  }

  FutureOr<void> radioButtonEvent(
      RadioButtonEvent event, Emitter<TeacherState> emit) {
    emit(RadioButtonState(gender: event.gender));
  }

  FutureOr<void> fetchStudentDatasEvent(
      FetchStudentDatasEvent event, Emitter<TeacherState> emit) async {
    emit(FetchStudentDataLoadingState());
    try {
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      Stream<QuerySnapshot<Object?>>? studentDatas =
          DbFunctionsTeacher().getStudentsDatas(id);
      emit(FetchStudentDataSuccessState(studetDatas: studentDatas));
    } catch (e) {
      emit(FetchStudentDataErrorState());
    }
  }

  FutureOr<void> fetchClassDetailsEvent(
      FetchClassDetailsEvent event, Emitter<TeacherState> emit) async {
    emit(FetchClassDetailsLoadingState());
    try {
      final String? id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final prefs = await SharedPreferences.getInstance();
      final String? date = prefs.getString('last_updated_date');
      if (date != null) {
        final currentDate = DateTime.now();
        final formattedDate =
            DateTime(currentDate.year, currentDate.month, currentDate.day);
        date == formattedDate.toString()
            ? emit(SameDateState(isVisited: true))
            : emit(SameDateState(isVisited: false));
      } else {
        emit(SameDateState(isVisited: false));
      }
      final Stream<QuerySnapshot<Object?>> classDatas =
          DbFunctionsTeacher().getClassDetails(id);
      final Stream<QuerySnapshot<Object?>> currentAttendanceDatas =
          DbFunctionsTeacher().getCurrentAttendanceData(id);

      emit(FetchClassDetailsState(
          classDatas: classDatas, todayAttendenceData: currentAttendanceDatas));
    } catch (e) {
      emit(FetchClassDetailsErrorState());
    }
  }

  FutureOr<void> updateFeeScreenEvent(
      UpdateFeeScreenEvent event, Emitter<TeacherState> emit) {
    emit(UpdateFeeScreenState(
        feeData: event.feeData,
        studentId: event.studentId,
        isOfflinePaymet: event.isOfflinePaymet));
  }

  FutureOr<void> updateStudentFeeEvent(
      UpdateStudentFeeEvent event, Emitter<TeacherState> emit) {
    DbFunctionsTeacher().updateStudentFeeDatas(event.feeData, event.studentId);
    emit(UpdateStudentFeeState());
  }

  FutureOr<void> updateStudentDataEvent(
      UpdateStudentDataEvent event, Emitter<TeacherState> emit) {
    emit(UpdateStudentDataLoadingState());
    try {
      StudentDbFunctions()
          .updateStudentData(event.studentData, event.studentId);
      emit(UpdateStudentDataSuccessState());
    } catch (e) {
      emit(UpdateStudentDataErrorState());
    }
  }

  FutureOr<void> fetchAllStudentsEvent(
      FetchAllStudentsEvent event, Emitter<TeacherState> emit) {
    emit(FetchAllStudentsLoadingState());
    try {
      final Stream<QuerySnapshot<Object?>> studentData =
          DbFunctionsTeacher().getStudentsDatas(id);
      emit(FetchAllStudentsSuccessState(studentDatas: studentData));
    } catch (e) {
      emit(FetchAllStudentsErrorState());
    }
  }

  FutureOr<void> searchStudentScreenEvent(
      SearchStudentScreenEvent event, Emitter<TeacherState> emit) {
    emit(SearchStudentScreenState(studentList: event.studentList));
  }

  FutureOr<void> performSearchEvent(
      PerformSearchEvent event, Emitter<TeacherState> emit) {
    emit(PerformSearchState(searchContent: event.searchContent));
  }
}
