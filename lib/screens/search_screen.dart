import 'package:chatapp/constants.dart';
import 'package:chatapp/model/user_information.dart';
import 'package:chatapp/model/chat_screen_arguments.dart';
import 'package:chatapp/screens/conversation_screen.dart';
import 'package:chatapp/screens/create_group_screen.dart';
import 'package:chatapp/services/database_wrapper.dart';
import 'package:chatapp/utils/login_user_info.dart';
import 'package:chatapp/widgets/rounded_button.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

bool enableStreamBuilder = false;
Stream<QuerySnapshot> searchSnapShotStream;
QuerySnapshot searchSnapShot;

class SearchScreen extends StatefulWidget {
  static const String routeName = 'search_screen';

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final textController = TextEditingController();
  final dbWrapper = DatabaseWrapper();

  @override
  void dispose() {
    super.dispose();
    searchSnapShotStream = null;
  }

  initiateSearch() {
    if (enableStreamBuilder) {
      setState(() {
        searchSnapShotStream =
            dbWrapper.fetchUserInfoAsStream(textController.text);
      });
    } else {
      final snapShot = dbWrapper.fetchUserInfo(
          textController.text, LogInUserInfo.userInformation.email);
      snapShot.then((value) {
        setState(() {
          searchSnapShot = value;
        });
      });
    }
  }

  Widget searchList() {
    return searchSnapShot == null
        ? Container()
        : Expanded(
            child: ListView.builder(
                itemCount: searchSnapShot.size,
                itemBuilder: (context, index) {
                  String email = searchSnapShot.docs[index].data()['email'];
                  if (email.compareTo(LogInUserInfo.userInformation.email) ==
                      0) {
                    return Container();
                  }
                  return UserTile(
                    userName: searchSnapShot.docs[index].data()['username'],
                    email: email,
                  );
                }),
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Users'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Color(0x54FFFFFF),
            padding:
                const EdgeInsets.symmetric(vertical: 16.0, horizontal: 24.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    decoration: InputDecoration(
                      hintText: 'User name',
                      border: InputBorder.none,
                    ),
                    // kInputDecoration.copyWith(
                    //   hintText: 'User name',
                    // ),
                    style: kTextStyle,
                  ),
                ),
                SizedBox(
                  width: 10.0,
                ),
                GestureDetector(
                  onTap: () async {
                    initiateSearch();
                  },
                  child: Image.asset(
                    'assets/images/search_white.png',
                    height: 20,
                  ),
                ),
              ],
            ),
          ),
          FlatButton(
            onPressed: () {
              Navigator.pushNamed(context, CreateGroup.routeName);
            },
            child: Text(
              '+ Create Group',
              style: kTextStyle.copyWith(fontSize: 20.0),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          enableStreamBuilder ? SearchStream() : searchList(),
        ],
      ),
    );
  }
}

class SearchStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    if (searchSnapShotStream == null) {
      print('Inside SearchStream, searchStreamSnapShot is NULL');
      return Container();
    } else {
      return StreamBuilder<QuerySnapshot>(
        stream: searchSnapShotStream,
        builder: (context, snapshot) {
          print('Inside Stream Builder, HasData? ${snapshot.hasData}');
          if (!snapshot.hasData) {
            return Container(
              child: CircularProgressIndicator(),
            );
          }
          List<UserTile> users = [];
          final messages = snapshot.data.docs;
          for (var message in messages) {
            final userMap = message.data();
            if (LogInUserInfo.userInformation.email.compareTo(
                    userMap[DatabaseWrapper.DB_EMAIL_KEY].toString()) ==
                0) {
              print('Self User Info received in the search');
              continue;
            }
            users.add(
              UserTile(
                userName: userMap[DatabaseWrapper.DB_USER_NAME_KEY],
                email: userMap[DatabaseWrapper.DB_EMAIL_KEY],
              ),
            );
          }
          return Expanded(
            child: ListView(
              children: users,
            ),
          );
        },
      );
    }
  }
}

class UserTile extends StatelessWidget {
  final String userName;
  final String email;

  UserTile({this.userName, this.email});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey,
      padding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
      child: Row(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            backgroundImage: AssetImage('assets/images/p2p-icon.png'),
          ),
          SizedBox(
            width: 10.0,
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
                  style: kTextStyle,
                ),
                SizedBox(
                  height: 5.0,
                ),
                Text(
                  email,
                  style: kTextStyle,
                ),
              ],
            ),
          ),
          RoundedButton(
            buttonColor: Colors.blue,
            buttonText: 'Message',
            height: 22.0,
            onPressed: () {
              String chatRoomId = '';
              final myUserInfo = LogInUserInfo.userInformation;
              List<String> users = [myUserInfo.userName, userName];
              List<UserInformation> userInfos = [];
              if (userName.compareTo(myUserInfo.userName) >= 0) {
                chatRoomId = '$userName-${myUserInfo.userName}';
              } else {
                chatRoomId = '${myUserInfo.userName}-$userName';
              }
              Map<String, dynamic> chatRoomMap = {
                'roomId': chatRoomId,
                'users': users
              };
              userInfos.add(myUserInfo);
              userInfos.add(UserInformation(userName: userName, email: email));
              ChatArguments args = ChatArguments(
                  chatRoomId: chatRoomId,
                  peerUserName: userName,
                  peerEmail: email,
                  userInfos: userInfos);
              DatabaseWrapper().createChatRoom(chatRoomId, chatRoomMap);
              Navigator.pushReplacementNamed(context, ChatScreen.routeName,
                  arguments: args);
            },
          ),
        ],
      ),
    );
  }
}
