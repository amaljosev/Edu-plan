import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/repositories/firebase/teacher/fee/payment_remainder_functions.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/firebase/student/db_functions_student.dart';
import 'package:eduplanapp/repositories/firebase/student/tasks_functions.dart';
import 'package:eduplanapp/repositories/firebase/teacher/db_functions_teacher.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

part 'student_event.dart';
part 'student_state.dart';

class StudentBloc extends Bloc<StudentEvent, StudentState> {
  StudentBloc() : super(StudentInitial()) {
    on<StudentBottomNavigationEvent>(bottomNavigationEvent);
    on<StudentActionsEvent>(studentActionsEvent);
    on<FetchStudentDataEvent>(fetchStudentDataEvent);
    on<FetchEventsDataEvent>(fetchEventsDataEvent);
    on<SubmitWorkEvent>(submitWorkEvent);
    on<LoadingEvent>(loadingEvent);
    on<FileUploadedEvent>(fileUploadedEvent);
    on<LogOutEvent>(logOutEvent);
    on<DeleteTaskEvent>(deleteTaskEvent);
    on<SelectFileEvent>(selectFileEvent);
    on<UploadFileEvent>(uploadFileEvent);
    on<DeletePickedImage>(deletePickedImage);
    on<FetchPaymentDataEvent>(fetchPaymentDataEvent);
    on<RazorPaySuccessEvent>(razorPaySuccessEvent);
    on<RazorPayErrorEvent>(razorPayErrorEvent);
    on<RazorPayWalletEvent>(razorPayWalletEvent);
  }

  FutureOr<void> bottomNavigationEvent(
      StudentBottomNavigationEvent event, Emitter<StudentState> emit) {
    emit(
        StudentBottomNavigationState(currentPageIndex: event.currentPageIndex));
  }

  FutureOr<void> studentActionsEvent(
      StudentActionsEvent event, Emitter<StudentState> emit) async {
    final teacherId = await DbFunctionsTeacher().getTeacherIdFromPrefs();
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('attendance')
        .get();
    final DocumentSnapshot classDoc = querySnapshot.docs.first;
    int totalWorkingDays = classDoc.get('toatal_working_days_completed');
    emit(StudentActionsState(
        index: event.index,
        name: event.name,
        studentsMap: event.studentsMap,
        totalWorkingDaysCompleted: totalWorkingDays));
  }

  FutureOr<void> fetchStudentDataEvent(
      FetchStudentDataEvent event, Emitter<StudentState> emit) async {
    final studentId = await DbFunctionsTeacher().getStudentIdFromPrefs();
    final teacherId = await DbFunctionsTeacher().getTeacherIdFromPrefs();
    final Stream<DocumentSnapshot<Object?>> studentstream = DbFunctionsStudent()
        .getStudentsDatas(teacherId as String, studentId as String);
    final QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('teachers')
        .doc(teacherId)
        .collection('attendance')
        .get();
    final DocumentSnapshot classDoc = querySnapshot.docs.first;
    int totalWorkingDays = classDoc.get('toatal_working_days_completed');
    emit(FetchStudentDatasSuccessState(
        studentstream: studentstream,
        studentId: studentId,
        totalWorkingDaysCompleted: totalWorkingDays));
  }

  FutureOr<void> fetchEventsDataEvent(
      FetchEventsDataEvent event, Emitter<StudentState> emit) async {
    emit(FetchEventsDatasLoadingState());
    try {
      final String? teacherId =
          await DbFunctionsTeacher().getTeacherIdFromPrefs();
      Stream<QuerySnapshot<Object?>> eventsStream = TasksDbFunctionsStudent()
          .getEventsDatas(teacherId: teacherId as String, collection: 'events');

      emit(FetchEventsDatasSuccessDatas(eventsData: eventsStream));
    } catch (e) {
      emit(FetchEventsDatasErrorState());
    }
  }

  FutureOr<void> submitWorkEvent(
      SubmitWorkEvent event, Emitter<StudentState> emit) async {
    emit(SubmitWorkLoadingState());
    try {
      final studentId =
          await DbFunctionsTeacher().getStudentIdFromPrefs() as String;
      final teacherId =
          await DbFunctionsTeacher().getTeacherIdFromPrefs() as String;
      final bool isHw = event.isHw;
      final bool resopnse = isHw
          ? await TasksDbFunctionsStudent().submitHomeWork(
              topic: event.topic,
              teacherId: teacherId,
              note: event.note,
              subject: event.subject,
              name: event.name,
              imageUrlsList: event.imageUrlList,
              studentId: studentId)
          : await TasksDbFunctionsStudent().submitAssignment(
              topic: event.topic,
              teacherId: teacherId,
              note: event.note,
              subject: event.subject,
              name: event.name,
              imageUrlsLiist: event.imageUrlList,
              studentId: studentId);
      if (resopnse) {
        emit(SubmitWorkSuccessState());
      } else {
        emit(SubmitWorkErrorState());
      }
    } catch (e) {
      emit(SubmitWorkErrorState());
    }
  }

  FutureOr<void> loadingEvent(LoadingEvent event, Emitter<StudentState> emit) {
    emit(LoadingState(isCompleted: event.isCompleted));
  }

  FutureOr<void> fileUploadedEvent(
      FileUploadedEvent event, Emitter<StudentState> emit) {
    emit(FileUploadedState(imageUrl: event.imageUrl));
  }

  FutureOr<void> logOutEvent(LogOutEvent event, Emitter<StudentState> emit) {
    emit(LogOutState());
  }

  FutureOr<void> deleteTaskEvent(
      DeleteTaskEvent event, Emitter<StudentState> emit) async {
    emit(DeleteTaskLoadingState());
    final studentId =
        await DbFunctionsTeacher().getStudentIdFromPrefs() as String;
    final teacherId =
        await DbFunctionsTeacher().getTeacherIdFromPrefs() as String;
    final bool isHw = event.isHw;
    final bool resopnse = isHw
        ? await TasksDbFunctionsStudent().deleteStudentTask(
            note: event.note,
            studentName: event.studentName,
            teacherId: teacherId,
            studentId: studentId,
            collection: 'submitted_homeworks',
            taskId: event.taskId)
        : await TasksDbFunctionsStudent().deleteStudentTask(
            note: event.note,
            studentName: event.studentName,
            teacherId: teacherId,
            studentId: studentId,
            collection: 'submitted_assignments',
            taskId: event.taskId);

    if (resopnse) {
      emit(DeleteTaskSucessState());
    } else {
      emit(DeleteTaskErrorState());
    }
  }

  FutureOr<void> selectFileEvent(
      SelectFileEvent event, Emitter<StudentState> emit) {
    emit(SelectFileState(platformFiles: event.platformFiles));
  }

  FutureOr<void> uploadFileEvent(
      UploadFileEvent event, Emitter<StudentState> emit) {
    emit(UploadFileSuccessState(
        isComplete: event.isComplete, uploadTask: event.uploadTask));
  }

  FutureOr<void> deletePickedImage(
      DeletePickedImage event, Emitter<StudentState> emit) {
    emit(DeletePickedImageState(index: event.index));
  }

  FutureOr<void> fetchPaymentDataEvent(
      FetchPaymentDataEvent event, Emitter<StudentState> emit) async {
    emit(FetchPaymentDataLoadingState());
    try {
      final String? teacherId =
          await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final studentId =
          await DbFunctionsTeacher().getStudentIdFromPrefs() as String;
      Stream<QuerySnapshot<Object?>> paymentStream = DbFunctionsStudent()
          .getPayment(studentId: studentId, teacherId: teacherId as String);
      Stream<QuerySnapshot<Object?>> feeStream = DbFunctionsStudent()
          .getFeeDetails(studentId: studentId, teacherId: teacherId);
      emit(FetchPaymentDataSuccessState(
          PaymentData: paymentStream, feeData: feeStream));
    } catch (e) {
      emit(FetchPaymentDataErrorState());
    }
  }

  FutureOr<void> razorPaySuccessEvent(
      RazorPaySuccessEvent event, Emitter<StudentState> emit) async {
    try {
      final studentId =
          await DbFunctionsTeacher().getStudentIdFromPrefs() as String;
      await PaymentFunctionsTeacher()
          .updatePayment(studentId, event.paymentId, event.note, event.amount);
      emit(PaymentSuccessState(response: event.response));
    } catch (e) {
      log('$e');
    }
  }

  FutureOr<void> razorPayErrorEvent(
      RazorPayErrorEvent event, Emitter<StudentState> emit) {
    emit(PaymentErrorState(response: event.response));
  }

  FutureOr<void> razorPayWalletEvent(
      RazorPayWalletEvent event, Emitter<StudentState> emit) {
    emit(PaymentWalletState(response: event.response));
  }
}
