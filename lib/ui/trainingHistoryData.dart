import 'package:bbfc_application/entity/training.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/permisson.dart';
import 'package:bbfc_application/exception/trainingFieldIsEmptyException.dart';
import 'package:bbfc_application/util/validator.dart';
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
  Training training;
  final Validator validator = Validator();
  final planController = TextEditingController();
  TrainingHistoryDataPageState({required this.user, required this.training});

  void _saveTraining(String plan, L10n l10n){
    try{
      if(validator.validateTrainingPlan(plan, l10n)){
        training.trainingPlan = plan;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.trainingPlanSaved),
        ));
      }
    } on TrainingFieldIsEmptyException catch(e){
      _showAlertDialog(context, l10n, e.cause);
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
                  _saveTraining(planController.text, l10n);
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