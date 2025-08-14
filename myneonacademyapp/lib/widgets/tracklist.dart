class Track {
  final String trackName;
  final String artistName;
  final String artworkUrl100;
  final String previewUrl;
  final String collectionName;
  final int trackTimeMillis;

  Track({
    required this.trackName,
    required this.artistName,
    required this.artworkUrl100,
    required this.previewUrl,
    required this.collectionName,
    required this.trackTimeMillis,
  });

  factory Track.fromJson(Map<String, dynamic> json) {
    return Track(
      trackName: json['trackName'] ?? 'Unknown Track',
      artistName: json['artistName'] ?? 'Unknown Artist',
      artworkUrl100: json['artworkUrl100'] ?? '',
      previewUrl: json['previewUrl'] ?? '',
      collectionName: json['collectionName'] ?? 'Unknown Album',
      trackTimeMillis: json['trackTimeMillis'] ?? 0,
    );
  }

  String get durationFormatted {
    final duration = Duration(milliseconds: trackTimeMillis);
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}