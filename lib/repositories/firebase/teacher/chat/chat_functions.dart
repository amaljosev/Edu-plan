import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eduplanapp/models/chat_model.dart';

class ChatFunctions {
  Future<bool> sendMessage(ChatModel data) async {
    try {
      Map<String, dynamic> chatData = {
        'student_name': data.name,
        'message': data.message,
        'sender_id': data.senderId,
        'receiver_id':data.receiverId,
        'is_teacher':data.isTeacher,
        'date': data.date
      };
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(data.receiverId)
          .set({
        'name': data.name,
        'gender': data.gender,
        'date': DateTime.now()
      });
      await FirebaseFirestore.instance
          .collection('chat')
          .doc(data.receiverId)
          .collection(data.name)
          .doc()
          .set(chatData);
      return true;
    } catch (e) {
      return false;
    }
  }

  final CollectionReference chatCollection =
      FirebaseFirestore.instance.collection('chat');

  Stream<QuerySnapshot> getMessages() {
    final chatsStream = chatCollection.snapshots();
    return chatsStream;
  }

  Stream<QuerySnapshot<Object?>> getStudentChat(
      String teacherId, String studentName) {
    final CollectionReference studentCollection = FirebaseFirestore.instance
        .collection('chat')
        .doc(teacherId)
        .collection(studentName);
    final studentsStream = studentCollection.snapshots();
    return studentsStream;
  }
}
