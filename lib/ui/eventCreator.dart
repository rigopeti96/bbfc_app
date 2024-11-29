import 'dart:convert';

import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/exception/createEventException.dart';
import 'package:bbfc_application/exception/jwtTokenValidityException.dart';
import 'package:bbfc_application/exception/selectedDateIsInvalidException.dart';
import 'package:bbfc_application/main.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:bbfc_application/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

const List<String> eventTypeList = <String>['Training', 'Match', 'SportsMedicineExamination'];
const List<String> selectorList = <String>['Home', 'Away'];
const List<String> matchTypeList = <String>['Cup', 'League'];

class EventCreatorPage extends StatefulWidget {
  final User actUser;
  EventCreatorPage({super.key, required this.actUser});
  final TestItemGenerator generator = TestItemGenerator();

  @override
  State<EventCreatorPage> createState() => EventCreatorPageState(actUser: actUser);
}

class EventCreatorPageState extends State<EventCreatorPage>{
  final User actUser;
  final Validator validator = Validator();
  EventCreatorPageState({required this.actUser});
  String eventTypeValue = eventTypeList.first;
  String selectorValue = selectorList.first;
  String matchTypeValue = matchTypeList.first;
  bool isTrainingSelected = true;
  bool isMatchSelected = false;
  bool isSportsMedicineExaminationSelected = false;
  DateTime selectedDate = DateTime.now();
  final addressCityController = TextEditingController();
  final _timePickerController = TextEditingController();
  final _datePickerController = TextEditingController();
  final addressController = TextEditingController();
  final zipController = TextEditingController();
  final enemyTeamController = TextEditingController();
  final pitchNameController = TextEditingController();
  final prizeController = TextEditingController();
  final durationController = TextEditingController();
  final trainingPlanController = TextEditingController();

  String _getL10nValue(String label, L10n l10n){
    switch(label){
      case "Training":
        return l10n.training;
      case "Match":
        return l10n.match;
      case "SportsMedicineExamination":
        return l10n.sportsMedicineExamination;
      case "Home":
        return l10n.createEventSelectorValueHome;
      case "Away":
        return l10n.createEventSelectorValueAway;
      case "Cup":
        return l10n.createMatchTypeValueCup;
      case "League":
        return l10n.createMatchTypeValueLeague;
    }

    return "";
  }

  Future<bool> _createEvent(BuildContext context, L10n l10n, String endpoint) async{
    print(selectedDate.toString());
    try{
      final response = await http.post(
        Uri.http('192.168.0.171:8080', endpoint),
        headers: <String, String>{
          "Access-Control-Allow-Origin": "*", // Required for CORS support to work
          "Access-Control-Allow-Headers": "Origin,Content-Type,X-Amz-Date,Authorization,X-Api-Key,X-Amz-Security-Token,locale",
          "Access-Control-Allow-Methods": "POST, OPTIONS",
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $jwtToken",
        },
        body: jsonEncode(
            _createRequestMessage()
        ),
      );

      switch(response.statusCode){
        case 201:
          return true;
        case 401:
          throw CreateEventException(l10n.badCredentialExceptionMessage);
        case 403:
          throw JwtTokenValidityException(l10n.jwtTokenExceptionMessage);
        default:
          throw CreateEventException(l10n.defaultLoginExceptionMessage);
      }

    } on CreateEventException catch (e) {
      _showAlertDialog(context, l10n, e.cause);
      throw CreateEventException(e.cause);
    } on http.ClientException catch(e) {
      print(e.message);
      _showAlertDialog(context, l10n, l10n.timeoutExceptionMessage);
      throw CreateEventException(l10n.timeoutExceptionMessage);
    } on JwtTokenValidityException {
      _showAlertDialog(context, l10n, l10n.timeoutExceptionMessage);
      throw JwtTokenValidityException(l10n.jwtTokenExceptionMessage);
    }
  }

  Map <String, String> _createRequestMessage(){
    final f = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');


    Map <String, String> base = {
      "eventDate": f.format(selectedDate).toString(),
      "meetingTime": f.format(DateTime(selectedDate.year, selectedDate.month, selectedDate.day, selectedDate.hour - 1, selectedDate.minute)).toString(),
      "eventLocationZipCode": zipController.text,
      "eventLocationCity": addressCityController.text,
      "eventLocationAddress": addressController.text,
    };
    switch(eventTypeValue){
      case "Training":
        base["duration"] = durationController.text;
        base["trainingPlan"] = trainingPlanController.text;
        break;
      case "Match":
        base["enemyTeam"] = enemyTeamController.text;
        base["pitchName"] = pitchNameController.text;
        base["selector"] = selectorValue;
        base["matchType"] = matchTypeValue;
        break;
      case "SportsMedicineExamination":
        base["prize"] = prizeController.text;
        break;
      default:
        return <String, String>{};
    }

    return base;
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

  dynamic _datePickerDialog(BuildContext context) async {
    var date = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(1980),
        lastDate: DateTime(2030));

    if (date != null) {
      setState(() {
        selectedDate = DateTime(date.year, date.month, date.day, selectedDate.hour, selectedDate.minute);
      });
    }
  }

  dynamic _timePickerDialog(BuildContext context) async {
    var time = await showTimePicker(context: context, initialTime: TimeOfDay.now());

    if (time != null) {
      setState(() {
        selectedDate = DateTime(selectedDate.year, selectedDate.month, selectedDate.day, time.hour, time.minute);
      });
    }
  }

  _setSelectionStateValues(String value){
    isTrainingSelected = value == "Training";
    isMatchSelected = value == "Match";
    isSportsMedicineExaminationSelected = value == "SportsMedicineExamination";
  }

  String _selectEndpoint(){
    switch(eventTypeValue){
      case "Training":
        return "/trainings/create";
      case "Match":
        return "/matches/create";
      case "SportsMedicineExamination":
        return "/sportMedExam/create";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text("${l10n.shortTitle} - ${l10n.createEventTitle}"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            DropdownButton<String>(
              value: eventTypeValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  eventTypeValue = value!;
                  _setSelectionStateValues(value);
                });
              },
              items: eventTypeList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_getL10nValue(value, l10n)),
                );
              }).toList(),
            ),
            Text(l10n.createEventDate),
            Text("${selectedDate.toLocal()}".split(' ')[0]),
            MaterialButton(
              onPressed: (){
                _datePickerDialog(context);
              },
              child: Text(l10n.btnSelectDate),
            ),
            Text("${selectedDate.toLocal()}".split(' ')[1].split('.')[0]),
            MaterialButton(
              onPressed: (){
                _timePickerDialog(context);
              },
              child: Text(l10n.btnSelectDate),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.createEventAddress),
            ),
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(3), //apply padding to all four sides
                      child: TextField(
                        controller: zipController,
                        decoration: InputDecoration(
                          hintText: l10n.createEventZipTag,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Flexible(
                    child: Padding(
                      padding: const EdgeInsets.all(3), //apply padding to all four sides
                      child: TextField(
                        controller: addressCityController,
                        decoration: InputDecoration(
                          hintText: l10n.createEventAddressCityTag,
                          filled: true,
                          fillColor: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            TextField(
              controller: addressController,
              decoration: InputDecoration(
                hintText: l10n.createEventAddressTag,
                filled: true,
                fillColor: Colors.white,
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(l10n.createEventSpecificData),
            ),
            Visibility(
              visible: isTrainingSelected,
              child:Column(
                children: [
                  TextField(
                    keyboardType: TextInputType.number,
                    inputFormatters: <TextInputFormatter>[
                      FilteringTextInputFormatter.digitsOnly
                    ],
                    controller: durationController,
                    decoration: InputDecoration(
                      hintText: l10n.trainingDuration,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  TextField(
                    maxLines: 8, //or null
                    controller: trainingPlanController,
                    decoration: InputDecoration(
                      hintText: l10n.trainingPlanHint,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ]
              )
            ),
            Visibility(
              visible: isMatchSelected,
              child: Column(
                children: [
                  TextField(
                    controller: enemyTeamController,
                    decoration: InputDecoration(
                      hintText: l10n.createEventEnemyTeamTag,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  TextField(
                    controller: pitchNameController,
                    decoration: InputDecoration(
                      hintText: l10n.createEventPitchNameTag,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                  DropdownButton<String>(
                    value: selectorValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        selectorValue = value!;
                      });
                    },
                    items: selectorList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(_getL10nValue(value, l10n)),
                      );
                    }).toList(),
                  ),
                  DropdownButton<String>(
                    value: matchTypeValue,
                    icon: const Icon(Icons.arrow_downward),
                    elevation: 16,
                    style: const TextStyle(color: Colors.deepPurple),
                    underline: Container(
                      height: 2,
                      color: Colors.deepPurpleAccent,
                    ),
                    onChanged: (String? value) {
                      // This is called when the user selects an item.
                      setState(() {
                        matchTypeValue = value!;
                      });
                    },
                    items: matchTypeList.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(_getL10nValue(value, l10n)),
                      );
                    }).toList(),
                  ),
                ],
              )
            ),
            Visibility(
              visible: isSportsMedicineExaminationSelected,
              child: TextField(
                keyboardType: TextInputType.number,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly
                ],
                controller: prizeController,
                decoration: InputDecoration(
                  hintText: l10n.createExamPrize,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
            ),
            Expanded(
              child: Align(
                alignment: FractionalOffset.bottomCenter,
                child: MaterialButton(
                  onPressed: (){
                    _createEvent(context, l10n, _selectEndpoint());
                    Navigator.of(context).pop();
                  },
                  child: Text(l10n.createEventTitle),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}