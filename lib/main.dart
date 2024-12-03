import 'dart:async';
import 'dart:convert';

import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/exception/loginFailedException.dart';
import 'package:bbfc_application/network/dao/response/loginDataResponse.dart';
import 'package:bbfc_application/ui/mainMenu.dart';
import 'package:bbfc_application/exception/loginFieldIsEmptyException.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:bbfc_application/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'gen_l10n/l10n.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

String jwtToken = "";
String userName = "";
int timeout = 5;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatelessWidget {
  MyHomePage({Key? key}) : super(key: key);
  final TestItemGenerator generator = TestItemGenerator();
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<LoginDataResponse> _login(BuildContext context, L10n l10n) async{
    Validator validator = Validator();

    try{
      validator.validateLoginFields(usernameController.text, passwordController.text, l10n);

      final response = await http.post(
        Uri.parse('http://192.168.0.171:8080/auth/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(<String, String>{
          'username': usernameController.text,
          'password': passwordController.text,
        }),
      );

      switch(response.statusCode){
        case 200:
          LoginDataResponse loginResponse = LoginDataResponse.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
          jwtToken = loginResponse.accessToken;
          userName = loginResponse.employeename;
          _navigateToMainMenu(context);
          return loginResponse;
        case 401:
          throw LoginFailedException(l10n.badCredentialExceptionMessage);
        default:
          throw LoginFailedException(l10n.defaultLoginExceptionMessage);
      }

    } on LoginFieldIsEmptyException catch (e) {
      _showAlertDialog(context, l10n, e.cause);
      throw LoginFieldIsEmptyException(e.cause);
    } on LoginFailedException catch (e) {
      _showAlertDialog(context, l10n, e.cause);
      throw LoginFailedException(e.cause);
    } on http.ClientException {
      _showAlertDialog(context, l10n, l10n.timeoutExceptionMessage);
      throw LoginFailedException(l10n.timeoutExceptionMessage);
    }
  }

  void _navigateToMainMenu(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MainMenu(),
      ),
    );
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
    final L10n? l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n!.homeTitle)),
      body: Container(
        /*decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash.jpg"),
            fit: BoxFit.cover,
          ),
        ),*/
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset('icon/bbfc_icon.png'),
              TextField(
                controller: usernameController,
                decoration: InputDecoration(
                  hintText: l10n.userNameTag,
                  filled: true,
                  fillColor: Colors.white,
                ),
              ),
              TextField(
                controller: passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    hintText: l10n.passwordTag,
                    filled: true,
                    fillColor: Colors.white
                ),
              ),
              ElevatedButton(
                child: Text(l10n.loginButton),
                onPressed: (){
                  _login(context, l10n);
                  //Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}