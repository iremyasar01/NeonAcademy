import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myneonacademyapp/models/track_model.dart';

class TrackCard extends StatelessWidget {
  final Track track; // Parça bilgileri
  final bool isPlaying; // Çalıyor mu?
  final VoidCallback onPlayPressed; // Oynatma butonuna basıldığında
  final bool isListMode; // Liste modu mu yoksa grid mi?

  const TrackCard({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onPlayPressed,
    required this.isListMode,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isPlaying ? Colors.blue.withOpacity(0.08) : Colors.white;

    return Card(
      elevation: 4,
      shadowColor: Colors.black26,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      color: cardColor,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onPlayPressed,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Albüm kapağı
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: CachedNetworkImage(
                  //bunu eklemeyince görseller piksel piksel geliyo.
                  imageUrl:
                      track.artworkUrl100.replaceAll("100x100", "300x300"),
                  width: double.infinity,
                  height: isListMode ? 140 : 140,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: Colors.grey[200],
                    child: const Center(
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.music_note, size: 40),
                  ),
                ),
              ),

              const SizedBox(height: 10),

              // Şarkı ismi
              Text(
                track.trackName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Sanatçı ismi
              Text(
                track.artistName,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),

              // Liste moduna özel ek bilgiler
              if (isListMode) ...[
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Şarkı süresi
                    Text(
                      track.durationFormatted,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),

                    // Oynatma/Duraklat butonu
                    IconButton(
                      icon: Icon(
                        isPlaying
                            ? Icons.pause_circle_filled
                            : Icons.play_circle_fill,
                        color: Colors.blue,
                        size: 28,
                      ),
                      onPressed: onPlayPressed,
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
