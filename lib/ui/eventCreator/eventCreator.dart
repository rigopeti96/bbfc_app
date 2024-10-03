import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/ui/eventList.dart';
import 'package:bbfc_application/ui/historyList.dart';
import 'package:bbfc_application/ui/injuryRegister.dart';
import 'package:bbfc_application/ui/profile.dart';
import 'package:bbfc_application/ui/settings.dart';
import 'package:bbfc_application/ui/trainingHistoryList.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

const List<String> list = <String>['Training', 'Match', 'SportsMedicineExamination'];

class EventCreatorPage extends StatefulWidget {
  final User actUser;
  EventCreatorPage({super.key, required this.actUser});
  final TestItemGenerator generator = TestItemGenerator();

  @override
  State<EventCreatorPage> createState() => EventCreatorPageState(actUser: actUser);
}

class EventCreatorPageState extends State<EventCreatorPage>{
  final User actUser;
  EventCreatorPageState({required this.actUser});
  String dropdownValue = list.first;
  bool isTrainingSelected = true;
  bool isMatchSelected = false;
  bool isSportsMedicineExaminationSelected = false;

  String _getL10nValue(String label, L10n l10n){
    switch(label){
      case "Training":
        return l10n.training;
      case "Match":
        return l10n.match;
      case "SportsMedicineExamination":
        return l10n.sportsMedicineExamination;
    }

    return "";
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
              value: dropdownValue,
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
                  dropdownValue = value!;
                  _setSelectionStateValues(value);
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(_getL10nValue(value, l10n)),
                );
              }).toList(),
            ),
            Visibility(
              visible: isTrainingSelected,
              child: MaterialButton(
                child: Text(l10n.training),
                onPressed: (){

                },
              ),
            ),
            Visibility(
              visible: isMatchSelected,
              child: MaterialButton(
                child: Text(l10n.match),
                onPressed: (){

                },
              ),
            ),
            Visibility(
              visible: isSportsMedicineExaminationSelected,
              child: MaterialButton(
                child: Text(l10n.sportsMedicineExamination),
                onPressed: (){

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}