import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/repositories/firebase/admin/admin_db_functions.dart';
import 'package:eduplanapp/repositories/firebase/database_functions.dart';

part 'admin_event.dart';
part 'admin_state.dart';

class AdminBloc extends Bloc<AdminEvent, AdminState> {
  AdminBloc() : super(AdminInitial()) {
    on<StudentCardTapEvent>(studentCardTapEvent);
    on<TeacherCardTapEvent>(teacherCardTapEvent);
    on<RequestTapEvent>(requestTapEvent);
    on<FloatingActionButtonTapEvent>(floatingActionButtonTapEvent);
    on<LogOutEvent>(logOutEvent);
    on<ShowDeleteAlertEvent>(showDeleteAlertEvent);
    on<DeleteTeacherEvent>(deleteTeacherEvent);
  }

  FutureOr<void> studentCardTapEvent(
      StudentCardTapEvent event, Emitter<AdminState> emit) {
    final Stream<QuerySnapshot<Object?>> studentList =
        AdminDb().getStudentsDatas(event.teacherId);
    emit(StudentCardTapState(
        studentList: studentList,
        standard: event.standard,
        division: event.division));
  }

  FutureOr<void> teacherCardTapEvent(
      TeacherCardTapEvent event, Emitter<AdminState> emit) {
    emit(TeacherCardTapState(
        teacherData: event.teacherData, teacherId: event.teacherId));
  }

  FutureOr<void> requestTapEvent(
      RequestTapEvent event, Emitter<AdminState> emit) {
    emit(RequestTapState());
  }

  FutureOr<void> floatingActionButtonTapEvent(
      FloatingActionButtonTapEvent event, Emitter<AdminState> emit) {
    emit(SettingsState());
  }

  FutureOr<void> logOutEvent(LogOutEvent event, Emitter<AdminState> emit) {
    emit(LogOutState());
  }

  FutureOr<void> showDeleteAlertEvent(
      ShowDeleteAlertEvent event, Emitter<AdminState> emit) {
    emit(ShowDialogState());
  }

  FutureOr<void> deleteTeacherEvent(
      DeleteTeacherEvent event, Emitter<AdminState> emit) async {
    emit(DeleteTeacherLoadingState());
    final bool response = await DbFunctions().deleteCollection(
        collection: 'teachers', collectionId: event.teacherId);
    if (response) {
      emit(DeleteTeacherSuccessState());
    } else {
      emit(DeleteTeacherErrorState());
    }
  }
}
