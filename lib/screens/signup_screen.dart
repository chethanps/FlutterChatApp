import 'package:chatapp/screens/signin_screen.dart';
import 'package:chatapp/screens/timeline_screen.dart';
import 'package:chatapp/services/auth_wrapper.dart';
import 'package:chatapp/services/database_wrapper.dart';
import 'package:chatapp/utils/form_utils.dart';
import 'package:chatapp/utils/shared_preference.dart';
import 'package:chatapp/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

import '../constants.dart';

class SignUp extends StatefulWidget {
  static const String routeName = 'sign_up_screen';

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController userNameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _inWaiting = false;

  void validateAndSignUp() async {
    if (_formKey.currentState.validate()) {
      setState(() {
        _inWaiting = true;
      });
      final auth = AuthWrapper.instance;
      final userName = userNameController.text;
      final email = emailController.text;
      final password = passwordController.text;
      auth
          .signUpWithEmailAndPassword(email: email, password: password)
          .then((credential) => () {
                if (credential != null) {
                  DatabaseWrapper()
                      .uploadUserInfo(userName: userName, email: email);
                  SharedPreferenceStore.instance.setLoginStatus(true);
                  credential.user.updateProfile(displayName: userName);
                  Navigator.pushReplacementNamed(context, TimeLine.routeName);
                }
              });
      setState(() {
        _inWaiting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // resizeToAvoidBottomInset: false, // set it to false
      appBar: AppBar(title: Text('chatapp')),
      body: ModalProgressHUD(
        inAsyncCall: _inWaiting,
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
                        validator: FormUtils.validateUserName,
                        controller: userNameController,
                        style: kTextStyle,
                        decoration:
                            kInputDecoration.copyWith(hintText: 'user name'),
                      ),
                      TextFormField(
                        validator: FormUtils.validateEmail,
                        keyboardType: TextInputType.emailAddress,
                        controller: emailController,
                        style: kTextStyle,
                        decoration:
                            kInputDecoration.copyWith(hintText: 'email'),
                      ),
                      TextFormField(
                        validator: FormUtils.validatePassword,
                        obscureText: true,
                        controller: passwordController,
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
                // Container(
                //   alignment: Alignment.centerRight,
                //   child: Container(
                //     child: Text(
                //       'Forgot password?',
                //       style: kTextStyle,
                //     ),
                //   ),
                // ),
                SizedBox(
                  height: 10.0,
                ),
                RoundedButton(
                  buttonColor: Colors.blueAccent,
                  minWidth: MediaQuery.of(context).size.width,
                  buttonText: 'Sign Up',
                  onPressed: validateAndSignUp,
                ),
                RoundedButton(
                  minWidth: MediaQuery.of(context).size.width,
                  buttonColor: Colors.white,
                  buttonText: 'Sign Up with Google',
                  onPressed: () {},
                ),
                SizedBox(
                  height: 10.0,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have account?',
                      style: kTextStyle,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pushReplacementNamed(context, SignIn.routeName);
                      },
                      child: Text(
                        'Sign In now',
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
