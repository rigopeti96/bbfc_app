import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class SeniorityPage extends StatelessWidget{
  final User actUser;
  final TestItemGenerator generator = TestItemGenerator();
  late final List<User> registeredUserList;

  SeniorityPage({super.key, required this.actUser}){
    registeredUserList = [];
    registeredUserList.add(generator.createAppliedUser1());
    registeredUserList.add(generator.createAppliedUser2());
    registeredUserList.add(generator.createAppliedUser3());
  }

  void onTapGesture(item, context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$item is selected"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    //_generateRegisteredUsers();
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.seniority)),
      body: ListView.builder(
        itemCount: registeredUserList.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            child: Card(
              child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("${index+1}."),
                      Text(registeredUserList[index].name),
                      Text(registeredUserList[index].matchPlayed.toString()),
                    ],
                  )
              ),
            ),
            onTap: () => onTapGesture(registeredUserList[index], context),
          );
        },
      ),
    );
  }
}
