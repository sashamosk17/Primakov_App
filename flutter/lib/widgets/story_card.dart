/// Story Card Widget - Исправленная версия без overflow
import 'package:flutter/material.dart';
import '../models/api_models.dart';

class StoryCard extends StatelessWidget {
  final Story story;
  final VoidCallback? onTap;

  const StoryCard({
    Key? key,
    required this.story,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isViewed = story.viewedBy.isNotEmpty;
    final hasImage = story.imageUrl != null && story.imageUrl!.isNotEmpty;
    final hasVideo = story.videoUrl != null && story.videoUrl!.isNotEmpty;
    
    final displayType = hasImage ? 'image' : (hasVideo ? 'video' : 'text');

    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 80,
        // 🔥 Увеличиваем высоту, чтобы всё влезло
        child: Column(
          mainAxisSize: MainAxisSize.min, // 🔥 Важно: не растягивать на всю высоту
          children: [
            // Аватар/превью
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isViewed ? const Color(0xFF999999) : const Color(0xFF1976D2),
                  width: 2,
                ),
                gradient: !hasImage && !hasVideo
                    ? const LinearGradient(
                        colors: [Color(0xFF1976D2), Color(0xFF42A5F5)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      )
                    : null,
              ),
              child: ClipOval(
                child: hasImage
                    ? Image.network(
                        story.imageUrl!,
                        fit: BoxFit.cover,
                        width: 70,
                        height: 70,
                        errorBuilder: (context, error, stackTrace) {
                          return _buildPlaceholder(displayType);
                        },
                      )
                    : _buildPlaceholder(displayType),
              ),
            ),
            const SizedBox(height: 6),
            
            // Заголовок - ограничиваем 2 строками
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 32),
              child: Text(
                story.title,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: isViewed ? FontWeight.normal : FontWeight.w600,
                  color: isViewed ? const Color(0xFF999999) : const Color(0xFF333333),
                ),
              ),
            ),
            
            // Индикатор "Новое" - показываем только если не просмотрено
            if (!isViewed) ...[
              const SizedBox(height: 2),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                decoration: BoxDecoration(
                  color: const Color(0xFF1976D2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Text(
                  'NEW',
                  style: TextStyle(
                    fontSize: 7,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildPlaceholder(String type) {
    return Container(
      width: 70,
      height: 70,
      color: const Color(0xFFE0E0E0),
      child: Icon(
        type == 'video' ? Icons.videocam : Icons.newspaper,
        size: 28,
        color: const Color(0xFF999999),
      ),
    );
  }
}