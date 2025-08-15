import 'package:flutter/material.dart';
import 'package:myneonacademyapp/models/track_model.dart';

class NowPlayingBar extends StatelessWidget {
  final Track track;
  final bool isPlaying;
  final VoidCallback onPlayPressed;

  const NowPlayingBar({
    super.key,
    required this.track,
    required this.isPlaying,
    required this.onPlayPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.blue[50],
        border: const Border(top: BorderSide(color: Colors.blue)),
      ),
      child: Row(
        children: [
          const Icon(Icons.music_note, color: Colors.blue, size: 36),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  track.trackName,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  track.artistName,
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              isPlaying ? Icons.pause_circle : Icons.play_circle,
              color: Colors.blue,
              size: 40,
            ),
            onPressed: onPlayPressed,
          ),
        ],
      ),
    );
  }
}