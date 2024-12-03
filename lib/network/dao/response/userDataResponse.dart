class UserDataResponse{
  final String id;
  final DateTime modifyDate;
  final String name;
  final String username;
  final String email;
  final String password;
  final String birthPlace;
  final DateTime birthDate;
  final int addressZip;
  final String addressCity;
  final String addressStreet;
  final String playerStatus;
  final bool enabled;
  DateTime? outUntil;

  UserDataResponse({
    required this.id,
    required this.modifyDate,
    required this.name,
    required this.username,
    required this.email,
    required this.password,
    required this.birthPlace,
    required this.birthDate,
    required this.addressZip,
    required this.addressCity,
    required this.addressStreet,
    required this.playerStatus,
    required this.enabled,
    this.outUntil
  });

  factory UserDataResponse.fromJson(Map<String, dynamic> json) {
    return UserDataResponse(
        id: json['id'] as String,
        modifyDate: json['modifyDate'] as DateTime,
        name: json['name'] as String,
        username: json['username'] as String,
        email: json['email'] as String,
        password: json['password'] as String,
        birthPlace: json['birthPlace'] as String,
        birthDate: json['birthDate'] as DateTime,
        addressZip: json['addressZip'] as int,
        addressCity: json['addressCity'] as String,
        addressStreet: json['addressStreet'] as String,
        playerStatus: json['playerStatus'] as String,
        enabled: json['enabled'] as bool,
        outUntil: json['outUntil'] as DateTime
    );
  }
}