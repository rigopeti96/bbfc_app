import 'package:bbfc_application/ui/mainMenu.dart';
import 'package:bbfc_application/exception/loginFieldIsEmptyException.dart';
import 'package:flutter/material.dart';
import 'gen_l10n/l10n.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';


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
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  void _login(BuildContext context, L10n l10n) {
    try{
      if(_validateLoginFields(l10n))
        _navigateToMainMenu(context);
    } on LoginFieldIsEmptyException catch (e){
      _showAlertDialog(context, l10n, e.cause);
    }

  }

  void _navigateToMainMenu(BuildContext context) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => const MainMenu(),
      ),
    );
  }

  bool _validateLoginFields(L10n l10n){
    if(usernameController.text == "" || passwordController.text == "")
      throw new LoginFieldIsEmptyException(l10n.loginFieldIsEmptyExceptionMessage);

    return true;
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
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/splash.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
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