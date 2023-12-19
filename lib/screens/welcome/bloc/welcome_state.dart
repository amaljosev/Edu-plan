part of 'welcome_bloc.dart';

abstract class WelcomeState {}

abstract class WelcomeActionState extends WelcomeState {}

final class WelcomeInitial extends WelcomeState {}

final class SplashState extends WelcomeState {}

final class NavigateToSignUpState extends WelcomeActionState {}

final class SignUpLoadingState extends WelcomeActionState {}

final class SignUpSuccessState extends WelcomeActionState {}

final class SignUpErrorState extends WelcomeActionState {}

final class SignUpClassErrorState extends WelcomeActionState {}

final class TeacherSignInSuccessState extends WelcomeActionState {}

final class TeacherSignInLoadingState extends WelcomeActionState {}

final class TeacherSignInErrorState extends WelcomeActionState {}

final class StudentSignInSuccessState extends WelcomeActionState {}

final class StudentSignInErrorState extends WelcomeActionState {}

final class DropdownMenuTapState extends WelcomeActionState {
  final String? dropdownValue;
  final int index;

  DropdownMenuTapState({
    required this.dropdownValue,
    required this.index,
  });
}

final class LoginCompletedState extends WelcomeActionState {}

final class AdminLoginState extends WelcomeActionEvent {}

final class NewUserState extends WelcomeActionState {}

final class ToHomeState extends WelcomeActionState {}

final class TeacherLoginState extends WelcomeActionState {
  final bool isTeacher;
  TeacherLoginState({required this.isTeacher});
}

final class StudentLoginState extends WelcomeActionState {
  final bool isTeacher;
  StudentLoginState({required this.isTeacher});
}

final class TeacherUpdatedSuccessState extends WelcomeActionState {}

final class TeacherUpdatedLoadingState extends WelcomeActionState {}

final class TeacherUpdatedErrorState extends WelcomeActionState {}

final class TeacherUpdatedClassExistState extends WelcomeActionState {}

final class PrivacyCheckState extends WelcomeActionState {
  final bool? isChecked;
  PrivacyCheckState({required this.isChecked});
}
