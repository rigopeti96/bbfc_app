import 'package:bbfc_application/entity/user.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../main.dart';

class UserHandlingPage extends StatefulWidget{
  final User actUser;
  const UserHandlingPage({super.key, required this.actUser});

  @override
  UserHandlingPageState createState() {
    return UserHandlingPageState(user: actUser);
  }
}

class UserHandlingPageState extends State<UserHandlingPage> {
  final User user;
  int _switchIndex = 0;
  final addressCityController = TextEditingController();
  final addressController = TextEditingController();
  final zipController = TextEditingController();

  UserHandlingPageState({required this.user});

  bool _isNewPlayer(){
    return _switchIndex == 0;
  }

  String _getTitleString(L10n l10n){
    if(_isNewPlayer()){
      return l10n.createUser;
    } else {
      return l10n.modifyUser;
    }
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
        appBar: AppBar(title: Text(l10n.profile)),
        body: Center(
          child: Column(
            children: [
              ToggleSwitch(
                initialLabelIndex: _switchIndex,
                totalSwitches: 2,
                labels: [l10n.createUser, l10n.modifyUser],
                minWidth: 100.0,
                cornerRadius: 20.0,
                activeFgColor: Colors.white,
                inactiveBgColor: Colors.grey,
                inactiveFgColor: Colors.white,
                activeBgColors: const [[Colors.green],[Colors.blue]],
                onToggle: (index) {
                  setState(() {
                    _switchIndex = index!;
                  });
                },
              ),
              Text(_getTitleString(l10n)),
              Text(l10n.fullNameTag),
              Text(l10n.createEventDate),
              Padding(
                padding: const EdgeInsets.all(5), //apply padding to all four sides
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(3), //apply padding to all four sides
                        child: TextField(
                          controller: zipController,
                          decoration: InputDecoration(
                            hintText: l10n.createEventZipTag,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.all(3), //apply padding to all four sides
                        child: TextField(
                          controller: addressCityController,
                          decoration: InputDecoration(
                            hintText: l10n.createEventAddressCityTag,
                            filled: true,
                            fillColor: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(3), //apply padding to all four sides
                child: TextField(
                  controller: addressController,
                  decoration: InputDecoration(
                    hintText: l10n.createEventAddressTag,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: MaterialButton(
                    onPressed: (){
                      Navigator.of(context).pop();
                    },
                    child: Text(_getTitleString(l10n)),
                  ),
                ),
              ),
            ],
          )
        )
    );
  }
}