/// When saving an edit to a materialized recurring row, whether to touch the series template.
enum RecurringMaterializedEditScope {
  /// Persist changes on this row only (series template unchanged).
  thisOccurrenceOnly,

  /// Update the series template and every materialized row on or after this date.
  thisAndFutureMaterialized,
}

/// Delete menu: remove one materialized row vs this row and all later occurrences in the series.
enum RecurringOccurrenceDeleteScope {
  thisOccurrenceOnly,
  thisAndFutureInSeries,
}
