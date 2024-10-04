import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/exception/selectedDateIsInvalidException.dart';
import 'package:bbfc_application/ui/eventList.dart';
import 'package:bbfc_application/ui/historyList.dart';
import 'package:bbfc_application/ui/injuryRegister.dart';
import 'package:bbfc_application/ui/profile.dart';
import 'package:bbfc_application/ui/settings.dart';
import 'package:bbfc_application/ui/trainingHistoryList.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:bbfc_application/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
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
  final addressController = TextEditingController();
  final zipController = TextEditingController();
  final enemyTeamController = TextEditingController();
  final pitchNameController = TextEditingController();
  final prizeController = TextEditingController();
  final durationController = TextEditingController();

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

  Future<void> _selectDate(BuildContext context, L10n l10n) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      try{
        if(validator.validateSelectedDate(picked, l10n)){
          setState(() {
            selectedDate = picked;
          });
        }
      } on SelectedDateIsInvalidException catch(e){
        _showAlertDialog(context, l10n, e.cause);
      }
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

  _setSelectionStateValues(String value){
    isTrainingSelected = value == "Training";
    isMatchSelected = value == "Match";
    isSportsMedicineExaminationSelected = value == "SportsMedicineExamination";
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
            const SizedBox(height: 20.0,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
              ),
              onPressed: () => _selectDate(context, l10n),
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
                    child: TextField(
                      controller: zipController,
                      decoration: InputDecoration(
                        hintText: l10n.createEventZipTag,
                        filled: true,
                        fillColor: Colors.white,
                      ),
                    ),
                  ),
                  Flexible(
                    child: TextField(
                      controller: addressCityController,
                      decoration: InputDecoration(
                        hintText: l10n.createEventAddressCityTag,
                        filled: true,
                        fillColor: Colors.white,
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
              child: TextField(
                controller: durationController,
                decoration: InputDecoration(
                  hintText: l10n.trainingDuration,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
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