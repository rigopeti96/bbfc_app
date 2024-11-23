class JwtTokenValidityException implements Exception {
  String cause;
  JwtTokenValidityException(this.cause);
}