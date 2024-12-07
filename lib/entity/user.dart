import 'package:bbfc_application/entity/certificate.dart';
import 'package:bbfc_application/entity/item.dart';
import 'package:bbfc_application/entity/rating.dart';
import 'package:bbfc_application/enum/playerStatus.dart';
import 'package:uuid/uuid.dart';

import '../enum/permisson.dart';

class User extends Item{
  final String name;
  String phoneNumber;
  DateTime birthDay;
  String birthPlace;
  final String username;
  final String password;
  final String email;
  final Permission roles;
  final int addressZip;
  final String addressCity;
  final String addressStreet;
  Certificate? certificate;
  int goals;
  int assists;
  DateTime? outUntil;
  int matchPlayed = 0;
  Set<Rating> ratings;
  PlayerStatus playerStatus;

  User({
    super.id,
    required super.modifyDate,
    required this.name,
    required this.phoneNumber,
    required this.birthDay,
    required this.birthPlace,
    required this.username,
    required this.password,
    required this.addressZip,
    required this.addressCity,
    required this.addressStreet,
    required this.email,
    required this.roles,
    this.certificate,
    required this.goals,
    required this.assists,
    this.outUntil,
    required this.matchPlayed,
    required this.ratings,
    required this.playerStatus,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      modifyDate: json['modifyDate'] as DateTime,
      name: json['name'] as String,
      phoneNumber: json['phoneNumber'] as String,
      birthDay: json['birthDay'] as DateTime,
      birthPlace: json['birthPlace'] as String,
      username: json['username'] as String,
      password: json['password'] as String,
      addressZip: json['addressZip'] as int,
      addressCity: json['addressCity'] as String,
      addressStreet: json['addressStreet'] as String,
      email: json['email'] as String,
      roles: json['roles'] as Permission,
      certificate: json['certificate'] as Certificate,
      goals: json['goals'] as int,
      assists: json['assists'] as int,
      outUntil: json['outUntil'] as DateTime,
      matchPlayed: json['matchPlayed'] as int,
      ratings: json['ratings'] as Set<Rating>,
      playerStatus: json['playerStatus'] as PlayerStatus,
    );
  }

  void changeStatus(PlayerStatus newStatus, User modifyUser){
    playerStatus = newStatus;
  }
}