import 'package:bbfc_application/entity/sportsMedicineExamination.dart';
import 'package:bbfc_application/entity/training.dart';
import 'package:bbfc_application/entity/match.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/matchType.dart';
import 'package:bbfc_application/enum/pitchSelector.dart';
import 'package:bbfc_application/ui/eventApplication.dart';
import 'package:bbfc_application/ui/rateTeammates.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:uuid/uuid.dart';

import '../entity/event.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class HistoryListPage extends StatefulWidget{
  final User actUser;
  const HistoryListPage({super.key, required this.actUser});

  @override
  HistoryListState createState() {
    return HistoryListState(actUser: actUser);
  }
}

class HistoryListState extends State<HistoryListPage>{
  final User actUser;
  List<dynamic> eventList = [];
  var uuid = Uuid();
  TestItemGenerator generator = TestItemGenerator();
  Set<User> appliedPlayers = {};

  HistoryListState({required this.actUser});

  void _generateEvents(){
    appliedPlayers.add(generator.createAppliedUser1());
    appliedPlayers.add(generator.createAppliedUser2());
    appliedPlayers.add(generator.createAppliedUser3());
    Match match = Match(
        id: uuid.v4(), modifyDate: DateTime.now(), modifyUser: generator.createCreatorUser(), eventDate: DateTime.now(), meetingTime: DateTime.now(), eventLocationZipCode: 1115, eventLocationCity: "Budapest", eventLocationAddress: "Mérnök utca 35", enemyTeam: "BEAC II.", homeGoals: 3, awayGoals: 2, selector: PitchSelector.BBFC, matchType: MatchType.LEAGUE, ratings: {});

    eventList.add(match);
  }

  void _navigateToRatingFormPage(BuildContext context, String eventId) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RateTeammatesPage(user: actUser, ),
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
    _generateEvents();
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.history)),
      body: ListView.builder(
        itemCount: eventList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text("${eventList[index].enemyTeam}, ${l10n.match}"),
                          Text(eventList[index].eventDate.toString().replaceAll("T", " ").replaceRange(
                              eventList[index].eventDate.toString().length-4,
                              eventList[index].eventDate.toString().length,
                              ""
                          )),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.navigate_next),
                        iconSize: 40,
                        onPressed: () {
                          _navigateToRatingFormPage(context, eventList[index].id);
                        },
                      )
                    ],
                  )
              ),
            ),
            onTap: () => onTapGesture(eventList[index]),
          );
        },
      ),
    );
  }
}
