import 'package:bbfc_application/entity/training.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
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
  final Training training;
  TrainingHistoryDataPageState({required this.user, required this.training});

  @override
  Widget build(BuildContext context) {
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
              child: Text(l10n.trainingPlan),
            ),
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Card(
                  color: Colors.white70,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextField(
                      maxLines: 8, //or null
                      decoration: InputDecoration.collapsed(hintText: l10n.trainingPlanHint),
                    ),
                  )
              )
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