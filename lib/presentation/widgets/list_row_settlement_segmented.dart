import 'package:flutter/material.dart';

/// Compact [SegmentedButton] for list rows (between title and overflow menu).
class ListRowSettlementSegmented extends StatelessWidget {
  const ListRowSettlementSegmented({
    super.key,
    required this.settled,
    required this.onChanged,
    required this.settledLabel,
    required this.unsettledLabel,
  });

  final bool settled;
  final ValueChanged<bool> onChanged;
  final String settledLabel;
  final String unsettledLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return SizedBox(
      width: 168,
      height: 40,
      child: Align(
        alignment: Alignment.center,
        child: FittedBox(
          fit: BoxFit.scaleDown,
          alignment: Alignment.center,
          child: SegmentedButton<bool>(
            showSelectedIcon: false,
            style: SegmentedButton.styleFrom(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              selectedForegroundColor: scheme.onSecondaryContainer,
              selectedBackgroundColor: scheme.secondaryContainer,
              foregroundColor: scheme.onSurfaceVariant,
              side: BorderSide(color: scheme.outlineVariant.withValues(alpha: 0.5)),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
            ),
            segments: [
              ButtonSegment<bool>(
                value: true,
                label: Text(
                  settledLabel,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
              ButtonSegment<bool>(
                value: false,
                label: Text(
                  unsettledLabel,
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ),
            ],
            selected: {settled},
            onSelectionChanged: (next) {
              if (next.isEmpty) {
                return;
              }
              onChanged(next.single);
            },
          ),
        ),
      ),
    );
  }
}
