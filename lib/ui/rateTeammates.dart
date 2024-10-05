import 'package:bbfc_application/entity/rating.dart';
import 'package:bbfc_application/entity/user.dart';
import 'package:bbfc_application/exception/ratingFieldIsEmptyException.dart';
import 'package:bbfc_application/exception/ratingValueIsInvalidException.dart';
import 'package:bbfc_application/util/testItemGenerator.dart';
import 'package:bbfc_application/util/validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  List<dynamic> registeredUserList = [];
  RateTeammatesState({required this.user});
  List<Rating> ratings = [];

  void _insertRating(String rateValue, User ratedUser, L10n l10n){
    try{
      if(validator.validateRating(rateValue, l10n)) {
        for(var i = 0; i < ratings.length; i++){
          if(ratings[i].ratedPlayer.id == ratedUser.id){
            setState(() {
              ratings[i].rateValue = int.parse(rateValue);
            });
          }
        }
      }
    } on RatingFieldIsEmptyException catch (e) {
      _showAlertDialog(context, l10n, e.cause);
    } on RatingValueIsInvalidException catch(e){
      _showAlertDialog(context, l10n, e.cause);
    }
  }

  _showRatingDialog(BuildContext context, L10n l10n, User ratedUser){
    final ratingController = TextEditingController();
    showDialog(builder: (context) => Dialog(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(ratedUser.name),
              TextField(
                  keyboardType: TextInputType.number,
                  inputFormatters: <TextInputFormatter>[
                    FilteringTextInputFormatter.digitsOnly
                  ],
                decoration: InputDecoration(hintText: l10n.ratingTag),
                controller: ratingController
              ),
              TextButton(
                child: Text(l10n.ratingTitle),
                onPressed: (){
                  _insertRating(ratingController.text, ratedUser, l10n);
                  Navigator.of(context).pop(ratingController.text);
                },
              )
            ],
          ),
        )
    ), context: context);
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

  void _generateRegisteredUsers(){
    registeredUserList.add(generator.createAppliedUser1());
    registeredUserList.add(generator.createAppliedUser2());
    registeredUserList.add(generator.createAppliedUser3());
    _initRating();
  }

  void _initRating(){
    for(var i = 0; i < registeredUserList.length; i++){
      Rating rating = Rating(ratedPlayer: user, rater: registeredUserList[i], rateValue: 0);
      ratings.add(rating);
    }
  }

  @override
  Widget build(BuildContext context) {
    _generateRegisteredUsers();
    final L10n l10n = L10n.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.ratingTitle)),
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
                      Text(registeredUserList[index].name),
                      Text(ratings[index].rateValue.toString()),
                      IconButton(
                        icon: const Icon(Icons.navigate_next),
                        iconSize: 40,
                        onPressed: () {
                          _showRatingDialog(context, l10n, registeredUserList[index]);
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
