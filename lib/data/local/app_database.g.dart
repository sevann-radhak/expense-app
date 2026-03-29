// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $CategoriesTable extends Categories
    with TableInfo<$CategoriesTable, CategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $CategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [id, name, description, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<CategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  CategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return CategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $CategoriesTable createAlias(String alias) {
    return $CategoriesTable(attachedDatabase, alias);
  }
}

class CategoryRow extends DataClass implements Insertable<CategoryRow> {
  final String id;
  final String name;
  final String? description;
  final int sortOrder;
  const CategoryRow({
    required this.id,
    required this.name,
    this.description,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  CategoriesCompanion toCompanion(bool nullToAbsent) {
    return CategoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sortOrder: Value(sortOrder),
    );
  }

  factory CategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return CategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? sortOrder,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('CategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SubcategoriesTable extends Subcategories
    with TableInfo<$SubcategoriesTable, SubcategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SubcategoriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE CASCADE',
    ),
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _slugMeta = const VerificationMeta('slug');
  @override
  late final GeneratedColumn<String> slug = GeneratedColumn<String>(
    'slug',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _isSystemReservedMeta = const VerificationMeta(
    'isSystemReserved',
  );
  @override
  late final GeneratedColumn<bool> isSystemReserved = GeneratedColumn<bool>(
    'is_system_reserved',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_system_reserved" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    categoryId,
    name,
    description,
    slug,
    isSystemReserved,
    sortOrder,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'subcategories';
  @override
  VerificationContext validateIntegrity(
    Insertable<SubcategoryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('slug')) {
      context.handle(
        _slugMeta,
        slug.isAcceptableOrUnknown(data['slug']!, _slugMeta),
      );
    } else if (isInserting) {
      context.missing(_slugMeta);
    }
    if (data.containsKey('is_system_reserved')) {
      context.handle(
        _isSystemReservedMeta,
        isSystemReserved.isAcceptableOrUnknown(
          data['is_system_reserved']!,
          _isSystemReservedMeta,
        ),
      );
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  SubcategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return SubcategoryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      ),
      slug: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}slug'],
      )!,
      isSystemReserved: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_system_reserved'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $SubcategoriesTable createAlias(String alias) {
    return $SubcategoriesTable(attachedDatabase, alias);
  }
}

class SubcategoryRow extends DataClass implements Insertable<SubcategoryRow> {
  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final String slug;
  final bool isSystemReserved;
  final int sortOrder;
  const SubcategoryRow({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.slug,
    required this.isSystemReserved,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['category_id'] = Variable<String>(categoryId);
    map['name'] = Variable<String>(name);
    if (!nullToAbsent || description != null) {
      map['description'] = Variable<String>(description);
    }
    map['slug'] = Variable<String>(slug);
    map['is_system_reserved'] = Variable<bool>(isSystemReserved);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  SubcategoriesCompanion toCompanion(bool nullToAbsent) {
    return SubcategoriesCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      slug: Value(slug),
      isSystemReserved: Value(isSystemReserved),
      sortOrder: Value(sortOrder),
    );
  }

  factory SubcategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return SubcategoryRow(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      slug: serializer.fromJson<String>(json['slug']),
      isSystemReserved: serializer.fromJson<bool>(json['isSystemReserved']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'categoryId': serializer.toJson<String>(categoryId),
      'name': serializer.toJson<String>(name),
      'description': serializer.toJson<String?>(description),
      'slug': serializer.toJson<String>(slug),
      'isSystemReserved': serializer.toJson<bool>(isSystemReserved),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  SubcategoryRow copyWith({
    String? id,
    String? categoryId,
    String? name,
    Value<String?> description = const Value.absent(),
    String? slug,
    bool? isSystemReserved,
    int? sortOrder,
  }) => SubcategoryRow(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    slug: slug ?? this.slug,
    isSystemReserved: isSystemReserved ?? this.isSystemReserved,
    sortOrder: sortOrder ?? this.sortOrder,
  );
  SubcategoryRow copyWithCompanion(SubcategoriesCompanion data) {
    return SubcategoryRow(
      id: data.id.present ? data.id.value : this.id,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      slug: data.slug.present ? data.slug.value : this.slug,
      isSystemReserved: data.isSystemReserved.present
          ? data.isSystemReserved.value
          : this.isSystemReserved,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('SubcategoryRow(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('slug: $slug, ')
          ..write('isSystemReserved: $isSystemReserved, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    categoryId,
    name,
    description,
    slug,
    isSystemReserved,
    sortOrder,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is SubcategoryRow &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.slug == this.slug &&
          other.isSystemReserved == this.isSystemReserved &&
          other.sortOrder == this.sortOrder);
}

class SubcategoriesCompanion extends UpdateCompanion<SubcategoryRow> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> slug;
  final Value<bool> isSystemReserved;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const SubcategoriesCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.slug = const Value.absent(),
    this.isSystemReserved = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SubcategoriesCompanion.insert({
    required String id,
    required String categoryId,
    required String name,
    this.description = const Value.absent(),
    required String slug,
    this.isSystemReserved = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryId = Value(categoryId),
       name = Value(name),
       slug = Value(slug);
  static Insertable<SubcategoryRow> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? slug,
    Expression<bool>? isSystemReserved,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (categoryId != null) 'category_id': categoryId,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (slug != null) 'slug': slug,
      if (isSystemReserved != null) 'is_system_reserved': isSystemReserved,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SubcategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryId,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? slug,
    Value<bool>? isSystemReserved,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return SubcategoriesCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      slug: slug ?? this.slug,
      isSystemReserved: isSystemReserved ?? this.isSystemReserved,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (slug.present) {
      map['slug'] = Variable<String>(slug.value);
    }
    if (isSystemReserved.present) {
      map['is_system_reserved'] = Variable<bool>(isSystemReserved.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SubcategoriesCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('slug: $slug, ')
          ..write('isSystemReserved: $isSystemReserved, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $RecExpenseSeriesTable extends RecExpenseSeries
    with TableInfo<$RecExpenseSeriesTable, ExpenseRecurringSeriesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $RecExpenseSeriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorOccurredOnMeta = const VerificationMeta(
    'anchorOccurredOn',
  );
  @override
  late final GeneratedColumn<String> anchorOccurredOn = GeneratedColumn<String>(
    'anchor_occurred_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _recurrenceJsonMeta = const VerificationMeta(
    'recurrenceJson',
  );
  @override
  late final GeneratedColumn<String> recurrenceJson = GeneratedColumn<String>(
    'recurrence_json',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _horizonMonthsMeta = const VerificationMeta(
    'horizonMonths',
  );
  @override
  late final GeneratedColumn<int> horizonMonths = GeneratedColumn<int>(
    'horizon_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _activeMeta = const VerificationMeta('active');
  @override
  late final GeneratedColumn<bool> active = GeneratedColumn<bool>(
    'active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _subcategoryIdMeta = const VerificationMeta(
    'subcategoryId',
  );
  @override
  late final GeneratedColumn<String> subcategoryId = GeneratedColumn<String>(
    'subcategory_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subcategories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _amountOriginalMeta = const VerificationMeta(
    'amountOriginal',
  );
  @override
  late final GeneratedColumn<double> amountOriginal = GeneratedColumn<double>(
    'amount_original',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _manualFxRateToUsdMeta = const VerificationMeta(
    'manualFxRateToUsd',
  );
  @override
  late final GeneratedColumn<double> manualFxRateToUsd =
      GeneratedColumn<double>(
        'manual_fx_rate_to_usd',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1.0),
      );
  static const VerificationMeta _amountUsdMeta = const VerificationMeta(
    'amountUsd',
  );
  @override
  late final GeneratedColumn<double> amountUsd = GeneratedColumn<double>(
    'amount_usd',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidWithCreditCardMeta =
      const VerificationMeta('paidWithCreditCard');
  @override
  late final GeneratedColumn<bool> paidWithCreditCard = GeneratedColumn<bool>(
    'paid_with_credit_card',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paid_with_credit_card" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _paymentInstrumentIdMeta =
      const VerificationMeta('paymentInstrumentId');
  @override
  late final GeneratedColumn<String> paymentInstrumentId =
      GeneratedColumn<String>(
        'payment_instrument_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    anchorOccurredOn,
    recurrenceJson,
    horizonMonths,
    active,
    categoryId,
    subcategoryId,
    amountOriginal,
    currencyCode,
    manualFxRateToUsd,
    amountUsd,
    paidWithCreditCard,
    description,
    paymentInstrumentId,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expense_recurring_series';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseRecurringSeriesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('anchor_occurred_on')) {
      context.handle(
        _anchorOccurredOnMeta,
        anchorOccurredOn.isAcceptableOrUnknown(
          data['anchor_occurred_on']!,
          _anchorOccurredOnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_anchorOccurredOnMeta);
    }
    if (data.containsKey('recurrence_json')) {
      context.handle(
        _recurrenceJsonMeta,
        recurrenceJson.isAcceptableOrUnknown(
          data['recurrence_json']!,
          _recurrenceJsonMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_recurrenceJsonMeta);
    }
    if (data.containsKey('horizon_months')) {
      context.handle(
        _horizonMonthsMeta,
        horizonMonths.isAcceptableOrUnknown(
          data['horizon_months']!,
          _horizonMonthsMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_horizonMonthsMeta);
    }
    if (data.containsKey('active')) {
      context.handle(
        _activeMeta,
        active.isAcceptableOrUnknown(data['active']!, _activeMeta),
      );
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('subcategory_id')) {
      context.handle(
        _subcategoryIdMeta,
        subcategoryId.isAcceptableOrUnknown(
          data['subcategory_id']!,
          _subcategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subcategoryIdMeta);
    }
    if (data.containsKey('amount_original')) {
      context.handle(
        _amountOriginalMeta,
        amountOriginal.isAcceptableOrUnknown(
          data['amount_original']!,
          _amountOriginalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountOriginalMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('manual_fx_rate_to_usd')) {
      context.handle(
        _manualFxRateToUsdMeta,
        manualFxRateToUsd.isAcceptableOrUnknown(
          data['manual_fx_rate_to_usd']!,
          _manualFxRateToUsdMeta,
        ),
      );
    }
    if (data.containsKey('amount_usd')) {
      context.handle(
        _amountUsdMeta,
        amountUsd.isAcceptableOrUnknown(data['amount_usd']!, _amountUsdMeta),
      );
    } else if (isInserting) {
      context.missing(_amountUsdMeta);
    }
    if (data.containsKey('paid_with_credit_card')) {
      context.handle(
        _paidWithCreditCardMeta,
        paidWithCreditCard.isAcceptableOrUnknown(
          data['paid_with_credit_card']!,
          _paidWithCreditCardMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('payment_instrument_id')) {
      context.handle(
        _paymentInstrumentIdMeta,
        paymentInstrumentId.isAcceptableOrUnknown(
          data['payment_instrument_id']!,
          _paymentInstrumentIdMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRecurringSeriesRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRecurringSeriesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      anchorOccurredOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_occurred_on'],
      )!,
      recurrenceJson: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurrence_json'],
      )!,
      horizonMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}horizon_months'],
      )!,
      active: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}active'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      subcategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subcategory_id'],
      )!,
      amountOriginal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_original'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      manualFxRateToUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}manual_fx_rate_to_usd'],
      )!,
      amountUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_usd'],
      )!,
      paidWithCreditCard: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paid_with_credit_card'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      paymentInstrumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_instrument_id'],
      ),
    );
  }

  @override
  $RecExpenseSeriesTable createAlias(String alias) {
    return $RecExpenseSeriesTable(attachedDatabase, alias);
  }
}

class ExpenseRecurringSeriesRow extends DataClass
    implements Insertable<ExpenseRecurringSeriesRow> {
  final String id;
  final String anchorOccurredOn;

  /// Recurrence payload JSON (application/recurrence_json_codec.dart v1).
  final String recurrenceJson;
  final int horizonMonths;
  final bool active;
  final String categoryId;
  final String subcategoryId;
  final double amountOriginal;
  final String currencyCode;
  final double manualFxRateToUsd;
  final double amountUsd;
  final bool paidWithCreditCard;
  final String description;
  final String? paymentInstrumentId;
  const ExpenseRecurringSeriesRow({
    required this.id,
    required this.anchorOccurredOn,
    required this.recurrenceJson,
    required this.horizonMonths,
    required this.active,
    required this.categoryId,
    required this.subcategoryId,
    required this.amountOriginal,
    required this.currencyCode,
    required this.manualFxRateToUsd,
    required this.amountUsd,
    required this.paidWithCreditCard,
    required this.description,
    this.paymentInstrumentId,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['anchor_occurred_on'] = Variable<String>(anchorOccurredOn);
    map['recurrence_json'] = Variable<String>(recurrenceJson);
    map['horizon_months'] = Variable<int>(horizonMonths);
    map['active'] = Variable<bool>(active);
    map['category_id'] = Variable<String>(categoryId);
    map['subcategory_id'] = Variable<String>(subcategoryId);
    map['amount_original'] = Variable<double>(amountOriginal);
    map['currency_code'] = Variable<String>(currencyCode);
    map['manual_fx_rate_to_usd'] = Variable<double>(manualFxRateToUsd);
    map['amount_usd'] = Variable<double>(amountUsd);
    map['paid_with_credit_card'] = Variable<bool>(paidWithCreditCard);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || paymentInstrumentId != null) {
      map['payment_instrument_id'] = Variable<String>(paymentInstrumentId);
    }
    return map;
  }

  RecExpenseSeriesCompanion toCompanion(bool nullToAbsent) {
    return RecExpenseSeriesCompanion(
      id: Value(id),
      anchorOccurredOn: Value(anchorOccurredOn),
      recurrenceJson: Value(recurrenceJson),
      horizonMonths: Value(horizonMonths),
      active: Value(active),
      categoryId: Value(categoryId),
      subcategoryId: Value(subcategoryId),
      amountOriginal: Value(amountOriginal),
      currencyCode: Value(currencyCode),
      manualFxRateToUsd: Value(manualFxRateToUsd),
      amountUsd: Value(amountUsd),
      paidWithCreditCard: Value(paidWithCreditCard),
      description: Value(description),
      paymentInstrumentId: paymentInstrumentId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentInstrumentId),
    );
  }

  factory ExpenseRecurringSeriesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRecurringSeriesRow(
      id: serializer.fromJson<String>(json['id']),
      anchorOccurredOn: serializer.fromJson<String>(json['anchorOccurredOn']),
      recurrenceJson: serializer.fromJson<String>(json['recurrenceJson']),
      horizonMonths: serializer.fromJson<int>(json['horizonMonths']),
      active: serializer.fromJson<bool>(json['active']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      subcategoryId: serializer.fromJson<String>(json['subcategoryId']),
      amountOriginal: serializer.fromJson<double>(json['amountOriginal']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      manualFxRateToUsd: serializer.fromJson<double>(json['manualFxRateToUsd']),
      amountUsd: serializer.fromJson<double>(json['amountUsd']),
      paidWithCreditCard: serializer.fromJson<bool>(json['paidWithCreditCard']),
      description: serializer.fromJson<String>(json['description']),
      paymentInstrumentId: serializer.fromJson<String?>(
        json['paymentInstrumentId'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'anchorOccurredOn': serializer.toJson<String>(anchorOccurredOn),
      'recurrenceJson': serializer.toJson<String>(recurrenceJson),
      'horizonMonths': serializer.toJson<int>(horizonMonths),
      'active': serializer.toJson<bool>(active),
      'categoryId': serializer.toJson<String>(categoryId),
      'subcategoryId': serializer.toJson<String>(subcategoryId),
      'amountOriginal': serializer.toJson<double>(amountOriginal),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'manualFxRateToUsd': serializer.toJson<double>(manualFxRateToUsd),
      'amountUsd': serializer.toJson<double>(amountUsd),
      'paidWithCreditCard': serializer.toJson<bool>(paidWithCreditCard),
      'description': serializer.toJson<String>(description),
      'paymentInstrumentId': serializer.toJson<String?>(paymentInstrumentId),
    };
  }

  ExpenseRecurringSeriesRow copyWith({
    String? id,
    String? anchorOccurredOn,
    String? recurrenceJson,
    int? horizonMonths,
    bool? active,
    String? categoryId,
    String? subcategoryId,
    double? amountOriginal,
    String? currencyCode,
    double? manualFxRateToUsd,
    double? amountUsd,
    bool? paidWithCreditCard,
    String? description,
    Value<String?> paymentInstrumentId = const Value.absent(),
  }) => ExpenseRecurringSeriesRow(
    id: id ?? this.id,
    anchorOccurredOn: anchorOccurredOn ?? this.anchorOccurredOn,
    recurrenceJson: recurrenceJson ?? this.recurrenceJson,
    horizonMonths: horizonMonths ?? this.horizonMonths,
    active: active ?? this.active,
    categoryId: categoryId ?? this.categoryId,
    subcategoryId: subcategoryId ?? this.subcategoryId,
    amountOriginal: amountOriginal ?? this.amountOriginal,
    currencyCode: currencyCode ?? this.currencyCode,
    manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
    amountUsd: amountUsd ?? this.amountUsd,
    paidWithCreditCard: paidWithCreditCard ?? this.paidWithCreditCard,
    description: description ?? this.description,
    paymentInstrumentId: paymentInstrumentId.present
        ? paymentInstrumentId.value
        : this.paymentInstrumentId,
  );
  ExpenseRecurringSeriesRow copyWithCompanion(RecExpenseSeriesCompanion data) {
    return ExpenseRecurringSeriesRow(
      id: data.id.present ? data.id.value : this.id,
      anchorOccurredOn: data.anchorOccurredOn.present
          ? data.anchorOccurredOn.value
          : this.anchorOccurredOn,
      recurrenceJson: data.recurrenceJson.present
          ? data.recurrenceJson.value
          : this.recurrenceJson,
      horizonMonths: data.horizonMonths.present
          ? data.horizonMonths.value
          : this.horizonMonths,
      active: data.active.present ? data.active.value : this.active,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      subcategoryId: data.subcategoryId.present
          ? data.subcategoryId.value
          : this.subcategoryId,
      amountOriginal: data.amountOriginal.present
          ? data.amountOriginal.value
          : this.amountOriginal,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      manualFxRateToUsd: data.manualFxRateToUsd.present
          ? data.manualFxRateToUsd.value
          : this.manualFxRateToUsd,
      amountUsd: data.amountUsd.present ? data.amountUsd.value : this.amountUsd,
      paidWithCreditCard: data.paidWithCreditCard.present
          ? data.paidWithCreditCard.value
          : this.paidWithCreditCard,
      description: data.description.present
          ? data.description.value
          : this.description,
      paymentInstrumentId: data.paymentInstrumentId.present
          ? data.paymentInstrumentId.value
          : this.paymentInstrumentId,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRecurringSeriesRow(')
          ..write('id: $id, ')
          ..write('anchorOccurredOn: $anchorOccurredOn, ')
          ..write('recurrenceJson: $recurrenceJson, ')
          ..write('horizonMonths: $horizonMonths, ')
          ..write('active: $active, ')
          ..write('categoryId: $categoryId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('amountOriginal: $amountOriginal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('manualFxRateToUsd: $manualFxRateToUsd, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('paidWithCreditCard: $paidWithCreditCard, ')
          ..write('description: $description, ')
          ..write('paymentInstrumentId: $paymentInstrumentId')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    anchorOccurredOn,
    recurrenceJson,
    horizonMonths,
    active,
    categoryId,
    subcategoryId,
    amountOriginal,
    currencyCode,
    manualFxRateToUsd,
    amountUsd,
    paidWithCreditCard,
    description,
    paymentInstrumentId,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRecurringSeriesRow &&
          other.id == this.id &&
          other.anchorOccurredOn == this.anchorOccurredOn &&
          other.recurrenceJson == this.recurrenceJson &&
          other.horizonMonths == this.horizonMonths &&
          other.active == this.active &&
          other.categoryId == this.categoryId &&
          other.subcategoryId == this.subcategoryId &&
          other.amountOriginal == this.amountOriginal &&
          other.currencyCode == this.currencyCode &&
          other.manualFxRateToUsd == this.manualFxRateToUsd &&
          other.amountUsd == this.amountUsd &&
          other.paidWithCreditCard == this.paidWithCreditCard &&
          other.description == this.description &&
          other.paymentInstrumentId == this.paymentInstrumentId);
}

class RecExpenseSeriesCompanion
    extends UpdateCompanion<ExpenseRecurringSeriesRow> {
  final Value<String> id;
  final Value<String> anchorOccurredOn;
  final Value<String> recurrenceJson;
  final Value<int> horizonMonths;
  final Value<bool> active;
  final Value<String> categoryId;
  final Value<String> subcategoryId;
  final Value<double> amountOriginal;
  final Value<String> currencyCode;
  final Value<double> manualFxRateToUsd;
  final Value<double> amountUsd;
  final Value<bool> paidWithCreditCard;
  final Value<String> description;
  final Value<String?> paymentInstrumentId;
  final Value<int> rowid;
  const RecExpenseSeriesCompanion({
    this.id = const Value.absent(),
    this.anchorOccurredOn = const Value.absent(),
    this.recurrenceJson = const Value.absent(),
    this.horizonMonths = const Value.absent(),
    this.active = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.subcategoryId = const Value.absent(),
    this.amountOriginal = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.manualFxRateToUsd = const Value.absent(),
    this.amountUsd = const Value.absent(),
    this.paidWithCreditCard = const Value.absent(),
    this.description = const Value.absent(),
    this.paymentInstrumentId = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  RecExpenseSeriesCompanion.insert({
    required String id,
    required String anchorOccurredOn,
    required String recurrenceJson,
    required int horizonMonths,
    this.active = const Value.absent(),
    required String categoryId,
    required String subcategoryId,
    required double amountOriginal,
    this.currencyCode = const Value.absent(),
    this.manualFxRateToUsd = const Value.absent(),
    required double amountUsd,
    this.paidWithCreditCard = const Value.absent(),
    this.description = const Value.absent(),
    this.paymentInstrumentId = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       anchorOccurredOn = Value(anchorOccurredOn),
       recurrenceJson = Value(recurrenceJson),
       horizonMonths = Value(horizonMonths),
       categoryId = Value(categoryId),
       subcategoryId = Value(subcategoryId),
       amountOriginal = Value(amountOriginal),
       amountUsd = Value(amountUsd);
  static Insertable<ExpenseRecurringSeriesRow> custom({
    Expression<String>? id,
    Expression<String>? anchorOccurredOn,
    Expression<String>? recurrenceJson,
    Expression<int>? horizonMonths,
    Expression<bool>? active,
    Expression<String>? categoryId,
    Expression<String>? subcategoryId,
    Expression<double>? amountOriginal,
    Expression<String>? currencyCode,
    Expression<double>? manualFxRateToUsd,
    Expression<double>? amountUsd,
    Expression<bool>? paidWithCreditCard,
    Expression<String>? description,
    Expression<String>? paymentInstrumentId,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (anchorOccurredOn != null) 'anchor_occurred_on': anchorOccurredOn,
      if (recurrenceJson != null) 'recurrence_json': recurrenceJson,
      if (horizonMonths != null) 'horizon_months': horizonMonths,
      if (active != null) 'active': active,
      if (categoryId != null) 'category_id': categoryId,
      if (subcategoryId != null) 'subcategory_id': subcategoryId,
      if (amountOriginal != null) 'amount_original': amountOriginal,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (manualFxRateToUsd != null) 'manual_fx_rate_to_usd': manualFxRateToUsd,
      if (amountUsd != null) 'amount_usd': amountUsd,
      if (paidWithCreditCard != null)
        'paid_with_credit_card': paidWithCreditCard,
      if (description != null) 'description': description,
      if (paymentInstrumentId != null)
        'payment_instrument_id': paymentInstrumentId,
      if (rowid != null) 'rowid': rowid,
    });
  }

  RecExpenseSeriesCompanion copyWith({
    Value<String>? id,
    Value<String>? anchorOccurredOn,
    Value<String>? recurrenceJson,
    Value<int>? horizonMonths,
    Value<bool>? active,
    Value<String>? categoryId,
    Value<String>? subcategoryId,
    Value<double>? amountOriginal,
    Value<String>? currencyCode,
    Value<double>? manualFxRateToUsd,
    Value<double>? amountUsd,
    Value<bool>? paidWithCreditCard,
    Value<String>? description,
    Value<String?>? paymentInstrumentId,
    Value<int>? rowid,
  }) {
    return RecExpenseSeriesCompanion(
      id: id ?? this.id,
      anchorOccurredOn: anchorOccurredOn ?? this.anchorOccurredOn,
      recurrenceJson: recurrenceJson ?? this.recurrenceJson,
      horizonMonths: horizonMonths ?? this.horizonMonths,
      active: active ?? this.active,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      amountOriginal: amountOriginal ?? this.amountOriginal,
      currencyCode: currencyCode ?? this.currencyCode,
      manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
      amountUsd: amountUsd ?? this.amountUsd,
      paidWithCreditCard: paidWithCreditCard ?? this.paidWithCreditCard,
      description: description ?? this.description,
      paymentInstrumentId: paymentInstrumentId ?? this.paymentInstrumentId,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (anchorOccurredOn.present) {
      map['anchor_occurred_on'] = Variable<String>(anchorOccurredOn.value);
    }
    if (recurrenceJson.present) {
      map['recurrence_json'] = Variable<String>(recurrenceJson.value);
    }
    if (horizonMonths.present) {
      map['horizon_months'] = Variable<int>(horizonMonths.value);
    }
    if (active.present) {
      map['active'] = Variable<bool>(active.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (subcategoryId.present) {
      map['subcategory_id'] = Variable<String>(subcategoryId.value);
    }
    if (amountOriginal.present) {
      map['amount_original'] = Variable<double>(amountOriginal.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (manualFxRateToUsd.present) {
      map['manual_fx_rate_to_usd'] = Variable<double>(manualFxRateToUsd.value);
    }
    if (amountUsd.present) {
      map['amount_usd'] = Variable<double>(amountUsd.value);
    }
    if (paidWithCreditCard.present) {
      map['paid_with_credit_card'] = Variable<bool>(paidWithCreditCard.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (paymentInstrumentId.present) {
      map['payment_instrument_id'] = Variable<String>(
        paymentInstrumentId.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('RecExpenseSeriesCompanion(')
          ..write('id: $id, ')
          ..write('anchorOccurredOn: $anchorOccurredOn, ')
          ..write('recurrenceJson: $recurrenceJson, ')
          ..write('horizonMonths: $horizonMonths, ')
          ..write('active: $active, ')
          ..write('categoryId: $categoryId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('amountOriginal: $amountOriginal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('manualFxRateToUsd: $manualFxRateToUsd, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('paidWithCreditCard: $paidWithCreditCard, ')
          ..write('description: $description, ')
          ..write('paymentInstrumentId: $paymentInstrumentId, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $ExpensesTable extends Expenses
    with TableInfo<$ExpensesTable, ExpenseRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $ExpensesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _occurredOnMeta = const VerificationMeta(
    'occurredOn',
  );
  @override
  late final GeneratedColumn<String> occurredOn = GeneratedColumn<String>(
    'occurred_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _categoryIdMeta = const VerificationMeta(
    'categoryId',
  );
  @override
  late final GeneratedColumn<String> categoryId = GeneratedColumn<String>(
    'category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _subcategoryIdMeta = const VerificationMeta(
    'subcategoryId',
  );
  @override
  late final GeneratedColumn<String> subcategoryId = GeneratedColumn<String>(
    'subcategory_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES subcategories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _amountOriginalMeta = const VerificationMeta(
    'amountOriginal',
  );
  @override
  late final GeneratedColumn<double> amountOriginal = GeneratedColumn<double>(
    'amount_original',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _currencyCodeMeta = const VerificationMeta(
    'currencyCode',
  );
  @override
  late final GeneratedColumn<String> currencyCode = GeneratedColumn<String>(
    'currency_code',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('USD'),
  );
  static const VerificationMeta _manualFxRateToUsdMeta = const VerificationMeta(
    'manualFxRateToUsd',
  );
  @override
  late final GeneratedColumn<double> manualFxRateToUsd =
      GeneratedColumn<double>(
        'manual_fx_rate_to_usd',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
        defaultValue: const Constant(1.0),
      );
  static const VerificationMeta _amountUsdMeta = const VerificationMeta(
    'amountUsd',
  );
  @override
  late final GeneratedColumn<double> amountUsd = GeneratedColumn<double>(
    'amount_usd',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paidWithCreditCardMeta =
      const VerificationMeta('paidWithCreditCard');
  @override
  late final GeneratedColumn<bool> paidWithCreditCard = GeneratedColumn<bool>(
    'paid_with_credit_card',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("paid_with_credit_card" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _descriptionMeta = const VerificationMeta(
    'description',
  );
  @override
  late final GeneratedColumn<String> description = GeneratedColumn<String>(
    'description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  static const VerificationMeta _paymentInstrumentIdMeta =
      const VerificationMeta('paymentInstrumentId');
  @override
  late final GeneratedColumn<String> paymentInstrumentId =
      GeneratedColumn<String>(
        'payment_instrument_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _recurringSeriesIdMeta = const VerificationMeta(
    'recurringSeriesId',
  );
  @override
  late final GeneratedColumn<String> recurringSeriesId =
      GeneratedColumn<String>(
        'recurring_series_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES expense_recurring_series (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _paymentExpectationStatusMeta =
      const VerificationMeta('paymentExpectationStatus');
  @override
  late final GeneratedColumn<String> paymentExpectationStatus =
      GeneratedColumn<String>(
        'payment_expectation_status',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _paymentExpectationConfirmedOnMeta =
      const VerificationMeta('paymentExpectationConfirmedOn');
  @override
  late final GeneratedColumn<String> paymentExpectationConfirmedOn =
      GeneratedColumn<String>(
        'payment_expectation_confirmed_on',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    occurredOn,
    categoryId,
    subcategoryId,
    amountOriginal,
    currencyCode,
    manualFxRateToUsd,
    amountUsd,
    paidWithCreditCard,
    description,
    paymentInstrumentId,
    recurringSeriesId,
    paymentExpectationStatus,
    paymentExpectationConfirmedOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'expenses';
  @override
  VerificationContext validateIntegrity(
    Insertable<ExpenseRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('occurred_on')) {
      context.handle(
        _occurredOnMeta,
        occurredOn.isAcceptableOrUnknown(data['occurred_on']!, _occurredOnMeta),
      );
    } else if (isInserting) {
      context.missing(_occurredOnMeta);
    }
    if (data.containsKey('category_id')) {
      context.handle(
        _categoryIdMeta,
        categoryId.isAcceptableOrUnknown(data['category_id']!, _categoryIdMeta),
      );
    } else if (isInserting) {
      context.missing(_categoryIdMeta);
    }
    if (data.containsKey('subcategory_id')) {
      context.handle(
        _subcategoryIdMeta,
        subcategoryId.isAcceptableOrUnknown(
          data['subcategory_id']!,
          _subcategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_subcategoryIdMeta);
    }
    if (data.containsKey('amount_original')) {
      context.handle(
        _amountOriginalMeta,
        amountOriginal.isAcceptableOrUnknown(
          data['amount_original']!,
          _amountOriginalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_amountOriginalMeta);
    }
    if (data.containsKey('currency_code')) {
      context.handle(
        _currencyCodeMeta,
        currencyCode.isAcceptableOrUnknown(
          data['currency_code']!,
          _currencyCodeMeta,
        ),
      );
    }
    if (data.containsKey('manual_fx_rate_to_usd')) {
      context.handle(
        _manualFxRateToUsdMeta,
        manualFxRateToUsd.isAcceptableOrUnknown(
          data['manual_fx_rate_to_usd']!,
          _manualFxRateToUsdMeta,
        ),
      );
    }
    if (data.containsKey('amount_usd')) {
      context.handle(
        _amountUsdMeta,
        amountUsd.isAcceptableOrUnknown(data['amount_usd']!, _amountUsdMeta),
      );
    } else if (isInserting) {
      context.missing(_amountUsdMeta);
    }
    if (data.containsKey('paid_with_credit_card')) {
      context.handle(
        _paidWithCreditCardMeta,
        paidWithCreditCard.isAcceptableOrUnknown(
          data['paid_with_credit_card']!,
          _paidWithCreditCardMeta,
        ),
      );
    }
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    if (data.containsKey('payment_instrument_id')) {
      context.handle(
        _paymentInstrumentIdMeta,
        paymentInstrumentId.isAcceptableOrUnknown(
          data['payment_instrument_id']!,
          _paymentInstrumentIdMeta,
        ),
      );
    }
    if (data.containsKey('recurring_series_id')) {
      context.handle(
        _recurringSeriesIdMeta,
        recurringSeriesId.isAcceptableOrUnknown(
          data['recurring_series_id']!,
          _recurringSeriesIdMeta,
        ),
      );
    }
    if (data.containsKey('payment_expectation_status')) {
      context.handle(
        _paymentExpectationStatusMeta,
        paymentExpectationStatus.isAcceptableOrUnknown(
          data['payment_expectation_status']!,
          _paymentExpectationStatusMeta,
        ),
      );
    }
    if (data.containsKey('payment_expectation_confirmed_on')) {
      context.handle(
        _paymentExpectationConfirmedOnMeta,
        paymentExpectationConfirmedOn.isAcceptableOrUnknown(
          data['payment_expectation_confirmed_on']!,
          _paymentExpectationConfirmedOnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  ExpenseRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return ExpenseRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      occurredOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}occurred_on'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      subcategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subcategory_id'],
      )!,
      amountOriginal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_original'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      manualFxRateToUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}manual_fx_rate_to_usd'],
      )!,
      amountUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}amount_usd'],
      )!,
      paidWithCreditCard: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}paid_with_credit_card'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      paymentInstrumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_instrument_id'],
      ),
      recurringSeriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_series_id'],
      ),
      paymentExpectationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_expectation_status'],
      ),
      paymentExpectationConfirmedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_expectation_confirmed_on'],
      ),
    );
  }

  @override
  $ExpensesTable createAlias(String alias) {
    return $ExpensesTable(attachedDatabase, alias);
  }
}

class ExpenseRow extends DataClass implements Insertable<ExpenseRow> {
  final String id;

  /// `YYYY-MM-DD` (local calendar date).
  final String occurredOn;
  final String categoryId;
  final String subcategoryId;
  final double amountOriginal;
  final String currencyCode;
  final double manualFxRateToUsd;
  final double amountUsd;
  final bool paidWithCreditCard;
  final String description;

  /// Optional card profile id; validated in [DriftExpenseRepository].
  final String? paymentInstrumentId;

  /// Generated from [RecExpenseSeries] when non-null.
  final String? recurringSeriesId;
  final String? paymentExpectationStatus;
  final String? paymentExpectationConfirmedOn;
  const ExpenseRow({
    required this.id,
    required this.occurredOn,
    required this.categoryId,
    required this.subcategoryId,
    required this.amountOriginal,
    required this.currencyCode,
    required this.manualFxRateToUsd,
    required this.amountUsd,
    required this.paidWithCreditCard,
    required this.description,
    this.paymentInstrumentId,
    this.recurringSeriesId,
    this.paymentExpectationStatus,
    this.paymentExpectationConfirmedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['occurred_on'] = Variable<String>(occurredOn);
    map['category_id'] = Variable<String>(categoryId);
    map['subcategory_id'] = Variable<String>(subcategoryId);
    map['amount_original'] = Variable<double>(amountOriginal);
    map['currency_code'] = Variable<String>(currencyCode);
    map['manual_fx_rate_to_usd'] = Variable<double>(manualFxRateToUsd);
    map['amount_usd'] = Variable<double>(amountUsd);
    map['paid_with_credit_card'] = Variable<bool>(paidWithCreditCard);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || paymentInstrumentId != null) {
      map['payment_instrument_id'] = Variable<String>(paymentInstrumentId);
    }
    if (!nullToAbsent || recurringSeriesId != null) {
      map['recurring_series_id'] = Variable<String>(recurringSeriesId);
    }
    if (!nullToAbsent || paymentExpectationStatus != null) {
      map['payment_expectation_status'] = Variable<String>(
        paymentExpectationStatus,
      );
    }
    if (!nullToAbsent || paymentExpectationConfirmedOn != null) {
      map['payment_expectation_confirmed_on'] = Variable<String>(
        paymentExpectationConfirmedOn,
      );
    }
    return map;
  }

  ExpensesCompanion toCompanion(bool nullToAbsent) {
    return ExpensesCompanion(
      id: Value(id),
      occurredOn: Value(occurredOn),
      categoryId: Value(categoryId),
      subcategoryId: Value(subcategoryId),
      amountOriginal: Value(amountOriginal),
      currencyCode: Value(currencyCode),
      manualFxRateToUsd: Value(manualFxRateToUsd),
      amountUsd: Value(amountUsd),
      paidWithCreditCard: Value(paidWithCreditCard),
      description: Value(description),
      paymentInstrumentId: paymentInstrumentId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentInstrumentId),
      recurringSeriesId: recurringSeriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringSeriesId),
      paymentExpectationStatus: paymentExpectationStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentExpectationStatus),
      paymentExpectationConfirmedOn:
          paymentExpectationConfirmedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentExpectationConfirmedOn),
    );
  }

  factory ExpenseRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return ExpenseRow(
      id: serializer.fromJson<String>(json['id']),
      occurredOn: serializer.fromJson<String>(json['occurredOn']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      subcategoryId: serializer.fromJson<String>(json['subcategoryId']),
      amountOriginal: serializer.fromJson<double>(json['amountOriginal']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      manualFxRateToUsd: serializer.fromJson<double>(json['manualFxRateToUsd']),
      amountUsd: serializer.fromJson<double>(json['amountUsd']),
      paidWithCreditCard: serializer.fromJson<bool>(json['paidWithCreditCard']),
      description: serializer.fromJson<String>(json['description']),
      paymentInstrumentId: serializer.fromJson<String?>(
        json['paymentInstrumentId'],
      ),
      recurringSeriesId: serializer.fromJson<String?>(
        json['recurringSeriesId'],
      ),
      paymentExpectationStatus: serializer.fromJson<String?>(
        json['paymentExpectationStatus'],
      ),
      paymentExpectationConfirmedOn: serializer.fromJson<String?>(
        json['paymentExpectationConfirmedOn'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'occurredOn': serializer.toJson<String>(occurredOn),
      'categoryId': serializer.toJson<String>(categoryId),
      'subcategoryId': serializer.toJson<String>(subcategoryId),
      'amountOriginal': serializer.toJson<double>(amountOriginal),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'manualFxRateToUsd': serializer.toJson<double>(manualFxRateToUsd),
      'amountUsd': serializer.toJson<double>(amountUsd),
      'paidWithCreditCard': serializer.toJson<bool>(paidWithCreditCard),
      'description': serializer.toJson<String>(description),
      'paymentInstrumentId': serializer.toJson<String?>(paymentInstrumentId),
      'recurringSeriesId': serializer.toJson<String?>(recurringSeriesId),
      'paymentExpectationStatus': serializer.toJson<String?>(
        paymentExpectationStatus,
      ),
      'paymentExpectationConfirmedOn': serializer.toJson<String?>(
        paymentExpectationConfirmedOn,
      ),
    };
  }

  ExpenseRow copyWith({
    String? id,
    String? occurredOn,
    String? categoryId,
    String? subcategoryId,
    double? amountOriginal,
    String? currencyCode,
    double? manualFxRateToUsd,
    double? amountUsd,
    bool? paidWithCreditCard,
    String? description,
    Value<String?> paymentInstrumentId = const Value.absent(),
    Value<String?> recurringSeriesId = const Value.absent(),
    Value<String?> paymentExpectationStatus = const Value.absent(),
    Value<String?> paymentExpectationConfirmedOn = const Value.absent(),
  }) => ExpenseRow(
    id: id ?? this.id,
    occurredOn: occurredOn ?? this.occurredOn,
    categoryId: categoryId ?? this.categoryId,
    subcategoryId: subcategoryId ?? this.subcategoryId,
    amountOriginal: amountOriginal ?? this.amountOriginal,
    currencyCode: currencyCode ?? this.currencyCode,
    manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
    amountUsd: amountUsd ?? this.amountUsd,
    paidWithCreditCard: paidWithCreditCard ?? this.paidWithCreditCard,
    description: description ?? this.description,
    paymentInstrumentId: paymentInstrumentId.present
        ? paymentInstrumentId.value
        : this.paymentInstrumentId,
    recurringSeriesId: recurringSeriesId.present
        ? recurringSeriesId.value
        : this.recurringSeriesId,
    paymentExpectationStatus: paymentExpectationStatus.present
        ? paymentExpectationStatus.value
        : this.paymentExpectationStatus,
    paymentExpectationConfirmedOn: paymentExpectationConfirmedOn.present
        ? paymentExpectationConfirmedOn.value
        : this.paymentExpectationConfirmedOn,
  );
  ExpenseRow copyWithCompanion(ExpensesCompanion data) {
    return ExpenseRow(
      id: data.id.present ? data.id.value : this.id,
      occurredOn: data.occurredOn.present
          ? data.occurredOn.value
          : this.occurredOn,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      subcategoryId: data.subcategoryId.present
          ? data.subcategoryId.value
          : this.subcategoryId,
      amountOriginal: data.amountOriginal.present
          ? data.amountOriginal.value
          : this.amountOriginal,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      manualFxRateToUsd: data.manualFxRateToUsd.present
          ? data.manualFxRateToUsd.value
          : this.manualFxRateToUsd,
      amountUsd: data.amountUsd.present ? data.amountUsd.value : this.amountUsd,
      paidWithCreditCard: data.paidWithCreditCard.present
          ? data.paidWithCreditCard.value
          : this.paidWithCreditCard,
      description: data.description.present
          ? data.description.value
          : this.description,
      paymentInstrumentId: data.paymentInstrumentId.present
          ? data.paymentInstrumentId.value
          : this.paymentInstrumentId,
      recurringSeriesId: data.recurringSeriesId.present
          ? data.recurringSeriesId.value
          : this.recurringSeriesId,
      paymentExpectationStatus: data.paymentExpectationStatus.present
          ? data.paymentExpectationStatus.value
          : this.paymentExpectationStatus,
      paymentExpectationConfirmedOn: data.paymentExpectationConfirmedOn.present
          ? data.paymentExpectationConfirmedOn.value
          : this.paymentExpectationConfirmedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('ExpenseRow(')
          ..write('id: $id, ')
          ..write('occurredOn: $occurredOn, ')
          ..write('categoryId: $categoryId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('amountOriginal: $amountOriginal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('manualFxRateToUsd: $manualFxRateToUsd, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('paidWithCreditCard: $paidWithCreditCard, ')
          ..write('description: $description, ')
          ..write('paymentInstrumentId: $paymentInstrumentId, ')
          ..write('recurringSeriesId: $recurringSeriesId, ')
          ..write('paymentExpectationStatus: $paymentExpectationStatus, ')
          ..write(
            'paymentExpectationConfirmedOn: $paymentExpectationConfirmedOn',
          )
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    occurredOn,
    categoryId,
    subcategoryId,
    amountOriginal,
    currencyCode,
    manualFxRateToUsd,
    amountUsd,
    paidWithCreditCard,
    description,
    paymentInstrumentId,
    recurringSeriesId,
    paymentExpectationStatus,
    paymentExpectationConfirmedOn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is ExpenseRow &&
          other.id == this.id &&
          other.occurredOn == this.occurredOn &&
          other.categoryId == this.categoryId &&
          other.subcategoryId == this.subcategoryId &&
          other.amountOriginal == this.amountOriginal &&
          other.currencyCode == this.currencyCode &&
          other.manualFxRateToUsd == this.manualFxRateToUsd &&
          other.amountUsd == this.amountUsd &&
          other.paidWithCreditCard == this.paidWithCreditCard &&
          other.description == this.description &&
          other.paymentInstrumentId == this.paymentInstrumentId &&
          other.recurringSeriesId == this.recurringSeriesId &&
          other.paymentExpectationStatus == this.paymentExpectationStatus &&
          other.paymentExpectationConfirmedOn ==
              this.paymentExpectationConfirmedOn);
}

class ExpensesCompanion extends UpdateCompanion<ExpenseRow> {
  final Value<String> id;
  final Value<String> occurredOn;
  final Value<String> categoryId;
  final Value<String> subcategoryId;
  final Value<double> amountOriginal;
  final Value<String> currencyCode;
  final Value<double> manualFxRateToUsd;
  final Value<double> amountUsd;
  final Value<bool> paidWithCreditCard;
  final Value<String> description;
  final Value<String?> paymentInstrumentId;
  final Value<String?> recurringSeriesId;
  final Value<String?> paymentExpectationStatus;
  final Value<String?> paymentExpectationConfirmedOn;
  final Value<int> rowid;
  const ExpensesCompanion({
    this.id = const Value.absent(),
    this.occurredOn = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.subcategoryId = const Value.absent(),
    this.amountOriginal = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.manualFxRateToUsd = const Value.absent(),
    this.amountUsd = const Value.absent(),
    this.paidWithCreditCard = const Value.absent(),
    this.description = const Value.absent(),
    this.paymentInstrumentId = const Value.absent(),
    this.recurringSeriesId = const Value.absent(),
    this.paymentExpectationStatus = const Value.absent(),
    this.paymentExpectationConfirmedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  ExpensesCompanion.insert({
    required String id,
    required String occurredOn,
    required String categoryId,
    required String subcategoryId,
    required double amountOriginal,
    this.currencyCode = const Value.absent(),
    this.manualFxRateToUsd = const Value.absent(),
    required double amountUsd,
    this.paidWithCreditCard = const Value.absent(),
    this.description = const Value.absent(),
    this.paymentInstrumentId = const Value.absent(),
    this.recurringSeriesId = const Value.absent(),
    this.paymentExpectationStatus = const Value.absent(),
    this.paymentExpectationConfirmedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       occurredOn = Value(occurredOn),
       categoryId = Value(categoryId),
       subcategoryId = Value(subcategoryId),
       amountOriginal = Value(amountOriginal),
       amountUsd = Value(amountUsd);
  static Insertable<ExpenseRow> custom({
    Expression<String>? id,
    Expression<String>? occurredOn,
    Expression<String>? categoryId,
    Expression<String>? subcategoryId,
    Expression<double>? amountOriginal,
    Expression<String>? currencyCode,
    Expression<double>? manualFxRateToUsd,
    Expression<double>? amountUsd,
    Expression<bool>? paidWithCreditCard,
    Expression<String>? description,
    Expression<String>? paymentInstrumentId,
    Expression<String>? recurringSeriesId,
    Expression<String>? paymentExpectationStatus,
    Expression<String>? paymentExpectationConfirmedOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (occurredOn != null) 'occurred_on': occurredOn,
      if (categoryId != null) 'category_id': categoryId,
      if (subcategoryId != null) 'subcategory_id': subcategoryId,
      if (amountOriginal != null) 'amount_original': amountOriginal,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (manualFxRateToUsd != null) 'manual_fx_rate_to_usd': manualFxRateToUsd,
      if (amountUsd != null) 'amount_usd': amountUsd,
      if (paidWithCreditCard != null)
        'paid_with_credit_card': paidWithCreditCard,
      if (description != null) 'description': description,
      if (paymentInstrumentId != null)
        'payment_instrument_id': paymentInstrumentId,
      if (recurringSeriesId != null) 'recurring_series_id': recurringSeriesId,
      if (paymentExpectationStatus != null)
        'payment_expectation_status': paymentExpectationStatus,
      if (paymentExpectationConfirmedOn != null)
        'payment_expectation_confirmed_on': paymentExpectationConfirmedOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  ExpensesCompanion copyWith({
    Value<String>? id,
    Value<String>? occurredOn,
    Value<String>? categoryId,
    Value<String>? subcategoryId,
    Value<double>? amountOriginal,
    Value<String>? currencyCode,
    Value<double>? manualFxRateToUsd,
    Value<double>? amountUsd,
    Value<bool>? paidWithCreditCard,
    Value<String>? description,
    Value<String?>? paymentInstrumentId,
    Value<String?>? recurringSeriesId,
    Value<String?>? paymentExpectationStatus,
    Value<String?>? paymentExpectationConfirmedOn,
    Value<int>? rowid,
  }) {
    return ExpensesCompanion(
      id: id ?? this.id,
      occurredOn: occurredOn ?? this.occurredOn,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      amountOriginal: amountOriginal ?? this.amountOriginal,
      currencyCode: currencyCode ?? this.currencyCode,
      manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
      amountUsd: amountUsd ?? this.amountUsd,
      paidWithCreditCard: paidWithCreditCard ?? this.paidWithCreditCard,
      description: description ?? this.description,
      paymentInstrumentId: paymentInstrumentId ?? this.paymentInstrumentId,
      recurringSeriesId: recurringSeriesId ?? this.recurringSeriesId,
      paymentExpectationStatus:
          paymentExpectationStatus ?? this.paymentExpectationStatus,
      paymentExpectationConfirmedOn:
          paymentExpectationConfirmedOn ?? this.paymentExpectationConfirmedOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (occurredOn.present) {
      map['occurred_on'] = Variable<String>(occurredOn.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (subcategoryId.present) {
      map['subcategory_id'] = Variable<String>(subcategoryId.value);
    }
    if (amountOriginal.present) {
      map['amount_original'] = Variable<double>(amountOriginal.value);
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (manualFxRateToUsd.present) {
      map['manual_fx_rate_to_usd'] = Variable<double>(manualFxRateToUsd.value);
    }
    if (amountUsd.present) {
      map['amount_usd'] = Variable<double>(amountUsd.value);
    }
    if (paidWithCreditCard.present) {
      map['paid_with_credit_card'] = Variable<bool>(paidWithCreditCard.value);
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (paymentInstrumentId.present) {
      map['payment_instrument_id'] = Variable<String>(
        paymentInstrumentId.value,
      );
    }
    if (recurringSeriesId.present) {
      map['recurring_series_id'] = Variable<String>(recurringSeriesId.value);
    }
    if (paymentExpectationStatus.present) {
      map['payment_expectation_status'] = Variable<String>(
        paymentExpectationStatus.value,
      );
    }
    if (paymentExpectationConfirmedOn.present) {
      map['payment_expectation_confirmed_on'] = Variable<String>(
        paymentExpectationConfirmedOn.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('ExpensesCompanion(')
          ..write('id: $id, ')
          ..write('occurredOn: $occurredOn, ')
          ..write('categoryId: $categoryId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('amountOriginal: $amountOriginal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('manualFxRateToUsd: $manualFxRateToUsd, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('paidWithCreditCard: $paidWithCreditCard, ')
          ..write('description: $description, ')
          ..write('paymentInstrumentId: $paymentInstrumentId, ')
          ..write('recurringSeriesId: $recurringSeriesId, ')
          ..write('paymentExpectationStatus: $paymentExpectationStatus, ')
          ..write(
            'paymentExpectationConfirmedOn: $paymentExpectationConfirmedOn, ',
          )
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $PaymentInstrumentsTable extends PaymentInstruments
    with TableInfo<$PaymentInstrumentsTable, PaymentInstrumentRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $PaymentInstrumentsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _labelMeta = const VerificationMeta('label');
  @override
  late final GeneratedColumn<String> label = GeneratedColumn<String>(
    'label',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _bankNameMeta = const VerificationMeta(
    'bankName',
  );
  @override
  late final GeneratedColumn<String> bankName = GeneratedColumn<String>(
    'bank_name',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _billingCycleDayMeta = const VerificationMeta(
    'billingCycleDay',
  );
  @override
  late final GeneratedColumn<int> billingCycleDay = GeneratedColumn<int>(
    'billing_cycle_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _annualFeeAmountMeta = const VerificationMeta(
    'annualFeeAmount',
  );
  @override
  late final GeneratedColumn<double> annualFeeAmount = GeneratedColumn<double>(
    'annual_fee_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _monthlyFeeAmountMeta = const VerificationMeta(
    'monthlyFeeAmount',
  );
  @override
  late final GeneratedColumn<double> monthlyFeeAmount = GeneratedColumn<double>(
    'monthly_fee_amount',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _feeDescriptionMeta = const VerificationMeta(
    'feeDescription',
  );
  @override
  late final GeneratedColumn<String> feeDescription = GeneratedColumn<String>(
    'fee_description',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant(''),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    label,
    bankName,
    billingCycleDay,
    annualFeeAmount,
    monthlyFeeAmount,
    feeDescription,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'payment_instruments';
  @override
  VerificationContext validateIntegrity(
    Insertable<PaymentInstrumentRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('label')) {
      context.handle(
        _labelMeta,
        label.isAcceptableOrUnknown(data['label']!, _labelMeta),
      );
    } else if (isInserting) {
      context.missing(_labelMeta);
    }
    if (data.containsKey('bank_name')) {
      context.handle(
        _bankNameMeta,
        bankName.isAcceptableOrUnknown(data['bank_name']!, _bankNameMeta),
      );
    }
    if (data.containsKey('billing_cycle_day')) {
      context.handle(
        _billingCycleDayMeta,
        billingCycleDay.isAcceptableOrUnknown(
          data['billing_cycle_day']!,
          _billingCycleDayMeta,
        ),
      );
    }
    if (data.containsKey('annual_fee_amount')) {
      context.handle(
        _annualFeeAmountMeta,
        annualFeeAmount.isAcceptableOrUnknown(
          data['annual_fee_amount']!,
          _annualFeeAmountMeta,
        ),
      );
    }
    if (data.containsKey('monthly_fee_amount')) {
      context.handle(
        _monthlyFeeAmountMeta,
        monthlyFeeAmount.isAcceptableOrUnknown(
          data['monthly_fee_amount']!,
          _monthlyFeeAmountMeta,
        ),
      );
    }
    if (data.containsKey('fee_description')) {
      context.handle(
        _feeDescriptionMeta,
        feeDescription.isAcceptableOrUnknown(
          data['fee_description']!,
          _feeDescriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  PaymentInstrumentRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return PaymentInstrumentRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      label: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}label'],
      )!,
      bankName: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}bank_name'],
      ),
      billingCycleDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}billing_cycle_day'],
      ),
      annualFeeAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}annual_fee_amount'],
      ),
      monthlyFeeAmount: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}monthly_fee_amount'],
      ),
      feeDescription: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}fee_description'],
      )!,
    );
  }

  @override
  $PaymentInstrumentsTable createAlias(String alias) {
    return $PaymentInstrumentsTable(attachedDatabase, alias);
  }
}

class PaymentInstrumentRow extends DataClass
    implements Insertable<PaymentInstrumentRow> {
  final String id;
  final String label;
  final String? bankName;
  final int? billingCycleDay;
  final double? annualFeeAmount;
  final double? monthlyFeeAmount;
  final String feeDescription;
  const PaymentInstrumentRow({
    required this.id,
    required this.label,
    this.bankName,
    this.billingCycleDay,
    this.annualFeeAmount,
    this.monthlyFeeAmount,
    required this.feeDescription,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['label'] = Variable<String>(label);
    if (!nullToAbsent || bankName != null) {
      map['bank_name'] = Variable<String>(bankName);
    }
    if (!nullToAbsent || billingCycleDay != null) {
      map['billing_cycle_day'] = Variable<int>(billingCycleDay);
    }
    if (!nullToAbsent || annualFeeAmount != null) {
      map['annual_fee_amount'] = Variable<double>(annualFeeAmount);
    }
    if (!nullToAbsent || monthlyFeeAmount != null) {
      map['monthly_fee_amount'] = Variable<double>(monthlyFeeAmount);
    }
    map['fee_description'] = Variable<String>(feeDescription);
    return map;
  }

  PaymentInstrumentsCompanion toCompanion(bool nullToAbsent) {
    return PaymentInstrumentsCompanion(
      id: Value(id),
      label: Value(label),
      bankName: bankName == null && nullToAbsent
          ? const Value.absent()
          : Value(bankName),
      billingCycleDay: billingCycleDay == null && nullToAbsent
          ? const Value.absent()
          : Value(billingCycleDay),
      annualFeeAmount: annualFeeAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(annualFeeAmount),
      monthlyFeeAmount: monthlyFeeAmount == null && nullToAbsent
          ? const Value.absent()
          : Value(monthlyFeeAmount),
      feeDescription: Value(feeDescription),
    );
  }

  factory PaymentInstrumentRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return PaymentInstrumentRow(
      id: serializer.fromJson<String>(json['id']),
      label: serializer.fromJson<String>(json['label']),
      bankName: serializer.fromJson<String?>(json['bankName']),
      billingCycleDay: serializer.fromJson<int?>(json['billingCycleDay']),
      annualFeeAmount: serializer.fromJson<double?>(json['annualFeeAmount']),
      monthlyFeeAmount: serializer.fromJson<double?>(json['monthlyFeeAmount']),
      feeDescription: serializer.fromJson<String>(json['feeDescription']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'label': serializer.toJson<String>(label),
      'bankName': serializer.toJson<String?>(bankName),
      'billingCycleDay': serializer.toJson<int?>(billingCycleDay),
      'annualFeeAmount': serializer.toJson<double?>(annualFeeAmount),
      'monthlyFeeAmount': serializer.toJson<double?>(monthlyFeeAmount),
      'feeDescription': serializer.toJson<String>(feeDescription),
    };
  }

  PaymentInstrumentRow copyWith({
    String? id,
    String? label,
    Value<String?> bankName = const Value.absent(),
    Value<int?> billingCycleDay = const Value.absent(),
    Value<double?> annualFeeAmount = const Value.absent(),
    Value<double?> monthlyFeeAmount = const Value.absent(),
    String? feeDescription,
  }) => PaymentInstrumentRow(
    id: id ?? this.id,
    label: label ?? this.label,
    bankName: bankName.present ? bankName.value : this.bankName,
    billingCycleDay: billingCycleDay.present
        ? billingCycleDay.value
        : this.billingCycleDay,
    annualFeeAmount: annualFeeAmount.present
        ? annualFeeAmount.value
        : this.annualFeeAmount,
    monthlyFeeAmount: monthlyFeeAmount.present
        ? monthlyFeeAmount.value
        : this.monthlyFeeAmount,
    feeDescription: feeDescription ?? this.feeDescription,
  );
  PaymentInstrumentRow copyWithCompanion(PaymentInstrumentsCompanion data) {
    return PaymentInstrumentRow(
      id: data.id.present ? data.id.value : this.id,
      label: data.label.present ? data.label.value : this.label,
      bankName: data.bankName.present ? data.bankName.value : this.bankName,
      billingCycleDay: data.billingCycleDay.present
          ? data.billingCycleDay.value
          : this.billingCycleDay,
      annualFeeAmount: data.annualFeeAmount.present
          ? data.annualFeeAmount.value
          : this.annualFeeAmount,
      monthlyFeeAmount: data.monthlyFeeAmount.present
          ? data.monthlyFeeAmount.value
          : this.monthlyFeeAmount,
      feeDescription: data.feeDescription.present
          ? data.feeDescription.value
          : this.feeDescription,
    );
  }

  @override
  String toString() {
    return (StringBuffer('PaymentInstrumentRow(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('bankName: $bankName, ')
          ..write('billingCycleDay: $billingCycleDay, ')
          ..write('annualFeeAmount: $annualFeeAmount, ')
          ..write('monthlyFeeAmount: $monthlyFeeAmount, ')
          ..write('feeDescription: $feeDescription')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    label,
    bankName,
    billingCycleDay,
    annualFeeAmount,
    monthlyFeeAmount,
    feeDescription,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is PaymentInstrumentRow &&
          other.id == this.id &&
          other.label == this.label &&
          other.bankName == this.bankName &&
          other.billingCycleDay == this.billingCycleDay &&
          other.annualFeeAmount == this.annualFeeAmount &&
          other.monthlyFeeAmount == this.monthlyFeeAmount &&
          other.feeDescription == this.feeDescription);
}

class PaymentInstrumentsCompanion
    extends UpdateCompanion<PaymentInstrumentRow> {
  final Value<String> id;
  final Value<String> label;
  final Value<String?> bankName;
  final Value<int?> billingCycleDay;
  final Value<double?> annualFeeAmount;
  final Value<double?> monthlyFeeAmount;
  final Value<String> feeDescription;
  final Value<int> rowid;
  const PaymentInstrumentsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.bankName = const Value.absent(),
    this.billingCycleDay = const Value.absent(),
    this.annualFeeAmount = const Value.absent(),
    this.monthlyFeeAmount = const Value.absent(),
    this.feeDescription = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  PaymentInstrumentsCompanion.insert({
    required String id,
    required String label,
    this.bankName = const Value.absent(),
    this.billingCycleDay = const Value.absent(),
    this.annualFeeAmount = const Value.absent(),
    this.monthlyFeeAmount = const Value.absent(),
    this.feeDescription = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       label = Value(label);
  static Insertable<PaymentInstrumentRow> custom({
    Expression<String>? id,
    Expression<String>? label,
    Expression<String>? bankName,
    Expression<int>? billingCycleDay,
    Expression<double>? annualFeeAmount,
    Expression<double>? monthlyFeeAmount,
    Expression<String>? feeDescription,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (label != null) 'label': label,
      if (bankName != null) 'bank_name': bankName,
      if (billingCycleDay != null) 'billing_cycle_day': billingCycleDay,
      if (annualFeeAmount != null) 'annual_fee_amount': annualFeeAmount,
      if (monthlyFeeAmount != null) 'monthly_fee_amount': monthlyFeeAmount,
      if (feeDescription != null) 'fee_description': feeDescription,
      if (rowid != null) 'rowid': rowid,
    });
  }

  PaymentInstrumentsCompanion copyWith({
    Value<String>? id,
    Value<String>? label,
    Value<String?>? bankName,
    Value<int?>? billingCycleDay,
    Value<double?>? annualFeeAmount,
    Value<double?>? monthlyFeeAmount,
    Value<String>? feeDescription,
    Value<int>? rowid,
  }) {
    return PaymentInstrumentsCompanion(
      id: id ?? this.id,
      label: label ?? this.label,
      bankName: bankName ?? this.bankName,
      billingCycleDay: billingCycleDay ?? this.billingCycleDay,
      annualFeeAmount: annualFeeAmount ?? this.annualFeeAmount,
      monthlyFeeAmount: monthlyFeeAmount ?? this.monthlyFeeAmount,
      feeDescription: feeDescription ?? this.feeDescription,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (label.present) {
      map['label'] = Variable<String>(label.value);
    }
    if (bankName.present) {
      map['bank_name'] = Variable<String>(bankName.value);
    }
    if (billingCycleDay.present) {
      map['billing_cycle_day'] = Variable<int>(billingCycleDay.value);
    }
    if (annualFeeAmount.present) {
      map['annual_fee_amount'] = Variable<double>(annualFeeAmount.value);
    }
    if (monthlyFeeAmount.present) {
      map['monthly_fee_amount'] = Variable<double>(monthlyFeeAmount.value);
    }
    if (feeDescription.present) {
      map['fee_description'] = Variable<String>(feeDescription.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('PaymentInstrumentsCompanion(')
          ..write('id: $id, ')
          ..write('label: $label, ')
          ..write('bankName: $bankName, ')
          ..write('billingCycleDay: $billingCycleDay, ')
          ..write('annualFeeAmount: $annualFeeAmount, ')
          ..write('monthlyFeeAmount: $monthlyFeeAmount, ')
          ..write('feeDescription: $feeDescription, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $CategoriesTable categories = $CategoriesTable(this);
  late final $SubcategoriesTable subcategories = $SubcategoriesTable(this);
  late final $RecExpenseSeriesTable recExpenseSeries = $RecExpenseSeriesTable(
    this,
  );
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $PaymentInstrumentsTable paymentInstruments =
      $PaymentInstrumentsTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    subcategories,
    recExpenseSeries,
    expenses,
    paymentInstruments,
  ];
  @override
  StreamQueryUpdateRules get streamUpdateRules => const StreamQueryUpdateRules([
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('subcategories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'expense_recurring_series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$CategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $CategoriesTable, CategoryRow> {
  $$CategoriesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static MultiTypedResultKey<$SubcategoriesTable, List<SubcategoryRow>>
  _subcategoriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.subcategories,
    aliasName: $_aliasNameGenerator(
      db.categories.id,
      db.subcategories.categoryId,
    ),
  );

  $$SubcategoriesTableProcessedTableManager get subcategoriesRefs {
    final manager = $$SubcategoriesTableTableManager(
      $_db,
      $_db.subcategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_subcategoriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $RecExpenseSeriesTable,
    List<ExpenseRecurringSeriesRow>
  >
  _recExpenseSeriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recExpenseSeries,
    aliasName: $_aliasNameGenerator(
      db.categories.id,
      db.recExpenseSeries.categoryId,
    ),
  );

  $$RecExpenseSeriesTableProcessedTableManager get recExpenseSeriesRefs {
    final manager = $$RecExpenseSeriesTableTableManager(
      $_db,
      $_db.recExpenseSeries,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recExpenseSeriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<ExpenseRow>>
  _expensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(db.categories.id, db.expenses.categoryId),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$CategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> subcategoriesRefs(
    Expression<bool> Function($$SubcategoriesTableFilterComposer f) f,
  ) {
    final $$SubcategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableFilterComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> recExpenseSeriesRefs(
    Expression<bool> Function($$RecExpenseSeriesTableFilterComposer f) f,
  ) {
    final $$RecExpenseSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recExpenseSeries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecExpenseSeriesTableFilterComposer(
            $db: $db,
            $table: $db.recExpenseSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$CategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $CategoriesTable> {
  $$CategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  Expression<T> subcategoriesRefs<T extends Object>(
    Expression<T> Function($$SubcategoriesTableAnnotationComposer a) f,
  ) {
    final $$SubcategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> recExpenseSeriesRefs<T extends Object>(
    Expression<T> Function($$RecExpenseSeriesTableAnnotationComposer a) f,
  ) {
    final $$RecExpenseSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recExpenseSeries,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecExpenseSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.recExpenseSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$CategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $CategoriesTable,
          CategoryRow,
          $$CategoriesTableFilterComposer,
          $$CategoriesTableOrderingComposer,
          $$CategoriesTableAnnotationComposer,
          $$CategoriesTableCreateCompanionBuilder,
          $$CategoriesTableUpdateCompanionBuilder,
          (CategoryRow, $$CategoriesTableReferences),
          CategoryRow,
          PrefetchHooks Function({
            bool subcategoriesRefs,
            bool recExpenseSeriesRefs,
            bool expensesRefs,
          })
        > {
  $$CategoriesTableTableManager(_$AppDatabase db, $CategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$CategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$CategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$CategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$CategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                subcategoriesRefs = false,
                recExpenseSeriesRefs = false,
                expensesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subcategoriesRefs) db.subcategories,
                    if (recExpenseSeriesRefs) db.recExpenseSeries,
                    if (expensesRefs) db.expenses,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (subcategoriesRefs)
                        await $_getPrefetchedData<
                          CategoryRow,
                          $CategoriesTable,
                          SubcategoryRow
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._subcategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).subcategoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (recExpenseSeriesRefs)
                        await $_getPrefetchedData<
                          CategoryRow,
                          $CategoriesTable,
                          ExpenseRecurringSeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._recExpenseSeriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).recExpenseSeriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          CategoryRow,
                          $CategoriesTable,
                          ExpenseRow
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$CategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $CategoriesTable,
      CategoryRow,
      $$CategoriesTableFilterComposer,
      $$CategoriesTableOrderingComposer,
      $$CategoriesTableAnnotationComposer,
      $$CategoriesTableCreateCompanionBuilder,
      $$CategoriesTableUpdateCompanionBuilder,
      (CategoryRow, $$CategoriesTableReferences),
      CategoryRow,
      PrefetchHooks Function({
        bool subcategoriesRefs,
        bool recExpenseSeriesRefs,
        bool expensesRefs,
      })
    >;
typedef $$SubcategoriesTableCreateCompanionBuilder =
    SubcategoriesCompanion Function({
      required String id,
      required String categoryId,
      required String name,
      Value<String?> description,
      required String slug,
      Value<bool> isSystemReserved,
      Value<int> sortOrder,
      Value<int> rowid,
    });
typedef $$SubcategoriesTableUpdateCompanionBuilder =
    SubcategoriesCompanion Function({
      Value<String> id,
      Value<String> categoryId,
      Value<String> name,
      Value<String?> description,
      Value<String> slug,
      Value<bool> isSystemReserved,
      Value<int> sortOrder,
      Value<int> rowid,
    });

final class $$SubcategoriesTableReferences
    extends BaseReferences<_$AppDatabase, $SubcategoriesTable, SubcategoryRow> {
  $$SubcategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.subcategories.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $RecExpenseSeriesTable,
    List<ExpenseRecurringSeriesRow>
  >
  _recExpenseSeriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.recExpenseSeries,
    aliasName: $_aliasNameGenerator(
      db.subcategories.id,
      db.recExpenseSeries.subcategoryId,
    ),
  );

  $$RecExpenseSeriesTableProcessedTableManager get recExpenseSeriesRefs {
    final manager = $$RecExpenseSeriesTableTableManager(
      $_db,
      $_db.recExpenseSeries,
    ).filter((f) => f.subcategoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _recExpenseSeriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<ExpenseRow>>
  _expensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(
      db.subcategories.id,
      db.expenses.subcategoryId,
    ),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager(
      $_db,
      $_db.expenses,
    ).filter((f) => f.subcategoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$SubcategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $SubcategoriesTable> {
  $$SubcategoriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isSystemReserved => $composableBuilder(
    column: $table.isSystemReserved,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> recExpenseSeriesRefs(
    Expression<bool> Function($$RecExpenseSeriesTableFilterComposer f) f,
  ) {
    final $$RecExpenseSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recExpenseSeries,
      getReferencedColumn: (t) => t.subcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecExpenseSeriesTableFilterComposer(
            $db: $db,
            $table: $db.recExpenseSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.subcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubcategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $SubcategoriesTable> {
  $$SubcategoriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get slug => $composableBuilder(
    column: $table.slug,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isSystemReserved => $composableBuilder(
    column: $table.isSystemReserved,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$SubcategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $SubcategoriesTable> {
  $$SubcategoriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get slug =>
      $composableBuilder(column: $table.slug, builder: (column) => column);

  GeneratedColumn<bool> get isSystemReserved => $composableBuilder(
    column: $table.isSystemReserved,
    builder: (column) => column,
  );

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> recExpenseSeriesRefs<T extends Object>(
    Expression<T> Function($$RecExpenseSeriesTableAnnotationComposer a) f,
  ) {
    final $$RecExpenseSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.recExpenseSeries,
      getReferencedColumn: (t) => t.subcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecExpenseSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.recExpenseSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.subcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$SubcategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SubcategoriesTable,
          SubcategoryRow,
          $$SubcategoriesTableFilterComposer,
          $$SubcategoriesTableOrderingComposer,
          $$SubcategoriesTableAnnotationComposer,
          $$SubcategoriesTableCreateCompanionBuilder,
          $$SubcategoriesTableUpdateCompanionBuilder,
          (SubcategoryRow, $$SubcategoriesTableReferences),
          SubcategoryRow,
          PrefetchHooks Function({
            bool categoryId,
            bool recExpenseSeriesRefs,
            bool expensesRefs,
          })
        > {
  $$SubcategoriesTableTableManager(_$AppDatabase db, $SubcategoriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SubcategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SubcategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SubcategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<bool> isSystemReserved = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubcategoriesCompanion(
                id: id,
                categoryId: categoryId,
                name: name,
                description: description,
                slug: slug,
                isSystemReserved: isSystemReserved,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String categoryId,
                required String name,
                Value<String?> description = const Value.absent(),
                required String slug,
                Value<bool> isSystemReserved = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubcategoriesCompanion.insert(
                id: id,
                categoryId: categoryId,
                name: name,
                description: description,
                slug: slug,
                isSystemReserved: isSystemReserved,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$SubcategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                recExpenseSeriesRefs = false,
                expensesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (recExpenseSeriesRefs) db.recExpenseSeries,
                    if (expensesRefs) db.expenses,
                  ],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$SubcategoriesTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$SubcategoriesTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (recExpenseSeriesRefs)
                        await $_getPrefetchedData<
                          SubcategoryRow,
                          $SubcategoriesTable,
                          ExpenseRecurringSeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubcategoriesTableReferences
                              ._recExpenseSeriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubcategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).recExpenseSeriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subcategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          SubcategoryRow,
                          $SubcategoriesTable,
                          ExpenseRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubcategoriesTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubcategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subcategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$SubcategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SubcategoriesTable,
      SubcategoryRow,
      $$SubcategoriesTableFilterComposer,
      $$SubcategoriesTableOrderingComposer,
      $$SubcategoriesTableAnnotationComposer,
      $$SubcategoriesTableCreateCompanionBuilder,
      $$SubcategoriesTableUpdateCompanionBuilder,
      (SubcategoryRow, $$SubcategoriesTableReferences),
      SubcategoryRow,
      PrefetchHooks Function({
        bool categoryId,
        bool recExpenseSeriesRefs,
        bool expensesRefs,
      })
    >;
typedef $$RecExpenseSeriesTableCreateCompanionBuilder =
    RecExpenseSeriesCompanion Function({
      required String id,
      required String anchorOccurredOn,
      required String recurrenceJson,
      required int horizonMonths,
      Value<bool> active,
      required String categoryId,
      required String subcategoryId,
      required double amountOriginal,
      Value<String> currencyCode,
      Value<double> manualFxRateToUsd,
      required double amountUsd,
      Value<bool> paidWithCreditCard,
      Value<String> description,
      Value<String?> paymentInstrumentId,
      Value<int> rowid,
    });
typedef $$RecExpenseSeriesTableUpdateCompanionBuilder =
    RecExpenseSeriesCompanion Function({
      Value<String> id,
      Value<String> anchorOccurredOn,
      Value<String> recurrenceJson,
      Value<int> horizonMonths,
      Value<bool> active,
      Value<String> categoryId,
      Value<String> subcategoryId,
      Value<double> amountOriginal,
      Value<String> currencyCode,
      Value<double> manualFxRateToUsd,
      Value<double> amountUsd,
      Value<bool> paidWithCreditCard,
      Value<String> description,
      Value<String?> paymentInstrumentId,
      Value<int> rowid,
    });

final class $$RecExpenseSeriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $RecExpenseSeriesTable,
          ExpenseRecurringSeriesRow
        > {
  $$RecExpenseSeriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.recExpenseSeries.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubcategoriesTable _subcategoryIdTable(_$AppDatabase db) =>
      db.subcategories.createAlias(
        $_aliasNameGenerator(
          db.recExpenseSeries.subcategoryId,
          db.subcategories.id,
        ),
      );

  $$SubcategoriesTableProcessedTableManager get subcategoryId {
    final $_column = $_itemColumn<String>('subcategory_id')!;

    final manager = $$SubcategoriesTableTableManager(
      $_db,
      $_db.subcategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subcategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<ExpenseRow>>
  _expensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(
      db.recExpenseSeries.id,
      db.expenses.recurringSeriesId,
    ),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager($_db, $_db.expenses).filter(
      (f) => f.recurringSeriesId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$RecExpenseSeriesTableFilterComposer
    extends Composer<_$AppDatabase, $RecExpenseSeriesTable> {
  $$RecExpenseSeriesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorOccurredOn => $composableBuilder(
    column: $table.anchorOccurredOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get recurrenceJson => $composableBuilder(
    column: $table.recurrenceJson,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get horizonMonths => $composableBuilder(
    column: $table.horizonMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountOriginal => $composableBuilder(
    column: $table.amountOriginal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get manualFxRateToUsd => $composableBuilder(
    column: $table.manualFxRateToUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountUsd => $composableBuilder(
    column: $table.amountUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paidWithCreditCard => $composableBuilder(
    column: $table.paidWithCreditCard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentInstrumentId => $composableBuilder(
    column: $table.paymentInstrumentId,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubcategoriesTableFilterComposer get subcategoryId {
    final $$SubcategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subcategoryId,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableFilterComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> expensesRefs(
    Expression<bool> Function($$ExpensesTableFilterComposer f) f,
  ) {
    final $$ExpensesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.recurringSeriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableFilterComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecExpenseSeriesTableOrderingComposer
    extends Composer<_$AppDatabase, $RecExpenseSeriesTable> {
  $$RecExpenseSeriesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorOccurredOn => $composableBuilder(
    column: $table.anchorOccurredOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get recurrenceJson => $composableBuilder(
    column: $table.recurrenceJson,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get horizonMonths => $composableBuilder(
    column: $table.horizonMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get active => $composableBuilder(
    column: $table.active,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountOriginal => $composableBuilder(
    column: $table.amountOriginal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get manualFxRateToUsd => $composableBuilder(
    column: $table.manualFxRateToUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountUsd => $composableBuilder(
    column: $table.amountUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paidWithCreditCard => $composableBuilder(
    column: $table.paidWithCreditCard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentInstrumentId => $composableBuilder(
    column: $table.paymentInstrumentId,
    builder: (column) => ColumnOrderings(column),
  );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubcategoriesTableOrderingComposer get subcategoryId {
    final $$SubcategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subcategoryId,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$RecExpenseSeriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $RecExpenseSeriesTable> {
  $$RecExpenseSeriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get anchorOccurredOn => $composableBuilder(
    column: $table.anchorOccurredOn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get recurrenceJson => $composableBuilder(
    column: $table.recurrenceJson,
    builder: (column) => column,
  );

  GeneratedColumn<int> get horizonMonths => $composableBuilder(
    column: $table.horizonMonths,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get active =>
      $composableBuilder(column: $table.active, builder: (column) => column);

  GeneratedColumn<double> get amountOriginal => $composableBuilder(
    column: $table.amountOriginal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get manualFxRateToUsd => $composableBuilder(
    column: $table.manualFxRateToUsd,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountUsd =>
      $composableBuilder(column: $table.amountUsd, builder: (column) => column);

  GeneratedColumn<bool> get paidWithCreditCard => $composableBuilder(
    column: $table.paidWithCreditCard,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentInstrumentId => $composableBuilder(
    column: $table.paymentInstrumentId,
    builder: (column) => column,
  );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubcategoriesTableAnnotationComposer get subcategoryId {
    final $$SubcategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subcategoryId,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> expensesRefs<T extends Object>(
    Expression<T> Function($$ExpensesTableAnnotationComposer a) f,
  ) {
    final $$ExpensesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.expenses,
      getReferencedColumn: (t) => t.recurringSeriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$ExpensesTableAnnotationComposer(
            $db: $db,
            $table: $db.expenses,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$RecExpenseSeriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $RecExpenseSeriesTable,
          ExpenseRecurringSeriesRow,
          $$RecExpenseSeriesTableFilterComposer,
          $$RecExpenseSeriesTableOrderingComposer,
          $$RecExpenseSeriesTableAnnotationComposer,
          $$RecExpenseSeriesTableCreateCompanionBuilder,
          $$RecExpenseSeriesTableUpdateCompanionBuilder,
          (ExpenseRecurringSeriesRow, $$RecExpenseSeriesTableReferences),
          ExpenseRecurringSeriesRow,
          PrefetchHooks Function({
            bool categoryId,
            bool subcategoryId,
            bool expensesRefs,
          })
        > {
  $$RecExpenseSeriesTableTableManager(
    _$AppDatabase db,
    $RecExpenseSeriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$RecExpenseSeriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$RecExpenseSeriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$RecExpenseSeriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> anchorOccurredOn = const Value.absent(),
                Value<String> recurrenceJson = const Value.absent(),
                Value<int> horizonMonths = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> subcategoryId = const Value.absent(),
                Value<double> amountOriginal = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double> manualFxRateToUsd = const Value.absent(),
                Value<double> amountUsd = const Value.absent(),
                Value<bool> paidWithCreditCard = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> paymentInstrumentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecExpenseSeriesCompanion(
                id: id,
                anchorOccurredOn: anchorOccurredOn,
                recurrenceJson: recurrenceJson,
                horizonMonths: horizonMonths,
                active: active,
                categoryId: categoryId,
                subcategoryId: subcategoryId,
                amountOriginal: amountOriginal,
                currencyCode: currencyCode,
                manualFxRateToUsd: manualFxRateToUsd,
                amountUsd: amountUsd,
                paidWithCreditCard: paidWithCreditCard,
                description: description,
                paymentInstrumentId: paymentInstrumentId,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String anchorOccurredOn,
                required String recurrenceJson,
                required int horizonMonths,
                Value<bool> active = const Value.absent(),
                required String categoryId,
                required String subcategoryId,
                required double amountOriginal,
                Value<String> currencyCode = const Value.absent(),
                Value<double> manualFxRateToUsd = const Value.absent(),
                required double amountUsd,
                Value<bool> paidWithCreditCard = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> paymentInstrumentId = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => RecExpenseSeriesCompanion.insert(
                id: id,
                anchorOccurredOn: anchorOccurredOn,
                recurrenceJson: recurrenceJson,
                horizonMonths: horizonMonths,
                active: active,
                categoryId: categoryId,
                subcategoryId: subcategoryId,
                amountOriginal: amountOriginal,
                currencyCode: currencyCode,
                manualFxRateToUsd: manualFxRateToUsd,
                amountUsd: amountUsd,
                paidWithCreditCard: paidWithCreditCard,
                description: description,
                paymentInstrumentId: paymentInstrumentId,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$RecExpenseSeriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                subcategoryId = false,
                expensesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [if (expensesRefs) db.expenses],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable:
                                        $$RecExpenseSeriesTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$RecExpenseSeriesTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (subcategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subcategoryId,
                                    referencedTable:
                                        $$RecExpenseSeriesTableReferences
                                            ._subcategoryIdTable(db),
                                    referencedColumn:
                                        $$RecExpenseSeriesTableReferences
                                            ._subcategoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (expensesRefs)
                        await $_getPrefetchedData<
                          ExpenseRecurringSeriesRow,
                          $RecExpenseSeriesTable,
                          ExpenseRow
                        >(
                          currentTable: table,
                          referencedTable: $$RecExpenseSeriesTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$RecExpenseSeriesTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.recurringSeriesId == item.id,
                              ),
                          typedResults: items,
                        ),
                    ];
                  },
                );
              },
        ),
      );
}

typedef $$RecExpenseSeriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $RecExpenseSeriesTable,
      ExpenseRecurringSeriesRow,
      $$RecExpenseSeriesTableFilterComposer,
      $$RecExpenseSeriesTableOrderingComposer,
      $$RecExpenseSeriesTableAnnotationComposer,
      $$RecExpenseSeriesTableCreateCompanionBuilder,
      $$RecExpenseSeriesTableUpdateCompanionBuilder,
      (ExpenseRecurringSeriesRow, $$RecExpenseSeriesTableReferences),
      ExpenseRecurringSeriesRow,
      PrefetchHooks Function({
        bool categoryId,
        bool subcategoryId,
        bool expensesRefs,
      })
    >;
typedef $$ExpensesTableCreateCompanionBuilder =
    ExpensesCompanion Function({
      required String id,
      required String occurredOn,
      required String categoryId,
      required String subcategoryId,
      required double amountOriginal,
      Value<String> currencyCode,
      Value<double> manualFxRateToUsd,
      required double amountUsd,
      Value<bool> paidWithCreditCard,
      Value<String> description,
      Value<String?> paymentInstrumentId,
      Value<String?> recurringSeriesId,
      Value<String?> paymentExpectationStatus,
      Value<String?> paymentExpectationConfirmedOn,
      Value<int> rowid,
    });
typedef $$ExpensesTableUpdateCompanionBuilder =
    ExpensesCompanion Function({
      Value<String> id,
      Value<String> occurredOn,
      Value<String> categoryId,
      Value<String> subcategoryId,
      Value<double> amountOriginal,
      Value<String> currencyCode,
      Value<double> manualFxRateToUsd,
      Value<double> amountUsd,
      Value<bool> paidWithCreditCard,
      Value<String> description,
      Value<String?> paymentInstrumentId,
      Value<String?> recurringSeriesId,
      Value<String?> paymentExpectationStatus,
      Value<String?> paymentExpectationConfirmedOn,
      Value<int> rowid,
    });

final class $$ExpensesTableReferences
    extends BaseReferences<_$AppDatabase, $ExpensesTable, ExpenseRow> {
  $$ExpensesTableReferences(super.$_db, super.$_table, super.$_typedResult);

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.expenses.categoryId, db.categories.id),
      );

  $$CategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$CategoriesTableTableManager(
      $_db,
      $_db.categories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $SubcategoriesTable _subcategoryIdTable(_$AppDatabase db) =>
      db.subcategories.createAlias(
        $_aliasNameGenerator(db.expenses.subcategoryId, db.subcategories.id),
      );

  $$SubcategoriesTableProcessedTableManager get subcategoryId {
    final $_column = $_itemColumn<String>('subcategory_id')!;

    final manager = $$SubcategoriesTableTableManager(
      $_db,
      $_db.subcategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_subcategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $RecExpenseSeriesTable _recurringSeriesIdTable(_$AppDatabase db) =>
      db.recExpenseSeries.createAlias(
        $_aliasNameGenerator(
          db.expenses.recurringSeriesId,
          db.recExpenseSeries.id,
        ),
      );

  $$RecExpenseSeriesTableProcessedTableManager? get recurringSeriesId {
    final $_column = $_itemColumn<String>('recurring_series_id');
    if ($_column == null) return null;
    final manager = $$RecExpenseSeriesTableTableManager(
      $_db,
      $_db.recExpenseSeries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurringSeriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$ExpensesTableFilterComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountOriginal => $composableBuilder(
    column: $table.amountOriginal,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get manualFxRateToUsd => $composableBuilder(
    column: $table.manualFxRateToUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get amountUsd => $composableBuilder(
    column: $table.amountUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get paidWithCreditCard => $composableBuilder(
    column: $table.paidWithCreditCard,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentInstrumentId => $composableBuilder(
    column: $table.paymentInstrumentId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentExpectationStatus => $composableBuilder(
    column: $table.paymentExpectationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get paymentExpectationConfirmedOn => $composableBuilder(
    column: $table.paymentExpectationConfirmedOn,
    builder: (column) => ColumnFilters(column),
  );

  $$CategoriesTableFilterComposer get categoryId {
    final $$CategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableFilterComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubcategoriesTableFilterComposer get subcategoryId {
    final $$SubcategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subcategoryId,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableFilterComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecExpenseSeriesTableFilterComposer get recurringSeriesId {
    final $$RecExpenseSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringSeriesId,
      referencedTable: $db.recExpenseSeries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecExpenseSeriesTableFilterComposer(
            $db: $db,
            $table: $db.recExpenseSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableOrderingComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountOriginal => $composableBuilder(
    column: $table.amountOriginal,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get manualFxRateToUsd => $composableBuilder(
    column: $table.manualFxRateToUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get amountUsd => $composableBuilder(
    column: $table.amountUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get paidWithCreditCard => $composableBuilder(
    column: $table.paidWithCreditCard,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentInstrumentId => $composableBuilder(
    column: $table.paymentInstrumentId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentExpectationStatus => $composableBuilder(
    column: $table.paymentExpectationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get paymentExpectationConfirmedOn =>
      $composableBuilder(
        column: $table.paymentExpectationConfirmedOn,
        builder: (column) => ColumnOrderings(column),
      );

  $$CategoriesTableOrderingComposer get categoryId {
    final $$CategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubcategoriesTableOrderingComposer get subcategoryId {
    final $$SubcategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subcategoryId,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecExpenseSeriesTableOrderingComposer get recurringSeriesId {
    final $$RecExpenseSeriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringSeriesId,
      referencedTable: $db.recExpenseSeries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecExpenseSeriesTableOrderingComposer(
            $db: $db,
            $table: $db.recExpenseSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableAnnotationComposer
    extends Composer<_$AppDatabase, $ExpensesTable> {
  $$ExpensesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get occurredOn => $composableBuilder(
    column: $table.occurredOn,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountOriginal => $composableBuilder(
    column: $table.amountOriginal,
    builder: (column) => column,
  );

  GeneratedColumn<String> get currencyCode => $composableBuilder(
    column: $table.currencyCode,
    builder: (column) => column,
  );

  GeneratedColumn<double> get manualFxRateToUsd => $composableBuilder(
    column: $table.manualFxRateToUsd,
    builder: (column) => column,
  );

  GeneratedColumn<double> get amountUsd =>
      $composableBuilder(column: $table.amountUsd, builder: (column) => column);

  GeneratedColumn<bool> get paidWithCreditCard => $composableBuilder(
    column: $table.paidWithCreditCard,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentInstrumentId => $composableBuilder(
    column: $table.paymentInstrumentId,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentExpectationStatus => $composableBuilder(
    column: $table.paymentExpectationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get paymentExpectationConfirmedOn =>
      $composableBuilder(
        column: $table.paymentExpectationConfirmedOn,
        builder: (column) => column,
      );

  $$CategoriesTableAnnotationComposer get categoryId {
    final $$CategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.categories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$CategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.categories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$SubcategoriesTableAnnotationComposer get subcategoryId {
    final $$SubcategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.subcategoryId,
      referencedTable: $db.subcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$SubcategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.subcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$RecExpenseSeriesTableAnnotationComposer get recurringSeriesId {
    final $$RecExpenseSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringSeriesId,
      referencedTable: $db.recExpenseSeries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$RecExpenseSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.recExpenseSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$ExpensesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $ExpensesTable,
          ExpenseRow,
          $$ExpensesTableFilterComposer,
          $$ExpensesTableOrderingComposer,
          $$ExpensesTableAnnotationComposer,
          $$ExpensesTableCreateCompanionBuilder,
          $$ExpensesTableUpdateCompanionBuilder,
          (ExpenseRow, $$ExpensesTableReferences),
          ExpenseRow,
          PrefetchHooks Function({
            bool categoryId,
            bool subcategoryId,
            bool recurringSeriesId,
          })
        > {
  $$ExpensesTableTableManager(_$AppDatabase db, $ExpensesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$ExpensesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$ExpensesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$ExpensesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> occurredOn = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> subcategoryId = const Value.absent(),
                Value<double> amountOriginal = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double> manualFxRateToUsd = const Value.absent(),
                Value<double> amountUsd = const Value.absent(),
                Value<bool> paidWithCreditCard = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> paymentInstrumentId = const Value.absent(),
                Value<String?> recurringSeriesId = const Value.absent(),
                Value<String?> paymentExpectationStatus = const Value.absent(),
                Value<String?> paymentExpectationConfirmedOn =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion(
                id: id,
                occurredOn: occurredOn,
                categoryId: categoryId,
                subcategoryId: subcategoryId,
                amountOriginal: amountOriginal,
                currencyCode: currencyCode,
                manualFxRateToUsd: manualFxRateToUsd,
                amountUsd: amountUsd,
                paidWithCreditCard: paidWithCreditCard,
                description: description,
                paymentInstrumentId: paymentInstrumentId,
                recurringSeriesId: recurringSeriesId,
                paymentExpectationStatus: paymentExpectationStatus,
                paymentExpectationConfirmedOn: paymentExpectationConfirmedOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String occurredOn,
                required String categoryId,
                required String subcategoryId,
                required double amountOriginal,
                Value<String> currencyCode = const Value.absent(),
                Value<double> manualFxRateToUsd = const Value.absent(),
                required double amountUsd,
                Value<bool> paidWithCreditCard = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> paymentInstrumentId = const Value.absent(),
                Value<String?> recurringSeriesId = const Value.absent(),
                Value<String?> paymentExpectationStatus = const Value.absent(),
                Value<String?> paymentExpectationConfirmedOn =
                    const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => ExpensesCompanion.insert(
                id: id,
                occurredOn: occurredOn,
                categoryId: categoryId,
                subcategoryId: subcategoryId,
                amountOriginal: amountOriginal,
                currencyCode: currencyCode,
                manualFxRateToUsd: manualFxRateToUsd,
                amountUsd: amountUsd,
                paidWithCreditCard: paidWithCreditCard,
                description: description,
                paymentInstrumentId: paymentInstrumentId,
                recurringSeriesId: recurringSeriesId,
                paymentExpectationStatus: paymentExpectationStatus,
                paymentExpectationConfirmedOn: paymentExpectationConfirmedOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$ExpensesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                subcategoryId = false,
                recurringSeriesId = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [],
                  addJoins:
                      <
                        T extends TableManagerState<
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic,
                          dynamic
                        >
                      >(state) {
                        if (categoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.categoryId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._categoryIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._categoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (subcategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.subcategoryId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._subcategoryIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._subcategoryIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }
                        if (recurringSeriesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.recurringSeriesId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._recurringSeriesIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._recurringSeriesIdTable(db)
                                        .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [];
                  },
                );
              },
        ),
      );
}

typedef $$ExpensesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $ExpensesTable,
      ExpenseRow,
      $$ExpensesTableFilterComposer,
      $$ExpensesTableOrderingComposer,
      $$ExpensesTableAnnotationComposer,
      $$ExpensesTableCreateCompanionBuilder,
      $$ExpensesTableUpdateCompanionBuilder,
      (ExpenseRow, $$ExpensesTableReferences),
      ExpenseRow,
      PrefetchHooks Function({
        bool categoryId,
        bool subcategoryId,
        bool recurringSeriesId,
      })
    >;
typedef $$PaymentInstrumentsTableCreateCompanionBuilder =
    PaymentInstrumentsCompanion Function({
      required String id,
      required String label,
      Value<String?> bankName,
      Value<int?> billingCycleDay,
      Value<double?> annualFeeAmount,
      Value<double?> monthlyFeeAmount,
      Value<String> feeDescription,
      Value<int> rowid,
    });
typedef $$PaymentInstrumentsTableUpdateCompanionBuilder =
    PaymentInstrumentsCompanion Function({
      Value<String> id,
      Value<String> label,
      Value<String?> bankName,
      Value<int?> billingCycleDay,
      Value<double?> annualFeeAmount,
      Value<double?> monthlyFeeAmount,
      Value<String> feeDescription,
      Value<int> rowid,
    });

class $$PaymentInstrumentsTableFilterComposer
    extends Composer<_$AppDatabase, $PaymentInstrumentsTable> {
  $$PaymentInstrumentsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get billingCycleDay => $composableBuilder(
    column: $table.billingCycleDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get annualFeeAmount => $composableBuilder(
    column: $table.annualFeeAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get monthlyFeeAmount => $composableBuilder(
    column: $table.monthlyFeeAmount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get feeDescription => $composableBuilder(
    column: $table.feeDescription,
    builder: (column) => ColumnFilters(column),
  );
}

class $$PaymentInstrumentsTableOrderingComposer
    extends Composer<_$AppDatabase, $PaymentInstrumentsTable> {
  $$PaymentInstrumentsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get label => $composableBuilder(
    column: $table.label,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get bankName => $composableBuilder(
    column: $table.bankName,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get billingCycleDay => $composableBuilder(
    column: $table.billingCycleDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get annualFeeAmount => $composableBuilder(
    column: $table.annualFeeAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get monthlyFeeAmount => $composableBuilder(
    column: $table.monthlyFeeAmount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get feeDescription => $composableBuilder(
    column: $table.feeDescription,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$PaymentInstrumentsTableAnnotationComposer
    extends Composer<_$AppDatabase, $PaymentInstrumentsTable> {
  $$PaymentInstrumentsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get label =>
      $composableBuilder(column: $table.label, builder: (column) => column);

  GeneratedColumn<String> get bankName =>
      $composableBuilder(column: $table.bankName, builder: (column) => column);

  GeneratedColumn<int> get billingCycleDay => $composableBuilder(
    column: $table.billingCycleDay,
    builder: (column) => column,
  );

  GeneratedColumn<double> get annualFeeAmount => $composableBuilder(
    column: $table.annualFeeAmount,
    builder: (column) => column,
  );

  GeneratedColumn<double> get monthlyFeeAmount => $composableBuilder(
    column: $table.monthlyFeeAmount,
    builder: (column) => column,
  );

  GeneratedColumn<String> get feeDescription => $composableBuilder(
    column: $table.feeDescription,
    builder: (column) => column,
  );
}

class $$PaymentInstrumentsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $PaymentInstrumentsTable,
          PaymentInstrumentRow,
          $$PaymentInstrumentsTableFilterComposer,
          $$PaymentInstrumentsTableOrderingComposer,
          $$PaymentInstrumentsTableAnnotationComposer,
          $$PaymentInstrumentsTableCreateCompanionBuilder,
          $$PaymentInstrumentsTableUpdateCompanionBuilder,
          (
            PaymentInstrumentRow,
            BaseReferences<
              _$AppDatabase,
              $PaymentInstrumentsTable,
              PaymentInstrumentRow
            >,
          ),
          PaymentInstrumentRow,
          PrefetchHooks Function()
        > {
  $$PaymentInstrumentsTableTableManager(
    _$AppDatabase db,
    $PaymentInstrumentsTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$PaymentInstrumentsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$PaymentInstrumentsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$PaymentInstrumentsTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> label = const Value.absent(),
                Value<String?> bankName = const Value.absent(),
                Value<int?> billingCycleDay = const Value.absent(),
                Value<double?> annualFeeAmount = const Value.absent(),
                Value<double?> monthlyFeeAmount = const Value.absent(),
                Value<String> feeDescription = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentInstrumentsCompanion(
                id: id,
                label: label,
                bankName: bankName,
                billingCycleDay: billingCycleDay,
                annualFeeAmount: annualFeeAmount,
                monthlyFeeAmount: monthlyFeeAmount,
                feeDescription: feeDescription,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String label,
                Value<String?> bankName = const Value.absent(),
                Value<int?> billingCycleDay = const Value.absent(),
                Value<double?> annualFeeAmount = const Value.absent(),
                Value<double?> monthlyFeeAmount = const Value.absent(),
                Value<String> feeDescription = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentInstrumentsCompanion.insert(
                id: id,
                label: label,
                bankName: bankName,
                billingCycleDay: billingCycleDay,
                annualFeeAmount: annualFeeAmount,
                monthlyFeeAmount: monthlyFeeAmount,
                feeDescription: feeDescription,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map((e) => (e.readTable(table), BaseReferences(db, table, e)))
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$PaymentInstrumentsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $PaymentInstrumentsTable,
      PaymentInstrumentRow,
      $$PaymentInstrumentsTableFilterComposer,
      $$PaymentInstrumentsTableOrderingComposer,
      $$PaymentInstrumentsTableAnnotationComposer,
      $$PaymentInstrumentsTableCreateCompanionBuilder,
      $$PaymentInstrumentsTableUpdateCompanionBuilder,
      (
        PaymentInstrumentRow,
        BaseReferences<
          _$AppDatabase,
          $PaymentInstrumentsTable,
          PaymentInstrumentRow
        >,
      ),
      PaymentInstrumentRow,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$SubcategoriesTableTableManager get subcategories =>
      $$SubcategoriesTableTableManager(_db, _db.subcategories);
  $$RecExpenseSeriesTableTableManager get recExpenseSeries =>
      $$RecExpenseSeriesTableTableManager(_db, _db.recExpenseSeries);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$PaymentInstrumentsTableTableManager get paymentInstruments =>
      $$PaymentInstrumentsTableTableManager(_db, _db.paymentInstruments);
}
