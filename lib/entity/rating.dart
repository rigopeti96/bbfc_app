import 'package:bbfc_application/entity/user.dart';

class Rating{
  final User ratedPlayer;
  final User rater;
  int rateValue;

  Rating({
    required this.ratedPlayer,
    required this.rater,
    required this.rateValue
  });

  factory Rating.fromJson(Map<String, dynamic> json) {
    return Rating(
      ratedPlayer: json['ratedPlayer'] as User,
      rater: json['rater'] as User,
      rateValue: json['rateValue'] as int
    );
  }
}