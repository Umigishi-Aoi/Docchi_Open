import 'package:drift/native.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p;
import 'package:drift/drift.dart';
import 'dart:io';

import '../choices_model.dart';

part 'drift_db.g.dart';

class DriftChoice extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get title => text()();
  TextColumn get choice1 => text()();
  TextColumn get choice2 => text()();
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'db.sqlite'));
    return NativeDatabase(file);
  });
}

@DriftDatabase(tables: [DriftChoice],daos:[ChoiceDao])
class ChoicesDatabase extends _$ChoicesDatabase {
  ChoicesDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

@DriftAccessor(tables: [DriftChoice])
class ChoiceDao extends DatabaseAccessor<ChoicesDatabase> with _$ChoiceDaoMixin{
  final ChoicesDatabase db;

  ChoiceDao(this.db) : super(db);

  Future<List<DriftChoiceData>> get allDriftChoiceEntries => select(driftChoice).get();

  Stream<List<Choice>> watchAllChoices(){
    return select(driftChoice)
        .watch()
        .map((rows){
        final choices = <Choice>[];
        rows.forEach((row) {
          final choice = driftChoiceToChoice(row);
          if(!choices.contains(choice)){
            choices.add(choice);
          }
        });
        return choices;
    },);

  }

  Future<List<DriftChoiceData>> findChoiceById(int id) =>
      (select(driftChoice)..where((tbl) => tbl.id.equals(id))).get();

  Future<int> insertChoice(Insertable<DriftChoiceData> choice) =>
      into(driftChoice).insert(choice);

  Future updateChoice(Insertable<DriftChoiceData> choice,int id) =>
      (update(driftChoice)
        ..where((tbl) => tbl.id.equals(id))
      ).write(choice);

  Future deleteChoice(int id) => Future.value(
      (delete(driftChoice)..where((tbl) => tbl.id.equals(id))).go()
  );

}

//変換メソッド
Choice driftChoiceToChoice(DriftChoiceData choice){
  return Choice(
    id:choice.id,
    title: choice.title,
    choice1: choice.choice1,
    choice2: choice.choice2,
  );
}

Insertable<DriftChoiceData> choiceToInsertableDriftChoice(Choice choice){
  return DriftChoiceCompanion.insert(
      title: choice.title,
      choice1: choice.choice1 ,
      choice2: choice.choice2 ,
  );
}