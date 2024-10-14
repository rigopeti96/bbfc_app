import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/permisson.dart';
import 'package:bbfc_application/enum/pitchSelector.dart';
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
  MatchReportPageState({required this.actUser, required this.actMatch});
  int value = 0;
  final _homeGoalsController = TextEditingController();
  final _awayGoalsController = TextEditingController();

  _addItem() {
    setState(() {
      if(actMatch.selector == PitchSelector.BBFC){
        value = int.parse(_homeGoalsController.text);
      } else {
        value = int.parse(_awayGoalsController.text);
      }
    });
  }

  _buildRow(int index) {
    return Text("Item " + index.toString());
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
              itemCount: this.value,
              itemBuilder: (context, index) => this._buildRow(index)
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