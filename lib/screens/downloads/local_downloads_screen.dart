import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:open_filex/open_filex.dart';
import 'package:share_plus/share_plus.dart';
import '../../providers/download_provider.dart';
import '../../widgets/empty_state.dart';
import '../../theme/app_colors.dart';
import '../../l10n/app_localizations.dart';

/// Check if platform supports opening folder in file manager
bool get _canOpenFolder {
  if (kIsWeb) return false;
  return Platform.isWindows || Platform.isMacOS || Platform.isLinux;
}

class LocalDownloadsScreen extends ConsumerWidget {
  const LocalDownloadsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 2 Tabs: Ongoing (Downloading) / Completed
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          title: Text(AppLocalizations.of(context).get('downloads'), style: const TextStyle(color: AppColors.textPrimary, fontWeight: FontWeight.bold)),
          centerTitle: true,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(60),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
              height: 40,
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(20),
              ),
              child: TabBar(
                indicator: BoxDecoration(
                  color: AppColors.primary, // Dark Teal
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withOpacity(0.3),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.white,
                unselectedLabelColor: AppColors.textSecondary,
                labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                dividerColor: Colors.transparent,
                tabs: [
                  Tab(text: AppLocalizations.of(context).get('ongoing')),
                  Tab(text: AppLocalizations.of(context).get('completed')),
                ],
              ),
            ),
          ),
        ),
        body: const TabBarView(
          children: [
            _OngoingDownloads(),
            _CompletedDownloads(),
          ],
        ),
      ),
    );
  }
}

class _OngoingDownloads extends ConsumerWidget {
  const _OngoingDownloads();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(downloadProvider).where((t) => t.status == DownloadStatus.downloading || t.status == DownloadStatus.pending).toList();

    if (tasks.isEmpty) {
      return EmptyState(
        icon: Icons.downloading,
        title: AppLocalizations.of(context).get('no_active_downloads'),
        message: AppLocalizations.of(context).get('downloads_appear_here'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) => _DownloadItem(task: tasks[index]),
    );
  }
}

class _CompletedDownloads extends ConsumerWidget {
  const _CompletedDownloads();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tasks = ref.watch(downloadProvider).where((t) => t.status == DownloadStatus.completed || t.status == DownloadStatus.error).toList(); // Include errors here or separate? Usually errors act as stopped.

    if (tasks.isEmpty) {
      return EmptyState(
        icon: Icons.check_circle_outline,
        title: AppLocalizations.of(context).get('no_completed_downloads'),
        message: AppLocalizations.of(context).get('downloaded_books_here'),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: tasks.length,
      itemBuilder: (context, index) => _DownloadItem(task: tasks[index]),
    );
  }
}

class _DownloadItem extends ConsumerWidget {
  final DownloadTask task;

  const _DownloadItem({required this.task});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDownloading = task.status == DownloadStatus.downloading;
    final isError = task.status == DownloadStatus.error;
    final isCompleted = task.status == DownloadStatus.completed;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: InkWell(
        onTap: isCompleted && task.filePath != null && _canOpenFolder
            ? () => _openFolder(context, task.filePath!)
            : null,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Cover
              Container(
                width: 50,
                height: 75,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Colors.grey[100],
                  image: task.book.cover != null
                      ? DecorationImage(
                          image: NetworkImage(task.book.cover!),
                          fit: BoxFit.cover,
                        )
                      : null,
                ),
                child: task.book.cover == null ? const Icon(Icons.book, color: Colors.grey) : null,
              ),
              const SizedBox(width: 16),
              
              // Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      task.book.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      task.book.author ?? 'Unknown',
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 12),
                    
                    // Progress Bar (Multi-color)
                    if (isDownloading) ...[
                      ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: LinearProgressIndicator(
                          value: task.progress,
                          backgroundColor: Colors.grey[100],
                          valueColor: AlwaysStoppedAnimation(
                            task.progress > 0.7 ? AppColors.progressGreen : (task.progress > 0.3 ? AppColors.progressYellow : AppColors.progressOrange),
                          ),
                          minHeight: 6,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${(task.progress * 100).toInt()}% • ${AppLocalizations.of(context).get('downloading')}',
                        style: const TextStyle(fontSize: 10, color: AppColors.textSecondary),
                      ),
                    ] else if (isError) ...[
                      Text(
                        task.error ?? AppLocalizations.of(context).get('error'),
                        style: const TextStyle(color: AppColors.error, fontSize: 11),
                        maxLines: 2, 
                      ),
                    ] else ...[
                       Container(
                         padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                         decoration: BoxDecoration(
                           color: AppColors.success.withOpacity(0.1),
                           borderRadius: BorderRadius.circular(4),
                         ),
                         child: Text(
                           AppLocalizations.of(context).get('completed'),
                           style: const TextStyle(color: AppColors.success, fontSize: 10, fontWeight: FontWeight.bold),
                         ),
                       ),
                    ],
                  ],
                ),
              ),
              
              // Actions
              if (isDownloading)
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: AppColors.textSecondary),
                  onPressed: () => ref.read(downloadProvider.notifier).cancelDownload(task.id),
                ),
                
              if (isCompleted && _canOpenFolder)
                 IconButton(
                  icon: const Icon(Icons.folder_open_rounded, color: AppColors.primary),
                  tooltip: 'Open Folder',
                  onPressed: () {
                     if (task.filePath != null) _openFolder(context, task.filePath!);
                  },
                ),
                
              if (!isDownloading)
                PopupMenuButton<String>(
                  icon: const Icon(Icons.more_vert_rounded, color: AppColors.textSecondary),
                  onSelected: (value) => _handleMenuAction(context, ref, value),
                  itemBuilder: (context) => [
                    if (isCompleted && task.filePath != null) ...[
                      PopupMenuItem(
                        value: 'open',
                        child: Row(
                          children: [
                            const Icon(Icons.open_in_new_rounded, size: 20, color: AppColors.primary),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).get('open_file')),
                          ],
                        ),
                      ),
                      if (_canOpenFolder)
                        PopupMenuItem(
                          value: 'folder',
                          child: Row(
                            children: [
                              const Icon(Icons.folder_open_rounded, size: 20, color: AppColors.primary),
                              const SizedBox(width: 8),
                              Text(AppLocalizations.of(context).get('open_folder')),
                            ],
                          ),
                        ),
                      PopupMenuItem(
                        value: 'share',
                        child: Row(
                          children: [
                            const Icon(Icons.share_rounded, size: 20, color: AppColors.accent),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).get('share')),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: 'copy',
                        child: Row(
                          children: [
                            const Icon(Icons.copy_rounded, size: 20, color: AppColors.textSecondary),
                            const SizedBox(width: 8),
                            Text(AppLocalizations.of(context).get('copy_path')),
                          ],
                        ),
                      ),
                      const PopupMenuDivider(),
                    ],
                    PopupMenuItem(
                      value: 'delete',
                      child: Row(
                        children: [
                          const Icon(Icons.delete_outline, size: 20, color: AppColors.error),
                          const SizedBox(width: 8),
                          Text(AppLocalizations.of(context).get('remove')),
                        ],
                      ),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }

  void _openFolder(BuildContext context, String filePath) {
    // Get parent directory
    final file = File(filePath);
    final folder = file.parent.path;
    OpenFilex.open(folder);
  }

  void _handleMenuAction(BuildContext context, WidgetRef ref, String action) {
    switch (action) {
      case 'open':
        if (task.filePath != null) OpenFilex.open(task.filePath!);
        break;
      case 'folder':
        if (task.filePath != null) _openFolder(context, task.filePath!);
        break;
      case 'share':
        if (task.filePath != null) {
          Share.shareXFiles([XFile(task.filePath!)], text: task.book.title);
        }
        break;
      case 'copy':
        if (task.filePath != null) {
          Clipboard.setData(ClipboardData(text: task.filePath!));
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Path copied to clipboard')),
          );
        }
        break;
      case 'delete':
        ref.read(downloadProvider.notifier).removeTask(task.id);
        break;
    }
  }
}
