import 'package:bbfc_application/entity/user.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class CertificateManagerPage extends StatefulWidget{
  final User actUser;
  final User visitedUser;
  const CertificateManagerPage({super.key, required this.actUser, required this.visitedUser});

  @override
  CertificateManagerState createState() {
    return CertificateManagerState(actUser: actUser, visitedUser: visitedUser);
  }
}

class CertificateManagerState extends State<CertificateManagerPage>{
  final User actUser;
  final User visitedUser;
  CertificateManagerState({required this.actUser, required this.visitedUser});

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Text("${l10n.fullNameTag}: ${visitedUser.name}"),
            ),
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Text("${l10n.userNameTag}: ${visitedUser.username}"),
            ),
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Text("${l10n.emailTag}: ${user.email}"),
            ),
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Text("${l10n.emailTag}: rigopeti96@gmail.com"),
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