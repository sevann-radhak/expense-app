/// User-facing category (expense grouping).
class Category {
  const Category({
    required this.id,
    required this.name,
    required this.sortOrder,
  });

  final String id;
  final String name;
  final int sortOrder;
}

/// Subcategory under a [Category]. System-reserved `other` cannot be deleted.
class Subcategory {
  const Subcategory({
    required this.id,
    required this.categoryId,
    required this.name,
    required this.slug,
    required this.isSystemReserved,
    required this.sortOrder,
  });

  final String id;
  final String categoryId;
  final String name;
  final String slug;
  final bool isSystemReserved;
  final int sortOrder;

  bool get isOther => slug == kOtherSubcategorySlug;
}

/// Reserved slug for the non-deletable "Other" subcategory (see business rules).
const String kOtherSubcategorySlug = 'other';
