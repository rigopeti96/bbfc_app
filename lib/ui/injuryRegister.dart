import 'dart:convert';

import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/enum/playerStatus.dart';
import 'package:bbfc_application/exception/selectedDateIsInvalidException.dart';
import 'package:bbfc_application/exception/statusUpdateException.dart';
import 'package:bbfc_application/main.dart';
import 'package:bbfc_application/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class InjuryRegisterPage extends StatefulWidget{
  final User actUser;
  const InjuryRegisterPage({super.key, required this.actUser});

  @override
  State<InjuryRegisterPage> createState() => InjuryRegisterPageState(actUser: actUser);
}

class InjuryRegisterPageState extends State<InjuryRegisterPage>{
  DateTime selectedDate = DateTime.now();
  final User actUser;
  final Validator validator = Validator();

  InjuryRegisterPageState({required this.actUser});

  Future<void> _selectDate(BuildContext context, L10n l10n) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      try{
        if(validator.validateSelectedDate(picked, l10n)){
          setState(() {
            selectedDate = picked;
          });
        }
      } on SelectedDateIsInvalidException catch(e){
        _showAlertDialog(context, l10n, e.cause);
      }
    }
  }

  Future<bool> _registerInjury(BuildContext context, L10n l10n) async{
    try{
      final response = await http.put(
        Uri.parse('http://192.168.0.171:8080/status'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': "Bearer $jwtToken",
        },
        body: jsonEncode(_createRequestMessage()),
      );

      if(response.statusCode == 200){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(l10n.playerStatusUpdated),
        ));
        return true;
      } else {
        throw StatusUpdateException(l10n.createUserExceptionMessage);
      }

    } on StatusUpdateException catch (e) {
      _showAlertDialog(context, l10n, e.cause);
      throw StatusUpdateException(e.cause);
    } on http.ClientException {
      _showAlertDialog(context, l10n, l10n.timeoutExceptionMessage);
      throw StatusUpdateException(l10n.timeoutExceptionMessage);
    }
  }

  Map <String, dynamic> _createRequestMessage() {
    final f = DateFormat('yyyy-MM-ddTHH:mm:ss.SSS');

    return {
      "newStatus": PlayerStatus.INJURED.toString().split(".")[1],
      "outUntil": f.format(selectedDate).toString()
    };
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
      appBar: AppBar(
        title: Text("${l10n.shortTitle} - ${l10n.injury}"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(l10n.injuryEstimatedUntil),
            Text("${selectedDate.toLocal()}".split(' ')[0]),
            const SizedBox(height: 20.0,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
              ),
              onPressed: () => _selectDate(context, l10n),
              child: const Text('Select date'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
              ),
              onPressed: () => _registerInjury(context, l10n),
              child: Text(l10n.update),
            ),
          ],
        ),
      ),
    );
  }
}