import 'package:bbfc_application/network/communicationApi.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../main.dart';

export 'package:flutter_gen/gen_l10n/l10n.dart';

class Profile extends StatefulWidget{
  const Profile({super.key});

  @override
  ProfileState createState() {
    return ProfileState();
  }
}

class ProfileState extends State<Profile>{
  L10n? l10n;
  CommunicationApi communicationApi = CommunicationApi();

  @override
  void initState() {
    super.initState();
  }

  _showAlertDialog(L10n l10n, String errorMessage) {
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

  @override
  Widget build(BuildContext context) {
    l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.profile)),
      body: Center(
        child: FutureBuilder(
          future: communicationApi.getUserData(l10n!),
          builder: (context, snapshot){
            if (snapshot.hasData) {
              return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                   Padding(
                    padding: const EdgeInsets.all(5), //apply padding to all four sides
                    child: Text("${l10n!.fullNameTag}: ${snapshot.data!.name}"),

                  ),
                  Padding(
                    padding: const EdgeInsets.all(5), //apply padding to all four sides
                    child: Text("${l10n!.emailTag}: ${snapshot.data!.email}"),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5), //apply padding to all four sides
                    child: Text("${l10n!.address}: ${snapshot.data!.addressZip} ${snapshot.data!.addressCity}, ${snapshot.data!.addressStreet}, "),
                  ),
                  Expanded(
                    child: Align(
                      alignment: FractionalOffset.bottomCenter,
                      child: MaterialButton(
                        onPressed: (){
                          Navigator.of(context).pop();
                        },
                        child: Text(l10n!.back),
                      ),
                    ),
                  )
                ]
              );
            } else if (snapshot.hasError) {
              _showAlertDialog(l10n!, l10n!.userNotFoundExceptionMessage);
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          }
        ),
      ),
    );
  }
}