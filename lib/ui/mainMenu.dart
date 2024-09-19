import 'package:bbfc_application/ui/injuryRegister.dart';
import 'package:bbfc_application/ui/profile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  void _navigateToProfile(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const Profile(),
      ),
    );
  }

  void _navigateToInjuryRegister(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const InjuryRegisterPage(),
      ),
    );
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
                  ElevatedButton(
                    child: Text(l10n.profile),
                    onPressed: (){
                      _navigateToProfile(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text(l10n.events),
                    onPressed: (){

                    },
                  ),
                  ElevatedButton(
                    child: Text(l10n.injury),
                    onPressed: (){
                      _navigateToInjuryRegister(context);
                    },
                  ),
                  ElevatedButton(
                    child: Text(l10n.settings),
                    onPressed: (){

                    },
                  ),
                ],
            ),
        ),
    );
  }
}