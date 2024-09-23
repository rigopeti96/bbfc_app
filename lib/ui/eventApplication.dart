import 'package:bbfc_application/util/validator.dart';
import 'package:flutter/material.dart';

import '../entity/event.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class EventApplicationPage extends StatelessWidget {
  final String eventId;
  const EventApplicationPage({super.key, required this.eventId});

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text("${l10n.shortTitle} - ${l10n.eventResponsePageTitle}"),),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(eventId),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
              ),
              child: Text(l10n.applyButton),
              onPressed: (){

              },
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
              ),
              child: Text(l10n.denyButton),
              onPressed: (){

              },
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