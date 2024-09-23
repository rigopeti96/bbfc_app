import 'package:bbfc_application/entity/sportsMedicineExamination.dart';
import 'package:bbfc_application/entity/training.dart';
import 'package:bbfc_application/entity/match.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/matchType.dart';
import 'package:bbfc_application/enum/pitchSelector.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:uuid/uuid.dart';

import '../entity/event.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class EventListPage extends StatefulWidget{
  const EventListPage({super.key});

  @override
  EventListState createState() {
    return EventListState();
  }
}

class EventListState extends State<EventListPage>{
  List<dynamic> eventList = [];
  var uuid = Uuid();
  TestItemGenerator generator = TestItemGenerator();
  Set<User> appliedPlayers = {};

  EventListState();

  void _generateEvents(){
    appliedPlayers.add(generator.createAppliedUser1());
    appliedPlayers.add(generator.createAppliedUser2());
    appliedPlayers.add(generator.createAppliedUser3());
    SportsMedicineExamination medExam = SportsMedicineExamination(
        id: uuid.v4(), modifyDate: DateTime.now(), modifyUser: generator.createCreatorUser(), eventDate: DateTime.now(), meetingTime: DateTime.now(), eventLocationZipCode: 2360, eventLocationCity: "Gyál", eventLocationAddress: "Ady Endre utca 22", prize: 5000, appliedPlayers: appliedPlayers);
    Training training = Training(
        id: uuid.v4(), modifyDate: DateTime.now(), modifyUser: generator.createCreatorUser(), eventDate: DateTime.now(), meetingTime: DateTime.now(), eventLocationZipCode: 1115, eventLocationCity: "Budapest", eventLocationAddress: "Mérnök utca 35", duration: 2, appliedPlayers: appliedPlayers);
    Match match = Match(
        id: uuid.v4(), modifyDate: DateTime.now(), modifyUser: generator.createCreatorUser(), eventDate: DateTime.now(), meetingTime: DateTime.now(), eventLocationZipCode: 1115, eventLocationCity: "Budapest", eventLocationAddress: "Mérnök utca 35", enemyTeam: "EDSE II.", homeGoals: 0, awayGoals: 0, selector: PitchSelector.BBFC, matchType: MatchType.LEAGUE, ratings: {});

    eventList.add(medExam);
    eventList.add(training);
    eventList.add(match);
  }

  String _getItemType(item, L10n l10n){
    if(item is Match){
      return l10n.match;
    }

    if(item is Training){
      return l10n.training;
    }

    return l10n.sportsMedicineExamination;
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
      appBar: AppBar(title: Text(l10n.events)),
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
                          Text(_getItemType(eventList[index], l10n)),
                          Text(eventList[index].eventDate.toString().replaceAll("T", " ").replaceRange(
                              eventList[index].eventDate.toString().length-4,
                              eventList[index].eventDate.toString().length,
                              ""
                          )),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.access_time_filled),
                        iconSize: 40,
                        onPressed: () {

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
