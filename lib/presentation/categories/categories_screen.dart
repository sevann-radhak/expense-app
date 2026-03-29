import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/theme/category_accent_colors.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: Text(l10n.navCategories),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [
              Tab(text: l10n.categoriesTabExpenses),
              Tab(text: l10n.categoriesTabIncome),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _ExpenseCategoriesTabBody(),
            _IncomeCategoriesTabBody(),
          ],
        ),
      ),
    );
  }
}

class _ExpenseCategoriesTabBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    return categoriesAsync.when(
      data: (cats) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.categoriesScreenSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          ...cats.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _CategoryExpansionTile(category: c),
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}

class _IncomeCategoriesTabBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(incomeCategoriesStreamProvider);
    return categoriesAsync.when(
      data: (cats) => ListView(
        padding: const EdgeInsets.all(24),
        children: [
          Text(
            l10n.categoriesIncomeScreenSubtitle,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
          const SizedBox(height: 16),
          ...cats.map(
            (c) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: _IncomeCategoryExpansionTile(category: c),
            ),
          ),
        ],
      ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}

class _DescriptionEditorDialog extends StatefulWidget {
  const _DescriptionEditorDialog({
    required this.title,
    required this.label,
    required this.initialText,
    required this.onSave,
  });

  final String title;
  final String label;
  final String initialText;
  final Future<void> Function(String text) onSave;

  @override
  State<_DescriptionEditorDialog> createState() =>
      _DescriptionEditorDialogState();
}

class _DescriptionEditorDialogState extends State<_DescriptionEditorDialog> {
  late final TextEditingController _controller =
      TextEditingController(text: widget.initialText);
  var _busy = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: _controller,
        maxLines: 3,
        enabled: !_busy,
        decoration: InputDecoration(labelText: widget.label),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: _busy
              ? null
              : () async {
                  setState(() => _busy = true);
                  try {
                    await widget.onSave(_controller.text);
                    if (context.mounted) {
                      Navigator.pop(context);
                    }
                  } finally {
                    if (mounted) {
                      setState(() => _busy = false);
                    }
                  }
                },
          child: Text(l10n.saveExpenseAction),
        ),
      ],
    );
  }
}

class _CategoryExpansionTile extends ConsumerWidget {
  const _CategoryExpansionTile({required this.category});

  final Category category;

  static Future<void> _openCategoryEditor(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _DescriptionEditorDialog(
        title: l10n.categoryEditDescriptionTitle,
        label: l10n.categoryDescriptionLabel,
        initialText: category.description ?? '',
        onSave: (text) => ref
            .read(categoryRepositoryProvider)
            .setCategoryDescription(category.id, text),
      ),
    );
  }

  static Future<void> _openSubcategoryEditor(
    BuildContext context,
    WidgetRef ref,
    Subcategory sub,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _DescriptionEditorDialog(
        title: l10n.subcategoryEditDescriptionTitle,
        label: l10n.categoryDescriptionLabel,
        initialText: sub.description ?? '',
        onSave: (text) => ref
            .read(categoryRepositoryProvider)
            .setSubcategoryDescription(sub.id, text),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subsAsync = ref.watch(
      subcategoriesForCategoryProvider(category.id),
    );
    final catDesc = category.description?.trim();
    final parentColor = categoryAccentColor(category.id);

    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        leading: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: parentColor,
            shape: BoxShape.circle,
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text(category.name)),
            IconButton(
              tooltip: l10n.categoryEditDescriptionTooltip,
              icon: const Icon(Icons.edit_outlined),
              visualDensity: VisualDensity.compact,
              onPressed: () => _openCategoryEditor(context, ref, category),
            ),
          ],
        ),
        subtitle: catDesc != null && catDesc.isNotEmpty
            ? Text(
                catDesc,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              )
            : null,
        children: subsAsync.when(
          data: (subs) {
            final n = subs.length;
            return subs.asMap().entries.map((e) {
              final i = e.key;
              final s = e.value;
              final subDesc = s.description?.trim();
              final tone = subcategoryTonalColor(parentColor, i, n);
              return ListTile(
                dense: true,
                leading: Container(
                  width: 8,
                  height: 32,
                  decoration: BoxDecoration(
                    color: tone,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Text(s.name),
                subtitle: subDesc != null && subDesc.isNotEmpty
                    ? Text(
                        subDesc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: l10n.categoryEditDescriptionTooltip,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      visualDensity: VisualDensity.compact,
                      onPressed: () =>
                          _openSubcategoryEditor(context, ref, s),
                    ),
                    if (!s.isSystemReserved)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        visualDensity: VisualDensity.compact,
                        onPressed: () async {
                          try {
                            await ref
                                .read(categoryRepositoryProvider)
                                .deleteSubcategory(s.id);
                          } on ReservedSubcategoryException {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.cannotDeleteReservedSubcategory,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                  ],
                ),
              );
            }).toList();
          },
          loading: () => [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
          error: (e, _) => [
            ListTile(title: Text('$e')),
          ],
        ),
      ),
    );
  }
}

class _IncomeCategoryExpansionTile extends ConsumerWidget {
  const _IncomeCategoryExpansionTile({required this.category});

  final IncomeCategory category;

  static Future<void> _openCategoryEditor(
    BuildContext context,
    WidgetRef ref,
    IncomeCategory category,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _DescriptionEditorDialog(
        title: l10n.categoryEditDescriptionTitle,
        label: l10n.categoryDescriptionLabel,
        initialText: category.description ?? '',
        onSave: (text) => ref
            .read(incomeTaxonomyRepositoryProvider)
            .setIncomeCategoryDescription(category.id, text),
      ),
    );
  }

  static Future<void> _openSubcategoryEditor(
    BuildContext context,
    WidgetRef ref,
    IncomeSubcategory sub,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _DescriptionEditorDialog(
        title: l10n.subcategoryEditDescriptionTitle,
        label: l10n.categoryDescriptionLabel,
        initialText: sub.description ?? '',
        onSave: (text) => ref
            .read(incomeTaxonomyRepositoryProvider)
            .setIncomeSubcategoryDescription(sub.id, text),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subsAsync = ref.watch(
      incomeSubcategoriesForCategoryProvider(category.id),
    );
    final catDesc = category.description?.trim();
    final parentColor = categoryAccentColor(category.id);

    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        leading: Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: parentColor,
            shape: BoxShape.circle,
          ),
        ),
        title: Row(
          children: [
            Expanded(child: Text(category.name)),
            IconButton(
              tooltip: l10n.categoryEditDescriptionTooltip,
              icon: const Icon(Icons.edit_outlined),
              visualDensity: VisualDensity.compact,
              onPressed: () => _openCategoryEditor(context, ref, category),
            ),
          ],
        ),
        subtitle: catDesc != null && catDesc.isNotEmpty
            ? Text(
                catDesc,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              )
            : null,
        children: subsAsync.when(
          data: (subs) {
            final n = subs.length;
            return subs.asMap().entries.map((e) {
              final i = e.key;
              final s = e.value;
              final subDesc = s.description?.trim();
              final tone = subcategoryTonalColor(parentColor, i, n);
              return ListTile(
                dense: true,
                leading: Container(
                  width: 8,
                  height: 32,
                  decoration: BoxDecoration(
                    color: tone,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
                title: Text(s.name),
                subtitle: subDesc != null && subDesc.isNotEmpty
                    ? Text(
                        subDesc,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      )
                    : null,
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      tooltip: l10n.categoryEditDescriptionTooltip,
                      icon: const Icon(Icons.edit_outlined, size: 20),
                      visualDensity: VisualDensity.compact,
                      onPressed: () =>
                          _openSubcategoryEditor(context, ref, s),
                    ),
                    if (!s.isSystemReserved)
                      IconButton(
                        icon: const Icon(Icons.delete_outline, size: 20),
                        visualDensity: VisualDensity.compact,
                        onPressed: () async {
                          try {
                            await ref
                                .read(incomeTaxonomyRepositoryProvider)
                                .deleteIncomeSubcategory(s.id);
                          } on ReservedSubcategoryException {
                            if (context.mounted) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    l10n.cannotDeleteReservedSubcategory,
                                  ),
                                ),
                              );
                            }
                          }
                        },
                      ),
                  ],
                ),
              );
            }).toList();
          },
          loading: () => [
            const Padding(
              padding: EdgeInsets.all(16),
              child: Center(child: CircularProgressIndicator()),
            ),
          ],
          error: (e, _) => [
            ListTile(title: Text('$e')),
          ],
        ),
      ),
    );
  }
}
