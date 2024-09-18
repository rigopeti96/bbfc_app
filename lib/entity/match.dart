import 'package:bbfc_application/entity/event.dart';
import 'package:bbfc_application/entity/rating.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/matchType.dart';
import 'package:bbfc_application/enum/pitchSelector.dart';
import 'package:uuid/uuid.dart';

class Match extends Event{
  final String enemyTeam;
  int homeGoals;
  int awayGoals;
  final PitchSelector selector;
  final MatchType matchType;
  Set<Rating> ratings;

  Match({
    required super.id,
    required super.modifyDate,
    required super.modifyUser,
    required super.eventDate,
    required super.meetingTime,
    required super.eventLocationZipCode,
    required super.eventLocationCity,
    required super.eventLocationAddress,
    required this.enemyTeam,
    required this.homeGoals,
    required this.awayGoals,
    required this.selector,
    required this.matchType,
    required this.ratings
  });

  factory Match.fromJson(Map<String, dynamic> json) {
    return Match(
      id: json['id'] as Uuid,
      modifyDate: json['modifyDate'] as DateTime,
      modifyUser: json['modifyUser'] as User,
      eventDate: json['eventDate'] as DateTime,
      meetingTime: json['meetingTime'] as DateTime,
      eventLocationZipCode: json['eventLocationZipCode'] as int,
      eventLocationCity: json['eventLocationCity'] as String,
      eventLocationAddress: json['eventLocationAddress'] as String,
      enemyTeam: json['enemyTeam'] as String,
      homeGoals: json['homeGoals'] as int,
      awayGoals: json['eventLocationAddress'] as int,
      selector: json['selector'] as PitchSelector,
      matchType: json['matchType'] as MatchType,
      ratings: json['ratings'] as Set<Rating>,
    );
  }
}