import 'dart:convert';

import 'package:bbfc_application/entity/training.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/permisson.dart';
import 'package:bbfc_application/exception/jwtTokenValidityException.dart';
import 'package:bbfc_application/exception/trainingFieldIsEmptyException.dart';
import 'package:bbfc_application/exception/trainingNotFoundException.dart';
import 'package:bbfc_application/exception/trainingRequestException.dart';
import 'package:bbfc_application/main.dart';
import 'package:bbfc_application/network/dao/response/trainingDataResponse.dart';
import 'package:bbfc_application/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
export 'package:flutter_gen/gen_l10n/l10n.dart';

class TrainingHistoryDataPage extends StatefulWidget{
  final User user;
  final Training training;
  const TrainingHistoryDataPage({super.key, required this.user, required this.training});

  @override
  TrainingHistoryDataPageState createState() {
    return TrainingHistoryDataPageState(user: user, training: training);
  }
}

class TrainingHistoryDataPageState extends State<TrainingHistoryDataPage>{
  final User user;
  Training training;
  final Validator validator = Validator();
  final planController = TextEditingController();
  TrainingHistoryDataPageState({required this.user, required this.training});

  Future<TrainingDataResponse> _updateTrainingPlan(BuildContext context, L10n l10n) async{
    try{
      validator.validateTrainingPlan(planController.text, l10n);
      final response = await http.put(
          Uri.http('192.168.0.171:8080', "/trainings/updateTrainingPlan/${training.id}"),
          headers: <String, String>{
            "Access-Control-Allow-Origin": "*", // Required for CORS support to work
            "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
            "Access-Control-Allow-Methods": "POST, OPTIONS",
            'Content-Type': 'application/json; charset=UTF-8',
            'Authorization': "Bearer $jwtToken",
          },
        body: jsonEncode(<String, String>{
          'trainingPlan': planController.text,
        }),
      );

      switch(response.statusCode){
        case 200:
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text(l10n.trainingPlanSaved),
          ));
          return TrainingDataResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
        case 401:
          throw TrainingNotFoundException(l10n.trainingNotFoundExceptionMessage);
        case 403:
          throw JwtTokenValidityException(l10n.jwtTokenExceptionMessage);
        default:
          throw TrainingNotFoundException(l10n.defaultLoginExceptionMessage);
      }

    } on TrainingFieldIsEmptyException catch(e){
      _showAlertDialog(context, l10n, e.cause);
      throw TrainingFieldIsEmptyException(e.cause);
    }  on http.ClientException {
      _showAlertDialog(context, l10n, l10n.timeoutExceptionMessage);
      throw TrainingRequestException(l10n.timeoutExceptionMessage);
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

  bool _isPageReadOnly(){
    if(user.roles == Permission.PLAYER){
      return true;
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    planController.text = training.trainingPlan;
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.trainingPlan)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Text("${l10n.training} - ${training.eventDate}"),
            ),
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Text("${l10n.trainingPlace} - ${training.eventLocationCity}, ${training.eventLocationAddress}"),
            ),
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Text("${l10n.trainingDuration} - ${training.duration} ${l10n.trainingDurationMeasurementUnit}"),
            ),
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Text(l10n.trainingPlan),
            ),
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Card(
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      controller: planController,
                      maxLines: 8, //or null
                      readOnly: _isPageReadOnly(),
                      decoration: InputDecoration.collapsed(hintText: l10n.trainingPlanHint),

                    ),
                  )
              )
            ),
            Visibility(
              visible: !_isPageReadOnly(),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                ),
                child: Text(l10n.saveButtonText),
                onPressed: (){
                  _updateTrainingPlan(context, l10n);
                },
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: MaterialButton(
                  onPressed: (){
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.back),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}