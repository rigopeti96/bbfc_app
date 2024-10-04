import 'package:bbfc_application/exception/passwordNotMatchException.dart';
import 'package:bbfc_application/exception/ratingFieldIsEmptyException.dart';
import 'package:bbfc_application/exception/ratingValueIsInvalidException.dart';
import 'package:bbfc_application/exception/selectedDateIsInvalidException.dart';
import 'package:bbfc_application/exception/trainingFieldIsEmptyException.dart';
import 'package:flutter_gen/gen_l10n/l10n.dart';

import '../exception/loginFieldIsEmptyException.dart';
export 'package:flutter_gen/gen_l10n/l10n.dart';

class Validator {
  bool validateLoginFields(String username, String password, L10n l10n){
    if(username.isEmpty || password.isEmpty) {
      throw LoginFieldIsEmptyException(l10n.loginFieldIsEmptyExceptionMessage);
    }

    return true;
  }

  bool validateSelectedDate(DateTime picked, L10n l10n){
    if(picked.isBefore(DateTime.now())){
      throw SelectedDateIsInvalidException(l10n.selectedDateIsInvalidExceptionMessage);
    }

    return true;
  }

  bool validatePasswordChange(String actPassword, String oldPassword, String newPassword, String newPasswordConf, L10n l10n){
    if(actPassword != oldPassword){
      throw PasswordNotMatchException(l10n.oldAndNewPasswordNotMatchExceptionMessage);
    }

    if(newPassword != newPasswordConf){
      throw PasswordNotMatchException(l10n.newPasswordAndConfirmExceptionMessage);
    }

    return true;
  }

  bool validateRating(String actualRating, L10n l10n){
    if(actualRating.isEmpty || actualRating == ""){
      throw RatingFieldIsEmptyException(l10n.ratingFieldIsEmptyExceptionMessage);
    }

    if(int.parse(actualRating) < 1 || int.parse(actualRating) > 10){
      throw RatingValueIsInvalidException(l10n.ratingValueIsInvalidExceptionMessage);
    }

    return true;
  }

  bool validateTrainingPlan(String trainingPlan, L10n l10n){
    if(trainingPlan.isEmpty || trainingPlan == ""){
      throw TrainingFieldIsEmptyException(l10n.trainingFieldIsEmptyExceptionMessage);
    }

    return true;
  }
}