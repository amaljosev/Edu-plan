part of 'student_bloc.dart';

abstract class StudentState {}

abstract class StudentActionState extends StudentState {}

final class StudentInitial extends StudentState {}

final class StudentBottomNavigationState extends StudentActionState {
  final int currentPageIndex;
  StudentBottomNavigationState({required this.currentPageIndex});
}

final class StudentActionsState extends StudentActionState {
  final int index;
  final String name;
  final int totalWorkingDaysCompleted;
  final Map<String, dynamic>? studentsMap;
  StudentActionsState(
      {required this.index,
      required this.name,
      required this.totalWorkingDaysCompleted,
      required this.studentsMap});
}

final class FetchStudentDatasSuccessState extends StudentActionState {
  final Stream<DocumentSnapshot<Object?>> studentstream;
  final String studentId;
  final int totalWorkingDaysCompleted;
  FetchStudentDatasSuccessState(
      {required this.studentstream,
      required this.studentId,
      required this.totalWorkingDaysCompleted});
}

final class FetchEventsDatasSuccessDatas extends StudentActionState {
  final Stream<QuerySnapshot<Object?>> eventsData;
  FetchEventsDatasSuccessDatas({required this.eventsData});
}

final class FetchEventsDatasLoadingState extends StudentActionState {}

final class FetchEventsDatasErrorState extends StudentActionState {}

final class SubmitWorkSuccessState extends StudentActionState {}

final class SubmitWorkLoadingState extends StudentActionState {}

final class SubmitWorkErrorState extends StudentActionState {}

final class LoadingState extends StudentActionState {
  final bool isCompleted;
  LoadingState({required this.isCompleted});
}

final class FileUploadedState extends StudentActionState {
  final String imageUrl;
  FileUploadedState({required this.imageUrl});
}

final class LogOutState extends StudentActionState {}

final class DeleteTaskSucessState extends StudentActionState {}

final class DeleteTaskErrorState extends StudentActionState {}

final class DeleteTaskLoadingState extends StudentActionState {}

final class UploadFileSuccessState extends StudentActionState {
  final bool isComplete;
  final UploadTask uploadTask;
  UploadFileSuccessState({required this.isComplete,required this.uploadTask});  
}

final class UploadFileLoadingState extends StudentActionState {}

final class UploadFileErrorState extends StudentActionState {}

final class SelectFileState extends StudentActionState {
   final List<PlatformFile> platformFiles;
  SelectFileState({required this.platformFiles}); 
}
final class DeletePickedImageState extends StudentActionState {
   final int index;
  DeletePickedImageState({required this.index}); 
}