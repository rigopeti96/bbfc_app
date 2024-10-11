import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/exception/selectedDateIsInvalidException.dart';
import 'package:bbfc_application/util/validator.dart';
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
  bool _hasUserCertificate = false;
  Validator _validator = Validator();
  DateTime _newSportExamValidity = DateTime.now();
  DateTime _newPhotoValidity = DateTime.now();

  CertificateManagerState({required this.actUser, required this.visitedUser}){
    if(visitedUser.certificate != null){
      _hasUserCertificate = true;
    }
  }

  Future<void> _selectExamValidityDate(BuildContext context, L10n l10n) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _newSportExamValidity,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != _newSportExamValidity) {
      try{
        if(_validator.validateSelectedDate(picked, l10n)){
          setState(() {
            _newSportExamValidity = picked;
          });
        }
      } on SelectedDateIsInvalidException catch(e){
        _showAlertDialog(context, l10n, e.cause);
      }
    }
  }

  Future<void> _selectPhotoValidityDate(BuildContext context, L10n l10n) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: _newPhotoValidity,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != _newPhotoValidity) {
      try{
        if(_validator.validateSelectedDate(picked, l10n)){
          setState(() {
            _newPhotoValidity = picked;
          });
        }
      } on SelectedDateIsInvalidException catch(e){
        _showAlertDialog(context, l10n, e.cause);
      }
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

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text("${l10n.manageCertificate} - ${visitedUser.name}")),
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
            Visibility(
              visible: _hasUserCertificate,
              child: Column(
                children: [
                  Text("${l10n.photoValidUntil}${visitedUser.certificate?.photoValidUntil}"),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size.square(40), // fromHeight use double.infinity as width and 40 is the height
                          ),
                          onPressed: () => _selectPhotoValidityDate(context, l10n),
                          child: Text(l10n.btnSelectDate),
                        ),
                        ElevatedButton(
                          onPressed: () => _newPhotoValidity = DateTime.now(),
                          child: Text(l10n.btnSelectToday)
                        )
                      ],
                    )
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5), //apply padding to all four sides
                    child: Column(
                      children: [
                        Text("${l10n.photoValidUntil}${visitedUser.certificate?.photoValidUntil}"),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  minimumSize: const Size.square(40), // fromHeight use double.infinity as width and 40 is the height
                                ),
                                onPressed: () => _selectPhotoValidityDate(context, l10n),
                                child: Text(l10n.btnSelectDate),
                              ),
                              ElevatedButton(
                                onPressed: () => _newPhotoValidity = DateTime.now(),
                                child: Text(l10n.btnSelectToday)
                              )
                            ],
                          )
                        )
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(5), //apply padding to all four sides
                    child: Text("${l10n.freeExamSpaces}${visitedUser.certificate?.sportExamSpaces}"),
                  ),
                ],
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
              )
            ),
          ],
        ),
      ),
    );
  }
}