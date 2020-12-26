import 'package:chatapp/model/user_information.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthWrapper {
  FirebaseAuth _auth = FirebaseAuth.instance;
  static final AuthWrapper _instance = AuthWrapper._internal();

  static AuthWrapper get instance {
    return _instance;
  }

  AuthWrapper._internal();

  Future signInWithEmailAndPassword({String email, String password}) async {
    UserCredential credential;
    try {
      credential = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      return credential != null
          ? UserInformation(
              userId: credential.user.uid, email: credential.user.email)
          : null;
    } catch (e) {
      print('signInWithEmailAndPassword: Exception received $e');
    }
    return null;
  }

  Future<UserCredential> signUpWithEmailAndPassword(
      {String email, String password}) {
    try {
      return _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } catch (e) {
      print('signUpWithEmailAndPassword: Exception received $e');
    }
    return null;
  }

  Future resetPassword({String email}) async {
    try {
      return await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      print('resetPassword: Exception received $e');
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print('signOut: Exception received $e');
    }
  }

  String get userName {
    return _auth.currentUser.displayName;
  }

  String get email {
    return _auth.currentUser.email;
  }
}
