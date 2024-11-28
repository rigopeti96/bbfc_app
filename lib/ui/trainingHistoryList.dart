import 'dart:convert';

import 'package:bbfc_application/entity/sportsMedicineExamination.dart';
import 'package:bbfc_application/entity/training.dart';
import 'package:bbfc_application/entity/match.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/matchType.dart';
import 'package:bbfc_application/enum/pitchSelector.dart';
import 'package:bbfc_application/exception/trainingNotFoundException.dart';
import 'package:bbfc_application/exception/trainingRequestException.dart';
import 'package:bbfc_application/main.dart';
import 'package:bbfc_application/network/dao/response/trainingDataResponse.dart';
import 'package:bbfc_application/ui/eventApplication.dart';
import 'package:bbfc_application/ui/rateTeammates.dart';
import 'package:bbfc_application/ui/trainingHistoryData.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:uuid/uuid.dart';
import 'package:http/http.dart' as http;
import '../entity/event.dart';
import '../exception/jwtTokenValidityException.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class TrainingHistoryListPage extends StatefulWidget{
  final User actUser;
  const TrainingHistoryListPage({super.key, required this.actUser});

  @override
  TrainingHistoryListState createState() {
    return TrainingHistoryListState(actUser: actUser);
  }
}

class TrainingHistoryListState extends State<TrainingHistoryListPage>{
  final User actUser;
  List<dynamic> trainingList = [];
  var uuid = Uuid();
  TestItemGenerator generator = TestItemGenerator();
  Set<User> appliedPlayers = {};

  TrainingHistoryListState({required this.actUser});

  Future<List<TrainingDataResponse>> _getTrainingHistory(BuildContext context, L10n l10n) async{
    try{
      final response = await http.get(
        Uri.http('192.168.0.171:8080', "/trainings/findSeasonTrainings"),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $jwtToken",
        }
      );

      switch(response.statusCode){
        case 200:
          List<dynamic> parsedListJson = json.decode(response.body);
          return List<TrainingDataResponse>.from(parsedListJson.map((e) => TrainingDataResponse.fromJson(e)));
        case 401:
          throw TrainingNotFoundException(l10n.trainingNotFoundExceptionMessage);
        case 403:
          throw JwtTokenValidityException(l10n.jwtTokenExceptionMessage);
        default:
          throw TrainingNotFoundException(l10n.defaultLoginExceptionMessage);
      }

    } on TrainingNotFoundException catch (e) {
      _showAlertDialog(context, l10n, e.cause);
      throw TrainingNotFoundException(e.cause);
    } on http.ClientException {
      _showAlertDialog(context, l10n, l10n.timeoutExceptionMessage);
      throw TrainingRequestException(l10n.timeoutExceptionMessage);
    } on JwtTokenValidityException {
      _showAlertDialog(context, l10n, l10n.timeoutExceptionMessage);
      throw JwtTokenValidityException(l10n.jwtTokenExceptionMessage);
    }
  }

  void _createTrainingList(BuildContext context, L10n l10n){
    //List<TrainingDataResponse> responseList = _getTrainingHistory(context, l10n);
    _getTrainingHistory(context, l10n).then((res) {
      setState(() {
        if(trainingList.isNotEmpty){
          for (var element in trainingList) {
            trainingList.remove(element);
          }
        }
        for(var element in res){
          trainingList.add(_convertResponseItemToTraining(element));
        }
      });
    });
  }

  Training _convertResponseItemToTraining(TrainingDataResponse response){
    return Training(
        id: response.id,
        modifyDate: DateTime.parse(response.createdAt),
        modifyUser: actUser,
        eventDate: DateTime.parse(response.eventDate),
        meetingTime: DateTime.parse(response.meetingTime),
        eventLocationZipCode: response.eventLocationZipCode,
        eventLocationCity: response.eventLocationCity,
        eventLocationAddress: response.eventLocationAddress,
        duration: response.duration,
        trainingPlan: response.trainingPlan,
        appliedPlayers: appliedPlayers
    );
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

  void _navigateToTrainingHistoryData(BuildContext context, Training training) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrainingHistoryDataPage(user: actUser, training: training),
      ),
    );
  }

  void onTapGesture(item) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$item is selected"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    if(trainingList.isEmpty){
      _createTrainingList(context, l10n);
    }
    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: ListView.builder(
        itemCount: trainingList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${l10n.training} - ${trainingList[index].eventDate}".split('.')[0]),
                      IconButton(
                        icon: const Icon(Icons.navigate_next),
                        iconSize: 40,
                        onPressed: () {
                          _navigateToTrainingHistoryData(context, trainingList[index]);
                        },
                      )
                    ],
                  )
              ),
            ),
            onTap: () => onTapGesture(trainingList[index]),
          );
        },
      ),
    );
  }
}
