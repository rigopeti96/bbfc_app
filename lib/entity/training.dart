import 'package:bbfc_application/entity/event.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:uuid/uuid.dart';

class Training extends Event{
  final double duration;
  Set<User> appliedPlayers;

  Training({
    required super.id,
    required super.modifyDate,
    required super.modifyUser,
    required super.eventDate,
    required super.meetingTime,
    required super.eventLocationZipCode,
    required super.eventLocationCity,
    required super.eventLocationAddress,
    required this.duration,
    required this.appliedPlayers
  });

  factory Training.fromJson(Map<String, dynamic> json) {
    return Training(
      id: json['id'] as Uuid,
      modifyDate: json['modifyDate'] as DateTime,
      modifyUser: json['modifyUser'] as User,
      eventDate: json['eventDate'] as DateTime,
      meetingTime: json['meetingTime'] as DateTime,
      eventLocationZipCode: json['eventLocationZipCode'] as int,
      eventLocationCity: json['eventLocationCity'] as String,
      eventLocationAddress: json['eventLocationAddress'] as String,
      duration: json['duration'] as double,
      appliedPlayers: json['appliedPlayers'] as Set<User>,
    );
  }
}