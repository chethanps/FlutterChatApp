import 'package:chatapp/model/user_information.dart';
import 'package:chatapp/screens/signup_screen.dart';
import 'package:chatapp/screens/timeline_screen.dart';
import 'package:chatapp/services/auth_wrapper.dart';
import 'package:chatapp/utils/form_utils.dart';
import 'package:chatapp/utils/login_user_info.dart';
import 'package:chatapp/utils/shared_preference.dart';
import 'package:chatapp/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class SignIn extends StatefulWidget {
  static const String routeName = 'sign_in_screen';

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool _isWaiting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(title: Text('chatapp')),
      body: ModalProgressHUD(
        inAsyncCall: _isWaiting,
        child: Container(
          alignment: Alignment.bottomCenter,
          padding: EdgeInsets.symmetric(horizontal: 24.0),
          //Column is wrapped inside scroll view to avoid bottom inset overload error.
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisSize: MainAxisSize.min,
              children: [
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: emailController,
                        validator: FormUtils.validateEmail,
                        style: kTextStyle,
                        decoration:
                            kInputDecoration.copyWith(hintText: 'email'),
                      ),
                      TextFormField(
                        controller: passwordController,
                        validator: FormUtils.validatePassword,
                        obscureText: true,
                        style: kTextStyle,
                        decoration:
                            kInputDecoration.copyWith(hintText: 'password'),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  alignment: Alignment.centerRight,
                  child: Container(
                    child: Text(
                      'Forgot password?',
                      style: kTextStyle,
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                RoundedButton(
                  buttonColor: Colors.blueAccent,
                  buttonText: 'Sign In',
                  minWidth: MediaQuery.of(context).size.width,
                  onPressed: () async {
                    UserInformation savedUser = await SharedPreferenceStore
                        .instance
                        .getUserInformation();
                    if (_formKey.currentState.validate()) {
                      setState(() {
                        _isWaiting = true;
                      });
                      UserInformation userInfo = await AuthWrapper.instance
                          .signInWithEmailAndPassword(
                              email: emailController.text,
                              password: passwordController.text);
                      setState(() {
                        _isWaiting = false;
                      });
                      if (userInfo != null) {
                        print(savedUser);
                        SharedPreferenceStore.instance.setLoginStatus(true);
                        if (userInfo.email.compareTo(savedUser.email) != 0) {
                          SharedPreferenceStore.instance
                              .setUserInformation(userInfo);
                        } else {
                          LogInUserInfo.userInformation = savedUser;
                        }
                        Navigator.pushReplacementNamed(context, TimeLine.routeName);
                        print(userInfo);
                      }
                    }
                  },
                ),
                RoundedButton(
                  minWidth: MediaQuery.of(context).size.width,
                  buttonColor: Colors.white,
                  buttonText: 'Sign In with Google',
                  onPressed: () {},
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Don\'t have account?',
                      style: kTextStyle,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, SignUp.routeName);
                      },
                      child: Text(
                        'Register now',
                        style: kTextStyle.copyWith(
                            decoration: TextDecoration.underline),
                      ),
                    ),
                  ],
                ),
                SizedBox(
                  height: 50.0,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
