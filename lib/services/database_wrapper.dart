import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseWrapper {
  static const DB_CHAT_ROOM_COLLECTION_NAME = 'chatrooms';
  static const DB_USER_COLLECTION_NAME = 'users';
  static const DB_USER_NAME_KEY = 'username';
  static const DB_EMAIL_KEY = 'email';

  final _firebaseFirestore = FirebaseFirestore.instance;

  uploadUserInfo({String userName, String email}) {
    final data = {DB_USER_NAME_KEY: userName, DB_EMAIL_KEY: email};
    _firebaseFirestore.collection(DB_USER_COLLECTION_NAME).add(data);
  }

  Future<QuerySnapshot> fetchUserInfo(String userName, String myEmailId) async {
    return _firebaseFirestore
        .collection(DB_USER_COLLECTION_NAME)
        .where(DB_USER_NAME_KEY, isGreaterThanOrEqualTo: userName)
        .where(DB_USER_NAME_KEY, isLessThan: userName + 'z')
        .get();
  }

  Stream<QuerySnapshot> fetchUserInfoAsStream(String userName) {
    return _firebaseFirestore
        .collection(DB_USER_COLLECTION_NAME)
        .where(DB_USER_NAME_KEY, isGreaterThanOrEqualTo: userName)
        .where(DB_USER_NAME_KEY, isLessThan: userName + 'z')
        .snapshots();
  }

  createChatRoom(String chatRoomId, chatRoomMap) {
    _firebaseFirestore
        .collection(DB_CHAT_ROOM_COLLECTION_NAME)
        .doc(chatRoomId)
        .set(chatRoomMap)
        .catchError((e) {
      print('createChatRoom failed with exception $e');
      return false;
    });
    return true;
  }

  sendMessageToChatRoom(String chatRoomId, messageMap) {
    _firebaseFirestore
        .collection(DB_CHAT_ROOM_COLLECTION_NAME)
        .doc(chatRoomId)
        .collection('chats')
        .add(messageMap)
        .catchError(
            (e) => print('sendMessageToChatRoom failed with exception $e'));
  }

  Stream<QuerySnapshot> getAllChatMessages(String chatRoomId) {
    return _firebaseFirestore
        .collection(DB_CHAT_ROOM_COLLECTION_NAME)
        .doc(chatRoomId)
        .collection('chats')
        .orderBy("timestamp")
        .snapshots();
  }

  Stream<QuerySnapshot> getAllChatRooms(String email) {
    return _firebaseFirestore
        .collection(DB_CHAT_ROOM_COLLECTION_NAME)
        .where("users", arrayContains: email)
        .snapshots();
  }
}
