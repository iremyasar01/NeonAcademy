import 'package:flutter/material.dart';

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
    // Debug için JSON'u yazdır
    debugPrint('🔄 Track JSON parse ediliyor: ${json['trackName']}');
    
    // trackTimeMillis için güvenli dönüşüm
    dynamic timeValue = json['trackTimeMillis'];
    int trackTime = 0;

    if (timeValue is int) {
      trackTime = timeValue;
    } else if (timeValue is String) {
      trackTime = int.tryParse(timeValue) ?? 0;
    } else if (timeValue is double) {
      trackTime = timeValue.toInt();
    }

    // Preview URL kontrolü
    String previewUrl = json['previewUrl']?.toString() ?? '';
    if (previewUrl.isEmpty) {
      debugPrint('⚠️ Preview URL boş: ${json['trackName']}');
    }

    return Track(
      trackName: json['trackName']?.toString() ?? 'Unknown Track',
      artistName: json['artistName']?.toString() ?? 'Unknown Artist',
      artworkUrl100: json['artworkUrl100']?.toString() ?? '',
      previewUrl: previewUrl,
      collectionName: json['collectionName']?.toString() ?? 'Unknown Album',
      trackTimeMillis: trackTime,
    );
  }

  String get durationFormatted {
    if (trackTimeMillis <= 0) return '0:00';
    final duration = Duration(milliseconds: trackTimeMillis);
    return '${duration.inMinutes}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
  }
}