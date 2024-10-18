import 'package:bbfc_application/entity/matchReportItem.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/enumTranslator.dart';
import 'package:bbfc_application/enum/matchReportItemType.dart';
import 'package:bbfc_application/enum/permisson.dart';
import 'package:bbfc_application/enum/pitchSelector.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:flutter/material.dart';
import 'package:bbfc_application/entity/match.dart';

import '../main.dart';

class MatchReportPage extends StatefulWidget {
  final User actUser;
  final Match actMatch;
  const MatchReportPage({super.key, required this.actUser, required this.actMatch});

  @override
  MatchReportPageState createState() => MatchReportPageState(actUser: actUser, actMatch: actMatch);
}

class MatchReportPageState extends State<MatchReportPage> {
  final User actUser;
  final Match actMatch;
  late final List<User> registeredUserList;
  final List<MatchReportItemType> _reportTypes = [MatchReportItemType.YELLOW_CARD, MatchReportItemType.RED_CARD, MatchReportItemType.GOAL];
  final List<MatchReportItem> reportItems = [];
  final TestItemGenerator _generator = TestItemGenerator();
  int value = 0;
  final _homeGoalsController = TextEditingController();
  final _awayGoalsController = TextEditingController();
  final EnumTranslator _translator = EnumTranslator();

  MatchReportPageState({required this.actUser, required this.actMatch}){
    registeredUserList = [];
    registeredUserList.add(_generator.createAppliedUser1());
    registeredUserList.add(_generator.createAppliedUser2());
    registeredUserList.add(_generator.createAppliedUser3());
  }

  _addItem() {
    setState(() {
      if(actMatch.selector == PitchSelector.BBFC){
        value = int.parse(_homeGoalsController.text);
      } else {
        value = int.parse(_awayGoalsController.text);
      }
    });
  }

  _createReportItem(MatchReportItemType matchReportItemType, int minutes, String userName, String? assist){
    MatchReportItem item = MatchReportItem(
        modifyDate: DateTime.now(),
        matchReportItemType: matchReportItemType,
        minutes: minutes,
        user: userName
    );

    if(assist != null){
      item.assistUser = assist;
    }

    reportItems.add(item);
  }

  _buildReportItemRegister(int index, L10n l10n){
    String? reportType;
    return Dialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DropdownButton<String>(
            value: _translator.translate(_reportTypes.first.toString(), l10n),
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
                reportType = value;
              });
            },
            items: _reportTypes.map<DropdownMenuItem<String>>((MatchReportItemType value) {
              return DropdownMenuItem<String>(
                value: value.toString(),
                child: Text(_translator.translate(value.toString(), l10n)),
              );
            }).toList(),
          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: l10n.newPasswordTag),

          ),
          TextField(
            obscureText: true,
            decoration: InputDecoration(hintText: l10n.newPasswordConfTag),

          ),
          TextButton(
            child: Text(l10n.btnSaveItem),
            onPressed: (){
              //_createReportItem();
            },
          )
        ],
      ),

    );
  }

  _saveMatchReportItem(){

  }

  _buildRow(int index) {
    return Card(
      child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("${index+1}."),
            ],
          )
      ),
    );
  }

  void onTapGesture(index, L10n l10n) {
    _buildReportItemRegister(index, l10n);
  }

  bool _isPageReadOnly(){
    if(actUser.roles == Permission.PLAYER){
      return true;
    }

    return false;
  }

  String _getHomeTeam(){
    if(actMatch.selector == PitchSelector.BBFC){
      return "BBFC";
    }

    return actMatch.enemyTeam;
  }

  String _getAwayTeam(){
    if(actMatch.selector != PitchSelector.BBFC){
      return "BBFC";
    }

    return actMatch.enemyTeam;
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.matchReport),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                  child: Text(_getHomeTeam())
              ),
              Expanded(
                child: TextField(
                  controller: _homeGoalsController,
                  maxLines: 1,
                  readOnly: _isPageReadOnly(),
                  decoration: InputDecoration.collapsed(hintText: l10n.goalNumber),
                ),
              ),
              Expanded(
                child: TextField(
                  controller: _awayGoalsController,
                  maxLines: 1,
                  readOnly: _isPageReadOnly(),
                  decoration: InputDecoration.collapsed(hintText: l10n.goalNumber),
                ),
              ),
              Expanded(
                  child: Text(_getAwayTeam())
              )
            ],
          ),
          ElevatedButton(
            onPressed: _addItem,
            child: Text(l10n.btnAddGoalScorer)
          ),
          ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: value,
              itemBuilder: (context, index) {
                return GestureDetector(
                  child: _buildRow(index),
                  onTap: () => onTapGesture(index, l10n),
              );
            }
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        child: Icon(Icons.add),
      ),
    );
  }
}