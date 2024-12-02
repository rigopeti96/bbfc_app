import 'package:bbfc_application/enum/playerStatus.dart';

class StatusUpdateRequest {
  final String newStatus;
  final DateTime? outUntil;

  const StatusUpdateRequest({
    required this.newStatus,
    this.outUntil
  });

  factory StatusUpdateRequest.fromJson(Map<String, dynamic> json) {
    return StatusUpdateRequest(
      newStatus: json['newStatus'] as String,
      outUntil: json['outUntil'] as DateTime
    );
  }
}