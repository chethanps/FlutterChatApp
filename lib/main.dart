import 'package:chatapp/screens/chat_details.dart';
import 'package:chatapp/screens/conversation_screen.dart';
import 'package:chatapp/screens/create_group_screen.dart';
import 'package:chatapp/screens/search_screen.dart';
import 'package:chatapp/screens/signin_screen.dart';
import 'package:chatapp/screens/signup_screen.dart';
import 'package:chatapp/screens/timeline_screen.dart';
import 'package:chatapp/utils/login_user_info.dart';
import 'package:chatapp/utils/shared_preference.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'model/user_information.dart';

bool userLoggedIn = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  bool loggedIn = await SharedPreferenceStore.instance.getLoginStatus();
  UserInformation userInformation =
      await SharedPreferenceStore.instance.getUserInformation();
  if (loggedIn != null && loggedIn) {
    LogInUserInfo.userInformation = userInformation;
    userLoggedIn = true;
  }
  runApp(ChatApp());
}

class ChatApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        SignIn.routeName: (context) => SignIn(),
        SignUp.routeName: (context) => SignUp(),
        TimeLine.routeName: (context) => TimeLine(),
        SearchScreen.routeName: (context) => SearchScreen(),
        ChatScreen.routeName: (context) => ChatScreen(),
        CreateGroup.routeName: (context) => CreateGroup(),
        ChatDetails.routeName: (context) => ChatDetails(),
      },
      initialRoute: userLoggedIn ? TimeLine.routeName : SignIn.routeName,
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.blueGrey),
          primaryColor: Color(0xFF145C9E),
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
          scaffoldBackgroundColor: Color(0xFF1F1F1F),
          inputDecorationTheme: InputDecorationTheme(
            hintStyle: TextStyle(color: Colors.white54),
          )),
      debugShowCheckedModeBanner: false,
    );
  }
}
