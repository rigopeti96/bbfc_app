import 'package:bbfc_application/entity/user.dart';
import 'package:uuid/uuid.dart';

class Item {
  final String id;
  DateTime modifyDate;

  Item({
    required this.id,
    required this.modifyDate
  });

  factory Item.fromJson(Map<String, dynamic> json) {
    return Item(
      id: json['id'] as String,
      modifyDate: json['modifyDate'] as DateTime
    );
  }
}