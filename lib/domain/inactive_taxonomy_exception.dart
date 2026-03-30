/// Thrown when a new expense or income row is saved with a deactivated category
/// or subcategory (historical edits may still reference inactive taxonomy).
class InactiveTaxonomyForNewEntryException implements Exception {
  InactiveTaxonomyForNewEntryException([this.message = 'Taxonomy must be active.']);

  final String message;

  @override
  String toString() => 'InactiveTaxonomyForNewEntryException: $message';
}
