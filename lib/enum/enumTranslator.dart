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
      case "MatchReportItemType.YELLOW_CARD":
        return l10n.yellowCard;
      case "MatchReportItemType.RED_CARD":
        return l10n.redCard;
      case "MatchReportItemType.GOAL":
        return l10n.goal;
    }

    return "";
  }
}