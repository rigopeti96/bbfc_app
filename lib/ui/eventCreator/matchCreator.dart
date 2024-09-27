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

class MatchCreatorHubPage extends StatefulWidget {
  final User actUser;

  MatchCreatorHubPage({super.key, required this.actUser});

  @override
  MatchCreatorHubPageState createState() {
    return MatchCreatorHubPageState(actUser: actUser);
  }
}

class MatchCreatorHubPageState extends State<MatchCreatorHubPage>{
  final User actUser;
  DateTime selectedDate = DateTime.now();

  MatchCreatorHubPageState({required this.actUser});

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text("${l10n.shortTitle} - ${l10n.mainMenuTitle}"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Row(
              children: <Widget>[
                  Text("data"),
                  TextField(),
              ]
            ),
            Row(
                children: <Widget>[
                  Text("data"),
                  TextField(),
                ]
            ),
          ],
        ),
      ),
    );
  }
}