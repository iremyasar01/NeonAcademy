import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:myneonacademyapp/models/track_model.dart';

class TrackCard extends StatelessWidget {
  final Track track;
  final bool isPlaying;
  final VoidCallback onPlayPressed;
  final bool isListMode;

  const TrackCard({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onPlayPressed,
    required this.isListMode,
  });

  @override
  Widget build(BuildContext context) {
    final cardColor = isPlaying 
      ? Colors.blue.withOpacity(0.1) 
      : Colors.transparent;

    return Card(
      elevation: 4,
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
                  imageUrl: track.artworkUrl100,
                  width: double.infinity,
                  height: isListMode ? 140 : 120,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: Colors.grey[200],
                    child: const Center(child: CircularProgressIndicator()),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: Colors.grey[200],
                    child: const Icon(Icons.music_note, size: 40),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              
              // Şarkı bilgileri
              Text(
                track.trackName,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                track.artistName,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 12,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              
              // Liste modu için ek detaylar
              if (isListMode) ...[
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      track.durationFormatted,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        isPlaying 
                          ? Icons.pause_circle_filled 
                          : Icons.play_circle_fill,
                        color: Colors.blue,
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