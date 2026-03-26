// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $SchemaAnchorsTable extends SchemaAnchors
    with TableInfo<$SchemaAnchorsTable, SchemaAnchor> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SchemaAnchorsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<int> id = GeneratedColumn<int>(
    'id',
    aliasedName,
    false,
    hasAutoIncrement: true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'PRIMARY KEY AUTOINCREMENT',
    ),
  );
  @override
  List<GeneratedColumn> get $columns => [id];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'schema_anchors';
  @override
  VerificationContext validateIntegrity(
    Insertable<SchemaAnchor> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SchemaAnchor map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SchemaAnchor(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}id'],
      )!,
    );
  }

  @override
  $SchemaAnchorsTable createAlias(String alias) {
    return $SchemaAnchorsTable(attachedDatabase, alias);
  }
}

class SchemaAnchor extends DataClass implements Insertable<SchemaAnchor> {
  final int id;
  const SchemaAnchor({required this.id});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<int>(id);
    return map;
  }

  SchemaAnchorsCompanion toCompanion(bool nullToAbsent) {
    return SchemaAnchorsCompanion(id: Value(id));
  }

  factory SchemaAnchor.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SchemaAnchor(id: serializer.fromJson<int>(json['id']));
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{'id': serializer.toJson<int>(id)};
  }

  SchemaAnchor copyWith({int? id}) => SchemaAnchor(id: id ?? this.id);
  SchemaAnchor copyWithCompanion(SchemaAnchorsCompanion data) {
    return SchemaAnchor(id: data.id.present ? data.id.value : this.id);
  }

  @override
  String toString() {
    return (StringBuffer('SchemaAnchor(')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => id.hashCode;
  @override
  bool operator ==(Object other) =>
      identical(this, other) || (other is SchemaAnchor && other.id == this.id);
}

class SchemaAnchorsCompanion extends UpdateCompanion<SchemaAnchor> {
  final Value<int> id;
  const SchemaAnchorsCompanion({this.id = const Value.absent()});
  SchemaAnchorsCompanion.insert({this.id = const Value.absent()});
  static Insertable<SchemaAnchor> custom({Expression<int>? id}) {
    return RawValuesInsertable({if (id != null) 'id': id});
  }

  SchemaAnchorsCompanion copyWith({Value<int>? id}) {
    return SchemaAnchorsCompanion(id: id ?? this.id);
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<int>(id.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SchemaAnchorsCompanion(')
          ..write('id: $id')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $SchemaAnchorsTable schemaAnchors = $SchemaAnchorsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [schemaAnchors];
}

typedef $$SchemaAnchorsTableCreateCompanionBuilder =
    SchemaAnchorsCompanion Function({Value<int> id});
typedef $$SchemaAnchorsTableUpdateCompanionBuilder =
    SchemaAnchorsCompanion Function({Value<int> id});

class $$SchemaAnchorsTableFilterComposer
    extends Composer<_$AppDatabase, $SchemaAnchorsTable> {
  $$SchemaAnchorsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SchemaAnchorsTableOrderingComposer
    extends Composer<_$AppDatabase, $SchemaAnchorsTable> {
  $$SchemaAnchorsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<int> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SchemaAnchorsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SchemaAnchorsTable> {
  $$SchemaAnchorsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<int> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);
}

class $$SchemaAnchorsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SchemaAnchorsTable,
          SchemaAnchor,
          $$SchemaAnchorsTableFilterComposer,
          $$SchemaAnchorsTableOrderingComposer,
          $$SchemaAnchorsTableAnnotationComposer,
          $$SchemaAnchorsTableCreateCompanionBuilder,
          $$SchemaAnchorsTableUpdateCompanionBuilder,
          (
            SchemaAnchor,
            BaseReferences<_$AppDatabase, $SchemaAnchorsTable, SchemaAnchor>,
          ),
          SchemaAnchor,
          PrefetchHooks Function()
        > {
  $$SchemaAnchorsTableTableManager(_$AppDatabase db, $SchemaAnchorsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SchemaAnchorsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SchemaAnchorsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SchemaAnchorsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({Value<int> id = const Value.absent()}) =>
              SchemaAnchorsCompanion(id: id),
          createCompanionCallback: ({Value<int> id = const Value.absent()}) =>
              SchemaAnchorsCompanion.insert(id: id),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SchemaAnchorsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SchemaAnchorsTable,
      SchemaAnchor,
      $$SchemaAnchorsTableFilterComposer,
      $$SchemaAnchorsTableOrderingComposer,
      $$SchemaAnchorsTableAnnotationComposer,
      $$SchemaAnchorsTableCreateCompanionBuilder,
      $$SchemaAnchorsTableUpdateCompanionBuilder,
      (
        SchemaAnchor,
        BaseReferences<_$AppDatabase, $SchemaAnchorsTable, SchemaAnchor>,
      ),
      SchemaAnchor,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$SchemaAnchorsTableTableManager get schemaAnchors =>
      $$SchemaAnchorsTableTableManager(_db, _db.schemaAnchors);
}
