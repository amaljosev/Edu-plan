part of 'welcome_bloc.dart';

abstract class WelcomeEvent {}

abstract class WelcomeActionEvent extends WelcomeEvent {}

final class NavigateEvent extends WelcomeActionEvent {}

final class SplashEvent extends WelcomeActionEvent {}

final class TeacherSignInEvent extends WelcomeActionEvent {
  final String email;
  final String password;

  TeacherSignInEvent({required this.email, required this.password});
}

final class StudentSignInEvent extends WelcomeActionEvent {
  final String email;
  final String password;

  StudentSignInEvent({required this.email, required this.password});
}

final class SignUpButtonEvent extends WelcomeActionEvent {
  final TeacherModel teacherData;
  SignUpButtonEvent({required this.teacherData});
}

final class DropdownMenuTapEvent extends WelcomeActionEvent {
  final String? dropdownValue;
  final int onSelected;

  DropdownMenuTapEvent({
    required this.dropdownValue,
    required this.onSelected,
  });
}

final class SplashCompleteEvent extends WelcomeEvent {}

final class TeacherLoginEvent extends WelcomeActionEvent {
  final bool isTeacher;
  TeacherLoginEvent({required this.isTeacher});
}

final class StudentLoginEvent extends WelcomeActionEvent {
  final bool isTeacher;
  StudentLoginEvent({required this.isTeacher});
}

final class UpdateButtonEvent extends WelcomeActionEvent {
  final TeacherModel teacherData;
  UpdateButtonEvent({required this.teacherData});
}

final class PrivacyCheckEvent extends WelcomeActionEvent{
  final bool? isChecked;
  PrivacyCheckEvent({required this.isChecked});
}