class StatusUpdateException implements Exception {
  String cause;
  StatusUpdateException(this.cause);
}