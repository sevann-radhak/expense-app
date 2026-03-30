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
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    sortOrder,
    isActive,
  ];
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
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
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
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  final bool isActive;
  const CategoryRow({
    required this.id,
    required this.name,
    this.description,
    required this.sortOrder,
    required this.isActive,
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
    map['is_active'] = Variable<bool>(isActive);
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
      isActive: Value(isActive),
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
      isActive: serializer.fromJson<bool>(json['isActive']),
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
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  CategoryRow copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? sortOrder,
    bool? isActive,
  }) => CategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  CategoryRow copyWithCompanion(CategoriesCompanion data) {
    return CategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('CategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is CategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class CategoriesCompanion extends UpdateCompanion<CategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const CategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  CategoriesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<CategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  CategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return CategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
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
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
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
          ..write('isActive: $isActive, ')
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
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    isActive,
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
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
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
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
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
  final bool isActive;
  const SubcategoryRow({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.slug,
    required this.isSystemReserved,
    required this.sortOrder,
    required this.isActive,
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
    map['is_active'] = Variable<bool>(isActive);
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
      isActive: Value(isActive),
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
      isActive: serializer.fromJson<bool>(json['isActive']),
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
      'isActive': serializer.toJson<bool>(isActive),
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
    bool? isActive,
  }) => SubcategoryRow(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    slug: slug ?? this.slug,
    isSystemReserved: isSystemReserved ?? this.isSystemReserved,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
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
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
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
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
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
    isActive,
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
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class SubcategoriesCompanion extends UpdateCompanion<SubcategoryRow> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> slug;
  final Value<bool> isSystemReserved;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const SubcategoriesCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.slug = const Value.absent(),
    this.isSystemReserved = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
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
    this.isActive = const Value.absent(),
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
    Expression<bool>? isActive,
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
      if (isActive != null) 'is_active': isActive,
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
    Value<bool>? isActive,
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
      isActive: isActive ?? this.isActive,
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
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
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
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeCategoriesTable extends IncomeCategories
    with TableInfo<$IncomeCategoriesTable, IncomeCategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeCategoriesTable(this.attachedDatabase, [this._alias]);
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
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    name,
    description,
    sortOrder,
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_categories';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeCategoryRow> instance, {
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
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeCategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeCategoryRow(
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
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $IncomeCategoriesTable createAlias(String alias) {
    return $IncomeCategoriesTable(attachedDatabase, alias);
  }
}

class IncomeCategoryRow extends DataClass
    implements Insertable<IncomeCategoryRow> {
  final String id;
  final String name;
  final String? description;
  final int sortOrder;
  final bool isActive;
  const IncomeCategoryRow({
    required this.id,
    required this.name,
    this.description,
    required this.sortOrder,
    required this.isActive,
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
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  IncomeCategoriesCompanion toCompanion(bool nullToAbsent) {
    return IncomeCategoriesCompanion(
      id: Value(id),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory IncomeCategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeCategoryRow(
      id: serializer.fromJson<String>(json['id']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
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
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  IncomeCategoryRow copyWith({
    String? id,
    String? name,
    Value<String?> description = const Value.absent(),
    int? sortOrder,
    bool? isActive,
  }) => IncomeCategoryRow(
    id: id ?? this.id,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  IncomeCategoryRow copyWithCompanion(IncomeCategoriesCompanion data) {
    return IncomeCategoryRow(
      id: data.id.present ? data.id.value : this.id,
      name: data.name.present ? data.name.value : this.name,
      description: data.description.present
          ? data.description.value
          : this.description,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeCategoryRow(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, name, description, sortOrder, isActive);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeCategoryRow &&
          other.id == this.id &&
          other.name == this.name &&
          other.description == this.description &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class IncomeCategoriesCompanion extends UpdateCompanion<IncomeCategoryRow> {
  final Value<String> id;
  final Value<String> name;
  final Value<String?> description;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const IncomeCategoriesCompanion({
    this.id = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeCategoriesCompanion.insert({
    required String id,
    required String name,
    this.description = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       name = Value(name);
  static Insertable<IncomeCategoryRow> custom({
    Expression<String>? id,
    Expression<String>? name,
    Expression<String>? description,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (name != null) 'name': name,
      if (description != null) 'description': description,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeCategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? name,
    Value<String?>? description,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return IncomeCategoriesCompanion(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
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
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeCategoriesCompanion(')
          ..write('id: $id, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeSubcategoriesTable extends IncomeSubcategories
    with TableInfo<$IncomeSubcategoriesTable, IncomeSubcategoryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeSubcategoriesTable(this.attachedDatabase, [this._alias]);
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
      'REFERENCES income_categories (id) ON DELETE CASCADE',
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
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
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
    isActive,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_subcategories';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeSubcategoryRow> instance, {
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
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeSubcategoryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeSubcategoryRow(
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
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
    );
  }

  @override
  $IncomeSubcategoriesTable createAlias(String alias) {
    return $IncomeSubcategoriesTable(attachedDatabase, alias);
  }
}

class IncomeSubcategoryRow extends DataClass
    implements Insertable<IncomeSubcategoryRow> {
  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final String slug;
  final bool isSystemReserved;
  final int sortOrder;
  final bool isActive;
  const IncomeSubcategoryRow({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.slug,
    required this.isSystemReserved,
    required this.sortOrder,
    required this.isActive,
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
    map['is_active'] = Variable<bool>(isActive);
    return map;
  }

  IncomeSubcategoriesCompanion toCompanion(bool nullToAbsent) {
    return IncomeSubcategoriesCompanion(
      id: Value(id),
      categoryId: Value(categoryId),
      name: Value(name),
      description: description == null && nullToAbsent
          ? const Value.absent()
          : Value(description),
      slug: Value(slug),
      isSystemReserved: Value(isSystemReserved),
      sortOrder: Value(sortOrder),
      isActive: Value(isActive),
    );
  }

  factory IncomeSubcategoryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeSubcategoryRow(
      id: serializer.fromJson<String>(json['id']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      name: serializer.fromJson<String>(json['name']),
      description: serializer.fromJson<String?>(json['description']),
      slug: serializer.fromJson<String>(json['slug']),
      isSystemReserved: serializer.fromJson<bool>(json['isSystemReserved']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
      isActive: serializer.fromJson<bool>(json['isActive']),
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
      'isActive': serializer.toJson<bool>(isActive),
    };
  }

  IncomeSubcategoryRow copyWith({
    String? id,
    String? categoryId,
    String? name,
    Value<String?> description = const Value.absent(),
    String? slug,
    bool? isSystemReserved,
    int? sortOrder,
    bool? isActive,
  }) => IncomeSubcategoryRow(
    id: id ?? this.id,
    categoryId: categoryId ?? this.categoryId,
    name: name ?? this.name,
    description: description.present ? description.value : this.description,
    slug: slug ?? this.slug,
    isSystemReserved: isSystemReserved ?? this.isSystemReserved,
    sortOrder: sortOrder ?? this.sortOrder,
    isActive: isActive ?? this.isActive,
  );
  IncomeSubcategoryRow copyWithCompanion(IncomeSubcategoriesCompanion data) {
    return IncomeSubcategoryRow(
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
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeSubcategoryRow(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('slug: $slug, ')
          ..write('isSystemReserved: $isSystemReserved, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive')
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
    isActive,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeSubcategoryRow &&
          other.id == this.id &&
          other.categoryId == this.categoryId &&
          other.name == this.name &&
          other.description == this.description &&
          other.slug == this.slug &&
          other.isSystemReserved == this.isSystemReserved &&
          other.sortOrder == this.sortOrder &&
          other.isActive == this.isActive);
}

class IncomeSubcategoriesCompanion
    extends UpdateCompanion<IncomeSubcategoryRow> {
  final Value<String> id;
  final Value<String> categoryId;
  final Value<String> name;
  final Value<String?> description;
  final Value<String> slug;
  final Value<bool> isSystemReserved;
  final Value<int> sortOrder;
  final Value<bool> isActive;
  final Value<int> rowid;
  const IncomeSubcategoriesCompanion({
    this.id = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.name = const Value.absent(),
    this.description = const Value.absent(),
    this.slug = const Value.absent(),
    this.isSystemReserved = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeSubcategoriesCompanion.insert({
    required String id,
    required String categoryId,
    required String name,
    this.description = const Value.absent(),
    required String slug,
    this.isSystemReserved = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.isActive = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       categoryId = Value(categoryId),
       name = Value(name),
       slug = Value(slug);
  static Insertable<IncomeSubcategoryRow> custom({
    Expression<String>? id,
    Expression<String>? categoryId,
    Expression<String>? name,
    Expression<String>? description,
    Expression<String>? slug,
    Expression<bool>? isSystemReserved,
    Expression<int>? sortOrder,
    Expression<bool>? isActive,
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
      if (isActive != null) 'is_active': isActive,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeSubcategoriesCompanion copyWith({
    Value<String>? id,
    Value<String>? categoryId,
    Value<String>? name,
    Value<String?>? description,
    Value<String>? slug,
    Value<bool>? isSystemReserved,
    Value<int>? sortOrder,
    Value<bool>? isActive,
    Value<int>? rowid,
  }) {
    return IncomeSubcategoriesCompanion(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: description ?? this.description,
      slug: slug ?? this.slug,
      isSystemReserved: isSystemReserved ?? this.isSystemReserved,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
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
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeSubcategoriesCompanion(')
          ..write('id: $id, ')
          ..write('categoryId: $categoryId, ')
          ..write('name: $name, ')
          ..write('description: $description, ')
          ..write('slug: $slug, ')
          ..write('isSystemReserved: $isSystemReserved, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('isActive: $isActive, ')
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
  static const VerificationMeta _isActiveMeta = const VerificationMeta(
    'isActive',
  );
  @override
  late final GeneratedColumn<bool> isActive = GeneratedColumn<bool>(
    'is_active',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_active" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _isDefaultMeta = const VerificationMeta(
    'isDefault',
  );
  @override
  late final GeneratedColumn<bool> isDefault = GeneratedColumn<bool>(
    'is_default',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("is_default" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _statementClosingDayMeta =
      const VerificationMeta('statementClosingDay');
  @override
  late final GeneratedColumn<int> statementClosingDay = GeneratedColumn<int>(
    'statement_closing_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _paymentDueDayMeta = const VerificationMeta(
    'paymentDueDay',
  );
  @override
  late final GeneratedColumn<int> paymentDueDay = GeneratedColumn<int>(
    'payment_due_day',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _nominalAprPercentMeta = const VerificationMeta(
    'nominalAprPercent',
  );
  @override
  late final GeneratedColumn<double> nominalAprPercent =
      GeneratedColumn<double>(
        'nominal_apr_percent',
        aliasedName,
        true,
        type: DriftSqlType.double,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _creditLimitMeta = const VerificationMeta(
    'creditLimit',
  );
  @override
  late final GeneratedColumn<double> creditLimit = GeneratedColumn<double>(
    'credit_limit',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _displaySuffixMeta = const VerificationMeta(
    'displaySuffix',
  );
  @override
  late final GeneratedColumn<String> displaySuffix = GeneratedColumn<String>(
    'display_suffix',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
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
    isActive,
    isDefault,
    statementClosingDay,
    paymentDueDay,
    nominalAprPercent,
    creditLimit,
    displaySuffix,
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
    if (data.containsKey('is_active')) {
      context.handle(
        _isActiveMeta,
        isActive.isAcceptableOrUnknown(data['is_active']!, _isActiveMeta),
      );
    }
    if (data.containsKey('is_default')) {
      context.handle(
        _isDefaultMeta,
        isDefault.isAcceptableOrUnknown(data['is_default']!, _isDefaultMeta),
      );
    }
    if (data.containsKey('statement_closing_day')) {
      context.handle(
        _statementClosingDayMeta,
        statementClosingDay.isAcceptableOrUnknown(
          data['statement_closing_day']!,
          _statementClosingDayMeta,
        ),
      );
    }
    if (data.containsKey('payment_due_day')) {
      context.handle(
        _paymentDueDayMeta,
        paymentDueDay.isAcceptableOrUnknown(
          data['payment_due_day']!,
          _paymentDueDayMeta,
        ),
      );
    }
    if (data.containsKey('nominal_apr_percent')) {
      context.handle(
        _nominalAprPercentMeta,
        nominalAprPercent.isAcceptableOrUnknown(
          data['nominal_apr_percent']!,
          _nominalAprPercentMeta,
        ),
      );
    }
    if (data.containsKey('credit_limit')) {
      context.handle(
        _creditLimitMeta,
        creditLimit.isAcceptableOrUnknown(
          data['credit_limit']!,
          _creditLimitMeta,
        ),
      );
    }
    if (data.containsKey('display_suffix')) {
      context.handle(
        _displaySuffixMeta,
        displaySuffix.isAcceptableOrUnknown(
          data['display_suffix']!,
          _displaySuffixMeta,
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
      isActive: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_active'],
      )!,
      isDefault: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}is_default'],
      )!,
      statementClosingDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}statement_closing_day'],
      ),
      paymentDueDay: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_due_day'],
      ),
      nominalAprPercent: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}nominal_apr_percent'],
      ),
      creditLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}credit_limit'],
      ),
      displaySuffix: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}display_suffix'],
      ),
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
  final bool isActive;
  final bool isDefault;
  final int? statementClosingDay;
  final int? paymentDueDay;
  final double? nominalAprPercent;
  final double? creditLimit;
  final String? displaySuffix;
  const PaymentInstrumentRow({
    required this.id,
    required this.label,
    this.bankName,
    this.billingCycleDay,
    this.annualFeeAmount,
    this.monthlyFeeAmount,
    required this.feeDescription,
    required this.isActive,
    required this.isDefault,
    this.statementClosingDay,
    this.paymentDueDay,
    this.nominalAprPercent,
    this.creditLimit,
    this.displaySuffix,
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
    map['is_active'] = Variable<bool>(isActive);
    map['is_default'] = Variable<bool>(isDefault);
    if (!nullToAbsent || statementClosingDay != null) {
      map['statement_closing_day'] = Variable<int>(statementClosingDay);
    }
    if (!nullToAbsent || paymentDueDay != null) {
      map['payment_due_day'] = Variable<int>(paymentDueDay);
    }
    if (!nullToAbsent || nominalAprPercent != null) {
      map['nominal_apr_percent'] = Variable<double>(nominalAprPercent);
    }
    if (!nullToAbsent || creditLimit != null) {
      map['credit_limit'] = Variable<double>(creditLimit);
    }
    if (!nullToAbsent || displaySuffix != null) {
      map['display_suffix'] = Variable<String>(displaySuffix);
    }
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
      isActive: Value(isActive),
      isDefault: Value(isDefault),
      statementClosingDay: statementClosingDay == null && nullToAbsent
          ? const Value.absent()
          : Value(statementClosingDay),
      paymentDueDay: paymentDueDay == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentDueDay),
      nominalAprPercent: nominalAprPercent == null && nullToAbsent
          ? const Value.absent()
          : Value(nominalAprPercent),
      creditLimit: creditLimit == null && nullToAbsent
          ? const Value.absent()
          : Value(creditLimit),
      displaySuffix: displaySuffix == null && nullToAbsent
          ? const Value.absent()
          : Value(displaySuffix),
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
      isActive: serializer.fromJson<bool>(json['isActive']),
      isDefault: serializer.fromJson<bool>(json['isDefault']),
      statementClosingDay: serializer.fromJson<int?>(
        json['statementClosingDay'],
      ),
      paymentDueDay: serializer.fromJson<int?>(json['paymentDueDay']),
      nominalAprPercent: serializer.fromJson<double?>(
        json['nominalAprPercent'],
      ),
      creditLimit: serializer.fromJson<double?>(json['creditLimit']),
      displaySuffix: serializer.fromJson<String?>(json['displaySuffix']),
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
      'isActive': serializer.toJson<bool>(isActive),
      'isDefault': serializer.toJson<bool>(isDefault),
      'statementClosingDay': serializer.toJson<int?>(statementClosingDay),
      'paymentDueDay': serializer.toJson<int?>(paymentDueDay),
      'nominalAprPercent': serializer.toJson<double?>(nominalAprPercent),
      'creditLimit': serializer.toJson<double?>(creditLimit),
      'displaySuffix': serializer.toJson<String?>(displaySuffix),
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
    bool? isActive,
    bool? isDefault,
    Value<int?> statementClosingDay = const Value.absent(),
    Value<int?> paymentDueDay = const Value.absent(),
    Value<double?> nominalAprPercent = const Value.absent(),
    Value<double?> creditLimit = const Value.absent(),
    Value<String?> displaySuffix = const Value.absent(),
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
    isActive: isActive ?? this.isActive,
    isDefault: isDefault ?? this.isDefault,
    statementClosingDay: statementClosingDay.present
        ? statementClosingDay.value
        : this.statementClosingDay,
    paymentDueDay: paymentDueDay.present
        ? paymentDueDay.value
        : this.paymentDueDay,
    nominalAprPercent: nominalAprPercent.present
        ? nominalAprPercent.value
        : this.nominalAprPercent,
    creditLimit: creditLimit.present ? creditLimit.value : this.creditLimit,
    displaySuffix: displaySuffix.present
        ? displaySuffix.value
        : this.displaySuffix,
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
      isActive: data.isActive.present ? data.isActive.value : this.isActive,
      isDefault: data.isDefault.present ? data.isDefault.value : this.isDefault,
      statementClosingDay: data.statementClosingDay.present
          ? data.statementClosingDay.value
          : this.statementClosingDay,
      paymentDueDay: data.paymentDueDay.present
          ? data.paymentDueDay.value
          : this.paymentDueDay,
      nominalAprPercent: data.nominalAprPercent.present
          ? data.nominalAprPercent.value
          : this.nominalAprPercent,
      creditLimit: data.creditLimit.present
          ? data.creditLimit.value
          : this.creditLimit,
      displaySuffix: data.displaySuffix.present
          ? data.displaySuffix.value
          : this.displaySuffix,
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
          ..write('feeDescription: $feeDescription, ')
          ..write('isActive: $isActive, ')
          ..write('isDefault: $isDefault, ')
          ..write('statementClosingDay: $statementClosingDay, ')
          ..write('paymentDueDay: $paymentDueDay, ')
          ..write('nominalAprPercent: $nominalAprPercent, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('displaySuffix: $displaySuffix')
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
    isActive,
    isDefault,
    statementClosingDay,
    paymentDueDay,
    nominalAprPercent,
    creditLimit,
    displaySuffix,
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
          other.feeDescription == this.feeDescription &&
          other.isActive == this.isActive &&
          other.isDefault == this.isDefault &&
          other.statementClosingDay == this.statementClosingDay &&
          other.paymentDueDay == this.paymentDueDay &&
          other.nominalAprPercent == this.nominalAprPercent &&
          other.creditLimit == this.creditLimit &&
          other.displaySuffix == this.displaySuffix);
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
  final Value<bool> isActive;
  final Value<bool> isDefault;
  final Value<int?> statementClosingDay;
  final Value<int?> paymentDueDay;
  final Value<double?> nominalAprPercent;
  final Value<double?> creditLimit;
  final Value<String?> displaySuffix;
  final Value<int> rowid;
  const PaymentInstrumentsCompanion({
    this.id = const Value.absent(),
    this.label = const Value.absent(),
    this.bankName = const Value.absent(),
    this.billingCycleDay = const Value.absent(),
    this.annualFeeAmount = const Value.absent(),
    this.monthlyFeeAmount = const Value.absent(),
    this.feeDescription = const Value.absent(),
    this.isActive = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.statementClosingDay = const Value.absent(),
    this.paymentDueDay = const Value.absent(),
    this.nominalAprPercent = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.displaySuffix = const Value.absent(),
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
    this.isActive = const Value.absent(),
    this.isDefault = const Value.absent(),
    this.statementClosingDay = const Value.absent(),
    this.paymentDueDay = const Value.absent(),
    this.nominalAprPercent = const Value.absent(),
    this.creditLimit = const Value.absent(),
    this.displaySuffix = const Value.absent(),
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
    Expression<bool>? isActive,
    Expression<bool>? isDefault,
    Expression<int>? statementClosingDay,
    Expression<int>? paymentDueDay,
    Expression<double>? nominalAprPercent,
    Expression<double>? creditLimit,
    Expression<String>? displaySuffix,
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
      if (isActive != null) 'is_active': isActive,
      if (isDefault != null) 'is_default': isDefault,
      if (statementClosingDay != null)
        'statement_closing_day': statementClosingDay,
      if (paymentDueDay != null) 'payment_due_day': paymentDueDay,
      if (nominalAprPercent != null) 'nominal_apr_percent': nominalAprPercent,
      if (creditLimit != null) 'credit_limit': creditLimit,
      if (displaySuffix != null) 'display_suffix': displaySuffix,
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
    Value<bool>? isActive,
    Value<bool>? isDefault,
    Value<int?>? statementClosingDay,
    Value<int?>? paymentDueDay,
    Value<double?>? nominalAprPercent,
    Value<double?>? creditLimit,
    Value<String?>? displaySuffix,
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
      isActive: isActive ?? this.isActive,
      isDefault: isDefault ?? this.isDefault,
      statementClosingDay: statementClosingDay ?? this.statementClosingDay,
      paymentDueDay: paymentDueDay ?? this.paymentDueDay,
      nominalAprPercent: nominalAprPercent ?? this.nominalAprPercent,
      creditLimit: creditLimit ?? this.creditLimit,
      displaySuffix: displaySuffix ?? this.displaySuffix,
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
    if (isActive.present) {
      map['is_active'] = Variable<bool>(isActive.value);
    }
    if (isDefault.present) {
      map['is_default'] = Variable<bool>(isDefault.value);
    }
    if (statementClosingDay.present) {
      map['statement_closing_day'] = Variable<int>(statementClosingDay.value);
    }
    if (paymentDueDay.present) {
      map['payment_due_day'] = Variable<int>(paymentDueDay.value);
    }
    if (nominalAprPercent.present) {
      map['nominal_apr_percent'] = Variable<double>(nominalAprPercent.value);
    }
    if (creditLimit.present) {
      map['credit_limit'] = Variable<double>(creditLimit.value);
    }
    if (displaySuffix.present) {
      map['display_suffix'] = Variable<String>(displaySuffix.value);
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
          ..write('isActive: $isActive, ')
          ..write('isDefault: $isDefault, ')
          ..write('statementClosingDay: $statementClosingDay, ')
          ..write('paymentDueDay: $paymentDueDay, ')
          ..write('nominalAprPercent: $nominalAprPercent, ')
          ..write('creditLimit: $creditLimit, ')
          ..write('displaySuffix: $displaySuffix, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $InstallmentPlansTable extends InstallmentPlans
    with TableInfo<$InstallmentPlansTable, InstallmentPlanRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $InstallmentPlansTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _paymentCountMeta = const VerificationMeta(
    'paymentCount',
  );
  @override
  late final GeneratedColumn<int> paymentCount = GeneratedColumn<int>(
    'payment_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _intervalMonthsMeta = const VerificationMeta(
    'intervalMonths',
  );
  @override
  late final GeneratedColumn<int> intervalMonths = GeneratedColumn<int>(
    'interval_months',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(1),
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
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES payment_instruments (id) ON DELETE SET NULL',
        ),
      );
  static const VerificationMeta _perPaymentAmountOriginalMeta =
      const VerificationMeta('perPaymentAmountOriginal');
  @override
  late final GeneratedColumn<double> perPaymentAmountOriginal =
      GeneratedColumn<double>(
        'per_payment_amount_original',
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
  static const VerificationMeta _perPaymentAmountUsdMeta =
      const VerificationMeta('perPaymentAmountUsd');
  @override
  late final GeneratedColumn<double> perPaymentAmountUsd =
      GeneratedColumn<double>(
        'per_payment_amount_usd',
        aliasedName,
        false,
        type: DriftSqlType.double,
        requiredDuringInsert: true,
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    paymentCount,
    intervalMonths,
    anchorOccurredOn,
    categoryId,
    subcategoryId,
    paymentInstrumentId,
    perPaymentAmountOriginal,
    currencyCode,
    manualFxRateToUsd,
    perPaymentAmountUsd,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'installment_plans';
  @override
  VerificationContext validateIntegrity(
    Insertable<InstallmentPlanRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('payment_count')) {
      context.handle(
        _paymentCountMeta,
        paymentCount.isAcceptableOrUnknown(
          data['payment_count']!,
          _paymentCountMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_paymentCountMeta);
    }
    if (data.containsKey('interval_months')) {
      context.handle(
        _intervalMonthsMeta,
        intervalMonths.isAcceptableOrUnknown(
          data['interval_months']!,
          _intervalMonthsMeta,
        ),
      );
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
    if (data.containsKey('payment_instrument_id')) {
      context.handle(
        _paymentInstrumentIdMeta,
        paymentInstrumentId.isAcceptableOrUnknown(
          data['payment_instrument_id']!,
          _paymentInstrumentIdMeta,
        ),
      );
    }
    if (data.containsKey('per_payment_amount_original')) {
      context.handle(
        _perPaymentAmountOriginalMeta,
        perPaymentAmountOriginal.isAcceptableOrUnknown(
          data['per_payment_amount_original']!,
          _perPaymentAmountOriginalMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_perPaymentAmountOriginalMeta);
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
    if (data.containsKey('per_payment_amount_usd')) {
      context.handle(
        _perPaymentAmountUsdMeta,
        perPaymentAmountUsd.isAcceptableOrUnknown(
          data['per_payment_amount_usd']!,
          _perPaymentAmountUsdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_perPaymentAmountUsdMeta);
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
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  InstallmentPlanRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return InstallmentPlanRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      paymentCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}payment_count'],
      )!,
      intervalMonths: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}interval_months'],
      )!,
      anchorOccurredOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_occurred_on'],
      )!,
      categoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}category_id'],
      )!,
      subcategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}subcategory_id'],
      )!,
      paymentInstrumentId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}payment_instrument_id'],
      ),
      perPaymentAmountOriginal: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}per_payment_amount_original'],
      )!,
      currencyCode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}currency_code'],
      )!,
      manualFxRateToUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}manual_fx_rate_to_usd'],
      )!,
      perPaymentAmountUsd: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}per_payment_amount_usd'],
      )!,
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $InstallmentPlansTable createAlias(String alias) {
    return $InstallmentPlansTable(attachedDatabase, alias);
  }
}

class InstallmentPlanRow extends DataClass
    implements Insertable<InstallmentPlanRow> {
  final String id;
  final int paymentCount;
  final int intervalMonths;
  final String anchorOccurredOn;
  final String categoryId;
  final String subcategoryId;
  final String? paymentInstrumentId;
  final double perPaymentAmountOriginal;
  final String currencyCode;
  final double manualFxRateToUsd;
  final double perPaymentAmountUsd;
  final String description;
  const InstallmentPlanRow({
    required this.id,
    required this.paymentCount,
    required this.intervalMonths,
    required this.anchorOccurredOn,
    required this.categoryId,
    required this.subcategoryId,
    this.paymentInstrumentId,
    required this.perPaymentAmountOriginal,
    required this.currencyCode,
    required this.manualFxRateToUsd,
    required this.perPaymentAmountUsd,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['payment_count'] = Variable<int>(paymentCount);
    map['interval_months'] = Variable<int>(intervalMonths);
    map['anchor_occurred_on'] = Variable<String>(anchorOccurredOn);
    map['category_id'] = Variable<String>(categoryId);
    map['subcategory_id'] = Variable<String>(subcategoryId);
    if (!nullToAbsent || paymentInstrumentId != null) {
      map['payment_instrument_id'] = Variable<String>(paymentInstrumentId);
    }
    map['per_payment_amount_original'] = Variable<double>(
      perPaymentAmountOriginal,
    );
    map['currency_code'] = Variable<String>(currencyCode);
    map['manual_fx_rate_to_usd'] = Variable<double>(manualFxRateToUsd);
    map['per_payment_amount_usd'] = Variable<double>(perPaymentAmountUsd);
    map['description'] = Variable<String>(description);
    return map;
  }

  InstallmentPlansCompanion toCompanion(bool nullToAbsent) {
    return InstallmentPlansCompanion(
      id: Value(id),
      paymentCount: Value(paymentCount),
      intervalMonths: Value(intervalMonths),
      anchorOccurredOn: Value(anchorOccurredOn),
      categoryId: Value(categoryId),
      subcategoryId: Value(subcategoryId),
      paymentInstrumentId: paymentInstrumentId == null && nullToAbsent
          ? const Value.absent()
          : Value(paymentInstrumentId),
      perPaymentAmountOriginal: Value(perPaymentAmountOriginal),
      currencyCode: Value(currencyCode),
      manualFxRateToUsd: Value(manualFxRateToUsd),
      perPaymentAmountUsd: Value(perPaymentAmountUsd),
      description: Value(description),
    );
  }

  factory InstallmentPlanRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return InstallmentPlanRow(
      id: serializer.fromJson<String>(json['id']),
      paymentCount: serializer.fromJson<int>(json['paymentCount']),
      intervalMonths: serializer.fromJson<int>(json['intervalMonths']),
      anchorOccurredOn: serializer.fromJson<String>(json['anchorOccurredOn']),
      categoryId: serializer.fromJson<String>(json['categoryId']),
      subcategoryId: serializer.fromJson<String>(json['subcategoryId']),
      paymentInstrumentId: serializer.fromJson<String?>(
        json['paymentInstrumentId'],
      ),
      perPaymentAmountOriginal: serializer.fromJson<double>(
        json['perPaymentAmountOriginal'],
      ),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      manualFxRateToUsd: serializer.fromJson<double>(json['manualFxRateToUsd']),
      perPaymentAmountUsd: serializer.fromJson<double>(
        json['perPaymentAmountUsd'],
      ),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'paymentCount': serializer.toJson<int>(paymentCount),
      'intervalMonths': serializer.toJson<int>(intervalMonths),
      'anchorOccurredOn': serializer.toJson<String>(anchorOccurredOn),
      'categoryId': serializer.toJson<String>(categoryId),
      'subcategoryId': serializer.toJson<String>(subcategoryId),
      'paymentInstrumentId': serializer.toJson<String?>(paymentInstrumentId),
      'perPaymentAmountOriginal': serializer.toJson<double>(
        perPaymentAmountOriginal,
      ),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'manualFxRateToUsd': serializer.toJson<double>(manualFxRateToUsd),
      'perPaymentAmountUsd': serializer.toJson<double>(perPaymentAmountUsd),
      'description': serializer.toJson<String>(description),
    };
  }

  InstallmentPlanRow copyWith({
    String? id,
    int? paymentCount,
    int? intervalMonths,
    String? anchorOccurredOn,
    String? categoryId,
    String? subcategoryId,
    Value<String?> paymentInstrumentId = const Value.absent(),
    double? perPaymentAmountOriginal,
    String? currencyCode,
    double? manualFxRateToUsd,
    double? perPaymentAmountUsd,
    String? description,
  }) => InstallmentPlanRow(
    id: id ?? this.id,
    paymentCount: paymentCount ?? this.paymentCount,
    intervalMonths: intervalMonths ?? this.intervalMonths,
    anchorOccurredOn: anchorOccurredOn ?? this.anchorOccurredOn,
    categoryId: categoryId ?? this.categoryId,
    subcategoryId: subcategoryId ?? this.subcategoryId,
    paymentInstrumentId: paymentInstrumentId.present
        ? paymentInstrumentId.value
        : this.paymentInstrumentId,
    perPaymentAmountOriginal:
        perPaymentAmountOriginal ?? this.perPaymentAmountOriginal,
    currencyCode: currencyCode ?? this.currencyCode,
    manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
    perPaymentAmountUsd: perPaymentAmountUsd ?? this.perPaymentAmountUsd,
    description: description ?? this.description,
  );
  InstallmentPlanRow copyWithCompanion(InstallmentPlansCompanion data) {
    return InstallmentPlanRow(
      id: data.id.present ? data.id.value : this.id,
      paymentCount: data.paymentCount.present
          ? data.paymentCount.value
          : this.paymentCount,
      intervalMonths: data.intervalMonths.present
          ? data.intervalMonths.value
          : this.intervalMonths,
      anchorOccurredOn: data.anchorOccurredOn.present
          ? data.anchorOccurredOn.value
          : this.anchorOccurredOn,
      categoryId: data.categoryId.present
          ? data.categoryId.value
          : this.categoryId,
      subcategoryId: data.subcategoryId.present
          ? data.subcategoryId.value
          : this.subcategoryId,
      paymentInstrumentId: data.paymentInstrumentId.present
          ? data.paymentInstrumentId.value
          : this.paymentInstrumentId,
      perPaymentAmountOriginal: data.perPaymentAmountOriginal.present
          ? data.perPaymentAmountOriginal.value
          : this.perPaymentAmountOriginal,
      currencyCode: data.currencyCode.present
          ? data.currencyCode.value
          : this.currencyCode,
      manualFxRateToUsd: data.manualFxRateToUsd.present
          ? data.manualFxRateToUsd.value
          : this.manualFxRateToUsd,
      perPaymentAmountUsd: data.perPaymentAmountUsd.present
          ? data.perPaymentAmountUsd.value
          : this.perPaymentAmountUsd,
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentPlanRow(')
          ..write('id: $id, ')
          ..write('paymentCount: $paymentCount, ')
          ..write('intervalMonths: $intervalMonths, ')
          ..write('anchorOccurredOn: $anchorOccurredOn, ')
          ..write('categoryId: $categoryId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('paymentInstrumentId: $paymentInstrumentId, ')
          ..write('perPaymentAmountOriginal: $perPaymentAmountOriginal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('manualFxRateToUsd: $manualFxRateToUsd, ')
          ..write('perPaymentAmountUsd: $perPaymentAmountUsd, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    paymentCount,
    intervalMonths,
    anchorOccurredOn,
    categoryId,
    subcategoryId,
    paymentInstrumentId,
    perPaymentAmountOriginal,
    currencyCode,
    manualFxRateToUsd,
    perPaymentAmountUsd,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is InstallmentPlanRow &&
          other.id == this.id &&
          other.paymentCount == this.paymentCount &&
          other.intervalMonths == this.intervalMonths &&
          other.anchorOccurredOn == this.anchorOccurredOn &&
          other.categoryId == this.categoryId &&
          other.subcategoryId == this.subcategoryId &&
          other.paymentInstrumentId == this.paymentInstrumentId &&
          other.perPaymentAmountOriginal == this.perPaymentAmountOriginal &&
          other.currencyCode == this.currencyCode &&
          other.manualFxRateToUsd == this.manualFxRateToUsd &&
          other.perPaymentAmountUsd == this.perPaymentAmountUsd &&
          other.description == this.description);
}

class InstallmentPlansCompanion extends UpdateCompanion<InstallmentPlanRow> {
  final Value<String> id;
  final Value<int> paymentCount;
  final Value<int> intervalMonths;
  final Value<String> anchorOccurredOn;
  final Value<String> categoryId;
  final Value<String> subcategoryId;
  final Value<String?> paymentInstrumentId;
  final Value<double> perPaymentAmountOriginal;
  final Value<String> currencyCode;
  final Value<double> manualFxRateToUsd;
  final Value<double> perPaymentAmountUsd;
  final Value<String> description;
  final Value<int> rowid;
  const InstallmentPlansCompanion({
    this.id = const Value.absent(),
    this.paymentCount = const Value.absent(),
    this.intervalMonths = const Value.absent(),
    this.anchorOccurredOn = const Value.absent(),
    this.categoryId = const Value.absent(),
    this.subcategoryId = const Value.absent(),
    this.paymentInstrumentId = const Value.absent(),
    this.perPaymentAmountOriginal = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.manualFxRateToUsd = const Value.absent(),
    this.perPaymentAmountUsd = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  InstallmentPlansCompanion.insert({
    required String id,
    required int paymentCount,
    this.intervalMonths = const Value.absent(),
    required String anchorOccurredOn,
    required String categoryId,
    required String subcategoryId,
    this.paymentInstrumentId = const Value.absent(),
    required double perPaymentAmountOriginal,
    this.currencyCode = const Value.absent(),
    this.manualFxRateToUsd = const Value.absent(),
    required double perPaymentAmountUsd,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       paymentCount = Value(paymentCount),
       anchorOccurredOn = Value(anchorOccurredOn),
       categoryId = Value(categoryId),
       subcategoryId = Value(subcategoryId),
       perPaymentAmountOriginal = Value(perPaymentAmountOriginal),
       perPaymentAmountUsd = Value(perPaymentAmountUsd);
  static Insertable<InstallmentPlanRow> custom({
    Expression<String>? id,
    Expression<int>? paymentCount,
    Expression<int>? intervalMonths,
    Expression<String>? anchorOccurredOn,
    Expression<String>? categoryId,
    Expression<String>? subcategoryId,
    Expression<String>? paymentInstrumentId,
    Expression<double>? perPaymentAmountOriginal,
    Expression<String>? currencyCode,
    Expression<double>? manualFxRateToUsd,
    Expression<double>? perPaymentAmountUsd,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (paymentCount != null) 'payment_count': paymentCount,
      if (intervalMonths != null) 'interval_months': intervalMonths,
      if (anchorOccurredOn != null) 'anchor_occurred_on': anchorOccurredOn,
      if (categoryId != null) 'category_id': categoryId,
      if (subcategoryId != null) 'subcategory_id': subcategoryId,
      if (paymentInstrumentId != null)
        'payment_instrument_id': paymentInstrumentId,
      if (perPaymentAmountOriginal != null)
        'per_payment_amount_original': perPaymentAmountOriginal,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (manualFxRateToUsd != null) 'manual_fx_rate_to_usd': manualFxRateToUsd,
      if (perPaymentAmountUsd != null)
        'per_payment_amount_usd': perPaymentAmountUsd,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  InstallmentPlansCompanion copyWith({
    Value<String>? id,
    Value<int>? paymentCount,
    Value<int>? intervalMonths,
    Value<String>? anchorOccurredOn,
    Value<String>? categoryId,
    Value<String>? subcategoryId,
    Value<String?>? paymentInstrumentId,
    Value<double>? perPaymentAmountOriginal,
    Value<String>? currencyCode,
    Value<double>? manualFxRateToUsd,
    Value<double>? perPaymentAmountUsd,
    Value<String>? description,
    Value<int>? rowid,
  }) {
    return InstallmentPlansCompanion(
      id: id ?? this.id,
      paymentCount: paymentCount ?? this.paymentCount,
      intervalMonths: intervalMonths ?? this.intervalMonths,
      anchorOccurredOn: anchorOccurredOn ?? this.anchorOccurredOn,
      categoryId: categoryId ?? this.categoryId,
      subcategoryId: subcategoryId ?? this.subcategoryId,
      paymentInstrumentId: paymentInstrumentId ?? this.paymentInstrumentId,
      perPaymentAmountOriginal:
          perPaymentAmountOriginal ?? this.perPaymentAmountOriginal,
      currencyCode: currencyCode ?? this.currencyCode,
      manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
      perPaymentAmountUsd: perPaymentAmountUsd ?? this.perPaymentAmountUsd,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (paymentCount.present) {
      map['payment_count'] = Variable<int>(paymentCount.value);
    }
    if (intervalMonths.present) {
      map['interval_months'] = Variable<int>(intervalMonths.value);
    }
    if (anchorOccurredOn.present) {
      map['anchor_occurred_on'] = Variable<String>(anchorOccurredOn.value);
    }
    if (categoryId.present) {
      map['category_id'] = Variable<String>(categoryId.value);
    }
    if (subcategoryId.present) {
      map['subcategory_id'] = Variable<String>(subcategoryId.value);
    }
    if (paymentInstrumentId.present) {
      map['payment_instrument_id'] = Variable<String>(
        paymentInstrumentId.value,
      );
    }
    if (perPaymentAmountOriginal.present) {
      map['per_payment_amount_original'] = Variable<double>(
        perPaymentAmountOriginal.value,
      );
    }
    if (currencyCode.present) {
      map['currency_code'] = Variable<String>(currencyCode.value);
    }
    if (manualFxRateToUsd.present) {
      map['manual_fx_rate_to_usd'] = Variable<double>(manualFxRateToUsd.value);
    }
    if (perPaymentAmountUsd.present) {
      map['per_payment_amount_usd'] = Variable<double>(
        perPaymentAmountUsd.value,
      );
    }
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('InstallmentPlansCompanion(')
          ..write('id: $id, ')
          ..write('paymentCount: $paymentCount, ')
          ..write('intervalMonths: $intervalMonths, ')
          ..write('anchorOccurredOn: $anchorOccurredOn, ')
          ..write('categoryId: $categoryId, ')
          ..write('subcategoryId: $subcategoryId, ')
          ..write('paymentInstrumentId: $paymentInstrumentId, ')
          ..write('perPaymentAmountOriginal: $perPaymentAmountOriginal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('manualFxRateToUsd: $manualFxRateToUsd, ')
          ..write('perPaymentAmountUsd: $perPaymentAmountUsd, ')
          ..write('description: $description, ')
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

class $IncomeRecSeriesTable extends IncomeRecSeries
    with TableInfo<$IncomeRecSeriesTable, IncomeRecurringSeriesRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeRecSeriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _anchorReceivedOnMeta = const VerificationMeta(
    'anchorReceivedOn',
  );
  @override
  late final GeneratedColumn<String> anchorReceivedOn = GeneratedColumn<String>(
    'anchor_received_on',
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
  static const VerificationMeta _incomeCategoryIdMeta = const VerificationMeta(
    'incomeCategoryId',
  );
  @override
  late final GeneratedColumn<String> incomeCategoryId = GeneratedColumn<String>(
    'income_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES income_categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _incomeSubcategoryIdMeta =
      const VerificationMeta('incomeSubcategoryId');
  @override
  late final GeneratedColumn<String> incomeSubcategoryId =
      GeneratedColumn<String>(
        'income_subcategory_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES income_subcategories (id) ON DELETE RESTRICT',
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
  @override
  List<GeneratedColumn> get $columns => [
    id,
    anchorReceivedOn,
    recurrenceJson,
    horizonMonths,
    active,
    incomeCategoryId,
    incomeSubcategoryId,
    amountOriginal,
    currencyCode,
    manualFxRateToUsd,
    amountUsd,
    description,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_recurring_series';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeRecurringSeriesRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('anchor_received_on')) {
      context.handle(
        _anchorReceivedOnMeta,
        anchorReceivedOn.isAcceptableOrUnknown(
          data['anchor_received_on']!,
          _anchorReceivedOnMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_anchorReceivedOnMeta);
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
    if (data.containsKey('income_category_id')) {
      context.handle(
        _incomeCategoryIdMeta,
        incomeCategoryId.isAcceptableOrUnknown(
          data['income_category_id']!,
          _incomeCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incomeCategoryIdMeta);
    }
    if (data.containsKey('income_subcategory_id')) {
      context.handle(
        _incomeSubcategoryIdMeta,
        incomeSubcategoryId.isAcceptableOrUnknown(
          data['income_subcategory_id']!,
          _incomeSubcategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incomeSubcategoryIdMeta);
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeRecurringSeriesRow map(
    Map<String, dynamic> data, {
    String? tablePrefix,
  }) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeRecurringSeriesRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      anchorReceivedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}anchor_received_on'],
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
      incomeCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}income_category_id'],
      )!,
      incomeSubcategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}income_subcategory_id'],
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
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
    );
  }

  @override
  $IncomeRecSeriesTable createAlias(String alias) {
    return $IncomeRecSeriesTable(attachedDatabase, alias);
  }
}

class IncomeRecurringSeriesRow extends DataClass
    implements Insertable<IncomeRecurringSeriesRow> {
  final String id;
  final String anchorReceivedOn;

  /// Recurrence payload JSON (application/recurrence_json_codec.dart v1).
  final String recurrenceJson;
  final int horizonMonths;
  final bool active;
  final String incomeCategoryId;
  final String incomeSubcategoryId;
  final double amountOriginal;
  final String currencyCode;
  final double manualFxRateToUsd;
  final double amountUsd;
  final String description;
  const IncomeRecurringSeriesRow({
    required this.id,
    required this.anchorReceivedOn,
    required this.recurrenceJson,
    required this.horizonMonths,
    required this.active,
    required this.incomeCategoryId,
    required this.incomeSubcategoryId,
    required this.amountOriginal,
    required this.currencyCode,
    required this.manualFxRateToUsd,
    required this.amountUsd,
    required this.description,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['anchor_received_on'] = Variable<String>(anchorReceivedOn);
    map['recurrence_json'] = Variable<String>(recurrenceJson);
    map['horizon_months'] = Variable<int>(horizonMonths);
    map['active'] = Variable<bool>(active);
    map['income_category_id'] = Variable<String>(incomeCategoryId);
    map['income_subcategory_id'] = Variable<String>(incomeSubcategoryId);
    map['amount_original'] = Variable<double>(amountOriginal);
    map['currency_code'] = Variable<String>(currencyCode);
    map['manual_fx_rate_to_usd'] = Variable<double>(manualFxRateToUsd);
    map['amount_usd'] = Variable<double>(amountUsd);
    map['description'] = Variable<String>(description);
    return map;
  }

  IncomeRecSeriesCompanion toCompanion(bool nullToAbsent) {
    return IncomeRecSeriesCompanion(
      id: Value(id),
      anchorReceivedOn: Value(anchorReceivedOn),
      recurrenceJson: Value(recurrenceJson),
      horizonMonths: Value(horizonMonths),
      active: Value(active),
      incomeCategoryId: Value(incomeCategoryId),
      incomeSubcategoryId: Value(incomeSubcategoryId),
      amountOriginal: Value(amountOriginal),
      currencyCode: Value(currencyCode),
      manualFxRateToUsd: Value(manualFxRateToUsd),
      amountUsd: Value(amountUsd),
      description: Value(description),
    );
  }

  factory IncomeRecurringSeriesRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeRecurringSeriesRow(
      id: serializer.fromJson<String>(json['id']),
      anchorReceivedOn: serializer.fromJson<String>(json['anchorReceivedOn']),
      recurrenceJson: serializer.fromJson<String>(json['recurrenceJson']),
      horizonMonths: serializer.fromJson<int>(json['horizonMonths']),
      active: serializer.fromJson<bool>(json['active']),
      incomeCategoryId: serializer.fromJson<String>(json['incomeCategoryId']),
      incomeSubcategoryId: serializer.fromJson<String>(
        json['incomeSubcategoryId'],
      ),
      amountOriginal: serializer.fromJson<double>(json['amountOriginal']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      manualFxRateToUsd: serializer.fromJson<double>(json['manualFxRateToUsd']),
      amountUsd: serializer.fromJson<double>(json['amountUsd']),
      description: serializer.fromJson<String>(json['description']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'anchorReceivedOn': serializer.toJson<String>(anchorReceivedOn),
      'recurrenceJson': serializer.toJson<String>(recurrenceJson),
      'horizonMonths': serializer.toJson<int>(horizonMonths),
      'active': serializer.toJson<bool>(active),
      'incomeCategoryId': serializer.toJson<String>(incomeCategoryId),
      'incomeSubcategoryId': serializer.toJson<String>(incomeSubcategoryId),
      'amountOriginal': serializer.toJson<double>(amountOriginal),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'manualFxRateToUsd': serializer.toJson<double>(manualFxRateToUsd),
      'amountUsd': serializer.toJson<double>(amountUsd),
      'description': serializer.toJson<String>(description),
    };
  }

  IncomeRecurringSeriesRow copyWith({
    String? id,
    String? anchorReceivedOn,
    String? recurrenceJson,
    int? horizonMonths,
    bool? active,
    String? incomeCategoryId,
    String? incomeSubcategoryId,
    double? amountOriginal,
    String? currencyCode,
    double? manualFxRateToUsd,
    double? amountUsd,
    String? description,
  }) => IncomeRecurringSeriesRow(
    id: id ?? this.id,
    anchorReceivedOn: anchorReceivedOn ?? this.anchorReceivedOn,
    recurrenceJson: recurrenceJson ?? this.recurrenceJson,
    horizonMonths: horizonMonths ?? this.horizonMonths,
    active: active ?? this.active,
    incomeCategoryId: incomeCategoryId ?? this.incomeCategoryId,
    incomeSubcategoryId: incomeSubcategoryId ?? this.incomeSubcategoryId,
    amountOriginal: amountOriginal ?? this.amountOriginal,
    currencyCode: currencyCode ?? this.currencyCode,
    manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
    amountUsd: amountUsd ?? this.amountUsd,
    description: description ?? this.description,
  );
  IncomeRecurringSeriesRow copyWithCompanion(IncomeRecSeriesCompanion data) {
    return IncomeRecurringSeriesRow(
      id: data.id.present ? data.id.value : this.id,
      anchorReceivedOn: data.anchorReceivedOn.present
          ? data.anchorReceivedOn.value
          : this.anchorReceivedOn,
      recurrenceJson: data.recurrenceJson.present
          ? data.recurrenceJson.value
          : this.recurrenceJson,
      horizonMonths: data.horizonMonths.present
          ? data.horizonMonths.value
          : this.horizonMonths,
      active: data.active.present ? data.active.value : this.active,
      incomeCategoryId: data.incomeCategoryId.present
          ? data.incomeCategoryId.value
          : this.incomeCategoryId,
      incomeSubcategoryId: data.incomeSubcategoryId.present
          ? data.incomeSubcategoryId.value
          : this.incomeSubcategoryId,
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
      description: data.description.present
          ? data.description.value
          : this.description,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeRecurringSeriesRow(')
          ..write('id: $id, ')
          ..write('anchorReceivedOn: $anchorReceivedOn, ')
          ..write('recurrenceJson: $recurrenceJson, ')
          ..write('horizonMonths: $horizonMonths, ')
          ..write('active: $active, ')
          ..write('incomeCategoryId: $incomeCategoryId, ')
          ..write('incomeSubcategoryId: $incomeSubcategoryId, ')
          ..write('amountOriginal: $amountOriginal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('manualFxRateToUsd: $manualFxRateToUsd, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('description: $description')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    anchorReceivedOn,
    recurrenceJson,
    horizonMonths,
    active,
    incomeCategoryId,
    incomeSubcategoryId,
    amountOriginal,
    currencyCode,
    manualFxRateToUsd,
    amountUsd,
    description,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeRecurringSeriesRow &&
          other.id == this.id &&
          other.anchorReceivedOn == this.anchorReceivedOn &&
          other.recurrenceJson == this.recurrenceJson &&
          other.horizonMonths == this.horizonMonths &&
          other.active == this.active &&
          other.incomeCategoryId == this.incomeCategoryId &&
          other.incomeSubcategoryId == this.incomeSubcategoryId &&
          other.amountOriginal == this.amountOriginal &&
          other.currencyCode == this.currencyCode &&
          other.manualFxRateToUsd == this.manualFxRateToUsd &&
          other.amountUsd == this.amountUsd &&
          other.description == this.description);
}

class IncomeRecSeriesCompanion
    extends UpdateCompanion<IncomeRecurringSeriesRow> {
  final Value<String> id;
  final Value<String> anchorReceivedOn;
  final Value<String> recurrenceJson;
  final Value<int> horizonMonths;
  final Value<bool> active;
  final Value<String> incomeCategoryId;
  final Value<String> incomeSubcategoryId;
  final Value<double> amountOriginal;
  final Value<String> currencyCode;
  final Value<double> manualFxRateToUsd;
  final Value<double> amountUsd;
  final Value<String> description;
  final Value<int> rowid;
  const IncomeRecSeriesCompanion({
    this.id = const Value.absent(),
    this.anchorReceivedOn = const Value.absent(),
    this.recurrenceJson = const Value.absent(),
    this.horizonMonths = const Value.absent(),
    this.active = const Value.absent(),
    this.incomeCategoryId = const Value.absent(),
    this.incomeSubcategoryId = const Value.absent(),
    this.amountOriginal = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.manualFxRateToUsd = const Value.absent(),
    this.amountUsd = const Value.absent(),
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeRecSeriesCompanion.insert({
    required String id,
    required String anchorReceivedOn,
    required String recurrenceJson,
    required int horizonMonths,
    this.active = const Value.absent(),
    required String incomeCategoryId,
    required String incomeSubcategoryId,
    required double amountOriginal,
    this.currencyCode = const Value.absent(),
    this.manualFxRateToUsd = const Value.absent(),
    required double amountUsd,
    this.description = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       anchorReceivedOn = Value(anchorReceivedOn),
       recurrenceJson = Value(recurrenceJson),
       horizonMonths = Value(horizonMonths),
       incomeCategoryId = Value(incomeCategoryId),
       incomeSubcategoryId = Value(incomeSubcategoryId),
       amountOriginal = Value(amountOriginal),
       amountUsd = Value(amountUsd);
  static Insertable<IncomeRecurringSeriesRow> custom({
    Expression<String>? id,
    Expression<String>? anchorReceivedOn,
    Expression<String>? recurrenceJson,
    Expression<int>? horizonMonths,
    Expression<bool>? active,
    Expression<String>? incomeCategoryId,
    Expression<String>? incomeSubcategoryId,
    Expression<double>? amountOriginal,
    Expression<String>? currencyCode,
    Expression<double>? manualFxRateToUsd,
    Expression<double>? amountUsd,
    Expression<String>? description,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (anchorReceivedOn != null) 'anchor_received_on': anchorReceivedOn,
      if (recurrenceJson != null) 'recurrence_json': recurrenceJson,
      if (horizonMonths != null) 'horizon_months': horizonMonths,
      if (active != null) 'active': active,
      if (incomeCategoryId != null) 'income_category_id': incomeCategoryId,
      if (incomeSubcategoryId != null)
        'income_subcategory_id': incomeSubcategoryId,
      if (amountOriginal != null) 'amount_original': amountOriginal,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (manualFxRateToUsd != null) 'manual_fx_rate_to_usd': manualFxRateToUsd,
      if (amountUsd != null) 'amount_usd': amountUsd,
      if (description != null) 'description': description,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeRecSeriesCompanion copyWith({
    Value<String>? id,
    Value<String>? anchorReceivedOn,
    Value<String>? recurrenceJson,
    Value<int>? horizonMonths,
    Value<bool>? active,
    Value<String>? incomeCategoryId,
    Value<String>? incomeSubcategoryId,
    Value<double>? amountOriginal,
    Value<String>? currencyCode,
    Value<double>? manualFxRateToUsd,
    Value<double>? amountUsd,
    Value<String>? description,
    Value<int>? rowid,
  }) {
    return IncomeRecSeriesCompanion(
      id: id ?? this.id,
      anchorReceivedOn: anchorReceivedOn ?? this.anchorReceivedOn,
      recurrenceJson: recurrenceJson ?? this.recurrenceJson,
      horizonMonths: horizonMonths ?? this.horizonMonths,
      active: active ?? this.active,
      incomeCategoryId: incomeCategoryId ?? this.incomeCategoryId,
      incomeSubcategoryId: incomeSubcategoryId ?? this.incomeSubcategoryId,
      amountOriginal: amountOriginal ?? this.amountOriginal,
      currencyCode: currencyCode ?? this.currencyCode,
      manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
      amountUsd: amountUsd ?? this.amountUsd,
      description: description ?? this.description,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (anchorReceivedOn.present) {
      map['anchor_received_on'] = Variable<String>(anchorReceivedOn.value);
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
    if (incomeCategoryId.present) {
      map['income_category_id'] = Variable<String>(incomeCategoryId.value);
    }
    if (incomeSubcategoryId.present) {
      map['income_subcategory_id'] = Variable<String>(
        incomeSubcategoryId.value,
      );
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeRecSeriesCompanion(')
          ..write('id: $id, ')
          ..write('anchorReceivedOn: $anchorReceivedOn, ')
          ..write('recurrenceJson: $recurrenceJson, ')
          ..write('horizonMonths: $horizonMonths, ')
          ..write('active: $active, ')
          ..write('incomeCategoryId: $incomeCategoryId, ')
          ..write('incomeSubcategoryId: $incomeSubcategoryId, ')
          ..write('amountOriginal: $amountOriginal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('manualFxRateToUsd: $manualFxRateToUsd, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('description: $description, ')
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
  static const VerificationMeta _installmentPlanIdMeta = const VerificationMeta(
    'installmentPlanId',
  );
  @override
  late final GeneratedColumn<String> installmentPlanId =
      GeneratedColumn<String>(
        'installment_plan_id',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES installment_plans (id) ON DELETE SET NULL',
        ),
      );
  static const VerificationMeta _installmentIndexMeta = const VerificationMeta(
    'installmentIndex',
  );
  @override
  late final GeneratedColumn<int> installmentIndex = GeneratedColumn<int>(
    'installment_index',
    aliasedName,
    true,
    type: DriftSqlType.int,
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
    installmentPlanId,
    installmentIndex,
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
    if (data.containsKey('installment_plan_id')) {
      context.handle(
        _installmentPlanIdMeta,
        installmentPlanId.isAcceptableOrUnknown(
          data['installment_plan_id']!,
          _installmentPlanIdMeta,
        ),
      );
    }
    if (data.containsKey('installment_index')) {
      context.handle(
        _installmentIndexMeta,
        installmentIndex.isAcceptableOrUnknown(
          data['installment_index']!,
          _installmentIndexMeta,
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
      installmentPlanId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}installment_plan_id'],
      ),
      installmentIndex: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}installment_index'],
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
  final String? installmentPlanId;
  final int? installmentIndex;
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
    this.installmentPlanId,
    this.installmentIndex,
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
    if (!nullToAbsent || installmentPlanId != null) {
      map['installment_plan_id'] = Variable<String>(installmentPlanId);
    }
    if (!nullToAbsent || installmentIndex != null) {
      map['installment_index'] = Variable<int>(installmentIndex);
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
      installmentPlanId: installmentPlanId == null && nullToAbsent
          ? const Value.absent()
          : Value(installmentPlanId),
      installmentIndex: installmentIndex == null && nullToAbsent
          ? const Value.absent()
          : Value(installmentIndex),
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
      installmentPlanId: serializer.fromJson<String?>(
        json['installmentPlanId'],
      ),
      installmentIndex: serializer.fromJson<int?>(json['installmentIndex']),
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
      'installmentPlanId': serializer.toJson<String?>(installmentPlanId),
      'installmentIndex': serializer.toJson<int?>(installmentIndex),
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
    Value<String?> installmentPlanId = const Value.absent(),
    Value<int?> installmentIndex = const Value.absent(),
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
    installmentPlanId: installmentPlanId.present
        ? installmentPlanId.value
        : this.installmentPlanId,
    installmentIndex: installmentIndex.present
        ? installmentIndex.value
        : this.installmentIndex,
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
      installmentPlanId: data.installmentPlanId.present
          ? data.installmentPlanId.value
          : this.installmentPlanId,
      installmentIndex: data.installmentIndex.present
          ? data.installmentIndex.value
          : this.installmentIndex,
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
            'paymentExpectationConfirmedOn: $paymentExpectationConfirmedOn, ',
          )
          ..write('installmentPlanId: $installmentPlanId, ')
          ..write('installmentIndex: $installmentIndex')
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
    installmentPlanId,
    installmentIndex,
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
              this.paymentExpectationConfirmedOn &&
          other.installmentPlanId == this.installmentPlanId &&
          other.installmentIndex == this.installmentIndex);
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
  final Value<String?> installmentPlanId;
  final Value<int?> installmentIndex;
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
    this.installmentPlanId = const Value.absent(),
    this.installmentIndex = const Value.absent(),
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
    this.installmentPlanId = const Value.absent(),
    this.installmentIndex = const Value.absent(),
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
    Expression<String>? installmentPlanId,
    Expression<int>? installmentIndex,
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
      if (installmentPlanId != null) 'installment_plan_id': installmentPlanId,
      if (installmentIndex != null) 'installment_index': installmentIndex,
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
    Value<String?>? installmentPlanId,
    Value<int?>? installmentIndex,
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
      installmentPlanId: installmentPlanId ?? this.installmentPlanId,
      installmentIndex: installmentIndex ?? this.installmentIndex,
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
    if (installmentPlanId.present) {
      map['installment_plan_id'] = Variable<String>(installmentPlanId.value);
    }
    if (installmentIndex.present) {
      map['installment_index'] = Variable<int>(installmentIndex.value);
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
          ..write('installmentPlanId: $installmentPlanId, ')
          ..write('installmentIndex: $installmentIndex, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $IncomeEntriesTable extends IncomeEntries
    with TableInfo<$IncomeEntriesTable, IncomeEntryRow> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $IncomeEntriesTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _receivedOnMeta = const VerificationMeta(
    'receivedOn',
  );
  @override
  late final GeneratedColumn<String> receivedOn = GeneratedColumn<String>(
    'received_on',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _incomeCategoryIdMeta = const VerificationMeta(
    'incomeCategoryId',
  );
  @override
  late final GeneratedColumn<String> incomeCategoryId = GeneratedColumn<String>(
    'income_category_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'REFERENCES income_categories (id) ON DELETE RESTRICT',
    ),
  );
  static const VerificationMeta _incomeSubcategoryIdMeta =
      const VerificationMeta('incomeSubcategoryId');
  @override
  late final GeneratedColumn<String> incomeSubcategoryId =
      GeneratedColumn<String>(
        'income_subcategory_id',
        aliasedName,
        false,
        type: DriftSqlType.string,
        requiredDuringInsert: true,
        defaultConstraints: GeneratedColumn.constraintIsAlways(
          'REFERENCES income_subcategories (id) ON DELETE RESTRICT',
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
          'REFERENCES income_recurring_series (id) ON DELETE CASCADE',
        ),
      );
  static const VerificationMeta _expectationStatusMeta = const VerificationMeta(
    'expectationStatus',
  );
  @override
  late final GeneratedColumn<String> expectationStatus =
      GeneratedColumn<String>(
        'expectation_status',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  static const VerificationMeta _expectationConfirmedOnMeta =
      const VerificationMeta('expectationConfirmedOn');
  @override
  late final GeneratedColumn<String> expectationConfirmedOn =
      GeneratedColumn<String>(
        'expectation_confirmed_on',
        aliasedName,
        true,
        type: DriftSqlType.string,
        requiredDuringInsert: false,
      );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    receivedOn,
    incomeCategoryId,
    incomeSubcategoryId,
    amountOriginal,
    currencyCode,
    manualFxRateToUsd,
    amountUsd,
    description,
    recurringSeriesId,
    expectationStatus,
    expectationConfirmedOn,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'income_entries';
  @override
  VerificationContext validateIntegrity(
    Insertable<IncomeEntryRow> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('received_on')) {
      context.handle(
        _receivedOnMeta,
        receivedOn.isAcceptableOrUnknown(data['received_on']!, _receivedOnMeta),
      );
    } else if (isInserting) {
      context.missing(_receivedOnMeta);
    }
    if (data.containsKey('income_category_id')) {
      context.handle(
        _incomeCategoryIdMeta,
        incomeCategoryId.isAcceptableOrUnknown(
          data['income_category_id']!,
          _incomeCategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incomeCategoryIdMeta);
    }
    if (data.containsKey('income_subcategory_id')) {
      context.handle(
        _incomeSubcategoryIdMeta,
        incomeSubcategoryId.isAcceptableOrUnknown(
          data['income_subcategory_id']!,
          _incomeSubcategoryIdMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_incomeSubcategoryIdMeta);
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
    if (data.containsKey('description')) {
      context.handle(
        _descriptionMeta,
        description.isAcceptableOrUnknown(
          data['description']!,
          _descriptionMeta,
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
    if (data.containsKey('expectation_status')) {
      context.handle(
        _expectationStatusMeta,
        expectationStatus.isAcceptableOrUnknown(
          data['expectation_status']!,
          _expectationStatusMeta,
        ),
      );
    }
    if (data.containsKey('expectation_confirmed_on')) {
      context.handle(
        _expectationConfirmedOnMeta,
        expectationConfirmedOn.isAcceptableOrUnknown(
          data['expectation_confirmed_on']!,
          _expectationConfirmedOnMeta,
        ),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  IncomeEntryRow map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return IncomeEntryRow(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      receivedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}received_on'],
      )!,
      incomeCategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}income_category_id'],
      )!,
      incomeSubcategoryId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}income_subcategory_id'],
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
      description: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}description'],
      )!,
      recurringSeriesId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}recurring_series_id'],
      ),
      expectationStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expectation_status'],
      ),
      expectationConfirmedOn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}expectation_confirmed_on'],
      ),
    );
  }

  @override
  $IncomeEntriesTable createAlias(String alias) {
    return $IncomeEntriesTable(attachedDatabase, alias);
  }
}

class IncomeEntryRow extends DataClass implements Insertable<IncomeEntryRow> {
  final String id;
  final String receivedOn;
  final String incomeCategoryId;
  final String incomeSubcategoryId;
  final double amountOriginal;
  final String currencyCode;
  final double manualFxRateToUsd;
  final double amountUsd;
  final String description;
  final String? recurringSeriesId;
  final String? expectationStatus;
  final String? expectationConfirmedOn;
  const IncomeEntryRow({
    required this.id,
    required this.receivedOn,
    required this.incomeCategoryId,
    required this.incomeSubcategoryId,
    required this.amountOriginal,
    required this.currencyCode,
    required this.manualFxRateToUsd,
    required this.amountUsd,
    required this.description,
    this.recurringSeriesId,
    this.expectationStatus,
    this.expectationConfirmedOn,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['received_on'] = Variable<String>(receivedOn);
    map['income_category_id'] = Variable<String>(incomeCategoryId);
    map['income_subcategory_id'] = Variable<String>(incomeSubcategoryId);
    map['amount_original'] = Variable<double>(amountOriginal);
    map['currency_code'] = Variable<String>(currencyCode);
    map['manual_fx_rate_to_usd'] = Variable<double>(manualFxRateToUsd);
    map['amount_usd'] = Variable<double>(amountUsd);
    map['description'] = Variable<String>(description);
    if (!nullToAbsent || recurringSeriesId != null) {
      map['recurring_series_id'] = Variable<String>(recurringSeriesId);
    }
    if (!nullToAbsent || expectationStatus != null) {
      map['expectation_status'] = Variable<String>(expectationStatus);
    }
    if (!nullToAbsent || expectationConfirmedOn != null) {
      map['expectation_confirmed_on'] = Variable<String>(
        expectationConfirmedOn,
      );
    }
    return map;
  }

  IncomeEntriesCompanion toCompanion(bool nullToAbsent) {
    return IncomeEntriesCompanion(
      id: Value(id),
      receivedOn: Value(receivedOn),
      incomeCategoryId: Value(incomeCategoryId),
      incomeSubcategoryId: Value(incomeSubcategoryId),
      amountOriginal: Value(amountOriginal),
      currencyCode: Value(currencyCode),
      manualFxRateToUsd: Value(manualFxRateToUsd),
      amountUsd: Value(amountUsd),
      description: Value(description),
      recurringSeriesId: recurringSeriesId == null && nullToAbsent
          ? const Value.absent()
          : Value(recurringSeriesId),
      expectationStatus: expectationStatus == null && nullToAbsent
          ? const Value.absent()
          : Value(expectationStatus),
      expectationConfirmedOn: expectationConfirmedOn == null && nullToAbsent
          ? const Value.absent()
          : Value(expectationConfirmedOn),
    );
  }

  factory IncomeEntryRow.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return IncomeEntryRow(
      id: serializer.fromJson<String>(json['id']),
      receivedOn: serializer.fromJson<String>(json['receivedOn']),
      incomeCategoryId: serializer.fromJson<String>(json['incomeCategoryId']),
      incomeSubcategoryId: serializer.fromJson<String>(
        json['incomeSubcategoryId'],
      ),
      amountOriginal: serializer.fromJson<double>(json['amountOriginal']),
      currencyCode: serializer.fromJson<String>(json['currencyCode']),
      manualFxRateToUsd: serializer.fromJson<double>(json['manualFxRateToUsd']),
      amountUsd: serializer.fromJson<double>(json['amountUsd']),
      description: serializer.fromJson<String>(json['description']),
      recurringSeriesId: serializer.fromJson<String?>(
        json['recurringSeriesId'],
      ),
      expectationStatus: serializer.fromJson<String?>(
        json['expectationStatus'],
      ),
      expectationConfirmedOn: serializer.fromJson<String?>(
        json['expectationConfirmedOn'],
      ),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'receivedOn': serializer.toJson<String>(receivedOn),
      'incomeCategoryId': serializer.toJson<String>(incomeCategoryId),
      'incomeSubcategoryId': serializer.toJson<String>(incomeSubcategoryId),
      'amountOriginal': serializer.toJson<double>(amountOriginal),
      'currencyCode': serializer.toJson<String>(currencyCode),
      'manualFxRateToUsd': serializer.toJson<double>(manualFxRateToUsd),
      'amountUsd': serializer.toJson<double>(amountUsd),
      'description': serializer.toJson<String>(description),
      'recurringSeriesId': serializer.toJson<String?>(recurringSeriesId),
      'expectationStatus': serializer.toJson<String?>(expectationStatus),
      'expectationConfirmedOn': serializer.toJson<String?>(
        expectationConfirmedOn,
      ),
    };
  }

  IncomeEntryRow copyWith({
    String? id,
    String? receivedOn,
    String? incomeCategoryId,
    String? incomeSubcategoryId,
    double? amountOriginal,
    String? currencyCode,
    double? manualFxRateToUsd,
    double? amountUsd,
    String? description,
    Value<String?> recurringSeriesId = const Value.absent(),
    Value<String?> expectationStatus = const Value.absent(),
    Value<String?> expectationConfirmedOn = const Value.absent(),
  }) => IncomeEntryRow(
    id: id ?? this.id,
    receivedOn: receivedOn ?? this.receivedOn,
    incomeCategoryId: incomeCategoryId ?? this.incomeCategoryId,
    incomeSubcategoryId: incomeSubcategoryId ?? this.incomeSubcategoryId,
    amountOriginal: amountOriginal ?? this.amountOriginal,
    currencyCode: currencyCode ?? this.currencyCode,
    manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
    amountUsd: amountUsd ?? this.amountUsd,
    description: description ?? this.description,
    recurringSeriesId: recurringSeriesId.present
        ? recurringSeriesId.value
        : this.recurringSeriesId,
    expectationStatus: expectationStatus.present
        ? expectationStatus.value
        : this.expectationStatus,
    expectationConfirmedOn: expectationConfirmedOn.present
        ? expectationConfirmedOn.value
        : this.expectationConfirmedOn,
  );
  IncomeEntryRow copyWithCompanion(IncomeEntriesCompanion data) {
    return IncomeEntryRow(
      id: data.id.present ? data.id.value : this.id,
      receivedOn: data.receivedOn.present
          ? data.receivedOn.value
          : this.receivedOn,
      incomeCategoryId: data.incomeCategoryId.present
          ? data.incomeCategoryId.value
          : this.incomeCategoryId,
      incomeSubcategoryId: data.incomeSubcategoryId.present
          ? data.incomeSubcategoryId.value
          : this.incomeSubcategoryId,
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
      description: data.description.present
          ? data.description.value
          : this.description,
      recurringSeriesId: data.recurringSeriesId.present
          ? data.recurringSeriesId.value
          : this.recurringSeriesId,
      expectationStatus: data.expectationStatus.present
          ? data.expectationStatus.value
          : this.expectationStatus,
      expectationConfirmedOn: data.expectationConfirmedOn.present
          ? data.expectationConfirmedOn.value
          : this.expectationConfirmedOn,
    );
  }

  @override
  String toString() {
    return (StringBuffer('IncomeEntryRow(')
          ..write('id: $id, ')
          ..write('receivedOn: $receivedOn, ')
          ..write('incomeCategoryId: $incomeCategoryId, ')
          ..write('incomeSubcategoryId: $incomeSubcategoryId, ')
          ..write('amountOriginal: $amountOriginal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('manualFxRateToUsd: $manualFxRateToUsd, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('description: $description, ')
          ..write('recurringSeriesId: $recurringSeriesId, ')
          ..write('expectationStatus: $expectationStatus, ')
          ..write('expectationConfirmedOn: $expectationConfirmedOn')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    receivedOn,
    incomeCategoryId,
    incomeSubcategoryId,
    amountOriginal,
    currencyCode,
    manualFxRateToUsd,
    amountUsd,
    description,
    recurringSeriesId,
    expectationStatus,
    expectationConfirmedOn,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is IncomeEntryRow &&
          other.id == this.id &&
          other.receivedOn == this.receivedOn &&
          other.incomeCategoryId == this.incomeCategoryId &&
          other.incomeSubcategoryId == this.incomeSubcategoryId &&
          other.amountOriginal == this.amountOriginal &&
          other.currencyCode == this.currencyCode &&
          other.manualFxRateToUsd == this.manualFxRateToUsd &&
          other.amountUsd == this.amountUsd &&
          other.description == this.description &&
          other.recurringSeriesId == this.recurringSeriesId &&
          other.expectationStatus == this.expectationStatus &&
          other.expectationConfirmedOn == this.expectationConfirmedOn);
}

class IncomeEntriesCompanion extends UpdateCompanion<IncomeEntryRow> {
  final Value<String> id;
  final Value<String> receivedOn;
  final Value<String> incomeCategoryId;
  final Value<String> incomeSubcategoryId;
  final Value<double> amountOriginal;
  final Value<String> currencyCode;
  final Value<double> manualFxRateToUsd;
  final Value<double> amountUsd;
  final Value<String> description;
  final Value<String?> recurringSeriesId;
  final Value<String?> expectationStatus;
  final Value<String?> expectationConfirmedOn;
  final Value<int> rowid;
  const IncomeEntriesCompanion({
    this.id = const Value.absent(),
    this.receivedOn = const Value.absent(),
    this.incomeCategoryId = const Value.absent(),
    this.incomeSubcategoryId = const Value.absent(),
    this.amountOriginal = const Value.absent(),
    this.currencyCode = const Value.absent(),
    this.manualFxRateToUsd = const Value.absent(),
    this.amountUsd = const Value.absent(),
    this.description = const Value.absent(),
    this.recurringSeriesId = const Value.absent(),
    this.expectationStatus = const Value.absent(),
    this.expectationConfirmedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  IncomeEntriesCompanion.insert({
    required String id,
    required String receivedOn,
    required String incomeCategoryId,
    required String incomeSubcategoryId,
    required double amountOriginal,
    this.currencyCode = const Value.absent(),
    this.manualFxRateToUsd = const Value.absent(),
    required double amountUsd,
    this.description = const Value.absent(),
    this.recurringSeriesId = const Value.absent(),
    this.expectationStatus = const Value.absent(),
    this.expectationConfirmedOn = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       receivedOn = Value(receivedOn),
       incomeCategoryId = Value(incomeCategoryId),
       incomeSubcategoryId = Value(incomeSubcategoryId),
       amountOriginal = Value(amountOriginal),
       amountUsd = Value(amountUsd);
  static Insertable<IncomeEntryRow> custom({
    Expression<String>? id,
    Expression<String>? receivedOn,
    Expression<String>? incomeCategoryId,
    Expression<String>? incomeSubcategoryId,
    Expression<double>? amountOriginal,
    Expression<String>? currencyCode,
    Expression<double>? manualFxRateToUsd,
    Expression<double>? amountUsd,
    Expression<String>? description,
    Expression<String>? recurringSeriesId,
    Expression<String>? expectationStatus,
    Expression<String>? expectationConfirmedOn,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (receivedOn != null) 'received_on': receivedOn,
      if (incomeCategoryId != null) 'income_category_id': incomeCategoryId,
      if (incomeSubcategoryId != null)
        'income_subcategory_id': incomeSubcategoryId,
      if (amountOriginal != null) 'amount_original': amountOriginal,
      if (currencyCode != null) 'currency_code': currencyCode,
      if (manualFxRateToUsd != null) 'manual_fx_rate_to_usd': manualFxRateToUsd,
      if (amountUsd != null) 'amount_usd': amountUsd,
      if (description != null) 'description': description,
      if (recurringSeriesId != null) 'recurring_series_id': recurringSeriesId,
      if (expectationStatus != null) 'expectation_status': expectationStatus,
      if (expectationConfirmedOn != null)
        'expectation_confirmed_on': expectationConfirmedOn,
      if (rowid != null) 'rowid': rowid,
    });
  }

  IncomeEntriesCompanion copyWith({
    Value<String>? id,
    Value<String>? receivedOn,
    Value<String>? incomeCategoryId,
    Value<String>? incomeSubcategoryId,
    Value<double>? amountOriginal,
    Value<String>? currencyCode,
    Value<double>? manualFxRateToUsd,
    Value<double>? amountUsd,
    Value<String>? description,
    Value<String?>? recurringSeriesId,
    Value<String?>? expectationStatus,
    Value<String?>? expectationConfirmedOn,
    Value<int>? rowid,
  }) {
    return IncomeEntriesCompanion(
      id: id ?? this.id,
      receivedOn: receivedOn ?? this.receivedOn,
      incomeCategoryId: incomeCategoryId ?? this.incomeCategoryId,
      incomeSubcategoryId: incomeSubcategoryId ?? this.incomeSubcategoryId,
      amountOriginal: amountOriginal ?? this.amountOriginal,
      currencyCode: currencyCode ?? this.currencyCode,
      manualFxRateToUsd: manualFxRateToUsd ?? this.manualFxRateToUsd,
      amountUsd: amountUsd ?? this.amountUsd,
      description: description ?? this.description,
      recurringSeriesId: recurringSeriesId ?? this.recurringSeriesId,
      expectationStatus: expectationStatus ?? this.expectationStatus,
      expectationConfirmedOn:
          expectationConfirmedOn ?? this.expectationConfirmedOn,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (receivedOn.present) {
      map['received_on'] = Variable<String>(receivedOn.value);
    }
    if (incomeCategoryId.present) {
      map['income_category_id'] = Variable<String>(incomeCategoryId.value);
    }
    if (incomeSubcategoryId.present) {
      map['income_subcategory_id'] = Variable<String>(
        incomeSubcategoryId.value,
      );
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
    if (description.present) {
      map['description'] = Variable<String>(description.value);
    }
    if (recurringSeriesId.present) {
      map['recurring_series_id'] = Variable<String>(recurringSeriesId.value);
    }
    if (expectationStatus.present) {
      map['expectation_status'] = Variable<String>(expectationStatus.value);
    }
    if (expectationConfirmedOn.present) {
      map['expectation_confirmed_on'] = Variable<String>(
        expectationConfirmedOn.value,
      );
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('IncomeEntriesCompanion(')
          ..write('id: $id, ')
          ..write('receivedOn: $receivedOn, ')
          ..write('incomeCategoryId: $incomeCategoryId, ')
          ..write('incomeSubcategoryId: $incomeSubcategoryId, ')
          ..write('amountOriginal: $amountOriginal, ')
          ..write('currencyCode: $currencyCode, ')
          ..write('manualFxRateToUsd: $manualFxRateToUsd, ')
          ..write('amountUsd: $amountUsd, ')
          ..write('description: $description, ')
          ..write('recurringSeriesId: $recurringSeriesId, ')
          ..write('expectationStatus: $expectationStatus, ')
          ..write('expectationConfirmedOn: $expectationConfirmedOn, ')
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
  late final $IncomeCategoriesTable incomeCategories = $IncomeCategoriesTable(
    this,
  );
  late final $IncomeSubcategoriesTable incomeSubcategories =
      $IncomeSubcategoriesTable(this);
  late final $PaymentInstrumentsTable paymentInstruments =
      $PaymentInstrumentsTable(this);
  late final $InstallmentPlansTable installmentPlans = $InstallmentPlansTable(
    this,
  );
  late final $RecExpenseSeriesTable recExpenseSeries = $RecExpenseSeriesTable(
    this,
  );
  late final $IncomeRecSeriesTable incomeRecSeries = $IncomeRecSeriesTable(
    this,
  );
  late final $ExpensesTable expenses = $ExpensesTable(this);
  late final $IncomeEntriesTable incomeEntries = $IncomeEntriesTable(this);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    categories,
    subcategories,
    incomeCategories,
    incomeSubcategories,
    paymentInstruments,
    installmentPlans,
    recExpenseSeries,
    incomeRecSeries,
    expenses,
    incomeEntries,
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
        'income_categories',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('income_subcategories', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'payment_instruments',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('installment_plans', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'expense_recurring_series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.delete)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'installment_plans',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('expenses', kind: UpdateKind.update)],
    ),
    WritePropagation(
      on: TableUpdateQuery.onTableName(
        'income_recurring_series',
        limitUpdateKind: UpdateKind.delete,
      ),
      result: [TableUpdate('income_entries', kind: UpdateKind.delete)],
    ),
  ]);
}

typedef $$CategoriesTableCreateCompanionBuilder =
    CategoriesCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$CategoriesTableUpdateCompanionBuilder =
    CategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
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

  static MultiTypedResultKey<$InstallmentPlansTable, List<InstallmentPlanRow>>
  _installmentPlansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.installmentPlans,
    aliasName: $_aliasNameGenerator(
      db.categories.id,
      db.installmentPlans.categoryId,
    ),
  );

  $$InstallmentPlansTableProcessedTableManager get installmentPlansRefs {
    final manager = $$InstallmentPlansTableTableManager(
      $_db,
      $_db.installmentPlans,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _installmentPlansRefsTable($_db),
    );
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

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  Expression<bool> installmentPlansRefs(
    Expression<bool> Function($$InstallmentPlansTableFilterComposer f) f,
  ) {
    final $$InstallmentPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.installmentPlans,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentPlansTableFilterComposer(
            $db: $db,
            $table: $db.installmentPlans,
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

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

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

  Expression<T> installmentPlansRefs<T extends Object>(
    Expression<T> Function($$InstallmentPlansTableAnnotationComposer a) f,
  ) {
    final $$InstallmentPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.installmentPlans,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.installmentPlans,
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
            bool installmentPlansRefs,
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
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => CategoriesCompanion.insert(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
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
                installmentPlansRefs = false,
                recExpenseSeriesRefs = false,
                expensesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (subcategoriesRefs) db.subcategories,
                    if (installmentPlansRefs) db.installmentPlans,
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
                      if (installmentPlansRefs)
                        await $_getPrefetchedData<
                          CategoryRow,
                          $CategoriesTable,
                          InstallmentPlanRow
                        >(
                          currentTable: table,
                          referencedTable: $$CategoriesTableReferences
                              ._installmentPlansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$CategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).installmentPlansRefs,
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
        bool installmentPlansRefs,
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
      Value<bool> isActive,
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
      Value<bool> isActive,
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

  static MultiTypedResultKey<$InstallmentPlansTable, List<InstallmentPlanRow>>
  _installmentPlansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.installmentPlans,
    aliasName: $_aliasNameGenerator(
      db.subcategories.id,
      db.installmentPlans.subcategoryId,
    ),
  );

  $$InstallmentPlansTableProcessedTableManager get installmentPlansRefs {
    final manager = $$InstallmentPlansTableTableManager(
      $_db,
      $_db.installmentPlans,
    ).filter((f) => f.subcategoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _installmentPlansRefsTable($_db),
    );
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

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  Expression<bool> installmentPlansRefs(
    Expression<bool> Function($$InstallmentPlansTableFilterComposer f) f,
  ) {
    final $$InstallmentPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.installmentPlans,
      getReferencedColumn: (t) => t.subcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentPlansTableFilterComposer(
            $db: $db,
            $table: $db.installmentPlans,
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

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
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

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

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

  Expression<T> installmentPlansRefs<T extends Object>(
    Expression<T> Function($$InstallmentPlansTableAnnotationComposer a) f,
  ) {
    final $$InstallmentPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.installmentPlans,
      getReferencedColumn: (t) => t.subcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.installmentPlans,
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
            bool installmentPlansRefs,
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
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubcategoriesCompanion(
                id: id,
                categoryId: categoryId,
                name: name,
                description: description,
                slug: slug,
                isSystemReserved: isSystemReserved,
                sortOrder: sortOrder,
                isActive: isActive,
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
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SubcategoriesCompanion.insert(
                id: id,
                categoryId: categoryId,
                name: name,
                description: description,
                slug: slug,
                isSystemReserved: isSystemReserved,
                sortOrder: sortOrder,
                isActive: isActive,
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
                installmentPlansRefs = false,
                recExpenseSeriesRefs = false,
                expensesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (installmentPlansRefs) db.installmentPlans,
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
                      if (installmentPlansRefs)
                        await $_getPrefetchedData<
                          SubcategoryRow,
                          $SubcategoriesTable,
                          InstallmentPlanRow
                        >(
                          currentTable: table,
                          referencedTable: $$SubcategoriesTableReferences
                              ._installmentPlansRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$SubcategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).installmentPlansRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.subcategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
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
        bool installmentPlansRefs,
        bool recExpenseSeriesRefs,
        bool expensesRefs,
      })
    >;
typedef $$IncomeCategoriesTableCreateCompanionBuilder =
    IncomeCategoriesCompanion Function({
      required String id,
      required String name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$IncomeCategoriesTableUpdateCompanionBuilder =
    IncomeCategoriesCompanion Function({
      Value<String> id,
      Value<String> name,
      Value<String?> description,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$IncomeCategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IncomeCategoriesTable,
          IncomeCategoryRow
        > {
  $$IncomeCategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<
    $IncomeSubcategoriesTable,
    List<IncomeSubcategoryRow>
  >
  _incomeSubcategoriesRefsTable(_$AppDatabase db) =>
      MultiTypedResultKey.fromTable(
        db.incomeSubcategories,
        aliasName: $_aliasNameGenerator(
          db.incomeCategories.id,
          db.incomeSubcategories.categoryId,
        ),
      );

  $$IncomeSubcategoriesTableProcessedTableManager get incomeSubcategoriesRefs {
    final manager = $$IncomeSubcategoriesTableTableManager(
      $_db,
      $_db.incomeSubcategories,
    ).filter((f) => f.categoryId.id.sqlEquals($_itemColumn<String>('id')!));

    final cache = $_typedResult.readTableOrNull(
      _incomeSubcategoriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<
    $IncomeRecSeriesTable,
    List<IncomeRecurringSeriesRow>
  >
  _incomeRecSeriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeRecSeries,
    aliasName: $_aliasNameGenerator(
      db.incomeCategories.id,
      db.incomeRecSeries.incomeCategoryId,
    ),
  );

  $$IncomeRecSeriesTableProcessedTableManager get incomeRecSeriesRefs {
    final manager =
        $$IncomeRecSeriesTableTableManager($_db, $_db.incomeRecSeries).filter(
          (f) => f.incomeCategoryId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _incomeRecSeriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IncomeEntriesTable, List<IncomeEntryRow>>
  _incomeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeEntries,
    aliasName: $_aliasNameGenerator(
      db.incomeCategories.id,
      db.incomeEntries.incomeCategoryId,
    ),
  );

  $$IncomeEntriesTableProcessedTableManager get incomeEntriesRefs {
    final manager = $$IncomeEntriesTableTableManager($_db, $_db.incomeEntries)
        .filter(
          (f) => f.incomeCategoryId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_incomeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IncomeCategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeCategoriesTable> {
  $$IncomeCategoriesTableFilterComposer({
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

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> incomeSubcategoriesRefs(
    Expression<bool> Function($$IncomeSubcategoriesTableFilterComposer f) f,
  ) {
    final $$IncomeSubcategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeSubcategories,
      getReferencedColumn: (t) => t.categoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeSubcategoriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeSubcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomeRecSeriesRefs(
    Expression<bool> Function($$IncomeRecSeriesTableFilterComposer f) f,
  ) {
    final $$IncomeRecSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeRecSeries,
      getReferencedColumn: (t) => t.incomeCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeRecSeriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeRecSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomeEntriesRefs(
    Expression<bool> Function($$IncomeEntriesTableFilterComposer f) f,
  ) {
    final $$IncomeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeEntries,
      getReferencedColumn: (t) => t.incomeCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncomeCategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeCategoriesTable> {
  $$IncomeCategoriesTableOrderingComposer({
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

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$IncomeCategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeCategoriesTable> {
  $$IncomeCategoriesTableAnnotationComposer({
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

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  Expression<T> incomeSubcategoriesRefs<T extends Object>(
    Expression<T> Function($$IncomeSubcategoriesTableAnnotationComposer a) f,
  ) {
    final $$IncomeSubcategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.id,
          referencedTable: $db.incomeSubcategories,
          getReferencedColumn: (t) => t.categoryId,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncomeSubcategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.incomeSubcategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return f(composer);
  }

  Expression<T> incomeRecSeriesRefs<T extends Object>(
    Expression<T> Function($$IncomeRecSeriesTableAnnotationComposer a) f,
  ) {
    final $$IncomeRecSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeRecSeries,
      getReferencedColumn: (t) => t.incomeCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeRecSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeRecSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomeEntriesRefs<T extends Object>(
    Expression<T> Function($$IncomeEntriesTableAnnotationComposer a) f,
  ) {
    final $$IncomeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeEntries,
      getReferencedColumn: (t) => t.incomeCategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncomeCategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeCategoriesTable,
          IncomeCategoryRow,
          $$IncomeCategoriesTableFilterComposer,
          $$IncomeCategoriesTableOrderingComposer,
          $$IncomeCategoriesTableAnnotationComposer,
          $$IncomeCategoriesTableCreateCompanionBuilder,
          $$IncomeCategoriesTableUpdateCompanionBuilder,
          (IncomeCategoryRow, $$IncomeCategoriesTableReferences),
          IncomeCategoryRow,
          PrefetchHooks Function({
            bool incomeSubcategoriesRefs,
            bool incomeRecSeriesRefs,
            bool incomeEntriesRefs,
          })
        > {
  $$IncomeCategoriesTableTableManager(
    _$AppDatabase db,
    $IncomeCategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeCategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeCategoriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeCategoriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeCategoriesCompanion(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String name,
                Value<String?> description = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeCategoriesCompanion.insert(
                id: id,
                name: name,
                description: description,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncomeCategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                incomeSubcategoriesRefs = false,
                incomeRecSeriesRefs = false,
                incomeEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (incomeSubcategoriesRefs) db.incomeSubcategories,
                    if (incomeRecSeriesRefs) db.incomeRecSeries,
                    if (incomeEntriesRefs) db.incomeEntries,
                  ],
                  addJoins: null,
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (incomeSubcategoriesRefs)
                        await $_getPrefetchedData<
                          IncomeCategoryRow,
                          $IncomeCategoriesTable,
                          IncomeSubcategoryRow
                        >(
                          currentTable: table,
                          referencedTable: $$IncomeCategoriesTableReferences
                              ._incomeSubcategoriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncomeCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).incomeSubcategoriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.categoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomeRecSeriesRefs)
                        await $_getPrefetchedData<
                          IncomeCategoryRow,
                          $IncomeCategoriesTable,
                          IncomeRecurringSeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$IncomeCategoriesTableReferences
                              ._incomeRecSeriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncomeCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).incomeRecSeriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.incomeCategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomeEntriesRefs)
                        await $_getPrefetchedData<
                          IncomeCategoryRow,
                          $IncomeCategoriesTable,
                          IncomeEntryRow
                        >(
                          currentTable: table,
                          referencedTable: $$IncomeCategoriesTableReferences
                              ._incomeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncomeCategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).incomeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.incomeCategoryId == item.id,
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

typedef $$IncomeCategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeCategoriesTable,
      IncomeCategoryRow,
      $$IncomeCategoriesTableFilterComposer,
      $$IncomeCategoriesTableOrderingComposer,
      $$IncomeCategoriesTableAnnotationComposer,
      $$IncomeCategoriesTableCreateCompanionBuilder,
      $$IncomeCategoriesTableUpdateCompanionBuilder,
      (IncomeCategoryRow, $$IncomeCategoriesTableReferences),
      IncomeCategoryRow,
      PrefetchHooks Function({
        bool incomeSubcategoriesRefs,
        bool incomeRecSeriesRefs,
        bool incomeEntriesRefs,
      })
    >;
typedef $$IncomeSubcategoriesTableCreateCompanionBuilder =
    IncomeSubcategoriesCompanion Function({
      required String id,
      required String categoryId,
      required String name,
      Value<String?> description,
      required String slug,
      Value<bool> isSystemReserved,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });
typedef $$IncomeSubcategoriesTableUpdateCompanionBuilder =
    IncomeSubcategoriesCompanion Function({
      Value<String> id,
      Value<String> categoryId,
      Value<String> name,
      Value<String?> description,
      Value<String> slug,
      Value<bool> isSystemReserved,
      Value<int> sortOrder,
      Value<bool> isActive,
      Value<int> rowid,
    });

final class $$IncomeSubcategoriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IncomeSubcategoriesTable,
          IncomeSubcategoryRow
        > {
  $$IncomeSubcategoriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IncomeCategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.incomeCategories.createAlias(
        $_aliasNameGenerator(
          db.incomeSubcategories.categoryId,
          db.incomeCategories.id,
        ),
      );

  $$IncomeCategoriesTableProcessedTableManager get categoryId {
    final $_column = $_itemColumn<String>('category_id')!;

    final manager = $$IncomeCategoriesTableTableManager(
      $_db,
      $_db.incomeCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_categoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<
    $IncomeRecSeriesTable,
    List<IncomeRecurringSeriesRow>
  >
  _incomeRecSeriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeRecSeries,
    aliasName: $_aliasNameGenerator(
      db.incomeSubcategories.id,
      db.incomeRecSeries.incomeSubcategoryId,
    ),
  );

  $$IncomeRecSeriesTableProcessedTableManager get incomeRecSeriesRefs {
    final manager =
        $$IncomeRecSeriesTableTableManager($_db, $_db.incomeRecSeries).filter(
          (f) =>
              f.incomeSubcategoryId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _incomeRecSeriesRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }

  static MultiTypedResultKey<$IncomeEntriesTable, List<IncomeEntryRow>>
  _incomeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeEntries,
    aliasName: $_aliasNameGenerator(
      db.incomeSubcategories.id,
      db.incomeEntries.incomeSubcategoryId,
    ),
  );

  $$IncomeEntriesTableProcessedTableManager get incomeEntriesRefs {
    final manager = $$IncomeEntriesTableTableManager($_db, $_db.incomeEntries)
        .filter(
          (f) =>
              f.incomeSubcategoryId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_incomeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IncomeSubcategoriesTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeSubcategoriesTable> {
  $$IncomeSubcategoriesTableFilterComposer({
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

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  $$IncomeCategoriesTableFilterComposer get categoryId {
    final $$IncomeCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> incomeRecSeriesRefs(
    Expression<bool> Function($$IncomeRecSeriesTableFilterComposer f) f,
  ) {
    final $$IncomeRecSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeRecSeries,
      getReferencedColumn: (t) => t.incomeSubcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeRecSeriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeRecSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<bool> incomeEntriesRefs(
    Expression<bool> Function($$IncomeEntriesTableFilterComposer f) f,
  ) {
    final $$IncomeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeEntries,
      getReferencedColumn: (t) => t.incomeSubcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncomeSubcategoriesTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeSubcategoriesTable> {
  $$IncomeSubcategoriesTableOrderingComposer({
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

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  $$IncomeCategoriesTableOrderingComposer get categoryId {
    final $$IncomeCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncomeSubcategoriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeSubcategoriesTable> {
  $$IncomeSubcategoriesTableAnnotationComposer({
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

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  $$IncomeCategoriesTableAnnotationComposer get categoryId {
    final $$IncomeCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.categoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<T> incomeRecSeriesRefs<T extends Object>(
    Expression<T> Function($$IncomeRecSeriesTableAnnotationComposer a) f,
  ) {
    final $$IncomeRecSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeRecSeries,
      getReferencedColumn: (t) => t.incomeSubcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeRecSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeRecSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }

  Expression<T> incomeEntriesRefs<T extends Object>(
    Expression<T> Function($$IncomeEntriesTableAnnotationComposer a) f,
  ) {
    final $$IncomeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeEntries,
      getReferencedColumn: (t) => t.incomeSubcategoryId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncomeSubcategoriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeSubcategoriesTable,
          IncomeSubcategoryRow,
          $$IncomeSubcategoriesTableFilterComposer,
          $$IncomeSubcategoriesTableOrderingComposer,
          $$IncomeSubcategoriesTableAnnotationComposer,
          $$IncomeSubcategoriesTableCreateCompanionBuilder,
          $$IncomeSubcategoriesTableUpdateCompanionBuilder,
          (IncomeSubcategoryRow, $$IncomeSubcategoriesTableReferences),
          IncomeSubcategoryRow,
          PrefetchHooks Function({
            bool categoryId,
            bool incomeRecSeriesRefs,
            bool incomeEntriesRefs,
          })
        > {
  $$IncomeSubcategoriesTableTableManager(
    _$AppDatabase db,
    $IncomeSubcategoriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeSubcategoriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeSubcategoriesTableOrderingComposer(
                $db: db,
                $table: table,
              ),
          createComputedFieldComposer: () =>
              $$IncomeSubcategoriesTableAnnotationComposer(
                $db: db,
                $table: table,
              ),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<String?> description = const Value.absent(),
                Value<String> slug = const Value.absent(),
                Value<bool> isSystemReserved = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeSubcategoriesCompanion(
                id: id,
                categoryId: categoryId,
                name: name,
                description: description,
                slug: slug,
                isSystemReserved: isSystemReserved,
                sortOrder: sortOrder,
                isActive: isActive,
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
                Value<bool> isActive = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeSubcategoriesCompanion.insert(
                id: id,
                categoryId: categoryId,
                name: name,
                description: description,
                slug: slug,
                isSystemReserved: isSystemReserved,
                sortOrder: sortOrder,
                isActive: isActive,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncomeSubcategoriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                incomeRecSeriesRefs = false,
                incomeEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (incomeRecSeriesRefs) db.incomeRecSeries,
                    if (incomeEntriesRefs) db.incomeEntries,
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
                                        $$IncomeSubcategoriesTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$IncomeSubcategoriesTableReferences
                                            ._categoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (incomeRecSeriesRefs)
                        await $_getPrefetchedData<
                          IncomeSubcategoryRow,
                          $IncomeSubcategoriesTable,
                          IncomeRecurringSeriesRow
                        >(
                          currentTable: table,
                          referencedTable: $$IncomeSubcategoriesTableReferences
                              ._incomeRecSeriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncomeSubcategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).incomeRecSeriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.incomeSubcategoryId == item.id,
                              ),
                          typedResults: items,
                        ),
                      if (incomeEntriesRefs)
                        await $_getPrefetchedData<
                          IncomeSubcategoryRow,
                          $IncomeSubcategoriesTable,
                          IncomeEntryRow
                        >(
                          currentTable: table,
                          referencedTable: $$IncomeSubcategoriesTableReferences
                              ._incomeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncomeSubcategoriesTableReferences(
                                db,
                                table,
                                p0,
                              ).incomeEntriesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.incomeSubcategoryId == item.id,
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

typedef $$IncomeSubcategoriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeSubcategoriesTable,
      IncomeSubcategoryRow,
      $$IncomeSubcategoriesTableFilterComposer,
      $$IncomeSubcategoriesTableOrderingComposer,
      $$IncomeSubcategoriesTableAnnotationComposer,
      $$IncomeSubcategoriesTableCreateCompanionBuilder,
      $$IncomeSubcategoriesTableUpdateCompanionBuilder,
      (IncomeSubcategoryRow, $$IncomeSubcategoriesTableReferences),
      IncomeSubcategoryRow,
      PrefetchHooks Function({
        bool categoryId,
        bool incomeRecSeriesRefs,
        bool incomeEntriesRefs,
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
      Value<bool> isActive,
      Value<bool> isDefault,
      Value<int?> statementClosingDay,
      Value<int?> paymentDueDay,
      Value<double?> nominalAprPercent,
      Value<double?> creditLimit,
      Value<String?> displaySuffix,
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
      Value<bool> isActive,
      Value<bool> isDefault,
      Value<int?> statementClosingDay,
      Value<int?> paymentDueDay,
      Value<double?> nominalAprPercent,
      Value<double?> creditLimit,
      Value<String?> displaySuffix,
      Value<int> rowid,
    });

final class $$PaymentInstrumentsTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $PaymentInstrumentsTable,
          PaymentInstrumentRow
        > {
  $$PaymentInstrumentsTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static MultiTypedResultKey<$InstallmentPlansTable, List<InstallmentPlanRow>>
  _installmentPlansRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.installmentPlans,
    aliasName: $_aliasNameGenerator(
      db.paymentInstruments.id,
      db.installmentPlans.paymentInstrumentId,
    ),
  );

  $$InstallmentPlansTableProcessedTableManager get installmentPlansRefs {
    final manager =
        $$InstallmentPlansTableTableManager($_db, $_db.installmentPlans).filter(
          (f) =>
              f.paymentInstrumentId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(
      _installmentPlansRefsTable($_db),
    );
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

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

  ColumnFilters<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get statementClosingDay => $composableBuilder(
    column: $table.statementClosingDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get paymentDueDay => $composableBuilder(
    column: $table.paymentDueDay,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get nominalAprPercent => $composableBuilder(
    column: $table.nominalAprPercent,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get displaySuffix => $composableBuilder(
    column: $table.displaySuffix,
    builder: (column) => ColumnFilters(column),
  );

  Expression<bool> installmentPlansRefs(
    Expression<bool> Function($$InstallmentPlansTableFilterComposer f) f,
  ) {
    final $$InstallmentPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.installmentPlans,
      getReferencedColumn: (t) => t.paymentInstrumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentPlansTableFilterComposer(
            $db: $db,
            $table: $db.installmentPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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

  ColumnOrderings<bool> get isActive => $composableBuilder(
    column: $table.isActive,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get isDefault => $composableBuilder(
    column: $table.isDefault,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get statementClosingDay => $composableBuilder(
    column: $table.statementClosingDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get paymentDueDay => $composableBuilder(
    column: $table.paymentDueDay,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get nominalAprPercent => $composableBuilder(
    column: $table.nominalAprPercent,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get displaySuffix => $composableBuilder(
    column: $table.displaySuffix,
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

  GeneratedColumn<bool> get isActive =>
      $composableBuilder(column: $table.isActive, builder: (column) => column);

  GeneratedColumn<bool> get isDefault =>
      $composableBuilder(column: $table.isDefault, builder: (column) => column);

  GeneratedColumn<int> get statementClosingDay => $composableBuilder(
    column: $table.statementClosingDay,
    builder: (column) => column,
  );

  GeneratedColumn<int> get paymentDueDay => $composableBuilder(
    column: $table.paymentDueDay,
    builder: (column) => column,
  );

  GeneratedColumn<double> get nominalAprPercent => $composableBuilder(
    column: $table.nominalAprPercent,
    builder: (column) => column,
  );

  GeneratedColumn<double> get creditLimit => $composableBuilder(
    column: $table.creditLimit,
    builder: (column) => column,
  );

  GeneratedColumn<String> get displaySuffix => $composableBuilder(
    column: $table.displaySuffix,
    builder: (column) => column,
  );

  Expression<T> installmentPlansRefs<T extends Object>(
    Expression<T> Function($$InstallmentPlansTableAnnotationComposer a) f,
  ) {
    final $$InstallmentPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.installmentPlans,
      getReferencedColumn: (t) => t.paymentInstrumentId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.installmentPlans,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
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
          (PaymentInstrumentRow, $$PaymentInstrumentsTableReferences),
          PaymentInstrumentRow,
          PrefetchHooks Function({bool installmentPlansRefs})
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
                Value<bool> isActive = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int?> statementClosingDay = const Value.absent(),
                Value<int?> paymentDueDay = const Value.absent(),
                Value<double?> nominalAprPercent = const Value.absent(),
                Value<double?> creditLimit = const Value.absent(),
                Value<String?> displaySuffix = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentInstrumentsCompanion(
                id: id,
                label: label,
                bankName: bankName,
                billingCycleDay: billingCycleDay,
                annualFeeAmount: annualFeeAmount,
                monthlyFeeAmount: monthlyFeeAmount,
                feeDescription: feeDescription,
                isActive: isActive,
                isDefault: isDefault,
                statementClosingDay: statementClosingDay,
                paymentDueDay: paymentDueDay,
                nominalAprPercent: nominalAprPercent,
                creditLimit: creditLimit,
                displaySuffix: displaySuffix,
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
                Value<bool> isActive = const Value.absent(),
                Value<bool> isDefault = const Value.absent(),
                Value<int?> statementClosingDay = const Value.absent(),
                Value<int?> paymentDueDay = const Value.absent(),
                Value<double?> nominalAprPercent = const Value.absent(),
                Value<double?> creditLimit = const Value.absent(),
                Value<String?> displaySuffix = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => PaymentInstrumentsCompanion.insert(
                id: id,
                label: label,
                bankName: bankName,
                billingCycleDay: billingCycleDay,
                annualFeeAmount: annualFeeAmount,
                monthlyFeeAmount: monthlyFeeAmount,
                feeDescription: feeDescription,
                isActive: isActive,
                isDefault: isDefault,
                statementClosingDay: statementClosingDay,
                paymentDueDay: paymentDueDay,
                nominalAprPercent: nominalAprPercent,
                creditLimit: creditLimit,
                displaySuffix: displaySuffix,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$PaymentInstrumentsTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: ({installmentPlansRefs = false}) {
            return PrefetchHooks(
              db: db,
              explicitlyWatchedTables: [
                if (installmentPlansRefs) db.installmentPlans,
              ],
              addJoins: null,
              getPrefetchedDataCallback: (items) async {
                return [
                  if (installmentPlansRefs)
                    await $_getPrefetchedData<
                      PaymentInstrumentRow,
                      $PaymentInstrumentsTable,
                      InstallmentPlanRow
                    >(
                      currentTable: table,
                      referencedTable: $$PaymentInstrumentsTableReferences
                          ._installmentPlansRefsTable(db),
                      managerFromTypedResult: (p0) =>
                          $$PaymentInstrumentsTableReferences(
                            db,
                            table,
                            p0,
                          ).installmentPlansRefs,
                      referencedItemsForCurrentItem: (item, referencedItems) =>
                          referencedItems.where(
                            (e) => e.paymentInstrumentId == item.id,
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
      (PaymentInstrumentRow, $$PaymentInstrumentsTableReferences),
      PaymentInstrumentRow,
      PrefetchHooks Function({bool installmentPlansRefs})
    >;
typedef $$InstallmentPlansTableCreateCompanionBuilder =
    InstallmentPlansCompanion Function({
      required String id,
      required int paymentCount,
      Value<int> intervalMonths,
      required String anchorOccurredOn,
      required String categoryId,
      required String subcategoryId,
      Value<String?> paymentInstrumentId,
      required double perPaymentAmountOriginal,
      Value<String> currencyCode,
      Value<double> manualFxRateToUsd,
      required double perPaymentAmountUsd,
      Value<String> description,
      Value<int> rowid,
    });
typedef $$InstallmentPlansTableUpdateCompanionBuilder =
    InstallmentPlansCompanion Function({
      Value<String> id,
      Value<int> paymentCount,
      Value<int> intervalMonths,
      Value<String> anchorOccurredOn,
      Value<String> categoryId,
      Value<String> subcategoryId,
      Value<String?> paymentInstrumentId,
      Value<double> perPaymentAmountOriginal,
      Value<String> currencyCode,
      Value<double> manualFxRateToUsd,
      Value<double> perPaymentAmountUsd,
      Value<String> description,
      Value<int> rowid,
    });

final class $$InstallmentPlansTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $InstallmentPlansTable,
          InstallmentPlanRow
        > {
  $$InstallmentPlansTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $CategoriesTable _categoryIdTable(_$AppDatabase db) =>
      db.categories.createAlias(
        $_aliasNameGenerator(db.installmentPlans.categoryId, db.categories.id),
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
          db.installmentPlans.subcategoryId,
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

  static $PaymentInstrumentsTable _paymentInstrumentIdTable(_$AppDatabase db) =>
      db.paymentInstruments.createAlias(
        $_aliasNameGenerator(
          db.installmentPlans.paymentInstrumentId,
          db.paymentInstruments.id,
        ),
      );

  $$PaymentInstrumentsTableProcessedTableManager? get paymentInstrumentId {
    final $_column = $_itemColumn<String>('payment_instrument_id');
    if ($_column == null) return null;
    final manager = $$PaymentInstrumentsTableTableManager(
      $_db,
      $_db.paymentInstruments,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_paymentInstrumentIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$ExpensesTable, List<ExpenseRow>>
  _expensesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.expenses,
    aliasName: $_aliasNameGenerator(
      db.installmentPlans.id,
      db.expenses.installmentPlanId,
    ),
  );

  $$ExpensesTableProcessedTableManager get expensesRefs {
    final manager = $$ExpensesTableTableManager($_db, $_db.expenses).filter(
      (f) => f.installmentPlanId.id.sqlEquals($_itemColumn<String>('id')!),
    );

    final cache = $_typedResult.readTableOrNull(_expensesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$InstallmentPlansTableFilterComposer
    extends Composer<_$AppDatabase, $InstallmentPlansTable> {
  $$InstallmentPlansTableFilterComposer({
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

  ColumnFilters<int> get paymentCount => $composableBuilder(
    column: $table.paymentCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get intervalMonths => $composableBuilder(
    column: $table.intervalMonths,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get anchorOccurredOn => $composableBuilder(
    column: $table.anchorOccurredOn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get perPaymentAmountOriginal => $composableBuilder(
    column: $table.perPaymentAmountOriginal,
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

  ColumnFilters<double> get perPaymentAmountUsd => $composableBuilder(
    column: $table.perPaymentAmountUsd,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
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

  $$PaymentInstrumentsTableFilterComposer get paymentInstrumentId {
    final $$PaymentInstrumentsTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentInstrumentId,
      referencedTable: $db.paymentInstruments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentInstrumentsTableFilterComposer(
            $db: $db,
            $table: $db.paymentInstruments,
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
      getReferencedColumn: (t) => t.installmentPlanId,
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

class $$InstallmentPlansTableOrderingComposer
    extends Composer<_$AppDatabase, $InstallmentPlansTable> {
  $$InstallmentPlansTableOrderingComposer({
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

  ColumnOrderings<int> get paymentCount => $composableBuilder(
    column: $table.paymentCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get intervalMonths => $composableBuilder(
    column: $table.intervalMonths,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get anchorOccurredOn => $composableBuilder(
    column: $table.anchorOccurredOn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get perPaymentAmountOriginal => $composableBuilder(
    column: $table.perPaymentAmountOriginal,
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

  ColumnOrderings<double> get perPaymentAmountUsd => $composableBuilder(
    column: $table.perPaymentAmountUsd,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
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

  $$PaymentInstrumentsTableOrderingComposer get paymentInstrumentId {
    final $$PaymentInstrumentsTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.paymentInstrumentId,
      referencedTable: $db.paymentInstruments,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$PaymentInstrumentsTableOrderingComposer(
            $db: $db,
            $table: $db.paymentInstruments,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$InstallmentPlansTableAnnotationComposer
    extends Composer<_$AppDatabase, $InstallmentPlansTable> {
  $$InstallmentPlansTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<int> get paymentCount => $composableBuilder(
    column: $table.paymentCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get intervalMonths => $composableBuilder(
    column: $table.intervalMonths,
    builder: (column) => column,
  );

  GeneratedColumn<String> get anchorOccurredOn => $composableBuilder(
    column: $table.anchorOccurredOn,
    builder: (column) => column,
  );

  GeneratedColumn<double> get perPaymentAmountOriginal => $composableBuilder(
    column: $table.perPaymentAmountOriginal,
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

  GeneratedColumn<double> get perPaymentAmountUsd => $composableBuilder(
    column: $table.perPaymentAmountUsd,
    builder: (column) => column,
  );

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
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

  $$PaymentInstrumentsTableAnnotationComposer get paymentInstrumentId {
    final $$PaymentInstrumentsTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.paymentInstrumentId,
          referencedTable: $db.paymentInstruments,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$PaymentInstrumentsTableAnnotationComposer(
                $db: $db,
                $table: $db.paymentInstruments,
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
      getReferencedColumn: (t) => t.installmentPlanId,
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

class $$InstallmentPlansTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $InstallmentPlansTable,
          InstallmentPlanRow,
          $$InstallmentPlansTableFilterComposer,
          $$InstallmentPlansTableOrderingComposer,
          $$InstallmentPlansTableAnnotationComposer,
          $$InstallmentPlansTableCreateCompanionBuilder,
          $$InstallmentPlansTableUpdateCompanionBuilder,
          (InstallmentPlanRow, $$InstallmentPlansTableReferences),
          InstallmentPlanRow,
          PrefetchHooks Function({
            bool categoryId,
            bool subcategoryId,
            bool paymentInstrumentId,
            bool expensesRefs,
          })
        > {
  $$InstallmentPlansTableTableManager(
    _$AppDatabase db,
    $InstallmentPlansTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$InstallmentPlansTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$InstallmentPlansTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$InstallmentPlansTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<int> paymentCount = const Value.absent(),
                Value<int> intervalMonths = const Value.absent(),
                Value<String> anchorOccurredOn = const Value.absent(),
                Value<String> categoryId = const Value.absent(),
                Value<String> subcategoryId = const Value.absent(),
                Value<String?> paymentInstrumentId = const Value.absent(),
                Value<double> perPaymentAmountOriginal = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double> manualFxRateToUsd = const Value.absent(),
                Value<double> perPaymentAmountUsd = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstallmentPlansCompanion(
                id: id,
                paymentCount: paymentCount,
                intervalMonths: intervalMonths,
                anchorOccurredOn: anchorOccurredOn,
                categoryId: categoryId,
                subcategoryId: subcategoryId,
                paymentInstrumentId: paymentInstrumentId,
                perPaymentAmountOriginal: perPaymentAmountOriginal,
                currencyCode: currencyCode,
                manualFxRateToUsd: manualFxRateToUsd,
                perPaymentAmountUsd: perPaymentAmountUsd,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required int paymentCount,
                Value<int> intervalMonths = const Value.absent(),
                required String anchorOccurredOn,
                required String categoryId,
                required String subcategoryId,
                Value<String?> paymentInstrumentId = const Value.absent(),
                required double perPaymentAmountOriginal,
                Value<String> currencyCode = const Value.absent(),
                Value<double> manualFxRateToUsd = const Value.absent(),
                required double perPaymentAmountUsd,
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => InstallmentPlansCompanion.insert(
                id: id,
                paymentCount: paymentCount,
                intervalMonths: intervalMonths,
                anchorOccurredOn: anchorOccurredOn,
                categoryId: categoryId,
                subcategoryId: subcategoryId,
                paymentInstrumentId: paymentInstrumentId,
                perPaymentAmountOriginal: perPaymentAmountOriginal,
                currencyCode: currencyCode,
                manualFxRateToUsd: manualFxRateToUsd,
                perPaymentAmountUsd: perPaymentAmountUsd,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$InstallmentPlansTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                categoryId = false,
                subcategoryId = false,
                paymentInstrumentId = false,
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
                                        $$InstallmentPlansTableReferences
                                            ._categoryIdTable(db),
                                    referencedColumn:
                                        $$InstallmentPlansTableReferences
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
                                        $$InstallmentPlansTableReferences
                                            ._subcategoryIdTable(db),
                                    referencedColumn:
                                        $$InstallmentPlansTableReferences
                                            ._subcategoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (paymentInstrumentId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.paymentInstrumentId,
                                    referencedTable:
                                        $$InstallmentPlansTableReferences
                                            ._paymentInstrumentIdTable(db),
                                    referencedColumn:
                                        $$InstallmentPlansTableReferences
                                            ._paymentInstrumentIdTable(db)
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
                          InstallmentPlanRow,
                          $InstallmentPlansTable,
                          ExpenseRow
                        >(
                          currentTable: table,
                          referencedTable: $$InstallmentPlansTableReferences
                              ._expensesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$InstallmentPlansTableReferences(
                                db,
                                table,
                                p0,
                              ).expensesRefs,
                          referencedItemsForCurrentItem:
                              (item, referencedItems) => referencedItems.where(
                                (e) => e.installmentPlanId == item.id,
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

typedef $$InstallmentPlansTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $InstallmentPlansTable,
      InstallmentPlanRow,
      $$InstallmentPlansTableFilterComposer,
      $$InstallmentPlansTableOrderingComposer,
      $$InstallmentPlansTableAnnotationComposer,
      $$InstallmentPlansTableCreateCompanionBuilder,
      $$InstallmentPlansTableUpdateCompanionBuilder,
      (InstallmentPlanRow, $$InstallmentPlansTableReferences),
      InstallmentPlanRow,
      PrefetchHooks Function({
        bool categoryId,
        bool subcategoryId,
        bool paymentInstrumentId,
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
typedef $$IncomeRecSeriesTableCreateCompanionBuilder =
    IncomeRecSeriesCompanion Function({
      required String id,
      required String anchorReceivedOn,
      required String recurrenceJson,
      required int horizonMonths,
      Value<bool> active,
      required String incomeCategoryId,
      required String incomeSubcategoryId,
      required double amountOriginal,
      Value<String> currencyCode,
      Value<double> manualFxRateToUsd,
      required double amountUsd,
      Value<String> description,
      Value<int> rowid,
    });
typedef $$IncomeRecSeriesTableUpdateCompanionBuilder =
    IncomeRecSeriesCompanion Function({
      Value<String> id,
      Value<String> anchorReceivedOn,
      Value<String> recurrenceJson,
      Value<int> horizonMonths,
      Value<bool> active,
      Value<String> incomeCategoryId,
      Value<String> incomeSubcategoryId,
      Value<double> amountOriginal,
      Value<String> currencyCode,
      Value<double> manualFxRateToUsd,
      Value<double> amountUsd,
      Value<String> description,
      Value<int> rowid,
    });

final class $$IncomeRecSeriesTableReferences
    extends
        BaseReferences<
          _$AppDatabase,
          $IncomeRecSeriesTable,
          IncomeRecurringSeriesRow
        > {
  $$IncomeRecSeriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IncomeCategoriesTable _incomeCategoryIdTable(_$AppDatabase db) =>
      db.incomeCategories.createAlias(
        $_aliasNameGenerator(
          db.incomeRecSeries.incomeCategoryId,
          db.incomeCategories.id,
        ),
      );

  $$IncomeCategoriesTableProcessedTableManager get incomeCategoryId {
    final $_column = $_itemColumn<String>('income_category_id')!;

    final manager = $$IncomeCategoriesTableTableManager(
      $_db,
      $_db.incomeCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_incomeCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IncomeSubcategoriesTable _incomeSubcategoryIdTable(
    _$AppDatabase db,
  ) => db.incomeSubcategories.createAlias(
    $_aliasNameGenerator(
      db.incomeRecSeries.incomeSubcategoryId,
      db.incomeSubcategories.id,
    ),
  );

  $$IncomeSubcategoriesTableProcessedTableManager get incomeSubcategoryId {
    final $_column = $_itemColumn<String>('income_subcategory_id')!;

    final manager = $$IncomeSubcategoriesTableTableManager(
      $_db,
      $_db.incomeSubcategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_incomeSubcategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static MultiTypedResultKey<$IncomeEntriesTable, List<IncomeEntryRow>>
  _incomeEntriesRefsTable(_$AppDatabase db) => MultiTypedResultKey.fromTable(
    db.incomeEntries,
    aliasName: $_aliasNameGenerator(
      db.incomeRecSeries.id,
      db.incomeEntries.recurringSeriesId,
    ),
  );

  $$IncomeEntriesTableProcessedTableManager get incomeEntriesRefs {
    final manager = $$IncomeEntriesTableTableManager($_db, $_db.incomeEntries)
        .filter(
          (f) => f.recurringSeriesId.id.sqlEquals($_itemColumn<String>('id')!),
        );

    final cache = $_typedResult.readTableOrNull(_incomeEntriesRefsTable($_db));
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: cache),
    );
  }
}

class $$IncomeRecSeriesTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeRecSeriesTable> {
  $$IncomeRecSeriesTableFilterComposer({
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

  ColumnFilters<String> get anchorReceivedOn => $composableBuilder(
    column: $table.anchorReceivedOn,
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  $$IncomeCategoriesTableFilterComposer get incomeCategoryId {
    final $$IncomeCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeCategoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeSubcategoriesTableFilterComposer get incomeSubcategoryId {
    final $$IncomeSubcategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeSubcategoryId,
      referencedTable: $db.incomeSubcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeSubcategoriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeSubcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  Expression<bool> incomeEntriesRefs(
    Expression<bool> Function($$IncomeEntriesTableFilterComposer f) f,
  ) {
    final $$IncomeEntriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeEntries,
      getReferencedColumn: (t) => t.recurringSeriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeEntriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncomeRecSeriesTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeRecSeriesTable> {
  $$IncomeRecSeriesTableOrderingComposer({
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

  ColumnOrderings<String> get anchorReceivedOn => $composableBuilder(
    column: $table.anchorReceivedOn,
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  $$IncomeCategoriesTableOrderingComposer get incomeCategoryId {
    final $$IncomeCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeCategoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeSubcategoriesTableOrderingComposer get incomeSubcategoryId {
    final $$IncomeSubcategoriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.incomeSubcategoryId,
          referencedTable: $db.incomeSubcategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncomeSubcategoriesTableOrderingComposer(
                $db: $db,
                $table: $db.incomeSubcategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }
}

class $$IncomeRecSeriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeRecSeriesTable> {
  $$IncomeRecSeriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get anchorReceivedOn => $composableBuilder(
    column: $table.anchorReceivedOn,
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  $$IncomeCategoriesTableAnnotationComposer get incomeCategoryId {
    final $$IncomeCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeCategoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeSubcategoriesTableAnnotationComposer get incomeSubcategoryId {
    final $$IncomeSubcategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.incomeSubcategoryId,
          referencedTable: $db.incomeSubcategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncomeSubcategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.incomeSubcategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  Expression<T> incomeEntriesRefs<T extends Object>(
    Expression<T> Function($$IncomeEntriesTableAnnotationComposer a) f,
  ) {
    final $$IncomeEntriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.id,
      referencedTable: $db.incomeEntries,
      getReferencedColumn: (t) => t.recurringSeriesId,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeEntriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeEntries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return f(composer);
  }
}

class $$IncomeRecSeriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeRecSeriesTable,
          IncomeRecurringSeriesRow,
          $$IncomeRecSeriesTableFilterComposer,
          $$IncomeRecSeriesTableOrderingComposer,
          $$IncomeRecSeriesTableAnnotationComposer,
          $$IncomeRecSeriesTableCreateCompanionBuilder,
          $$IncomeRecSeriesTableUpdateCompanionBuilder,
          (IncomeRecurringSeriesRow, $$IncomeRecSeriesTableReferences),
          IncomeRecurringSeriesRow,
          PrefetchHooks Function({
            bool incomeCategoryId,
            bool incomeSubcategoryId,
            bool incomeEntriesRefs,
          })
        > {
  $$IncomeRecSeriesTableTableManager(
    _$AppDatabase db,
    $IncomeRecSeriesTable table,
  ) : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeRecSeriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeRecSeriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeRecSeriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> anchorReceivedOn = const Value.absent(),
                Value<String> recurrenceJson = const Value.absent(),
                Value<int> horizonMonths = const Value.absent(),
                Value<bool> active = const Value.absent(),
                Value<String> incomeCategoryId = const Value.absent(),
                Value<String> incomeSubcategoryId = const Value.absent(),
                Value<double> amountOriginal = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double> manualFxRateToUsd = const Value.absent(),
                Value<double> amountUsd = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeRecSeriesCompanion(
                id: id,
                anchorReceivedOn: anchorReceivedOn,
                recurrenceJson: recurrenceJson,
                horizonMonths: horizonMonths,
                active: active,
                incomeCategoryId: incomeCategoryId,
                incomeSubcategoryId: incomeSubcategoryId,
                amountOriginal: amountOriginal,
                currencyCode: currencyCode,
                manualFxRateToUsd: manualFxRateToUsd,
                amountUsd: amountUsd,
                description: description,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String anchorReceivedOn,
                required String recurrenceJson,
                required int horizonMonths,
                Value<bool> active = const Value.absent(),
                required String incomeCategoryId,
                required String incomeSubcategoryId,
                required double amountOriginal,
                Value<String> currencyCode = const Value.absent(),
                Value<double> manualFxRateToUsd = const Value.absent(),
                required double amountUsd,
                Value<String> description = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeRecSeriesCompanion.insert(
                id: id,
                anchorReceivedOn: anchorReceivedOn,
                recurrenceJson: recurrenceJson,
                horizonMonths: horizonMonths,
                active: active,
                incomeCategoryId: incomeCategoryId,
                incomeSubcategoryId: incomeSubcategoryId,
                amountOriginal: amountOriginal,
                currencyCode: currencyCode,
                manualFxRateToUsd: manualFxRateToUsd,
                amountUsd: amountUsd,
                description: description,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncomeRecSeriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                incomeCategoryId = false,
                incomeSubcategoryId = false,
                incomeEntriesRefs = false,
              }) {
                return PrefetchHooks(
                  db: db,
                  explicitlyWatchedTables: [
                    if (incomeEntriesRefs) db.incomeEntries,
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
                        if (incomeCategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.incomeCategoryId,
                                    referencedTable:
                                        $$IncomeRecSeriesTableReferences
                                            ._incomeCategoryIdTable(db),
                                    referencedColumn:
                                        $$IncomeRecSeriesTableReferences
                                            ._incomeCategoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (incomeSubcategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.incomeSubcategoryId,
                                    referencedTable:
                                        $$IncomeRecSeriesTableReferences
                                            ._incomeSubcategoryIdTable(db),
                                    referencedColumn:
                                        $$IncomeRecSeriesTableReferences
                                            ._incomeSubcategoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }

                        return state;
                      },
                  getPrefetchedDataCallback: (items) async {
                    return [
                      if (incomeEntriesRefs)
                        await $_getPrefetchedData<
                          IncomeRecurringSeriesRow,
                          $IncomeRecSeriesTable,
                          IncomeEntryRow
                        >(
                          currentTable: table,
                          referencedTable: $$IncomeRecSeriesTableReferences
                              ._incomeEntriesRefsTable(db),
                          managerFromTypedResult: (p0) =>
                              $$IncomeRecSeriesTableReferences(
                                db,
                                table,
                                p0,
                              ).incomeEntriesRefs,
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

typedef $$IncomeRecSeriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeRecSeriesTable,
      IncomeRecurringSeriesRow,
      $$IncomeRecSeriesTableFilterComposer,
      $$IncomeRecSeriesTableOrderingComposer,
      $$IncomeRecSeriesTableAnnotationComposer,
      $$IncomeRecSeriesTableCreateCompanionBuilder,
      $$IncomeRecSeriesTableUpdateCompanionBuilder,
      (IncomeRecurringSeriesRow, $$IncomeRecSeriesTableReferences),
      IncomeRecurringSeriesRow,
      PrefetchHooks Function({
        bool incomeCategoryId,
        bool incomeSubcategoryId,
        bool incomeEntriesRefs,
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
      Value<String?> installmentPlanId,
      Value<int?> installmentIndex,
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
      Value<String?> installmentPlanId,
      Value<int?> installmentIndex,
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

  static $InstallmentPlansTable _installmentPlanIdTable(_$AppDatabase db) =>
      db.installmentPlans.createAlias(
        $_aliasNameGenerator(
          db.expenses.installmentPlanId,
          db.installmentPlans.id,
        ),
      );

  $$InstallmentPlansTableProcessedTableManager? get installmentPlanId {
    final $_column = $_itemColumn<String>('installment_plan_id');
    if ($_column == null) return null;
    final manager = $$InstallmentPlansTableTableManager(
      $_db,
      $_db.installmentPlans,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_installmentPlanIdTable($_db));
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

  ColumnFilters<int> get installmentIndex => $composableBuilder(
    column: $table.installmentIndex,
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

  $$InstallmentPlansTableFilterComposer get installmentPlanId {
    final $$InstallmentPlansTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.installmentPlanId,
      referencedTable: $db.installmentPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentPlansTableFilterComposer(
            $db: $db,
            $table: $db.installmentPlans,
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

  ColumnOrderings<int> get installmentIndex => $composableBuilder(
    column: $table.installmentIndex,
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

  $$InstallmentPlansTableOrderingComposer get installmentPlanId {
    final $$InstallmentPlansTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.installmentPlanId,
      referencedTable: $db.installmentPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentPlansTableOrderingComposer(
            $db: $db,
            $table: $db.installmentPlans,
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

  GeneratedColumn<int> get installmentIndex => $composableBuilder(
    column: $table.installmentIndex,
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

  $$InstallmentPlansTableAnnotationComposer get installmentPlanId {
    final $$InstallmentPlansTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.installmentPlanId,
      referencedTable: $db.installmentPlans,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$InstallmentPlansTableAnnotationComposer(
            $db: $db,
            $table: $db.installmentPlans,
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
            bool installmentPlanId,
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
                Value<String?> installmentPlanId = const Value.absent(),
                Value<int?> installmentIndex = const Value.absent(),
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
                installmentPlanId: installmentPlanId,
                installmentIndex: installmentIndex,
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
                Value<String?> installmentPlanId = const Value.absent(),
                Value<int?> installmentIndex = const Value.absent(),
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
                installmentPlanId: installmentPlanId,
                installmentIndex: installmentIndex,
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
                installmentPlanId = false,
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
                        if (installmentPlanId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.installmentPlanId,
                                    referencedTable: $$ExpensesTableReferences
                                        ._installmentPlanIdTable(db),
                                    referencedColumn: $$ExpensesTableReferences
                                        ._installmentPlanIdTable(db)
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
        bool installmentPlanId,
      })
    >;
typedef $$IncomeEntriesTableCreateCompanionBuilder =
    IncomeEntriesCompanion Function({
      required String id,
      required String receivedOn,
      required String incomeCategoryId,
      required String incomeSubcategoryId,
      required double amountOriginal,
      Value<String> currencyCode,
      Value<double> manualFxRateToUsd,
      required double amountUsd,
      Value<String> description,
      Value<String?> recurringSeriesId,
      Value<String?> expectationStatus,
      Value<String?> expectationConfirmedOn,
      Value<int> rowid,
    });
typedef $$IncomeEntriesTableUpdateCompanionBuilder =
    IncomeEntriesCompanion Function({
      Value<String> id,
      Value<String> receivedOn,
      Value<String> incomeCategoryId,
      Value<String> incomeSubcategoryId,
      Value<double> amountOriginal,
      Value<String> currencyCode,
      Value<double> manualFxRateToUsd,
      Value<double> amountUsd,
      Value<String> description,
      Value<String?> recurringSeriesId,
      Value<String?> expectationStatus,
      Value<String?> expectationConfirmedOn,
      Value<int> rowid,
    });

final class $$IncomeEntriesTableReferences
    extends BaseReferences<_$AppDatabase, $IncomeEntriesTable, IncomeEntryRow> {
  $$IncomeEntriesTableReferences(
    super.$_db,
    super.$_table,
    super.$_typedResult,
  );

  static $IncomeCategoriesTable _incomeCategoryIdTable(_$AppDatabase db) =>
      db.incomeCategories.createAlias(
        $_aliasNameGenerator(
          db.incomeEntries.incomeCategoryId,
          db.incomeCategories.id,
        ),
      );

  $$IncomeCategoriesTableProcessedTableManager get incomeCategoryId {
    final $_column = $_itemColumn<String>('income_category_id')!;

    final manager = $$IncomeCategoriesTableTableManager(
      $_db,
      $_db.incomeCategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_incomeCategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IncomeSubcategoriesTable _incomeSubcategoryIdTable(
    _$AppDatabase db,
  ) => db.incomeSubcategories.createAlias(
    $_aliasNameGenerator(
      db.incomeEntries.incomeSubcategoryId,
      db.incomeSubcategories.id,
    ),
  );

  $$IncomeSubcategoriesTableProcessedTableManager get incomeSubcategoryId {
    final $_column = $_itemColumn<String>('income_subcategory_id')!;

    final manager = $$IncomeSubcategoriesTableTableManager(
      $_db,
      $_db.incomeSubcategories,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_incomeSubcategoryIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }

  static $IncomeRecSeriesTable _recurringSeriesIdTable(_$AppDatabase db) =>
      db.incomeRecSeries.createAlias(
        $_aliasNameGenerator(
          db.incomeEntries.recurringSeriesId,
          db.incomeRecSeries.id,
        ),
      );

  $$IncomeRecSeriesTableProcessedTableManager? get recurringSeriesId {
    final $_column = $_itemColumn<String>('recurring_series_id');
    if ($_column == null) return null;
    final manager = $$IncomeRecSeriesTableTableManager(
      $_db,
      $_db.incomeRecSeries,
    ).filter((f) => f.id.sqlEquals($_column));
    final item = $_typedResult.readTableOrNull(_recurringSeriesIdTable($_db));
    if (item == null) return manager;
    return ProcessedTableManager(
      manager.$state.copyWith(prefetchedData: [item]),
    );
  }
}

class $$IncomeEntriesTableFilterComposer
    extends Composer<_$AppDatabase, $IncomeEntriesTable> {
  $$IncomeEntriesTableFilterComposer({
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

  ColumnFilters<String> get receivedOn => $composableBuilder(
    column: $table.receivedOn,
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

  ColumnFilters<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectationStatus => $composableBuilder(
    column: $table.expectationStatus,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get expectationConfirmedOn => $composableBuilder(
    column: $table.expectationConfirmedOn,
    builder: (column) => ColumnFilters(column),
  );

  $$IncomeCategoriesTableFilterComposer get incomeCategoryId {
    final $$IncomeCategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeCategoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeSubcategoriesTableFilterComposer get incomeSubcategoryId {
    final $$IncomeSubcategoriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeSubcategoryId,
      referencedTable: $db.incomeSubcategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeSubcategoriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeSubcategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeRecSeriesTableFilterComposer get recurringSeriesId {
    final $$IncomeRecSeriesTableFilterComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringSeriesId,
      referencedTable: $db.incomeRecSeries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeRecSeriesTableFilterComposer(
            $db: $db,
            $table: $db.incomeRecSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncomeEntriesTableOrderingComposer
    extends Composer<_$AppDatabase, $IncomeEntriesTable> {
  $$IncomeEntriesTableOrderingComposer({
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

  ColumnOrderings<String> get receivedOn => $composableBuilder(
    column: $table.receivedOn,
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

  ColumnOrderings<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectationStatus => $composableBuilder(
    column: $table.expectationStatus,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get expectationConfirmedOn => $composableBuilder(
    column: $table.expectationConfirmedOn,
    builder: (column) => ColumnOrderings(column),
  );

  $$IncomeCategoriesTableOrderingComposer get incomeCategoryId {
    final $$IncomeCategoriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeCategoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableOrderingComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeSubcategoriesTableOrderingComposer get incomeSubcategoryId {
    final $$IncomeSubcategoriesTableOrderingComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.incomeSubcategoryId,
          referencedTable: $db.incomeSubcategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncomeSubcategoriesTableOrderingComposer(
                $db: $db,
                $table: $db.incomeSubcategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IncomeRecSeriesTableOrderingComposer get recurringSeriesId {
    final $$IncomeRecSeriesTableOrderingComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringSeriesId,
      referencedTable: $db.incomeRecSeries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeRecSeriesTableOrderingComposer(
            $db: $db,
            $table: $db.incomeRecSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncomeEntriesTableAnnotationComposer
    extends Composer<_$AppDatabase, $IncomeEntriesTable> {
  $$IncomeEntriesTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get receivedOn => $composableBuilder(
    column: $table.receivedOn,
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

  GeneratedColumn<String> get description => $composableBuilder(
    column: $table.description,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expectationStatus => $composableBuilder(
    column: $table.expectationStatus,
    builder: (column) => column,
  );

  GeneratedColumn<String> get expectationConfirmedOn => $composableBuilder(
    column: $table.expectationConfirmedOn,
    builder: (column) => column,
  );

  $$IncomeCategoriesTableAnnotationComposer get incomeCategoryId {
    final $$IncomeCategoriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.incomeCategoryId,
      referencedTable: $db.incomeCategories,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeCategoriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeCategories,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }

  $$IncomeSubcategoriesTableAnnotationComposer get incomeSubcategoryId {
    final $$IncomeSubcategoriesTableAnnotationComposer composer =
        $composerBuilder(
          composer: this,
          getCurrentColumn: (t) => t.incomeSubcategoryId,
          referencedTable: $db.incomeSubcategories,
          getReferencedColumn: (t) => t.id,
          builder:
              (
                joinBuilder, {
                $addJoinBuilderToRootComposer,
                $removeJoinBuilderFromRootComposer,
              }) => $$IncomeSubcategoriesTableAnnotationComposer(
                $db: $db,
                $table: $db.incomeSubcategories,
                $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
                joinBuilder: joinBuilder,
                $removeJoinBuilderFromRootComposer:
                    $removeJoinBuilderFromRootComposer,
              ),
        );
    return composer;
  }

  $$IncomeRecSeriesTableAnnotationComposer get recurringSeriesId {
    final $$IncomeRecSeriesTableAnnotationComposer composer = $composerBuilder(
      composer: this,
      getCurrentColumn: (t) => t.recurringSeriesId,
      referencedTable: $db.incomeRecSeries,
      getReferencedColumn: (t) => t.id,
      builder:
          (
            joinBuilder, {
            $addJoinBuilderToRootComposer,
            $removeJoinBuilderFromRootComposer,
          }) => $$IncomeRecSeriesTableAnnotationComposer(
            $db: $db,
            $table: $db.incomeRecSeries,
            $addJoinBuilderToRootComposer: $addJoinBuilderToRootComposer,
            joinBuilder: joinBuilder,
            $removeJoinBuilderFromRootComposer:
                $removeJoinBuilderFromRootComposer,
          ),
    );
    return composer;
  }
}

class $$IncomeEntriesTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $IncomeEntriesTable,
          IncomeEntryRow,
          $$IncomeEntriesTableFilterComposer,
          $$IncomeEntriesTableOrderingComposer,
          $$IncomeEntriesTableAnnotationComposer,
          $$IncomeEntriesTableCreateCompanionBuilder,
          $$IncomeEntriesTableUpdateCompanionBuilder,
          (IncomeEntryRow, $$IncomeEntriesTableReferences),
          IncomeEntryRow,
          PrefetchHooks Function({
            bool incomeCategoryId,
            bool incomeSubcategoryId,
            bool recurringSeriesId,
          })
        > {
  $$IncomeEntriesTableTableManager(_$AppDatabase db, $IncomeEntriesTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$IncomeEntriesTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$IncomeEntriesTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$IncomeEntriesTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> receivedOn = const Value.absent(),
                Value<String> incomeCategoryId = const Value.absent(),
                Value<String> incomeSubcategoryId = const Value.absent(),
                Value<double> amountOriginal = const Value.absent(),
                Value<String> currencyCode = const Value.absent(),
                Value<double> manualFxRateToUsd = const Value.absent(),
                Value<double> amountUsd = const Value.absent(),
                Value<String> description = const Value.absent(),
                Value<String?> recurringSeriesId = const Value.absent(),
                Value<String?> expectationStatus = const Value.absent(),
                Value<String?> expectationConfirmedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeEntriesCompanion(
                id: id,
                receivedOn: receivedOn,
                incomeCategoryId: incomeCategoryId,
                incomeSubcategoryId: incomeSubcategoryId,
                amountOriginal: amountOriginal,
                currencyCode: currencyCode,
                manualFxRateToUsd: manualFxRateToUsd,
                amountUsd: amountUsd,
                description: description,
                recurringSeriesId: recurringSeriesId,
                expectationStatus: expectationStatus,
                expectationConfirmedOn: expectationConfirmedOn,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String receivedOn,
                required String incomeCategoryId,
                required String incomeSubcategoryId,
                required double amountOriginal,
                Value<String> currencyCode = const Value.absent(),
                Value<double> manualFxRateToUsd = const Value.absent(),
                required double amountUsd,
                Value<String> description = const Value.absent(),
                Value<String?> recurringSeriesId = const Value.absent(),
                Value<String?> expectationStatus = const Value.absent(),
                Value<String?> expectationConfirmedOn = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => IncomeEntriesCompanion.insert(
                id: id,
                receivedOn: receivedOn,
                incomeCategoryId: incomeCategoryId,
                incomeSubcategoryId: incomeSubcategoryId,
                amountOriginal: amountOriginal,
                currencyCode: currencyCode,
                manualFxRateToUsd: manualFxRateToUsd,
                amountUsd: amountUsd,
                description: description,
                recurringSeriesId: recurringSeriesId,
                expectationStatus: expectationStatus,
                expectationConfirmedOn: expectationConfirmedOn,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable(table),
                  $$IncomeEntriesTableReferences(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback:
              ({
                incomeCategoryId = false,
                incomeSubcategoryId = false,
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
                        if (incomeCategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.incomeCategoryId,
                                    referencedTable:
                                        $$IncomeEntriesTableReferences
                                            ._incomeCategoryIdTable(db),
                                    referencedColumn:
                                        $$IncomeEntriesTableReferences
                                            ._incomeCategoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (incomeSubcategoryId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.incomeSubcategoryId,
                                    referencedTable:
                                        $$IncomeEntriesTableReferences
                                            ._incomeSubcategoryIdTable(db),
                                    referencedColumn:
                                        $$IncomeEntriesTableReferences
                                            ._incomeSubcategoryIdTable(db)
                                            .id,
                                  )
                                  as T;
                        }
                        if (recurringSeriesId) {
                          state =
                              state.withJoin(
                                    currentTable: table,
                                    currentColumn: table.recurringSeriesId,
                                    referencedTable:
                                        $$IncomeEntriesTableReferences
                                            ._recurringSeriesIdTable(db),
                                    referencedColumn:
                                        $$IncomeEntriesTableReferences
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

typedef $$IncomeEntriesTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $IncomeEntriesTable,
      IncomeEntryRow,
      $$IncomeEntriesTableFilterComposer,
      $$IncomeEntriesTableOrderingComposer,
      $$IncomeEntriesTableAnnotationComposer,
      $$IncomeEntriesTableCreateCompanionBuilder,
      $$IncomeEntriesTableUpdateCompanionBuilder,
      (IncomeEntryRow, $$IncomeEntriesTableReferences),
      IncomeEntryRow,
      PrefetchHooks Function({
        bool incomeCategoryId,
        bool incomeSubcategoryId,
        bool recurringSeriesId,
      })
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$CategoriesTableTableManager get categories =>
      $$CategoriesTableTableManager(_db, _db.categories);
  $$SubcategoriesTableTableManager get subcategories =>
      $$SubcategoriesTableTableManager(_db, _db.subcategories);
  $$IncomeCategoriesTableTableManager get incomeCategories =>
      $$IncomeCategoriesTableTableManager(_db, _db.incomeCategories);
  $$IncomeSubcategoriesTableTableManager get incomeSubcategories =>
      $$IncomeSubcategoriesTableTableManager(_db, _db.incomeSubcategories);
  $$PaymentInstrumentsTableTableManager get paymentInstruments =>
      $$PaymentInstrumentsTableTableManager(_db, _db.paymentInstruments);
  $$InstallmentPlansTableTableManager get installmentPlans =>
      $$InstallmentPlansTableTableManager(_db, _db.installmentPlans);
  $$RecExpenseSeriesTableTableManager get recExpenseSeries =>
      $$RecExpenseSeriesTableTableManager(_db, _db.recExpenseSeries);
  $$IncomeRecSeriesTableTableManager get incomeRecSeries =>
      $$IncomeRecSeriesTableTableManager(_db, _db.incomeRecSeries);
  $$ExpensesTableTableManager get expenses =>
      $$ExpensesTableTableManager(_db, _db.expenses);
  $$IncomeEntriesTableTableManager get incomeEntries =>
      $$IncomeEntriesTableTableManager(_db, _db.incomeEntries);
}
