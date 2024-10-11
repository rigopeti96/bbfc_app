import 'package:bbfc_application/entity/rating.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/exception/selectedDateIsInvalidException.dart';
import 'package:bbfc_application/exception/userNotFoundExcepiton.dart';
import 'package:bbfc_application/ui/certificateManager.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:bbfc_application/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../main.dart';

class UserHandlingPage extends StatefulWidget{
  final User actUser;
  List<User> userList = [];
  TestItemGenerator _generator = new TestItemGenerator();
  UserHandlingPage({super.key, required this.actUser}){
    userList.add(_generator.createAppliedUser1());
    userList.add(_generator.createAppliedUser2());
    userList.add(_generator.createAppliedUser3());
  }

  @override
  UserHandlingPageState createState() {
    return UserHandlingPageState(user: actUser, userList: userList);
  }
}

class UserHandlingPageState extends State<UserHandlingPage> {
  final User user;
  int _switchIndex = 0;
  DateTime selectedDate = DateTime.now();
  final nameController = TextEditingController();
  final birthPlaceController = TextEditingController();
  final addressCityController = TextEditingController();
  final addressController = TextEditingController();
  final zipController = TextEditingController();
  final List<User> userList;
  String selectorValue = "";
  final Validator validator = Validator();

  UserHandlingPageState({required this.user, required this.userList}){
    selectorValue = userList.first.name;
  }

  User _findSelectedUser(L10n l10n){
    for(int i = 0; i < userList.length; i++){
      if(userList[i].name == selectorValue){
        return userList[i];
      }
    }

    throw UserNotFoundException(l10n.userNotFoundExceptionMessage);
  }

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

  double _calculateUserRating(User user){
    Set<Rating> ratings = user.ratings;
    int ratingsTotal = 0;

    for(int i = 0; i < ratings.length; i++){
      ratingsTotal = ratingsTotal + ratings.elementAt(i).rateValue;
    }

    return ratingsTotal/ratings.length;
  }

  _stringifyEnumValue(L10n l10n, String value){
    switch(value){
      case "Status.AVAILABLE":
        return l10n.available;
      case "Status.SUSPENDED":
        return l10n.suspended;
      case "Status.INJURED":
        return l10n.injured;
    }
  }

  _fillTextFields(L10n l10n){
    if(_isNewPlayer()){
      User selectedUser = _findSelectedUser(l10n);
      nameController.text = selectedUser.name;
      birthPlaceController.text = selectedUser.birthPlace;
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

  Future<void> _selectDate(BuildContext context, L10n l10n) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));

    if (picked != null && picked != selectedDate) {
      try{
        if(validator.validateSelectedBirthDate(picked, l10n)){
          setState(() {
            selectedDate = picked;
          });
        }
      } on SelectedDateIsInvalidException catch(e){
        _showAlertDialog(context, l10n, e.cause);
      }
    }
  }

  void _navigateToCertificateManagerPage(BuildContext context, L10n l10n) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => CertificateManagerPage(actUser: user, visitedUser: _findSelectedUser(l10n)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
        appBar: AppBar(title: Text(l10n.userHandling)),
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
                    selectorValue = userList[index].name;
                    _fillTextFields(l10n);
                  });
                },
              ),
              Visibility(
                visible: !_isNewPlayer(),
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      DropdownButton<String>(
                        value: selectorValue,
                        icon: const Icon(Icons.arrow_downward),
                        elevation: 16,
                        style: const TextStyle(color: Colors.deepPurple),
                        underline: Container(
                          height: 2,
                          color: Colors.deepPurpleAccent,
                        ),
                        onChanged: (String? value) {
                          // This is called when the user selects an item.
                          setState(() {
                            selectorValue = value!;
                          });
                        },
                        items: userList.map<DropdownMenuItem<String>>((User value) {
                          return DropdownMenuItem<String>(
                            value: value.name,
                            child: Text(value.name),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                )
              ),
              Text(_getTitleString(l10n)),
              Text(l10n.fullNameTag),
              Padding(
                padding: const EdgeInsets.all(3), //apply padding to all four sides
                child: TextField(
                  controller: nameController,
                  decoration: InputDecoration(
                    hintText: l10n.fullNameTag,
                    filled: true,
                    fillColor: Colors.white,
                  ),
                ),
              ),
              Text(l10n.birthDateAndPlace),
              Text("${selectedDate.toLocal()}".split(' ')[0]),
              const SizedBox(height: 20.0,),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size.fromHeight(40), // fromHeight use double.infinity as width and 40 is the height
                ),
                onPressed: () => _selectDate(context, l10n),
                child: Text(l10n.btnSelectDate),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.all(3), //apply padding to all four sides
                  child: TextField(
                    controller: birthPlaceController,
                    decoration: InputDecoration(
                      hintText: l10n.birthPlaceHint,
                      filled: true,
                      fillColor: Colors.white,
                    ),
                  ),
                ),
              ),
              Text(l10n.address),
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
              Visibility(
                visible: !_isNewPlayer(),
                child: Column(
                  children: [
                    Text("${l10n.numberOfGoals}${_findSelectedUser(l10n).goals}"),
                    Text("${l10n.numberOfAssists}${_findSelectedUser(l10n).assists}"),
                    Text("${l10n.ratingTag}${_calculateUserRating(_findSelectedUser(l10n))}"),
                    Text("${l10n.playerStatus}${_stringifyEnumValue(l10n, _findSelectedUser(l10n).playerStatus.toString())}"),
                    Visibility(
                      visible: _findSelectedUser(l10n).injuredUntil != null,
                      child: Text("${l10n.injuredUntil}${_findSelectedUser(l10n).injuredUntil}"),
                    ),
                    Visibility(
                      visible: _findSelectedUser(l10n).suspendedUntil != null,
                      child: Text("${l10n.suspendedUntil}${_findSelectedUser(l10n).suspendedUntil}"),
                    )
                  ],
                ),
              ),
              Expanded(
                child: Align(
                  alignment: FractionalOffset.bottomCenter,
                  child: Visibility(
                    visible: !_isNewPlayer(),
                    child: MaterialButton(
                      onPressed: (){
                        _navigateToCertificateManagerPage(context, l10n);
                      },
                      child: Text(l10n.manageCertificate),
                    ),
                  )
                ),
              ),
            ],
          )
        )
    );
  }
}