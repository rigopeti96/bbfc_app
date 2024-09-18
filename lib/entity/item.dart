import 'package:bbfc_application/entity/user.dart';
import 'package:uuid/uuid.dart';

class Item {
  final Uuid id;
  DateTime modifyDate;
  User modifyUser;

  Item({
    required this.id,
    required this.modifyDate,
    required this.modifyUser
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as Uuid,
      modifyDate: json['modifyDate'] as DateTime,
      modifyUser: json['modifyUser'] as User
    );
  }
}