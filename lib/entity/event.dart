import 'package:bbfc_application/entity/item.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:uuid/uuid.dart';

class Event extends Item {
  User modifyUser;
  final DateTime eventDate;
  final DateTime meetingTime;
  final int eventLocationZipCode;
  final String eventLocationCity;
  final String eventLocationAddress;

  Event({
    required super.id,
    required super.modifyDate,
    required this.modifyUser,
    required this.eventDate,
    required this.meetingTime,
    required this.eventLocationZipCode,
    required this.eventLocationCity,
    required this.eventLocationAddress
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as String,
      modifyDate: json['modifyDate'] as DateTime,
      modifyUser: json['modifyUser'] as User,
      eventDate: json['eventDate'] as DateTime,
      meetingTime: json['meetingTime'] as DateTime,
      eventLocationZipCode: json['eventLocationZipCode'] as int,
      eventLocationCity: json['eventLocationCity'] as String,
      eventLocationAddress: json['eventLocationAddress'] as String,
    );
  }
}