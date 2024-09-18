import 'package:bbfc_application/entity/Event.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:uuid/uuid.dart';

class SportsMedicineExamination extends Event{
  final int prize;
  Set<User> appliedPlayers;

  SportsMedicineExamination({
    required super.id,
    required super.modifyDate,
    required super.modifyUser,
    required super.eventDate,
    required super.meetingTime,
    required super.eventLocationZipCode,
    required super.eventLocationCity,
    required super.eventLocationAddress,
    required this.prize,
    required this.appliedPlayers
  });

  factory SportsMedicineExamination.fromJson(Map<String, dynamic> json) {
    return SportsMedicineExamination(
      id: json['id'] as Uuid,
      modifyDate: json['modifyDate'] as DateTime,
      modifyUser: json['modifyUser'] as User,
      eventDate: json['eventDate'] as DateTime,
      meetingTime: json['meetingTime'] as DateTime,
      eventLocationZipCode: json['eventLocationZipCode'] as int,
      eventLocationCity: json['eventLocationCity'] as String,
      eventLocationAddress: json['eventLocationAddress'] as String,
      prize: json['prize'] as int,
      appliedPlayers: json['appliedPlayers'] as Set<User>,
    );
  }
}