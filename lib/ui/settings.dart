import 'package:bbfc_application/exception/passwordNotMatchException.dart';
import 'package:flutter/material.dart';
import '../util/validator.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class SettingsPage extends StatefulWidget{
  const SettingsPage({super.key});

  @override
  SettingState createState() {
    return SettingState();
  }
}

class SettingState extends State<SettingsPage> {
  SettingState();

  final passwordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final newPasswordConfController = TextEditingController();

  void _saveNewPassword(String oldPassword, String newPassword, String newPasswordConf, L10n l10n){
    Validator validator = Validator();
    try{
      validator.validatePasswordChange("a", oldPassword, newPassword, newPasswordConf, l10n);
      Navigator.of(context).pop();
    } on PasswordNotMatchException catch (e){
      _showToast(context, e.cause, l10n.okButtonText);
    }
  }

  void _showToast(BuildContext context, String message, String okButton) {
    final scaffold = ScaffoldMessenger.of(context);
    scaffold.showSnackBar(
      SnackBar(
        content: Text(message),
        action: SnackBarAction(label: okButton, onPressed: scaffold.hideCurrentSnackBar),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextButton(
              onPressed: () {
                showDialog(builder: (context) => Dialog(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(hintText: l10n.passwordTag),
                        controller: passwordController,

                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(hintText: l10n.newPasswordTag),
                        controller: newPasswordController,

                      ),
                      TextField(
                        obscureText: true,
                        decoration: InputDecoration(hintText: l10n.newPasswordConfTag),
                        controller: newPasswordConfController,

                      ),
                      TextButton(
                        child: Text(l10n.saveButtonText),
                        onPressed: (){
                          _saveNewPassword(passwordController.text, newPasswordController.text, newPasswordConfController.text, l10n);
                        },
                      )
                    ],
                  ),

                ), context: context);
              },
              child: Text(l10n.changePassword),
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