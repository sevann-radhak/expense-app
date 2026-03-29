import 'package:flutter/material.dart';

/// Compact two-segment control for list rows (Paid/Expected or Received/Expected).
///
/// The settled side (true) uses high-contrast [ColorScheme.primary] when selected.
class ListRowSettlementSegmented extends StatelessWidget {
  const ListRowSettlementSegmented({
    super.key,
    required this.settled,
    required this.onChanged,
    required this.settledLabel,
    required this.unsettledLabel,
  });

  static const double _width = 124;
  static const double _height = 28;

  final bool settled;
  final ValueChanged<bool> onChanged;
  final String settledLabel;
  final String unsettledLabel;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final theme = Theme.of(context);

    return SizedBox(
      width: _width,
      height: _height,
      child: FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.center,
        child: Container(
          width: _width,
          height: _height,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: scheme.outlineVariant.withValues(alpha: 0.4),
            ),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Segment(
                selected: settled,
                strongSelected: true,
                label: settledLabel,
                scheme: scheme,
                theme: theme,
                onTap: () => onChanged(true),
              ),
              ColoredBox(
                color: scheme.outlineVariant.withValues(alpha: 0.35),
                child: const SizedBox(width: 1),
              ),
              _Segment(
                selected: !settled,
                strongSelected: false,
                label: unsettledLabel,
                scheme: scheme,
                theme: theme,
                onTap: () => onChanged(false),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.selected,
    required this.strongSelected,
    required this.label,
    required this.scheme,
    required this.theme,
    required this.onTap,
  });

  final bool selected;
  final bool strongSelected;
  final String label;
  final ColorScheme scheme;
  final ThemeData theme;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    late final Color bg;
    late final Color fg;
    late final FontWeight weight;

    if (selected) {
      if (strongSelected) {
        bg = scheme.primary;
        fg = scheme.onPrimary;
        weight = FontWeight.w800;
      } else {
        bg = scheme.secondaryContainer.withValues(alpha: 0.85);
        fg = scheme.onSecondaryContainer;
        weight = FontWeight.w600;
      }
    } else {
      bg = scheme.surfaceContainerHighest.withValues(alpha: 0.35);
      fg = scheme.onSurfaceVariant.withValues(alpha: 0.75);
      weight = FontWeight.w500;
    }

    return Expanded(
      child: Material(
        color: bg,
        child: InkWell(
          onTap: onTap,
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4),
              child: Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                strutStyle: const StrutStyle(
                  fontSize: 10.5,
                  height: 1.1,
                  forceStrutHeight: true,
                ),
                style: theme.textTheme.labelSmall?.copyWith(
                  fontSize: 10.5,
                  height: 1.1,
                  color: fg,
                  fontWeight: weight,
                  letterSpacing: strongSelected && selected ? 0.35 : 0,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
