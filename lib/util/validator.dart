import 'package:bbfc_application/exception/passwordNotMatchException.dart';
import 'package:bbfc_application/exception/ratingFieldIsEmptyException.dart';
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

    return true;
  }
}