import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:eduplanapp/models/teacher_model.dart';
import 'package:eduplanapp/repositories/firebase/admin/signup_request.dart';
import 'package:eduplanapp/repositories/firebase/login/login_functions.dart';
import 'package:eduplanapp/repositories/firebase/teacher/db_functions_teacher.dart';

part 'welcome_event.dart';
part 'welcome_state.dart';

SignUpRequest signUpRequest = SignUpRequest();

class WelcomeBloc extends Bloc<WelcomeEvent, WelcomeState> {
  WelcomeBloc() : super(WelcomeInitial()) {
    on<NavigateEvent>(navigate);
    on<TeacherSignInEvent>(teacherSignInEvent);
    on<StudentSignInEvent>(studentSignInEvent);
    on<SignUpButtonEvent>(signUpButtonEvent);
    on<DropdownMenuTapEvent>(dropdownMenuTapEvent);
    on<SplashEvent>(splashEvent);
    on<SplashCompleteEvent>(splashCompleteEvent);
    on<TeacherLoginEvent>(teacherLoginEvent);
    on<StudentLoginEvent>(studentLoginEvent);
    on<UpdateButtonEvent>(updateButtonEvent);
    on<PrivacyCheckEvent>(privacyCheckEvent);
  }
  FutureOr<void> splashEvent(SplashEvent event, Emitter<WelcomeState> emit) {
    emit(SplashState());
  }

  FutureOr<void> navigate(WelcomeEvent event, Emitter<WelcomeState> emit) {
    emit(NavigateToSignUpState());
  }

  FutureOr<void> teacherSignInEvent(
      TeacherSignInEvent event, Emitter<WelcomeState> emit) async {
    emit(TeacherSignInLoadingState());
    try {
      final userExist =
          await LoginFunctions().teacherLogin(event.email, event.password);
      if (userExist) {
        emit(TeacherSignInSuccessState());
      } else {
        emit(TeacherSignInErrorState());
      }
    } catch (e) {
      emit(TeacherSignInErrorState());
    }
  }

  FutureOr<void> studentSignInEvent(
      StudentSignInEvent event, Emitter<WelcomeState> emit) async {
    final userExist =
        await LoginFunctions().studentLogin(event.email, event.password);
    if (userExist) {
      emit(StudentSignInSuccessState());
    } else {
      emit(StudentSignInErrorState());
    }
  }

  FutureOr<void> signUpButtonEvent(
      SignUpButtonEvent event, Emitter<WelcomeState> emit) async {
    emit(SignUpLoadingState());
    try {
      final className =
          event.teacherData.className + event.teacherData.division;
      final classExist =
          await SignUpRequest().checkClass(className, event.teacherData.email);
      if (classExist) {
        emit(SignUpClassErrorState());
      } else {
        emit(SignUpLoadingState());
        final response = await signUpRequest.addData(event.teacherData);
        if (response) {
          emit(SignUpSuccessState());
        } else {
          emit(SignUpErrorState());
        }
      }
    } catch (e) {
      emit(SignUpErrorState());
    }
  }

  FutureOr<void> dropdownMenuTapEvent(
      DropdownMenuTapEvent event, Emitter<WelcomeState> emit) {
    emit(DropdownMenuTapState(
        dropdownValue: event.dropdownValue, index: event.onSelected));
  }

  FutureOr<void> splashCompleteEvent(
      SplashCompleteEvent event, Emitter<WelcomeState> emit) async {
    emit(NewUserState());
  }

  FutureOr<void> teacherLoginEvent(
      TeacherLoginEvent event, Emitter<WelcomeState> emit) {
    emit(TeacherLoginState(isTeacher: event.isTeacher));
  }

  FutureOr<void> studentLoginEvent(
      StudentLoginEvent event, Emitter<WelcomeState> emit) {
    emit(StudentLoginState(isTeacher: event.isTeacher));
  }

  FutureOr<void> updateButtonEvent(
      UpdateButtonEvent event, Emitter<WelcomeState> emit) async {
    emit(TeacherUpdatedLoadingState());
    try {
      final String? id = await DbFunctionsTeacher().getTeacherIdFromPrefs();
      final className =
          event.teacherData.className + event.teacherData.division;
      final classExist = await SignUpRequest().checkClassAlradyExist(className);
      if (classExist) {
        emit(TeacherUpdatedClassExistState());
      } else {
        final bool response = await DbFunctionsTeacher()
            .updateTeacherData(event.teacherData, id as String);
        if (response) {
          emit(TeacherUpdatedSuccessState());
        } else {
          emit(TeacherUpdatedErrorState());
        }
      }
    } catch (e) {
      emit(TeacherUpdatedErrorState());
    }
  }

  FutureOr<void> privacyCheckEvent(
      PrivacyCheckEvent event, Emitter<WelcomeState> emit) {
    emit(PrivacyCheckState(isChecked: event.isChecked));
  }
}
