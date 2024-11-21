class LoginFailedException implements Exception {
  String cause;
  LoginFailedException(this.cause);
}
