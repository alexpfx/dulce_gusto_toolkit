class UserCredentials {
  final String login;
  final String password;


  @override
  String toString() {
    return 'UserCredentials{login: $login, password: $password}';
  }

  UserCredentials(this.login, this.password);
}
