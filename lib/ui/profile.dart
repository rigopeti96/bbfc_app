import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  ProfileState createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile>{
  ProfileState();

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
              child: Text("${l10n.fullNameTag}: Rigó Peti"),
            ),
            Padding(
              padding: const EdgeInsets.all(5), //apply padding to all four sides
              child: Text("${l10n.userNameTag}: testuser_rigopeti96"),
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