import 'package:bbfc_application/entity/item.dart';
import 'package:bbfc_application/entity/user.dart';

class Certificate extends Item {
  User modifyUser;

  Certificate({
    required super.id,
    required super.modifyDate,
    required this.modifyUser,
  });

  factory Certificate.fromJson(Map<String, dynamic> json) {
    return Certificate(
        id: json['id'] as String,
        modifyDate: json['modifyDate'] as DateTime,
        modifyUser: json['modifyUser'] as User,
    );
  }
}