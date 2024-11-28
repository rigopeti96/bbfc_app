class TrainingDataResponse {
  final String id;
  final String eventDate;
  final String meetingTime;
  final String createdAt;
  final int eventLocationZipCode;
  final String eventLocationCity;
  final String eventLocationAddress;
  final double duration;
  final String trainingPlan;

  const TrainingDataResponse({
    required this.id,
    required this.eventDate,
    required this.meetingTime,
    required this.createdAt,
    required this.eventLocationZipCode,
    required this.eventLocationCity,
    required this.eventLocationAddress,
    required this.duration,
    required this.trainingPlan
  });

  factory TrainingDataResponse.fromJson(Map<String, dynamic> json) {
    return TrainingDataResponse(
      id: json['id'] as String,
      eventDate: json['eventDate'] as String,
      meetingTime: json['meetingTime'] as String,
      createdAt: json['createdAt'] as String,
      eventLocationZipCode: json['eventLocationZipCode'] as int,
      eventLocationCity: json['eventLocationCity'] as String,
      eventLocationAddress: json['eventLocationAddress'] as String,
      duration: json['duration'] as double,
      trainingPlan: json['trainingPlan'] as String
    );
  }
}