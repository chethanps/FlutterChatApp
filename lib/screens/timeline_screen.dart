import 'package:chatapp/constants.dart';
import 'package:chatapp/model/user_information.dart';
import 'package:chatapp/model/chat_screen_arguments.dart';
import 'package:chatapp/screens/conversation_screen.dart';
import 'package:chatapp/screens/search_screen.dart';
import 'package:chatapp/screens/signin_screen.dart';
import 'package:chatapp/services/auth_wrapper.dart';
import 'package:chatapp/services/database_wrapper.dart';
import 'package:chatapp/utils/login_user_info.dart';
import 'package:chatapp/utils/shared_preference.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeLine extends StatefulWidget {
  static const String routeName = 'timeline_screen';

  @override
  _TimeLineState createState() => _TimeLineState();
}

class _TimeLineState extends State<TimeLine> {
  final _authMethods = AuthWrapper.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TimeLine'),
        actions: [
          GestureDetector(
            onTap: () {
              SharedPreferenceStore.instance.setLoginStatus(false);
              _authMethods.signOut();
              Navigator.pushReplacementNamed(context, SignIn.routeName);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.exit_to_app),
            ),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            UserAccountsDrawerHeader(
              accountName: Text(LogInUserInfo.userInformation.userName),
              accountEmail: Text(LogInUserInfo.userInformation.email),
              currentAccountPicture: CircleAvatar(
                backgroundImage: AssetImage('assets/images/avatar.png'),
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            ChatRoomsStream(),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.search),
        onPressed: () {
          Navigator.pushNamed(context, SearchScreen.routeName);
        },
      ),
    );
  }
}

class ChatRoomsStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: getMessageTitles(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Container();
        }
        List<ChatRoomTile> roomList = [];
        int counter = 0;
        final messages = snapshot.data.docs;
        for (var message in messages) {
          List<UserInformation> userInfos = [];
          String peerUserName = 'User Name';
          String chatRoomId = message.data()['roomId'];
          final List usersList = message.data()['users'];
          bool isP2PChat = false;
          if (usersList.length == 2) {
            isP2PChat = true;
            for (var userName in usersList) {
              if (LogInUserInfo.userInformation.userName != userName) {
                peerUserName = userName;
              }
            }
          }

          userInfos.add(LogInUserInfo.userInformation);
          for (var userName in usersList) {
            if (LogInUserInfo.userInformation.userName != userName) {
              //TODO: Fetch the UserEmail details
              userInfos.add(UserInformation(userName: userName));
            }
          }

          Color tileColor;
          if (counter % 2 == 0) {
            tileColor = Colors.grey.shade600;
          } else {
            tileColor = Colors.grey.shade800;
          }
          counter++;
          var roomMessage = ChatRoomTile(
            chatRoomId: chatRoomId,
            peerUserName: peerUserName,
            isP2PChat: isP2PChat,
            tileColor: tileColor,
            usersInfos: userInfos,
          );
          roomList.add(roomMessage);
        }
        return Expanded(
          child: ListView(
            children: roomList,
          ),
        );
      },
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String chatRoomId;
  final String peerUserName;
  final bool isP2PChat;
  final Color tileColor;
  final List<UserInformation> usersInfos;

  ChatRoomTile(
      {this.chatRoomId,
      this.peerUserName,
      this.isP2PChat,
      this.tileColor,
      this.usersInfos});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      tileColor: tileColor,
      leading: CircleAvatar(
        radius: 20.0,
        backgroundColor: Colors.white,
        // child: Image.asset(isP2PChat? 'assets/images/p2p-icon.png'
        //     :'assets/images/group-icon.png'),
        backgroundImage: AssetImage(isP2PChat
            ? 'assets/images/p2p-icon.png'
            : 'assets/images/group-icon.png'),
      ),
      title: Text(isP2PChat ? peerUserName : chatRoomId,
          style: kTextStyle.copyWith(fontSize: 20.0)),
      onTap: () {
        Navigator.pushNamed(context, ChatScreen.routeName,
            arguments: ChatArguments(
                chatRoomId: chatRoomId,
                peerUserName: peerUserName,
                isGroupChat: !isP2PChat,
                userInfos: usersInfos));
      },
    );
  }
}

getMessageTitles() {
  print('Inside getMessageTitles');
  return DatabaseWrapper()
      .getAllChatRooms(LogInUserInfo.userInformation.userName);
}
