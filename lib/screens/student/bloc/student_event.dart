part of 'student_bloc.dart';

abstract class StudentEvent {}

abstract class StudentActionEvent extends StudentEvent {}

final class StudentBottomNavigationEvent extends StudentActionEvent {
  final int currentPageIndex;
  StudentBottomNavigationEvent({required this.currentPageIndex});
}

final class StudentActionsEvent extends StudentActionEvent {
  final int index;
  final String name;
  final Map<String, dynamic>? studentsMap;
  StudentActionsEvent(
      {required this.index, required this.name, required this.studentsMap});
}

final class FetchStudentDataEvent extends StudentActionEvent {}

final class FetchEventsDataEvent extends StudentActionEvent {}

final class SubmitWorkEvent extends StudentActionEvent {
  final String subject;
  final String note;
  final String name;
  final bool isHw;
  final String topic;
  final List<String> imageUrlList;
  SubmitWorkEvent(
      {required this.subject,
      required this.note,
      required this.name,
      required this.isHw,
      required this.imageUrlList,
      required this.topic});
}

final class LoadingEvent extends StudentActionEvent {
  final bool isCompleted;
  LoadingEvent({required this.isCompleted});
}

final class FileUploadedEvent extends StudentActionEvent {
  final String imageUrl;
  FileUploadedEvent({required this.imageUrl});
}

final class LogOutEvent extends StudentActionEvent {}

final class DeleteTaskEvent extends StudentActionEvent {
  final String taskId;
  final String note;
  final String studentName;
  final bool isHw;
  DeleteTaskEvent(
      {required this.taskId,
      required this.isHw,
      required this.note,
      required this.studentName});
}

final class SelectFileEvent extends StudentActionEvent {
  final List<PlatformFile> platformFiles;
  SelectFileEvent({required this.platformFiles});
}

final class UploadFileEvent extends StudentActionEvent {
  final UploadTask uploadTask;
  final bool isComplete;
  UploadFileEvent({required this.isComplete, required this.uploadTask});
}

final class DeletePickedImage extends StudentActionEvent {
  final int index;
  DeletePickedImage({required this.index});
}
