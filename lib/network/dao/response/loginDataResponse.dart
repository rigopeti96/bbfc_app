class LoginDataResponse {
  final String accessToken;
  final String employeename;
  final String email;
  final bool enabled;

  const LoginDataResponse({
    required this.accessToken,
    required this.employeename,
    required this.email,
    required this.enabled,
  });

  factory LoginDataResponse.fromJson(Map<String, dynamic> json) {
    return LoginDataResponse(
      accessToken: json['accessToken'] as String,
      employeename: json['employeename'] as String,
      email: json['email'] as String,
      enabled: json['enabled'] as bool,
    );
  }
}