import 'package:audioplayers/audioplayers.dart';

class AudioPlayerService {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentPlayingUrl;

  Future<void> playPreview(String url) async {
    if (_currentPlayingUrl == url) {
      await _audioPlayer.resume();
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.play(UrlSource(url));
      _currentPlayingUrl = url;
    }
  }

  Future<void> pausePreview() async {
    await _audioPlayer.pause();
  }

  Future<void> stopPreview() async {
    await _audioPlayer.stop();
    _currentPlayingUrl = null;
  }

  void dispose() {
    _audioPlayer.dispose();
  }
}