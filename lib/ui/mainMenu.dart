import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/permisson.dart';
import 'package:bbfc_application/ui/eventCreator.dart';
import 'package:bbfc_application/ui/eventList.dart';
import 'package:bbfc_application/ui/historyList.dart';
import 'package:bbfc_application/ui/injuryRegister.dart';
import 'package:bbfc_application/ui/matchReport.dart';
import 'package:bbfc_application/ui/profile.dart';
import 'package:bbfc_application/ui/seniority.dart';
import 'package:bbfc_application/ui/settings.dart';
import 'package:bbfc_application/ui/trainingHistoryList.dart';
import 'package:bbfc_application/ui/userHandlingPage.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class MainMenu extends StatelessWidget {
  final User actUser;
  MainMenu({super.key, required this.actUser});
  final TestItemGenerator generator = TestItemGenerator();

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => Profile(user: generator.createCreatorUser()),
      ),
    );
  }

  void _navigateToInjuryRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => InjuryRegisterPage(actUser: actUser),
      ),
    );
  }

  void _navigateToEvents(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const EventListPage(),
      ),
    );
  }

  void _navigateToHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HistoryListPage(actUser: actUser),
      ),
    );
  }

  void _navigateToTrainingHistory(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => TrainingHistoryListPage(actUser: actUser),
      ),
    );
  }

  void _navigateToSettings(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const SettingsPage(),
      ),
    );
  }

  void _navigateToEventCreatorHub(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EventCreatorPage(actUser: actUser),
      ),
    );
  }

  void _navigateToUserHandlingPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => UserHandlingPage(actUser: actUser),
      ),
    );
  }

  void _navigateToSeniorityPage(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => SeniorityPage(actUser: actUser),
      ),
    );
  }

  bool _isPlayerPermission(){
    if(actUser.roles == Permission.PLAYER){
      return true;
    }

    return false;
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
                  MaterialButton(
                    child: Text(l10n.profile),
                    onPressed: (){
                      _navigateToProfile(context);
                    },
                  ),
                  MaterialButton(
                    child: Text(l10n.events),
                    onPressed: (){
                      _navigateToEvents(context);
                    },
                  ),
                  MaterialButton(
                    child: Text(l10n.history),
                    onPressed: (){
                      _navigateToHistory(context);
                    },
                  ),
                  MaterialButton(
                    child: Text(l10n.trainingHistory),
                    onPressed: (){
                      _navigateToTrainingHistory(context);
                    },
                  ),
                  Visibility(
                    visible: !_isPlayerPermission(),
                    child: MaterialButton(
                      child: Text(l10n.createEventTitle),
                      onPressed: (){
                        _navigateToEventCreatorHub(context);
                      },
                    ),
                  ),
                  Visibility(
                    visible: !_isPlayerPermission(),
                    child: MaterialButton(
                      child: Text(l10n.userHandling),
                      onPressed: (){
                        _navigateToUserHandlingPage(context);
                      },
                    ),
                  ),
                  MaterialButton(
                    child: Text(l10n.injury),
                    onPressed: (){
                      _navigateToInjuryRegister(context);
                    },
                  ),
                  MaterialButton(
                    child: Text(l10n.settings),
                    onPressed: (){
                      _navigateToSettings(context);
                    },
                  ),
                  MaterialButton(
                    child: Text(l10n.seniority),
                    onPressed: (){
                      _navigateToSeniorityPage(context);
                    },
                  ),
                ],
            ),
        ),
    );
  }
}