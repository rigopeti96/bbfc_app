import 'package:bbfc_application/entity/user.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class UserHandlingPage extends StatefulWidget{
  final User user;
  const UserHandlingPage({super.key, required this.user});

  @override
  UserHandlingPageState createState() {
    return UserHandlingPageState(user: user);
  }
}

class UserHandlingPageState extends State<UserHandlingPage> {
  final User user;

  UserHandlingPageState({required this.user});

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
        appBar: AppBar(title: Text(l10n.profile)),
        body: Center()
    );
  }
}