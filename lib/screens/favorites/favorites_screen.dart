import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../providers/books_provider.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';
import '../../routes/app_routes.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

class FavoritesScreen extends ConsumerWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final savedBooksAsync = ref.watch(savedBooksProvider);

    return Scaffold(
      appBar: GradientAppBar(title: AppLocalizations.of(context).get('favorites')),
      body: savedBooksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return EmptyState(
              icon: Icons.favorite_outline,
              title: AppLocalizations.of(context).get('no_favorites'),
              message: AppLocalizations.of(context).get('save_books_hint'),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              
              return Slidable(
                key: ValueKey(book.id),
                endActionPane: ActionPane(
                  motion: const ScrollMotion(),
                  children: [
                    SlidableAction(
                      onPressed: (context) async {
                        await ref
                            .read(savedBooksProvider.notifier)
                            .unsaveBook(book.id.toString());
                      },
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      icon: Icons.delete,
                      label: AppLocalizations.of(context).get('remove'),
                    ),
                  ],
                ),
                child: Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(12),
                    leading: book.cover != null
                        ? ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              book.cover!,
                              width: 50,
                              height: 70,
                              fit: BoxFit.cover,
                            ),
                          )
                        : Container(
                            width: 50,
                            height: 70,
                            decoration: BoxDecoration(
                              color: AppColors.textSecondary.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(Icons.book),
                          ),
                    title: Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    subtitle: book.author != null
                        ? Text(book.author!)
                        : null,
                    trailing: const Icon(Icons.chevron_right),
                    onTap: () {
                      Navigator.of(context).pushNamed(
                        AppRoutes.bookDetail,
                        arguments: book,
                      );
                    },
                  ),
                ),
              );
            },
          );
        },
        loading: () => LoadingWidget(message: AppLocalizations.of(context).get('loading_favorites')),
        error: (error, stack) => EmptyState(
          icon: Icons.error_outline,
          title: AppLocalizations.of(context).get('error'),
          message: error.toString(),
        ),
      ),
    );
  }
}
