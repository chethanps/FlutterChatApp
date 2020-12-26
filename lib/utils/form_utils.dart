class FormUtils {
  static String validateEmail(String email) {
    Pattern pattern =
        r"^[a-zA-Z0-9.!#$%&'*+/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]"
        r"{0,253}[a-zA-Z0-9])?)*$";
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(email) || email == null)
      return 'Enter a valid email address';
    else
      return null;
  }

  static String validateUserName(String userName) {
    return userName.isEmpty || userName.length < 4 ? "Invalid User Name" : null;
  }

  static String validatePassword(String password) {
    return password.isEmpty || password.length < 6
        ? "Invalid Password, enter 6+ digit password"
        : null;
  }
}
