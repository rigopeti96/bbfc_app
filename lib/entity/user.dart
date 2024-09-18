class User {
  final String name;
  final String username;
  final String password;
  final String email;
  final Set<String> roles;

  const User({
    required this.name,
    required this.username,
    required this.password,
    required this.email,
    required this.roles,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
      roles: json['roles'] as Set<String>,
    );
  }
}