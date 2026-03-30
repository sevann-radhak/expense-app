/// User-facing category (expense grouping).
class Category {
  const Category({
    required this.id,
    required this.name,
    this.description,
    required this.sortOrder,
    this.isActive = true,
  });

  final String id;
  final String name;

  /// Optional note shown under the name on the Categories screen (not the internal id).
  final String? description;
  final int sortOrder;

  /// When false, hidden from pickers but kept for historical labels and FK integrity.
  final bool isActive;

  Category copyWith({
    String? id,
    String? name,
    String? description,
    int? sortOrder,
    bool? isActive,
    bool clearDescription = false,
  }) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      description: clearDescription ? null : (description ?? this.description),
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Subcategory under a [Category]. System-reserved `other` cannot be deleted.
class Subcategory {
  const Subcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    this.description,
    required this.slug,
    required this.isSystemReserved,
    required this.sortOrder,
    this.isActive = true,
  });

  final String id;
  final String categoryId;
  final String name;

  /// Optional note under the subcategory name (consumer UI never shows [slug] or [id]).
  final String? description;
  final String slug;
  final bool isSystemReserved;
  final int sortOrder;

  /// When false, hidden from pickers but kept for historical labels and FK integrity.
  final bool isActive;

  bool get isOther => slug == kOtherSubcategorySlug;

  Subcategory copyWith({
    String? id,
    String? categoryId,
    String? name,
    String? description,
    String? slug,
    bool? isSystemReserved,
    int? sortOrder,
    bool? isActive,
    bool clearDescription = false,
  }) {
    return Subcategory(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      name: name ?? this.name,
      description: clearDescription ? null : (description ?? this.description),
      slug: slug ?? this.slug,
      isSystemReserved: isSystemReserved ?? this.isSystemReserved,
      sortOrder: sortOrder ?? this.sortOrder,
      isActive: isActive ?? this.isActive,
    );
  }
}

/// Reserved slug for the non-deletable "Other" subcategory (see business rules).
const String kOtherSubcategorySlug = 'other';
