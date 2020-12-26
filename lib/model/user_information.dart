class UserInformation {
  String userId;
  String email;
  String userName;

  UserInformation({this.userId, this.email, this.userName});

  @override
  String toString() {
    return 'UserInformation{userId: $userId, email: $email, userName: $userName}';
  }
}
