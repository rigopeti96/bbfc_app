import 'package:bbfc_application/entity/sportsMedicineExamination.dart';
import 'package:bbfc_application/entity/training.dart';
import 'package:bbfc_application/entity/match.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/matchType.dart';
import 'package:bbfc_application/enum/pitchSelector.dart';
import 'package:bbfc_application/ui/eventApplication.dart';
import 'package:bbfc_application/ui/rateTeammates.dart';
import 'package:bbfc_application/ui/trainingHistoryData.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
import 'package:uuid/uuid.dart';

import '../entity/event.dart';
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

  void _generateEvents(){
    appliedPlayers.add(generator.createAppliedUser1());
    appliedPlayers.add(generator.createAppliedUser2());
    appliedPlayers.add(generator.createAppliedUser3());
    Training training = Training(
        id: uuid.v4(), modifyDate: DateTime.now(), modifyUser: generator.createCreatorUser(), eventDate: DateTime.now(), meetingTime: DateTime.now(), eventLocationZipCode: 1115, eventLocationCity: "Budapest", eventLocationAddress: "Mérnök utca 35", duration: 2, trainingPlan: "", appliedPlayers: appliedPlayers);

    trainingList.add(training);
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
    _generateEvents();
    final L10n l10n = L10n.of(context)!;
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
                      Text("${l10n.training} - ${trainingList[index].eventDate}"),
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
