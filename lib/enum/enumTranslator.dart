import '../main.dart';

class EnumTranslator {
  String translate(String label, L10n l10n){
    switch(label){
      case "Training":
        return l10n.training;
      case "Match":
        return l10n.match;
      case "SportsMedicineExamination":
        return l10n.sportsMedicineExamination;
      case "Home":
        return l10n.createEventSelectorValueHome;
      case "Away":
        return l10n.createEventSelectorValueAway;
      case "Cup":
        return l10n.createMatchTypeValueCup;
      case "League":
        return l10n.createMatchTypeValueLeague;
      case "Yellow_card":
        //TODO: translate change return value
        break;
      case "Red_card":
        //TODO: translate change return value
        break;
      case "Goal":
        //TODO: translate change return value
        break;
    }

    return "";
  }
}