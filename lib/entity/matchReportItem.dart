import 'package:bbfc_application/entity/item.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/matchReportItemType.dart';

class MatchReportItem extends Item {
  final MatchReportItemType matchReportItemType;
  final int minutes;
  final User user;
  final User? assistUser;

  MatchReportItem({
    super.id,
    required super.modifyDate,
    required this.matchReportItemType,
    required this.minutes,
    required this.user,
    this.assistUser
  });

  factory MatchReportItem.fromJson(Map<String, dynamic> json) {
    return MatchReportItem(
      id: json['id'] as String,
      modifyDate: json['modifyDate'] as DateTime,
      matchReportItemType: json['matchReportItemType'] as MatchReportItemType,
      minutes: json['minutes'] as int,
      user: json['user'] as User,
      assistUser: json['assistUser'] as User
    );
  }
}