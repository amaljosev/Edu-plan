class ChatModel {
  final String name;
  final String message;
  final DateTime date;
  final String senderId;
  final String receiverId;
  final String gender;
  final bool isTeacher;

  ChatModel(
      {required this.message,
      required this.gender,
      required this.date,
      required this.senderId,
      required this.name,
      required this.receiverId,
      required this.isTeacher});
}
