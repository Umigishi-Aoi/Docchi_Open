import 'dart:async';
import 'package:drift/drift.dart';
import 'package:flutter/cupertino.dart';

import '../model/choices_model.dart';

import '../model/drift/drift_db.dart';

class DriftRepository {
  late ChoicesDatabase choiceDatabase;
  late ChoiceDao _choiceDao;
  Stream<List<Choice>>? choiceStream;

  //使わないかもだけど、一応定義
  Future<List<Choice>> findAllChoices(){
    return _choiceDao
        .allDriftChoiceEntries
        .then<List<Choice>>((List<DriftChoiceData> driftChoices){
      final choices = <Choice>[];
      driftChoices.forEach(
        (driftChoice) async{
        final choice = driftChoiceToChoice(driftChoice);
        choices.add(choice);
        },
      );
      return choices;
    },);
  }

  Future<Choice> findRecipeById(int id) {
    return _choiceDao
        .findChoiceById(id)
        .then((listOfChoices) => driftChoiceToChoice(listOfChoices.first));
  }

  Stream<List<Choice>> watchAllChoices(){
    choiceStream ??= _choiceDao.watchAllChoices();
    return choiceStream!;
  }



  //インサート処理
  Future<int> insertChoice(Choice choice){
    return Future(() async{
      final id =
          await _choiceDao.insertChoice(choiceToInsertableDriftChoice(choice));

      return id;
    },);
  }

  //アップデート処理
  Future<void> updateChoice(Choice choice,int id){
    return Future(() async{
      await _choiceDao.updateChoice(choiceToInsertableDriftChoice(choice),id);
      return ;
    },);
  }

  Future<void> deleteChoice(Choice choice){
    return Future(() async{
      if(choice.id!=null){
        await _choiceDao.deleteChoice(choice.id!);
      }
      return ;
    },);
  }

  //データベース初期化処理
  Future init() async{
    choiceDatabase = ChoicesDatabase();
    _choiceDao = choiceDatabase.choiceDao;
  }

  Future initData(BuildContext context) async{

    List<Choice> choices;

    choices = await findAllChoices();

    if(choices.isEmpty) {
      await insertChoice(Choice.preset1(context));
      await insertChoice(Choice.preset2(context));
      await insertChoice(Choice.preset3(context));
      await insertChoice(Choice.preset4(context));
      await insertChoice(Choice.preset5(context));
    }
  }

  //データベースクローズ処理
  void close(){
    choiceDatabase.close();
  }

}