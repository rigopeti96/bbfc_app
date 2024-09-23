import 'package:bbfc_application/entity/rating.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/exception/ratingFieldIsEmptyException.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:bbfc_application/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class RateTeammatesPage extends StatefulWidget{
  final User user;
  const RateTeammatesPage({super.key, required this.user});

  @override
  RateTeammatesState createState() {
    return RateTeammatesState(user: user);
  }
}

class RateTeammatesState extends State<RateTeammatesPage>{
  Validator validator = Validator();
  TestItemGenerator generator = TestItemGenerator();
  final User user;
  List<User> registeredUserList = [];
  RateTeammatesState({required this.user});
  List<Rating> ratings = [];
  final ratingController = TextEditingController();

  void _insertRating(String rateValue, User ratedUser, L10n l10n){
    try{
      if(validator.validateRating(rateValue, l10n)) {
        Rating rating = Rating(ratedPlayer: ratedUser, rater: user, rateValue: int.parse(rateValue));
        ratings.add(rating);
      }
    } on RatingFieldIsEmptyException catch (e) {
      _showAlertDialog(context, l10n, e.cause);
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

  void onTapGesture(item) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text("$item is selected"),
    ));
  }

  @override
  Widget build(BuildContext context) {
    registeredUserList.add(generator.createAppliedUser1());
    registeredUserList.add(generator.createAppliedUser2());
    registeredUserList.add(generator.createAppliedUser3());
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.profile)),
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
                      Row(
                        children: [
                          Text(registeredUserList[index].name),
                          TextField(
                            controller: ratingController,
                            obscureText: true,
                            decoration: InputDecoration(
                                hintText: l10n.passwordTag,
                                filled: true,
                                fillColor: Colors.white
                            ),
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(Icons.navigate_next),
                        iconSize: 40,
                        onPressed: () {
                          _insertRating(ratingController.text, generator.createAppliedUser1(), l10n);
                        },
                      )
                    ],
                  )
              ),
            ),
            onTap: () => onTapGesture(registeredUserList[index]),
          );
        },
      ),
    );
  }
}
