import 'package:bbfc_application/entity/item.dart';
import 'package:bbfc_application/entity/user.dart';

class Certificate extends Item {
  User modifyUser;
  final int certificateNumber;
  DateTime photoValidUntil;
  DateTime sportExamValidUntil;
  int sportExamSpaces;

  Certificate({
    required super.id,
    required super.modifyDate,
    required this.modifyUser,
    required this.certificateNumber,
    required this.photoValidUntil,
    required this.sportExamValidUntil,
    required this.sportExamSpaces
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
        id: json['id'] as String,
        modifyDate: json['modifyDate'] as DateTime,
        modifyUser: json['modifyUser'] as User,
        certificateNumber: json['certificateNumber'] as int,
        photoValidUntil: json['photoValidUntil'] as DateTime,
        sportExamValidUntil: json['sportExamValidUntil'] as DateTime,
        sportExamSpaces: json['sportExamSpaces'] as int,
    );
  }
}