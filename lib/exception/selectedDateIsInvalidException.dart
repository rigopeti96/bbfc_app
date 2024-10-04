class SelectedDateIsInvalidException implements Exception {
  String cause;
  SelectedDateIsInvalidException(this.cause);
}