import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/book.dart';
import '../theme/app_colors.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback? onTap;

  const BookCard({
    super.key,
    required this.book,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    // Soft Card UI: White surface, soft shadow, rounded corners
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Cover Image (Expanded)
                Expanded(
                  flex: 3,
                  child: Stack(
                    fit: StackFit.expand,
                    children: [
                      if (book.cover != null && book.cover!.isNotEmpty)
                        CachedNetworkImage(
                          imageUrl: book.cover!,
                          fit: BoxFit.cover,
                          errorWidget: (context, url, error) => _buildPlaceholder(),
                          placeholder: (context, url) => _buildShimmer(),
                        )
                      else
                        _buildPlaceholder(),
                    ],
                  ),
                ),

                // 2. Info Content
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Level 2: Category/Tag (Orange, Small) - ABOVE Title
                        _buildMetaRow(),
                        
                        const SizedBox(height: 4),

                        // Level 1: Title (Black, Bold, Large)
                        Expanded(
                          child: Text(
                            book.title,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              height: 1.2,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        
                        // Level 3: Author (Grey, Secondary)
                        if (book.author != null && book.author!.isNotEmpty)
                          Text(
                            book.author!,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              fontSize: 11,
                            ),
                          ),
                          
                        const SizedBox(height: 8),

                        // Level 3: Bottom row (Stars/Size)
                        _buildBottomRow(),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  
  /// Build the top meta row (extension + year)
  Widget _buildMetaRow() {
    final hasExtension = book.extension != null && book.extension!.isNotEmpty;
    final hasYear = book.year != null && book.year != 0;
    
    if (!hasExtension && !hasYear) {
      // Return a minimal spacer if no meta info available
      return const SizedBox(height: 12);
    }
    
    return Row(
      children: [
        if (hasExtension)
          Text(
            book.extension!.toUpperCase(),
            style: const TextStyle(
              color: AppColors.accent,
              fontSize: 10,
              fontWeight: FontWeight.bold,
              letterSpacing: 0.5,
            ),
          ),
        if (hasExtension && hasYear)
          const SizedBox(width: 4),
        if (hasYear)
          Text(
            hasExtension ? '• ${book.year}' : '${book.year}',
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 10,
            ),
          ),
      ],
    );
  }
  
  /// Build the bottom row (rating + filesize)
  Widget _buildBottomRow() {
    final hasScore = book.interestScore != null && book.interestScore!.isNotEmpty;
    final hasSize = book.filesizeString != null && book.filesizeString!.isNotEmpty;
    
    if (!hasScore && !hasSize) {
      // Show nothing if no data available
      return const SizedBox.shrink();
    }
    
    return Row(
      children: [
        if (hasScore) ...[
          const Icon(Icons.star_rounded, size: 14, color: AppColors.accent),
          const SizedBox(width: 4),
          Text(
            book.interestScore!,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
        ],
        const Spacer(),
        if (hasSize)
          Text(
            book.filesizeString!,
            style: const TextStyle(
              fontSize: 10,
              color: AppColors.textSecondary,
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      color: Colors.grey[200],
      child: const Center(
        child: Icon(Icons.book_outlined, color: Colors.grey, size: 32),
      ),
    );
  }
  
  Widget _buildShimmer() {
    return Container(color: Colors.grey[100]);
  }
}
