import 'package:chatapp/model/chat_screen_arguments.dart';
import 'package:chatapp/screens/chat_details.dart';
import 'package:chatapp/services/database_wrapper.dart';
import 'package:chatapp/utils/login_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ChatScreen extends StatefulWidget {
  static const String routeName = 'chat_screen';

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  ChatArguments args;
  Stream<QuerySnapshot> messageStream;
  TextEditingController textEditingController = TextEditingController();
  DatabaseWrapper databaseWrapper = DatabaseWrapper();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context).settings.arguments;
    messageStream = databaseWrapper.getAllChatMessages(args.chatRoomId);

    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10.0),
          child: GestureDetector(
            onTap: () {
              Navigator.pushNamed(context, ChatDetails.routeName, arguments: args);
            },
            child: Text(args.isGroupChat ? args.chatRoomId : args.peerUserName),
          ),
        ),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
          child: CircleAvatar(
            radius: 10.0,
            backgroundColor: Colors.white,
            // child: Image.asset(isP2PChat? 'assets/images/p2p-icon.png'
            //     :'assets/images/group-icon.png'),
            backgroundImage: AssetImage(args.isGroupChat
                ? 'assets/images/group-icon.png'
                : 'assets/images/p2p-icon.png'),
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            MessageStream(
              messageStream: messageStream,
            ),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: textEditingController,
                      decoration: kMessageTextFieldDecoration,
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                  FlatButton(
                    onPressed: () {
                      final message = textEditingController.text;
                      textEditingController.clear();
                      //Implement send functionality.
                      databaseWrapper.sendMessageToChatRoom(args.chatRoomId, {
                        'message': message,
                        'senderId': LogInUserInfo.userInformation.email,
                        'timestamp': FieldValue.serverTimestamp(),
                      });
                    },
                    child: Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  final Stream<QuerySnapshot> messageStream;

  MessageStream({this.messageStream});

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: messageStream,
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return CircularProgressIndicator();
        }
        List<MessageBubble> messageList = [];
        final messages = snapshot.data.docs.reversed;
        for (var message in messages) {
          String sender = message.data()['senderId'];
          var displayMessage = MessageBubble(
            sender: sender,
            text: message.data()['message'],
            isMe: sender == LogInUserInfo.userInformation.email,
          );
          messageList.add(displayMessage);
        }
        return Expanded(
          child: ListView(
            reverse: true,
            children: messageList,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String text;
  final String sender;
  final bool isMe;

  MessageBubble({this.text, this.sender, this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          // Text(
          //   '$sender',
          //   style: TextStyle(
          //     fontSize: 10.0,
          //   ),
          // ),
          Material(
            color: isMe ? Colors.white : Colors.blueAccent,
            elevation: 5.0,
            borderRadius:
                isMe ? kMessageSelfBorderRadius : kMessagePeerBorderRadius,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                '$text',
                style: TextStyle(
                  color: isMe ? Colors.black54 : Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
