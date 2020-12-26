import 'package:chatapp/model/user_information.dart';
import 'package:chatapp/model/chat_screen_arguments.dart';
import 'package:chatapp/services/database_wrapper.dart';
import 'package:chatapp/utils/login_user_info.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

import '../constants.dart';
import 'conversation_screen.dart';

bool enableStreamBuilder = false;
Stream<QuerySnapshot> searchSnapShotStream;
QuerySnapshot searchSnapShot;
List<UserInformation> selectedUsers = [];

class CreateGroup extends StatefulWidget {
  static const String routeName = "create_group_screen";

  @override
  _CreateGroupState createState() => _CreateGroupState();
}

class _CreateGroupState extends State<CreateGroup> {
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

  isUserSelected(String userName) {
    var data = selectedUsers.where((element) => element.userName == userName);
    if (data.length >= 1) {
      return true;
    }
    return false;
  }

  Widget searchList() {
    return searchSnapShot == null
        ? Container()
        : Expanded(
            child: ListView.builder(
                itemCount: searchSnapShot.size,
                itemBuilder: (context, index) {
                  String email = searchSnapShot.docs[index].data()['email'];
                  String userName =
                      searchSnapShot.docs[index].data()['username'];
                  if (email.compareTo(LogInUserInfo.userInformation.email) ==
                      0) {
                    return Container();
                  }
                  return UserTile(
                    userName: userName,
                    email: email,
                    isChecked: isUserSelected(userName),
                    onCheckCallback: (value) {
                      if (value) {
                        selectedUsers.add(
                            UserInformation(userName: userName, email: email));
                      } else {
                        selectedUsers.removeWhere(
                            (element) => element.userName == userName);
                      }
                      setState(() {});
                    },
                  );
                }),
          );
  }

  Widget selectedUserList() {
    return selectedUsers.isEmpty
        ? Container()
        : Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Selected Users',
                  style: kTextStyle.copyWith(fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                  height: 55,
                  child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: selectedUsers.length,
                      itemBuilder: (context, index) {
                        String userName = selectedUsers[index].userName;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5.0),
                          child: Column(
                            children: [
                              CircleAvatar(
                                radius: 20.0,
                                child: Text(userName.substring(0, 1)),
                              ),
                              Text(
                                userName,
                                style: TextStyle(
                                    fontSize: 10.0, color: Colors.white),
                              ),
                            ],
                          ),
                        );
                      }),
                ),
              ],
            ),
          );
  }

  createChatRoom(String chatRoomId) {
    final myUserInfo = LogInUserInfo.userInformation;
    List<String> users = [myUserInfo.userName];

    for (var user in selectedUsers) {
      users.add(user.userName);
    }

    Map<String, dynamic> chatRoomMap = {'roomId': chatRoomId, 'users': users};
    selectedUsers.insert(0, myUserInfo);
    ChatArguments args = ChatArguments(
        chatRoomId: chatRoomId, isGroupChat: true, userInfos: selectedUsers);

    DatabaseWrapper().createChatRoom(chatRoomId, chatRoomMap);
    Navigator.pushReplacementNamed(context, ChatScreen.routeName, arguments: args);
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController roomNameController = TextEditingController();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text('Create Group'),
        actions: [
          GestureDetector(
            onTap: () {
              if (selectedUsers.length < 2) {
                Fluttertoast.showToast(
                    msg: 'Select minimum 2 peers to create a group');
                print('Select minimum 2 peers to create a group');
                return;
              }
              showModalBottomSheet(
                isScrollControlled: true,
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('Enter the Room name'),
                  content: SingleChildScrollView(
                    child: TextField(
                      controller: roomNameController,
                      decoration: InputDecoration(
                          hintText: 'Room Name',
                          hintStyle: TextStyle(color: Colors.white)),
                    ),
                  ),
                  actions: [
                    Row(
                      children: [
                        TextButton(
                          child: Text('Cancel'),
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                        ),
                        TextButton(
                          child: Text('Approve'),
                          onPressed: () {
                            String roomName = roomNameController.text;
                            print('Room Name is $roomName');
                            Navigator.of(context).pop();
                            createChatRoom(roomName);
                          },
                        ),
                      ],
                    )
                  ],
                ),
              );
              // Navigator.pushReplacementNamed(context, SignIn.id);
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  CircleAvatar(
                    backgroundImage:
                        AssetImage('assets/images/right_arrow.png'),
                    maxRadius: 12.0,
                  ),
                  Text('Next'),
                ],
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
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
          SizedBox(
            height: 5.0,
          ),
          selectedUserList(),
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
  final bool isChecked;
  final Function onCheckCallback;

  UserTile({this.userName, this.email, this.isChecked, this.onCheckCallback});

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
          Checkbox(
            value: isChecked,
            onChanged: onCheckCallback,
          ),
        ],
      ),
    );
  }
}
