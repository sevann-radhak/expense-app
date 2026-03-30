import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/providers/providers.dart';
import 'package:expense_app/presentation/theme/app_icons.dart';
import 'package:expense_app/presentation/theme/category_accent_colors.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    return DefaultTabController(
      length: 2,
      child: Builder(
        builder: (ctx) {
          final tab = DefaultTabController.of(ctx);
          return ListenableBuilder(
            listenable: tab,
            builder: (ctx2, _) {
              return Scaffold(
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
                floatingActionButton: FloatingActionButton.extended(
                  onPressed: () {
                    if (tab.index == 0) {
                      _showNewExpenseCategoryDialog(ctx2, ref);
                    } else {
                      _showNewIncomeCategoryDialog(ctx2, ref);
                    }
                  },
                  icon: Icon(AppIcons.add),
                  label: Text(l10n.taxonomyAddCategoryFab),
                ),
                body: TabBarView(
                  children: [
                    _ExpenseCategoriesTabBody(),
                    _IncomeCategoriesTabBody(),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}

Future<void> _showNewExpenseCategoryDialog(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  await showDialog<void>(
    context: context,
    builder: (ctx) => _TaxonomyFieldsDialog(
      title: l10n.taxonomyNewCategoryTitle,
      initialName: '',
      initialDescription: '',
      onSave: (name, description) async {
        await ref.read(categoryRepositoryProvider).createCategory(
              name: name,
              description: description.isEmpty ? null : description,
            );
      },
    ),
  );
}

Future<void> _showNewIncomeCategoryDialog(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  await showDialog<void>(
    context: context,
    builder: (ctx) => _TaxonomyFieldsDialog(
      title: l10n.taxonomyNewCategoryTitle,
      initialName: '',
      initialDescription: '',
      onSave: (name, description) async {
        await ref.read(incomeTaxonomyRepositoryProvider).createIncomeCategory(
              name: name,
              description: description.isEmpty ? null : description,
            );
      },
    ),
  );
}

class _TaxonomyFieldsDialog extends StatefulWidget {
  const _TaxonomyFieldsDialog({
    required this.title,
    required this.initialName,
    required this.initialDescription,
    required this.onSave,
  });

  final String title;
  final String initialName;
  final String initialDescription;
  final Future<void> Function(String name, String description) onSave;

  @override
  State<_TaxonomyFieldsDialog> createState() => _TaxonomyFieldsDialogState();
}

class _TaxonomyFieldsDialogState extends State<_TaxonomyFieldsDialog> {
  late final TextEditingController _name =
      TextEditingController(text: widget.initialName);
  late final TextEditingController _desc =
      TextEditingController(text: widget.initialDescription);
  var _busy = false;

  @override
  void dispose() {
    _name.dispose();
    _desc.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return AlertDialog(
      title: Text(widget.title),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: _name,
              enabled: !_busy,
              decoration: InputDecoration(labelText: l10n.taxonomyNameLabel),
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _desc,
              enabled: !_busy,
              maxLines: 3,
              decoration: InputDecoration(labelText: l10n.categoryDescriptionLabel),
            ),
          ],
        ),
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
                  final n = _name.text.trim();
                  if (n.isEmpty) {
                    return;
                  }
                  setState(() => _busy = true);
                  try {
                    await widget.onSave(n, _desc.text.trim());
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

int _cmpTaxonomyActive<T>(T a, T b, bool Function(T) isActive, int Function(T) sort) {
  final aa = isActive(a);
  final ba = isActive(b);
  if (aa != ba) {
    return aa ? -1 : 1;
  }
  return sort(a).compareTo(sort(b));
}

class _ExpenseCategoriesTabBody extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(categoriesStreamProvider);
    return categoriesAsync.when(
      data: (cats) {
        final sorted = [...cats]
          ..sort(
            (a, b) => _cmpTaxonomyActive(
              a,
              b,
              (c) => c.isActive,
              (c) => c.sortOrder,
            ),
          );
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              l10n.categoriesScreenSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            ...sorted.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _ExpenseCategoryExpansionTile(category: c),
              ),
            ),
          ],
        );
      },
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
      data: (cats) {
        final sorted = [...cats]
          ..sort(
            (a, b) => _cmpTaxonomyActive(
              a,
              b,
              (c) => c.isActive,
              (c) => c.sortOrder,
            ),
          );
        return ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text(
              l10n.categoriesIncomeScreenSubtitle,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            const SizedBox(height: 16),
            ...sorted.map(
              (c) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _IncomeCategoryExpansionTile(category: c),
              ),
            ),
          ],
        );
      },
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('$e')),
    );
  }
}

class _ExpenseCategoryExpansionTile extends ConsumerStatefulWidget {
  const _ExpenseCategoryExpansionTile({required this.category});

  final Category category;

  @override
  ConsumerState<_ExpenseCategoryExpansionTile> createState() =>
      _ExpenseCategoryExpansionTileState();

  static Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _TaxonomyFieldsDialog(
        title: l10n.taxonomyEditCategoryTitle,
        initialName: category.name,
        initialDescription: category.description ?? '',
        onSave: (name, description) async {
          final repo = ref.read(categoryRepositoryProvider);
          await repo.setCategoryName(category.id, name);
          await repo.setCategoryDescription(
            category.id,
            description.isEmpty ? null : description,
          );
        },
      ),
    );
  }

  static Future<void> _confirmDeactivateCategory(
    BuildContext context,
    WidgetRef ref,
    Category category,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.taxonomyDeactivateCategoryTitle),
        content: Text(l10n.taxonomyDeactivateCategoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirmDelete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref.read(categoryRepositoryProvider).deactivateCategory(category.id);
    }
  }

  static Future<void> _showNewSubcategory(
    BuildContext context,
    WidgetRef ref,
    String categoryId,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _TaxonomyFieldsDialog(
        title: l10n.taxonomyNewSubcategoryTitle,
        initialName: '',
        initialDescription: '',
        onSave: (name, description) async {
          await ref.read(categoryRepositoryProvider).createSubcategory(
                categoryId: categoryId,
                name: name,
                description: description.isEmpty ? null : description,
              );
        },
      ),
    );
  }

  static Future<void> _openSubEditor(
    BuildContext context,
    WidgetRef ref,
    Subcategory sub,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _TaxonomyFieldsDialog(
        title: l10n.taxonomyEditSubcategoryTitle,
        initialName: sub.name,
        initialDescription: sub.description ?? '',
        onSave: (name, description) async {
          final repo = ref.read(categoryRepositoryProvider);
          await repo.setSubcategoryName(sub.id, name);
          await repo.setSubcategoryDescription(
            sub.id,
            description.isEmpty ? null : description,
          );
        },
      ),
    );
  }

  static Future<void> _confirmDeactivateSub(
    BuildContext context,
    WidgetRef ref,
    Subcategory sub,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.taxonomyDeactivateSubcategoryTitle),
        content: Text(l10n.taxonomyDeactivateSubcategoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirmDelete),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        await ref.read(categoryRepositoryProvider).deleteSubcategory(sub.id);
      } on ReservedSubcategoryException {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.cannotDeleteReservedSubcategory)),
          );
        }
      }
    }
  }
}

class _ExpenseCategoryExpansionTileState
    extends ConsumerState<_ExpenseCategoryExpansionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final l10n = AppLocalizations.of(context)!;
    final subsAsync = ref.watch(
      subcategoriesForCategoryProvider(category.id),
    );
    final catDesc = category.description?.trim();
    final parentColor = categoryAccentColor(category.id);
    final chevronColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Opacity(
      opacity: category.isActive ? 1 : 0.72,
      child: Card(
        margin: EdgeInsets.zero,
        child: ExpansionTile(
          onExpansionChanged: (expanded) => setState(() => _expanded = expanded),
          trailing: AnimatedRotation(
            turns: _expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: Icon(AppIcons.caretDown, size: 22, color: chevronColor),
          ),
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
              Expanded(
                child: Text(
                  category.isActive
                      ? category.name
                      : '${category.name} ${l10n.taxonomyInactiveLabel}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: l10n.categoryEditDescriptionTooltip,
                icon: Icon(AppIcons.edit),
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    _ExpenseCategoryExpansionTile._openEditor(context, ref, category),
              ),
              if (category.isActive)
                IconButton(
                  tooltip: l10n.taxonomyDeactivateCategoryTooltip,
                  icon: Icon(AppIcons.hideDeactivate),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _ExpenseCategoryExpansionTile._confirmDeactivateCategory(
                        context,
                        ref,
                        category,
                      ),
                )
              else
                IconButton(
                  tooltip: l10n.taxonomyReactivateTooltip,
                  icon: Icon(AppIcons.restore),
                  visualDensity: VisualDensity.compact,
                  onPressed: () =>
                      ref.read(categoryRepositoryProvider).reactivateCategory(category.id),
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
              final sorted = [...subs]
                ..sort(
                  (a, b) => _cmpTaxonomyActive(
                    a,
                    b,
                    (s) => s.isActive,
                    (s) => s.sortOrder,
                  ),
                );
              final tiles = sorted.asMap().entries.map((e) {
                final i = e.key;
                final s = e.value;
                final n = sorted.length;
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
                  title: Text(
                    s.isActive ? s.name : '${s.name} ${l10n.taxonomyInactiveLabel}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                        icon: Icon(AppIcons.edit, size: 20),
                        visualDensity: VisualDensity.compact,
                        onPressed: () =>
                            _ExpenseCategoryExpansionTile._openSubEditor(context, ref, s),
                      ),
                      if (!s.isSystemReserved)
                        s.isActive
                            ? IconButton(
                                tooltip: l10n.taxonomyDeactivateSubcategoryTooltip,
                                icon: Icon(AppIcons.hideDeactivate, size: 20),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _ExpenseCategoryExpansionTile
                                    ._confirmDeactivateSub(context, ref, s),
                              )
                            : IconButton(
                                tooltip: l10n.taxonomyReactivateTooltip,
                                icon: Icon(AppIcons.restore, size: 20),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => ref
                                    .read(categoryRepositoryProvider)
                                    .reactivateSubcategory(s.id),
                              ),
                    ],
                  ),
                );
              }).toList();
              return [
                ...tiles,
                if (category.isActive)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _ExpenseCategoryExpansionTile._showNewSubcategory(
                            context,
                            ref,
                            category.id,
                          ),
                      icon: Icon(AppIcons.add, size: 20),
                      label: Text(l10n.taxonomyAddSubcategoryButton),
                    ),
                  ),
              ];
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
      ),
    );
  }
}

class _IncomeCategoryExpansionTile extends ConsumerStatefulWidget {
  const _IncomeCategoryExpansionTile({required this.category});

  final IncomeCategory category;

  @override
  ConsumerState<_IncomeCategoryExpansionTile> createState() =>
      _IncomeCategoryExpansionTileState();

  static Future<void> _openEditor(
    BuildContext context,
    WidgetRef ref,
    IncomeCategory category,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _TaxonomyFieldsDialog(
        title: l10n.taxonomyEditCategoryTitle,
        initialName: category.name,
        initialDescription: category.description ?? '',
        onSave: (name, description) async {
          final repo = ref.read(incomeTaxonomyRepositoryProvider);
          await repo.setIncomeCategoryName(category.id, name);
          await repo.setIncomeCategoryDescription(
            category.id,
            description.isEmpty ? null : description,
          );
        },
      ),
    );
  }

  static Future<void> _confirmDeactivateCategory(
    BuildContext context,
    WidgetRef ref,
    IncomeCategory category,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.taxonomyDeactivateIncomeCategoryTitle),
        content: Text(l10n.taxonomyDeactivateIncomeCategoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirmDelete),
          ),
        ],
      ),
    );
    if (ok == true) {
      await ref
          .read(incomeTaxonomyRepositoryProvider)
          .deactivateIncomeCategory(category.id);
    }
  }

  static Future<void> _showNewSubcategory(
    BuildContext context,
    WidgetRef ref,
    String categoryId,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _TaxonomyFieldsDialog(
        title: l10n.taxonomyNewSubcategoryTitle,
        initialName: '',
        initialDescription: '',
        onSave: (name, description) async {
          await ref.read(incomeTaxonomyRepositoryProvider).createIncomeSubcategory(
                categoryId: categoryId,
                name: name,
                description: description.isEmpty ? null : description,
              );
        },
      ),
    );
  }

  static Future<void> _openSubEditor(
    BuildContext context,
    WidgetRef ref,
    IncomeSubcategory sub,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    await showDialog<void>(
      context: context,
      builder: (ctx) => _TaxonomyFieldsDialog(
        title: l10n.taxonomyEditSubcategoryTitle,
        initialName: sub.name,
        initialDescription: sub.description ?? '',
        onSave: (name, description) async {
          final repo = ref.read(incomeTaxonomyRepositoryProvider);
          await repo.setIncomeSubcategoryName(sub.id, name);
          await repo.setIncomeSubcategoryDescription(
            sub.id,
            description.isEmpty ? null : description,
          );
        },
      ),
    );
  }

  static Future<void> _confirmDeactivateSub(
    BuildContext context,
    WidgetRef ref,
    IncomeSubcategory sub,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.taxonomyDeactivateIncomeSubcategoryTitle),
        content: Text(l10n.taxonomyDeactivateIncomeSubcategoryMessage),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(l10n.cancel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.confirmDelete),
          ),
        ],
      ),
    );
    if (ok == true) {
      try {
        await ref.read(incomeTaxonomyRepositoryProvider).deleteIncomeSubcategory(sub.id);
      } on ReservedSubcategoryException {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(l10n.cannotDeleteReservedSubcategory)),
          );
        }
      }
    }
  }
}

class _IncomeCategoryExpansionTileState
    extends ConsumerState<_IncomeCategoryExpansionTile> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final category = widget.category;
    final l10n = AppLocalizations.of(context)!;
    final subsAsync = ref.watch(
      incomeSubcategoriesForCategoryProvider(category.id),
    );
    final catDesc = category.description?.trim();
    final parentColor = categoryAccentColor(category.id);
    final chevronColor = Theme.of(context).colorScheme.onSurfaceVariant;

    return Opacity(
      opacity: category.isActive ? 1 : 0.72,
      child: Card(
        margin: EdgeInsets.zero,
        child: ExpansionTile(
          onExpansionChanged: (expanded) => setState(() => _expanded = expanded),
          trailing: AnimatedRotation(
            turns: _expanded ? 0.5 : 0,
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            child: Icon(AppIcons.caretDown, size: 22, color: chevronColor),
          ),
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
              Expanded(
                child: Text(
                  category.isActive
                      ? category.name
                      : '${category.name} ${l10n.taxonomyInactiveLabel}',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                tooltip: l10n.categoryEditDescriptionTooltip,
                icon: Icon(AppIcons.edit),
                visualDensity: VisualDensity.compact,
                onPressed: () =>
                    _IncomeCategoryExpansionTile._openEditor(context, ref, category),
              ),
              if (category.isActive)
                IconButton(
                  tooltip: l10n.taxonomyDeactivateCategoryTooltip,
                  icon: Icon(AppIcons.hideDeactivate),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => _IncomeCategoryExpansionTile._confirmDeactivateCategory(
                        context,
                        ref,
                        category,
                      ),
                )
              else
                IconButton(
                  tooltip: l10n.taxonomyReactivateTooltip,
                  icon: Icon(AppIcons.restore),
                  visualDensity: VisualDensity.compact,
                  onPressed: () => ref
                      .read(incomeTaxonomyRepositoryProvider)
                      .reactivateIncomeCategory(category.id),
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
              final sorted = [...subs]
                ..sort(
                  (a, b) => _cmpTaxonomyActive(
                    a,
                    b,
                    (s) => s.isActive,
                    (s) => s.sortOrder,
                  ),
                );
              final tiles = sorted.asMap().entries.map((e) {
                final i = e.key;
                final s = e.value;
                final n = sorted.length;
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
                  title: Text(
                    s.isActive ? s.name : '${s.name} ${l10n.taxonomyInactiveLabel}',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
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
                        icon: Icon(AppIcons.edit, size: 20),
                        visualDensity: VisualDensity.compact,
                        onPressed: () =>
                            _IncomeCategoryExpansionTile._openSubEditor(context, ref, s),
                      ),
                      if (!s.isSystemReserved)
                        s.isActive
                            ? IconButton(
                                tooltip: l10n.taxonomyDeactivateSubcategoryTooltip,
                                icon: Icon(AppIcons.hideDeactivate, size: 20),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => _IncomeCategoryExpansionTile
                                    ._confirmDeactivateSub(context, ref, s),
                              )
                            : IconButton(
                                tooltip: l10n.taxonomyReactivateTooltip,
                                icon: Icon(AppIcons.restore, size: 20),
                                visualDensity: VisualDensity.compact,
                                onPressed: () => ref
                                    .read(incomeTaxonomyRepositoryProvider)
                                    .reactivateIncomeSubcategory(s.id),
                              ),
                    ],
                  ),
                );
              }).toList();
              return [
                ...tiles,
                if (category.isActive)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton.icon(
                      onPressed: () => _IncomeCategoryExpansionTile._showNewSubcategory(
                            context,
                            ref,
                            category.id,
                          ),
                      icon: Icon(AppIcons.add, size: 20),
                      label: Text(l10n.taxonomyAddSubcategoryButton),
                    ),
                  ),
              ];
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
      ),
    );
  }
}
