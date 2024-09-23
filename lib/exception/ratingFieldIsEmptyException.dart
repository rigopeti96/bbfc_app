class RatingFieldIsEmptyException implements Exception {
  String cause;
  RatingFieldIsEmptyException(this.cause);
}
