// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'drift_db.dart';

// **************************************************************************
// MoorGenerator
// **************************************************************************

// ignore_for_file: unnecessary_brace_in_string_interps, unnecessary_this
class DriftChoiceData extends DataClass implements Insertable<DriftChoiceData> {
  final int id;
  final String title;
  final String choice1;
  final String choice2;
  DriftChoiceData(
      {required this.id,
      required this.title,
      required this.choice1,
      required this.choice2});
  factory DriftChoiceData.fromData(Map<String, dynamic> data,
      {String? prefix}) {
    final effectivePrefix = prefix ?? '';
    return DriftChoiceData(
      id: const IntType()
          .mapFromDatabaseResponse(data['${effectivePrefix}id'])!,
      title: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}title'])!,
      choice1: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}choice1'])!,
      choice2: const StringType()
          .mapFromDatabaseResponse(data['${effectivePrefix}choice2'])!,
    );
  }
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    map['title'] = Variable<String>(title);
    map['choice1'] = Variable<String>(choice1);
    map['choice2'] = Variable<String>(choice2);
    return map;
  }

  DriftChoiceCompanion toCompanion(bool nullToAbsent) {
    return DriftChoiceCompanion(
      id: Value(id),
      title: Value(title),
      choice1: Value(choice1),
      choice2: Value(choice2),
    );
  }

  factory DriftChoiceData.fromJson(Map<String, dynamic> json,
      {ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DriftChoiceData(
      id: serializer.fromJson<int>(json['id']),
      title: serializer.fromJson<String>(json['title']),
      choice1: serializer.fromJson<String>(json['choice1']),
      choice2: serializer.fromJson<String>(json['choice2']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<int>(id),
      'title': serializer.toJson<String>(title),
      'choice1': serializer.toJson<String>(choice1),
      'choice2': serializer.toJson<String>(choice2),
    };
  }

  DriftChoiceData copyWith(
          {int? id, String? title, String? choice1, String? choice2}) =>
      DriftChoiceData(
        id: id ?? this.id,
        title: title ?? this.title,
        choice1: choice1 ?? this.choice1,
        choice2: choice2 ?? this.choice2,
      );
  @override
  String toString() {
    return (StringBuffer('DriftChoiceData(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('choice1: $choice1, ')
          ..write('choice2: $choice2')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, title, choice1, choice2);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DriftChoiceData &&
          other.id == this.id &&
          other.title == this.title &&
          other.choice1 == this.choice1 &&
          other.choice2 == this.choice2);
}

class DriftChoiceCompanion extends UpdateCompanion<DriftChoiceData> {
  final Value<int> id;
  final Value<String> title;
  final Value<String> choice1;
  final Value<String> choice2;
  const DriftChoiceCompanion({
    this.id = const Value.absent(),
    this.title = const Value.absent(),
    this.choice1 = const Value.absent(),
    this.choice2 = const Value.absent(),
  });
  DriftChoiceCompanion.insert({
    this.id = const Value.absent(),
    required String title,
    required String choice1,
    required String choice2,
  })  : title = Value(title),
        choice1 = Value(choice1),
        choice2 = Value(choice2);
  static Insertable<DriftChoiceData> custom({
    Expression<int>? id,
    Expression<String>? title,
    Expression<String>? choice1,
    Expression<String>? choice2,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (title != null) 'title': title,
      if (choice1 != null) 'choice1': choice1,
      if (choice2 != null) 'choice2': choice2,
    });
  }

  DriftChoiceCompanion copyWith(
      {Value<int>? id,
      Value<String>? title,
      Value<String>? choice1,
      Value<String>? choice2}) {
    return DriftChoiceCompanion(
      id: id ?? this.id,
      title: title ?? this.title,
      choice1: choice1 ?? this.choice1,
      choice2: choice2 ?? this.choice2,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    if (title.present) {
      map['title'] = Variable<String>(title.value);
    }
    if (choice1.present) {
      map['choice1'] = Variable<String>(choice1.value);
    }
    if (choice2.present) {
      map['choice2'] = Variable<String>(choice2.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DriftChoiceCompanion(')
          ..write('id: $id, ')
          ..write('title: $title, ')
          ..write('choice1: $choice1, ')
          ..write('choice2: $choice2')
          ..write(')'))
        .toString();
  }
}

class $DriftChoiceTable extends DriftChoice
    with TableInfo<$DriftChoiceTable, DriftChoiceData> {
  final GeneratedDatabase _db;
  final String? _alias;
  $DriftChoiceTable(this._db, [this._alias]);
  final VerificationMeta _idMeta = const VerificationMeta('id');
  late final GeneratedColumn<int?> id = GeneratedColumn<int?>(
      'id', aliasedName, false,
      typeName: 'INTEGER',
      requiredDuringInsert: false,
      defaultConstraints: 'PRIMARY KEY AUTOINCREMENT');
  final VerificationMeta _titleMeta = const VerificationMeta('title');
  late final GeneratedColumn<String?> title = GeneratedColumn<String?>(
      'title', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _choice1Meta = const VerificationMeta('choice1');
  late final GeneratedColumn<String?> choice1 = GeneratedColumn<String?>(
      'choice1', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  final VerificationMeta _choice2Meta = const VerificationMeta('choice2');
  late final GeneratedColumn<String?> choice2 = GeneratedColumn<String?>(
      'choice2', aliasedName, false,
      typeName: 'TEXT', requiredDuringInsert: true);
  @override
  List<GeneratedColumn> get $columns => [id, title, choice1, choice2];
  @override
  String get aliasedName => _alias ?? 'drift_choice';
  @override
  String get actualTableName => 'drift_choice';
  @override
  VerificationContext validateIntegrity(Insertable<DriftChoiceData> instance,
      {bool isInserting = false}) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('title')) {
      context.handle(
          _titleMeta, title.isAcceptableOrUnknown(data['title']!, _titleMeta));
    } else if (isInserting) {
      context.missing(_titleMeta);
    }
    if (data.containsKey('choice1')) {
      context.handle(_choice1Meta,
          choice1.isAcceptableOrUnknown(data['choice1']!, _choice1Meta));
    } else if (isInserting) {
      context.missing(_choice1Meta);
    }
    if (data.containsKey('choice2')) {
      context.handle(_choice2Meta,
          choice2.isAcceptableOrUnknown(data['choice2']!, _choice2Meta));
    } else if (isInserting) {
      context.missing(_choice2Meta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  DriftChoiceData map(Map<String, dynamic> data, {String? tablePrefix}) {
    return DriftChoiceData.fromData(data,
        prefix: tablePrefix != null ? '$tablePrefix.' : null);
  }

  @override
  $DriftChoiceTable createAlias(String alias) {
    return $DriftChoiceTable(_db, alias);
  }
}

abstract class _$ChoicesDatabase extends GeneratedDatabase {
  _$ChoicesDatabase(QueryExecutor e) : super(SqlTypeSystem.defaultInstance, e);
  late final $DriftChoiceTable driftChoice = $DriftChoiceTable(this);
  late final ChoiceDao choiceDao = ChoiceDao(this as ChoicesDatabase);
  @override
  Iterable<TableInfo> get allTables => allSchemaEntities.whereType<TableInfo>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [driftChoice];
}

// **************************************************************************
// DaoGenerator
// **************************************************************************

mixin _$ChoiceDaoMixin on DatabaseAccessor<ChoicesDatabase> {
  $DriftChoiceTable get driftChoice => attachedDatabase.driftChoice;
}
