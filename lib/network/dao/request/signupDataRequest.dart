class SignupDataRequest {
  final String name;
  final String username;
  final String password;
  final String email;

  const SignupDataRequest({
    required this.name,
    required this.username,
    required this.password,
    required this.email,
  });

  factory SignupDataRequest.fromJson(Map<String, dynamic> json) {
    return SignupDataRequest(
      name: json['name'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
    );
  }
}