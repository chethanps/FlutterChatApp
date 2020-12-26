import 'user_information.dart';

class ChatArguments {
  String chatRoomId;
  String peerUserName;
  String peerEmail;
  bool isGroupChat;
  List<UserInformation> userInfos;

  ChatArguments(
      {this.chatRoomId,
      this.peerUserName,
      this.peerEmail,
      this.isGroupChat = false,
      this.userInfos});
}
