import 'package:chat_app/model/message.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class ChatService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> sendMessage(String receiverId, String message) async {
    final String currentId = _auth.currentUser!.uid;
    final String currentEmail = _auth.currentUser!.email.toString();
    final Timestamp timestamp = Timestamp.now();

    MessageClass newMessage = MessageClass.fromMap({
      'senderId': currentId,
      'senderEmail': currentEmail,
      'receiverId': receiverId,
      'message': message,
      'timestamp': timestamp,
    });

    List<String> ids = [currentId, receiverId];
    ids.sort();
    String chatRoomId = ids.join("_");
    await _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .add(newMessage.toMap());
    await messagingFirebase(message);
  }

  Future<void> messagingFirebase(String message) async {
    final firebaseMessaging = FirebaseMessaging.instance;
    await firebaseMessaging.requestPermission(); 
    //final fCMToken = await firebaseMessaging.getToken();
  }

  Stream<QuerySnapshot> getMessage(String userId, String otherUserId) {
    List<String> ids = [userId, otherUserId];
    ids.sort();
    String chatRoomId = ids.join("_");

    return _firestore
        .collection('chat_rooms')
        .doc(chatRoomId)
        .collection('messages')
        .orderBy('timestamp', descending: false)
        .snapshots();
  }
}
