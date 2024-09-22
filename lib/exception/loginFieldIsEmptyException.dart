class LoginFieldIsEmptyException implements Exception {
  String cause;
  LoginFieldIsEmptyException(this.cause);
}
