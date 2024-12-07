import 'dart:convert';

import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/permisson.dart';
import 'package:bbfc_application/enum/playerStatus.dart';
import 'package:bbfc_application/exception/userNotFoundExcepiton.dart';
import 'package:bbfc_application/main.dart';
import 'package:bbfc_application/network/dao/response/userDataResponse.dart';
import 'package:http/http.dart' as http;

class CommunicationApi{
  Future<User> getUserData(L10n l10n) async {
    try {
      final response = await http.get(
          Uri.parse('http://192.168.0.171:8080/users/me'),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer $jwtToken",
          }
      );

      switch (response.statusCode) {
        case 200:
          UserDataResponse loginResponse = UserDataResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
          return _convertResponseToEntity(loginResponse);
        case 401:
          throw UserNotFoundException(l10n.userNotFoundExceptionMessage);
        default:
          throw UserNotFoundException(l10n.defaultLoginExceptionMessage);
      }
    } on UserNotFoundException catch (e) {
      throw UserNotFoundException(e.cause);
    } on http.ClientException {
      throw UserNotFoundException(l10n.timeoutExceptionMessage);
    }
  }

  Future<User> _convertResponseToEntity(UserDataResponse loginResponse) async{
    return User(
        modifyDate: DateTime.now(),
        name: loginResponse.name,
        phoneNumber: "0",
        birthDay: DateTime.parse(loginResponse.birthDate),
        birthPlace: loginResponse.birthPlace,
        username: loginResponse.username,
        password: loginResponse.password,
        email: loginResponse.email,
        roles: Permission.ADMIN,
        addressZip: loginResponse.addressZip,
        addressCity: loginResponse.addressCity,
        addressStreet: loginResponse.addressStreet,
        goals: 0,
        assists: 0,
        outUntil: _paresOutUntil(loginResponse.outUntil),
        matchPlayed: 0,
        ratings: Set(),
        playerStatus: _convertStringToStatus(loginResponse.playerStatus)
    );
  }

  DateTime _paresOutUntil(String? outUntil){
    if(outUntil == null){
      return DateTime(0);
    }

    return DateTime.parse(outUntil);
  }

  PlayerStatus _convertStringToStatus(String playerStatus){
    switch(playerStatus){
      case "AVAILABLE":
        return PlayerStatus.AVAILABLE;
      case "INJURED":
        return PlayerStatus.INJURED;
      case "SUSPENDED":
        return PlayerStatus.SUSPENDED;
      default:
        return PlayerStatus.AVAILABLE;
    }
  }
}