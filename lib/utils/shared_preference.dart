import 'package:chatapp/model/user_information.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferenceStore {
  static final _instance = SharedPreferenceStore._internal();
  static const String SHARED_PREF_LOGIN_STATUS = 'login';
  static const String SHARED_PREF_USERNAME = 'userName';
  static const String SHARED_PREF_EMAIL = 'email';
  static const String SHARED_PREF_USERID = 'userId';

  static SharedPreferenceStore get instance {
    return _instance;
  }

  SharedPreferenceStore._internal();

  setUserInformation(UserInformation user) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    _sharedPreferences.setString(SHARED_PREF_USERNAME, user.userName);
    _sharedPreferences.setString(SHARED_PREF_EMAIL, user.email);
    _sharedPreferences.setString(SHARED_PREF_USERID, user.userId);
  }

  getUserInformation() async {
    UserInformation user = UserInformation();
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    user.userId = _sharedPreferences.getString(SHARED_PREF_USERNAME);
    user.email = _sharedPreferences.getString(SHARED_PREF_EMAIL);
    user.userName = _sharedPreferences.getString(SHARED_PREF_USERNAME);
    return user;
  }

  setLoginStatus(bool isLoggedIn) async {
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    print('setLoginStatus: $isLoggedIn');
    _sharedPreferences.setBool(SHARED_PREF_LOGIN_STATUS, isLoggedIn);
  }

  getLoginStatus() async {
    bool loggedIn = false;
    SharedPreferences _sharedPreferences =
        await SharedPreferences.getInstance();
    try {
      loggedIn = _sharedPreferences.getBool(SHARED_PREF_LOGIN_STATUS);
      print('getLoginStatus: $loggedIn');
    } catch (e) {
      print('getLoginStatus: Exception received $e');
    }
    return loggedIn;
  }
}
