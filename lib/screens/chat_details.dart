import 'package:chatapp/model/chat_screen_arguments.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../constants.dart';

class ChatDetails extends StatelessWidget {
  static const String routeName = 'chat_details_screen';

  @override
  Widget build(BuildContext context) {
    ChatArguments args = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text('Group Chat Details'),
        centerTitle: true,
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Chat Settings Container',
                  style: TextStyle(
                      fontSize: 16.0,
                      color: Colors.white,
                      fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  height: 10.0,
                ),
                CircleAvatar(
                  radius: 50.0,
                  child: Text('To be Done'),
                ),
                SizedBox(
                  height: 20,
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: args.userInfos.length,
              itemBuilder: (context, index) {
                String userName = args.userInfos[index].userName;
                String email = args.userInfos[index].email;
                Color tileColor = (index % 2 == 0)
                    ? Colors.grey.shade600
                    : Colors.grey.shade800;
                return Container(
                  color: tileColor,
                  padding:
                      EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
                  child: Row(
                    // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CircleAvatar(
                        backgroundColor: Colors.grey,
                        backgroundImage:
                            AssetImage('assets/images/p2p-icon.png'),
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
                              email == null ? 'TBD' : email,
                              style: kTextStyle,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
