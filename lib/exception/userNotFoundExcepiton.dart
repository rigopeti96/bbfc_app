class UserNotFoundException implements Exception {
  String cause;
  UserNotFoundException(this.cause);
}
