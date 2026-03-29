import 'package:expense_app/domain/category.dart';

/// Income grouping (separate from expense [Category]).
class IncomeCategory {
  const IncomeCategory({
    required this.id,
    required this.name,
    this.description,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final String? description;
  final int sortOrder;

  IncomeCategory copyWith({
    String? id,
    String? name,
    String? description,
    int? sortOrder,
    bool clearDescription = false,
  }) {
    return IncomeCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      description: clearDescription ? null : (description ?? this.description),
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}

/// Subcategory under an [IncomeCategory]. System-reserved **Other** uses [kOtherSubcategorySlug].
class IncomeSubcategory {
  const IncomeSubcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.slug,
    required this.isSystemReserved,
    required this.sortOrder,
  });

  final String id;
  final String categoryId;
  final String name;
  final String? description;
  final String slug;
  final bool isSystemReserved;
  final int sortOrder;

  bool get isOther => slug == kOtherSubcategorySlug;

  IncomeSubcategory copyWith({
    String? id,
    String? categoryId,
    String? name,
    String? description,
    String? slug,
    bool? isSystemReserved,
    int? sortOrder,
    bool clearDescription = false,
  }) {
    return IncomeSubcategory(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: clearDescription ? null : (description ?? this.description),
      slug: slug ?? this.slug,
      isSystemReserved: isSystemReserved ?? this.isSystemReserved,
      sortOrder: sortOrder ?? this.sortOrder,
    );
  }
}
