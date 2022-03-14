import 'package:flutter/cupertino.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class Choice {
  int? id;
  final String title;
  final String choice1;
  final String choice2;

  Choice({this.id,required this.title, required this.choice1, required this.choice2});

  factory Choice.preset1(BuildContext context){
    return Choice(
        title: AppLocalizations.of(context)!.doOrDont,
        choice1: AppLocalizations.of(context)!.doo,
        choice2: AppLocalizations.of(context)!.dont,);
  }

  factory Choice.preset2(BuildContext context){
    return Choice(
      title: AppLocalizations.of(context)!.buyOrDont,
      choice1: AppLocalizations.of(context)!.buy,
      choice2: AppLocalizations.of(context)!.dontBuy,);
  }

  factory Choice.preset3(BuildContext context){
    return Choice(
      title: AppLocalizations.of(context)!.rightOrLeft,
      choice1: AppLocalizations.of(context)!.left,
      choice2: AppLocalizations.of(context)!.right,);
  }

  factory Choice.preset4(BuildContext context){
    return Choice(
      title: AppLocalizations.of(context)!.seaOrMountain,
      choice1: AppLocalizations.of(context)!.sea,
      choice2: AppLocalizations.of(context)!.mountain,);
  }

  factory Choice.preset5(BuildContext context){
    return Choice(
      title: AppLocalizations.of(context)!.summerOrWinter,
      choice1: AppLocalizations.of(context)!.summer,
      choice2: AppLocalizations.of(context)!.winter,);
  }

  //Choiceが同じか否か確かめるためのメソッド
  bool check(Choice choices){
    return title == choices.title
        && choice1 == choices.choice1
        && choice2 == choices.choice2;
  }

}