import 'dart:convert';

import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/permisson.dart';
import 'package:bbfc_application/enum/playerStatus.dart';
import 'package:bbfc_application/exception/userNotFoundExcepiton.dart';
import 'package:bbfc_application/main.dart';
import 'package:bbfc_application/network/dao/response/userDataResponse.dart';
import 'package:bbfc_application/ui/eventCreator.dart';
import 'package:bbfc_application/ui/eventList.dart';
import 'package:bbfc_application/ui/historyList.dart';
import 'package:bbfc_application/ui/injuryRegister.dart';
import 'package:bbfc_application/ui/profile.dart';
import 'package:bbfc_application/ui/seniority.dart';
import 'package:bbfc_application/ui/settings.dart';
import 'package:bbfc_application/ui/trainingHistoryList.dart';
import 'package:bbfc_application/ui/userHandlingPage.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
export 'package:flutter_gen/gen_l10n/l10n.dart';

class MainMenu extends StatelessWidget {
  TestItemGenerator generator = TestItemGenerator();
  User? actUser;

  MainMenu({super.key}) : super() {
    actUser = generator.createCreatorUser();
  }

  Future<bool> _getUserData(BuildContext context, L10n l10n) async {
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
          actUser = _convertResponseToEntity(loginResponse);
          return true;
        case 401:
          throw UserNotFoundException(l10n.userNotFoundExceptionMessage);
        default:
          throw UserNotFoundException(l10n.defaultLoginExceptionMessage);
      }
    } on UserNotFoundException catch (e) {
      _showAlertDialog(context, l10n, e.cause);
      throw UserNotFoundException(e.cause);
    } on http.ClientException {
      _showAlertDialog(context, l10n, l10n.timeoutExceptionMessage);
      throw UserNotFoundException(l10n.timeoutExceptionMessage);
    }
  }

  User _convertResponseToEntity(UserDataResponse loginResponse){
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

  _showAlertDialog(BuildContext context, L10n l10n, String errorMessage) {
    // set up the button
    Widget okButton = TextButton(
      child: Text(l10n.back),
      onPressed: () {
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text(l10n.errorTitle),
      content: Text(errorMessage),
      actions: [
        okButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Profile(),
      ),
    );
  }

  void _navigateToInjuryRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InjuryRegisterPage(actUser: actUser!),
      ),
    );
  }

  void _navigateToEvents(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EventListPage(),
      ),
    );
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HistoryListPage(actUser: actUser!),
      ),
    );
  }

  void _navigateToTrainingHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrainingHistoryListPage(actUser: actUser!),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void _navigateToEventCreatorHub(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventCreatorPage(actUser: actUser!),
      ),
    );
  }

  void _navigateToUserHandlingPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserHandlingPage(actUser: actUser!),
      ),
    );
  }

  void _navigateToSeniorityPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SeniorityPage(actUser: actUser!),
      ),
    );
  }

  bool _isPlayerPermission(){
    /*try{
      if(actUser!.roles == Permission.PLAYER){
        return true;
      }

      return false;
    } on Exception {
      return false;
    }*/
    return false;

  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    _getUserData(context, l10n);
    return Scaffold(
      appBar: AppBar(title: Text("${l10n.shortTitle} - ${l10n.mainMenuTitle}"),),
        body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  MaterialButton(
                    child: Text(l10n.profile),
                    onPressed: (){
                      _navigateToProfile(context);
                    },
                  ),
                  MaterialButton(
                    child: Text(l10n.events),
                    onPressed: (){
                      _navigateToEvents(context);
                    },
                  ),
                  MaterialButton(
                    child: Text(l10n.history),
                    onPressed: (){
                      _navigateToHistory(context);
                    },
                  ),
                  MaterialButton(
                    child: Text(l10n.trainingHistory),
                    onPressed: (){
                      _navigateToTrainingHistory(context);
                    },
                  ),
                  Visibility(
                    visible: !_isPlayerPermission(),
                    child: MaterialButton(
                      child: Text(l10n.createEventTitle),
                      onPressed: (){
                        _navigateToEventCreatorHub(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: !_isPlayerPermission(),
                    child: MaterialButton(
                      child: Text(l10n.userHandling),
                      onPressed: (){
                        _navigateToUserHandlingPage(context);
                      },
                    ),
                  ),
                  MaterialButton(
                    child: Text(l10n.injury),
                    onPressed: (){
                      _navigateToInjuryRegister(context);
                    },
                  ),
                  MaterialButton(
                    child: Text(l10n.settings),
                    onPressed: (){
                      _navigateToSettings(context);
                    },
                  ),
                  MaterialButton(
                    child: Text(l10n.seniority),
                    onPressed: (){
                      _navigateToSeniorityPage(context);
                    },
                  ),
                ],
            ),
        ),
    );
  }
}