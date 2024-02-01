import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/models/new_payment_model.dart';
import 'package:eduplanapp/repositories/firebase/student/db_functions_student.dart';
import 'package:eduplanapp/repositories/firebase/teacher/fee/payment_remainder_functions.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/models/teacher_model.dart';
import 'package:eduplanapp/repositories/firebase/student/leave_db_functions.dart';
import 'package:eduplanapp/repositories/firebase/student/tasks_functions.dart';
import 'package:eduplanapp/repositories/firebase/teacher/attendance_functions.dart';
import 'package:eduplanapp/repositories/firebase/teacher/db_functions_teacher.dart';
import 'package:eduplanapp/repositories/firebase/teacher/teacher_actions_functions.dart';
import 'package:eduplanapp/repositories/firebase/teacher/task_db_functions.dart';
import 'package:eduplanapp/screens/teacher/profile/widgets/student_details_widget.dart';

part 'teacher_second_event.dart';
part 'teacher_second_state.dart';

class TeacherSecondBloc extends Bloc<TeacherSecondEvent, TeacherSecondState> {
  String? id = '';
  TeacherSecondBloc() : super(TeacherSecondInitial()) {
    on<CheckBoxTapEvent>(checkBoxTapEvent);
    on<SubmitAttendanceEvent>(submitAttendanceEvent);
    on<FetchAttendanceHistoryEvent>(fetchAttendanceHistoryEvent);
    on<HomeWorkSendEvent>(homeWorkSendEvent);
    on<TaskDropDownEvent>(taskDropDownEvent);
    on<DateSelectedEvent>(dateSelectedEvent);
    on<LogoutEvent>(logoutEvent);
    on<AssignmentSendEvent>(assignmentSendEvent);
    on<UpdateAttendanceEvent>(updateAttendanceEvent);
    on<EditTeacherEvent>(editTeacherEvent);
    on<FetchTaskDatasEvent>(fetchTaskDatasEvent);
    on<TeacherNoticeEvent>(teacherNoticeEvent);
    on<FetchFormDatasEvent>(fetchFormDatasEvent);
    on<FetchLeaveApplicationsEvent>(fetchLeaveApplicationsEvent);
    on<PopupMenuButtonEvent>(popupMenuButtonEvent);
    on<DeleteStudentEvent>(deleteStudentEvent);
    on<EventDeleteEvent>(eventDeleteEvent);
    on<TaskDeleteEvent>(taskDeleteEvent);
    on<AddANewPaymentEvent>(addANewPaymentEvent);
    on<FetchNewPaymentDataEvent>(fetchNewPaymentDataEvent);
    on<OfflineFeeEvent>(offlineFeeEvent);
    on<FetchOfflineFeeEvent>(fetchOfflineFeeEvent);
  }

  FutureOr<void> checkBoxTapEvent(
      CheckBoxTapEvent event, Emitter<TeacherSecondState> emit) {
    emit(CheckBoxTapState(isChecked: event.isChecked, index: event.index));
  }

  FutureOr<void> submitAttendanceEvent(
      SubmitAttendanceEvent event, Emitter<TeacherSecondState> emit) async {
    id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
    emit(SubmitAttendanceLoadingState());
    try {
      final responce = await AttendenceFunctions().submitAttendance(
          students: event.students,
          checkMarks: event.checkMarks,
          teacherId: id as String,
          isUpdate: false);
      if (responce) {
        emit(SubmitAttendanceSuccessState());
      } else {
        emit(SubmitAttendanceErrorState());
      }
    } catch (e) {
      emit(SubmitAttendanceErrorState());
    }
  }

  FutureOr<void> fetchAttendanceHistoryEvent(FetchAttendanceHistoryEvent event,
      Emitter<TeacherSecondState> emit) async {
    emit(FetchAttendanceHistoryLoadingState());
    try {
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final attendanceHistory = DbFunctionsTeacher().getAttendanceHistory(id);
      emit(FetchAttendanceHistorySuccessState(
          attendenceHistory: attendanceHistory));
    } catch (e) {
      emit(FetchAttendanceHistoryErrorState());
    }
  }

  FutureOr<void> homeWorkSendEvent(
      HomeWorkSendEvent event, Emitter<TeacherSecondState> emit) async {
    emit(HomeWorkSendLoadingState());
    try {
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final bool responce = await TaskTeacherDbFunctions()
          .addHomeWork(id as String, event.task, event.subject);
      if (responce) {
        emit(HomeWorkSendSuccessState());
      } else {
        emit(HomeWorkSendErrorState());
      }
    } catch (e) {
      emit(HomeWorkSendErrorState());
    }
  }

  FutureOr<void> taskDropDownEvent(
      TaskDropDownEvent event, Emitter<TeacherSecondState> emit) {
    emit(HomeWorkDropDownState(index: event.index, value: event.value));
  }

  FutureOr<void> assignmentSendEvent(
      AssignmentSendEvent event, Emitter<TeacherSecondState> emit) async {
    emit(AssignmentSendLoadingState());
    try {
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final bool responce = await TaskTeacherDbFunctions().addAssignments(
          id as String, event.task, event.subject, event.selectedDate);
      if (responce) {
        emit(AssignmentSendSuccessState());
      } else {
        emit(AssignmentSendErrorState());
      }
    } catch (e) {
      emit(AssignmentSendErrorState());
    }
  }

  FutureOr<void> dateSelectedEvent(
      DateSelectedEvent event, Emitter<TeacherSecondState> emit) {
    emit(DateSelectedState(selectedDate: event.selectedDate));
  }

  FutureOr<void> logoutEvent(
      LogoutEvent event, Emitter<TeacherSecondState> emit) {
    emit(LogoutState());
  }

  FutureOr<void> updateAttendanceEvent(
      UpdateAttendanceEvent event, Emitter<TeacherSecondState> emit) async {
    id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
    emit(UpdateAttendanceLoadingState());
    try {
      final responce = await AttendenceFunctions().submitAttendance(
          students: event.students,
          checkMarks: event.checkMarks,
          teacherId: id as String,
          isUpdate: true);
      if (responce) {
        emit(UpdateAttendanceSuccessState());
      } else {
        emit(UpdateAttendanceErrorState());
      }
    } catch (e) {
      emit(UpdateAttendanceErrorState());
    }
  }

  FutureOr<void> editTeacherEvent(
      EditTeacherEvent event, Emitter<TeacherSecondState> emit) {
    emit(EditTeacherSuccessState(teacherData: event.teacherData));
  }

  FutureOr<void> fetchTaskDatasEvent(
      FetchTaskDatasEvent event, Emitter<TeacherSecondState> emit) async {
    emit(FetchTaskLoadingDatas());
    try {
      final bool isTeacher = event.isTeacher;
      final bool isHw = event.isHw;
      final studentId = await DbFunctionsTeacher().getStudentIdFromPrefs();
      final teacherId = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      Stream<QuerySnapshot<Object?>> tasksStream = isHw
          ? DbFunctionsTeacherWork().getHomeWorksDatas(teacherId as String)
          : DbFunctionsTeacherWork().getAssignmentDatas(teacherId as String);
      Stream<QuerySnapshot<Object?>> submittedTaskStream = isHw
          ? isTeacher
              ? DbFunctionsTeacherWork().getSubmittedWorks(
                  teacherId: teacherId, subcollection: 'submitted_homeworks')
              : TasksDbFunctionsStudent().getSubmittedHomeWorks(
                  studentId: studentId as String, teacherId: teacherId)
          : isTeacher
              ? DbFunctionsTeacherWork().getSubmittedWorks(
                  teacherId: teacherId, subcollection: 'submitted_assignments')
              : TasksDbFunctionsStudent().getSubmittedAssignments(
                  studentId: studentId as String, teacherId: teacherId);

      emit(FetchTaskSuccessDatas(
          taskData: tasksStream, submittedTasks: submittedTaskStream));
    } catch (e) {
      emit(FetchTaskErrorDatas());
    }
  }

  FutureOr<void> teacherNoticeEvent(
      TeacherNoticeEvent event, Emitter<TeacherSecondState> emit) async {
    emit(TeacherNoticeLoadingState());
    try {
      final bool isTeacher = event.isTeacher;
      final String? teacherId =
          await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final String? studentId =
          await DbFunctionsTeacher().getStudentIdFromPrefs();
      final bool responce = isTeacher
          ? await TaskTeacherDbFunctions()
              .addEvents(id as String, event.titleOrDate, event.topicOrReason)
          : await TasksDbFunctionsStudent().addLeaveApplicationWork(
              teacherId: teacherId as String,
              date: event.titleOrDate,
              reason: event.topicOrReason,
              name: event.studentName,
              studentId: studentId as String);
      if (responce) {
        emit(TeacherNoticeSuccessState());
      } else {
        emit(TeacherNoticeErrorState());
      }
    } catch (e) {
      emit(TeacherNoticeErrorState());
    }
  }

  FutureOr<void> fetchFormDatasEvent(
      FetchFormDatasEvent event, Emitter<TeacherSecondState> emit) async {
    emit(FetchFormDatasLoadingState());
    try {
      final bool isTeacher = event.isTeacher;
      final String? teacherId =
          await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final String? studentId =
          await DbFunctionsTeacher().getStudentIdFromPrefs();
      Stream<QuerySnapshot<Object?>> formsStream = isTeacher
          ? DbFunctionsTeacherWork().getDatasFromTeacherSubCollection(
              teacherId: id as String, collection: 'events')
          : TasksDbFunctionsStudent().getStudentLeaveDatas(
              teacherId: teacherId as String, studentId: studentId as String);

      emit(FetchFormDatasSuccessDatas(formData: formsStream));
    } catch (e) {
      emit(FetchFormDatasErrorState());
    }
  }

  FutureOr<void> fetchLeaveApplicationsEvent(FetchLeaveApplicationsEvent event,
      Emitter<TeacherSecondState> emit) async {
    emit(FetchLeaveApplicationsLoadingState());
    try {
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      Stream<QuerySnapshot<Object?>> leavesStream = DbFunctionsTeacherWork()
          .getDatasFromTeacherSubCollection(
              teacherId: id as String, collection: 'leave_applications');

      emit(FetchLeaveApplicationsSuccessDatas(leaveData: leavesStream));
    } catch (e) {
      emit(FetchLeaveApplicationsErrorState());
    }
  }

  FutureOr<void> popupMenuButtonEvent(
      PopupMenuButtonEvent event, Emitter<TeacherSecondState> emit) {
    final Options option = event.item;
    if (option == Options.edit) {
      emit(PopupMenuButtonEditState());
    } else {
      emit(PopupMenuButtonDeleteState());
    }
  }

  FutureOr<void> deleteStudentEvent(
      DeleteStudentEvent event, Emitter<TeacherSecondState> emit) async {
    emit(DeleteStudentLoadingState());
    try {
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();

      final bool responce = await DbFunctionsTeacher().deleteSubCollection(
          gender: event.gender,
          email: event.email,
          password: event.password,
          teacherId: id as String,
          studentId: event.studentId);
      if (responce) {
        emit(DeleteStudentSuccessState());
      } else {
        emit(DeleteStudentErrorState());
      }
    } catch (e) {
      emit(DeleteStudentSuccessState());
    }
  }

  FutureOr<void> eventDeleteEvent(
      EventDeleteEvent event, Emitter<TeacherSecondState> emit) async {
    emit(DeleteEventLoadingState());
    try {
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final String? studentId =
          await DbFunctionsTeacher().getStudentIdFromPrefs();
      final bool isTeacher = event.isTeacher;
      final bool resopnse = isTeacher
          ? await TaskTeacherDbFunctions().deleteSubCollection(
              collection: 'teachers',
              collectionId: id as String,
              subCollection: 'events',
              subCollectionId: event.eventId)
          : await StudentLeaveDbFunctions().deleteLeaveApplication(
              teacherId: id as String,
              studntId: studentId as String,
              applicationId: event.eventId,
              studentName: event.studentName as String,
              reason: event.reason as String);
      if (resopnse) {
        emit(DeleteEventSuccessState());
      } else {
        emit(DeleteEventErrorState());
      }
    } catch (e) {
      emit(DeleteEventErrorState());
    }
  }

  FutureOr<void> taskDeleteEvent(
      TaskDeleteEvent event, Emitter<TeacherSecondState> emit) async {
    emit(DeleteEventLoadingState());
    try {
      final bool isHw = event.isHw;
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final bool resopnse = isHw
          ? await TaskTeacherDbFunctions().deleteSubCollection(
              collection: 'teachers',
              collectionId: id as String,
              subCollection: 'home_works',
              subCollectionId: event.taskId)
          : await TaskTeacherDbFunctions().deleteSubCollection(
              collection: 'teachers',
              collectionId: id as String,
              subCollection: 'assignments',
              subCollectionId: event.taskId);
      if (resopnse) {
        emit(DeleteEventSuccessState());
      } else {
        emit(DeleteEventErrorState());
      }
    } catch (e) {
      emit(DeleteEventErrorState());
    }
  }

  FutureOr<void> addANewPaymentEvent(
      AddANewPaymentEvent event, Emitter<TeacherSecondState> emit) async {
    emit(PaymentAddedLoadingState());
    try {
      final response = await PaymentFunctionsTeacher()
          .giveNewPayment(event.paymentModel, event.studentId);
      if (response) {
        emit(PaymentAddedSuccessState());
      } else {
        emit(PaymentAddedErrorState());
      }
    } catch (e) {
      emit(PaymentAddedErrorState());
    }
  }

  FutureOr<void> fetchNewPaymentDataEvent(
      FetchNewPaymentDataEvent event, Emitter<TeacherSecondState> emit) async {
    try {
      emit(FetchNewPaymentDataLoadingState());
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final Stream<QuerySnapshot<Object?>> paymentData = DbFunctionsStudent()
          .getPayment(teacherId: id as String, studentId: event.studentId);
      emit(FetchNewPaymentDataSuccessState(paymentData: paymentData));
    } catch (e) {
      emit(FetchNewPaymentDataErrorState());
    }
  }

  FutureOr<void> offlineFeeEvent(
      OfflineFeeEvent event, Emitter<TeacherSecondState> emit) async {
    emit(OfflineFeeLoadingState());
    try {
      final response = await PaymentFunctionsTeacher()
          .offlinePayment(event.amount, event.studentId);
      if (response) {
        emit(OfflineFeeSuccessState());
      } else {
        emit(OfflineFeeErrorState());
      }
    } catch (e) {
      emit(OfflineFeeErrorState());
    }
  }

  FutureOr<void> fetchOfflineFeeEvent(
      FetchOfflineFeeEvent event, Emitter<TeacherSecondState> emit) async {
    try {
      emit(FetchOfflineFeeLoadingState());
      id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final Stream<QuerySnapshot<Object?>> offlineFeeData = DbFunctionsStudent()
          .getOfflineFee(teacherId: id as String, studentId: event.studentId); 
      emit(FetchOfflineFeeSuccessState(OfflineFeeData: offlineFeeData));
    } catch (e) {
      emit(FetchOfflineFeeErrorState());
    }
  }
}
