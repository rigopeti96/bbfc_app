import 'package:bbfc_application/entity/item.dart';
import 'package:bbfc_application/entity/rating.dart';
import 'package:bbfc_application/enum/status.dart';
import 'package:uuid/uuid.dart';

class User extends Item{
  final String name;
  final String username;
  final String password;
  final String email;
  final Set<String> roles;
  Set<Rating> ratings;
  Status playerStatus;

  User({
    required super.id, required super.modifyDate, required super.modifyUser,
    required this.name,
    required this.username,
    required this.password,
    required this.email,
    required this.roles,
    required this.ratings,
    required this.playerStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as Uuid,
      modifyDate: json['modifyDate'] as DateTime,
      modifyUser: json['modifyUser'] as User,
      name: json['name'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      email: json['email'] as String,
      roles: json['roles'] as Set<String>,
      ratings: json['ratings'] as Set<Rating>,
      playerStatus: json['playerStatus'] as Status,
    );
  }

  void changeStatus(Status newStatus, User modifyUser){
    this.modifyUser = modifyUser;
    playerStatus = newStatus;
  }
}