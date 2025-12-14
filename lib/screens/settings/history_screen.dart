import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/books_provider.dart';
import '../../widgets/gradient_app_bar.dart';
import '../../widgets/loading_widget.dart';
import '../../widgets/empty_state.dart';
import '../../routes/app_routes.dart';

class HistoryScreen extends ConsumerWidget {
  const HistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // This provider gets "downloaded" books from account (Cloud history)
    final downloadedBooksAsync = ref.watch(downloadedBooksProvider);

    return Scaffold(
      appBar: const GradientAppBar(title: 'Download History'),
      body: downloadedBooksAsync.when(
        data: (books) {
          if (books.isEmpty) {
            return const EmptyState(
              icon: Icons.history,
              title: 'No history',
              message: 'Books you downloaded on other devices will appear here',
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              
              return Card(
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
                      : const Icon(Icons.book, size: 50),
                  title: Text(
                    book.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (book.author != null) Text(book.author!),
                      if (book.filesizeString != null)
                        Text(
                          '${book.extension?.toUpperCase()} • ${book.filesizeString}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                    ],
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).pushNamed(
                      AppRoutes.bookDetail,
                      arguments: book,
                    );
                  },
                ),
              );
            },
          );
        },
        loading: () => const LoadingWidget(message: 'Loading downloads...'),
        error: (error, stack) => EmptyState(
          icon: Icons.error_outline,
          title: 'Error',
          message: error.toString(),
        ),
      ),
    );
  }
}
