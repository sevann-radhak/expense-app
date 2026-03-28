import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:expense_app/domain/domain.dart';
import 'package:expense_app/l10n/app_localizations.dart';
import 'package:expense_app/presentation/providers/providers.dart';

class CategoriesScreen extends ConsumerWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final categoriesAsync = ref.watch(categoriesStreamProvider);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.navCategories)),
      body: categoriesAsync.when(
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
      ),
    );
  }
}

class _CategoryExpansionTile extends ConsumerWidget {
  const _CategoryExpansionTile({required this.category});

  final Category category;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final subsAsync = ref.watch(
      subcategoriesForCategoryProvider(category.id),
    );

    return Card(
      margin: EdgeInsets.zero,
      child: ExpansionTile(
        title: Text(category.name),
        subtitle: Text(
          category.id,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        children: subsAsync.when(
          data: (subs) => subs
              .map(
                (s) => ListTile(
                  dense: true,
                  title: Text(s.name),
                  subtitle: Text('${s.slug} · ${s.id}'),
                  trailing: s.isSystemReserved
                      ? null
                      : IconButton(
                          icon: const Icon(Icons.delete_outline),
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
                ),
              )
              .toList(),
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
