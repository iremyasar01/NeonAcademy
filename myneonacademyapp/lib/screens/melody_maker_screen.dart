import 'package:flutter/material.dart';
import 'package:myneonacademyapp/models/track_model.dart';
import 'package:myneonacademyapp/services/audio_service.dart';
import 'package:myneonacademyapp/services/music_api_service.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MelodyMakerScreen extends StatefulWidget {
  const MelodyMakerScreen({super.key});

  @override
  State<MelodyMakerScreen> createState() => _MelodyMakerScreenState();
}

class _MelodyMakerScreenState extends State<MelodyMakerScreen> {
  final MusicApiService _musicService = MusicApiService();
  final AudioPlayerService _audioService = AudioPlayerService();
  final TextEditingController _searchController = TextEditingController();
  
  List<Track> _tracks = [];
  bool _isLoading = false;
  String? _currentlyPlayingUrl;
  bool _isPlaying = false;
  String _searchTerm = '';

  void _search() async {
    if (_searchController.text.isEmpty) return;
    
    // Önceki oynatmayı durdur
    await _audioService.stopPreview();
    setState(() {
      _currentlyPlayingUrl = null;
      _isPlaying = false;
      _searchTerm = _searchController.text;
    });

    setState(() => _isLoading = true);
    
    try {
      final results = await _musicService.searchTracks(_searchTerm);
      setState(() => _tracks = results);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _handlePlayPressed(String url) async {
    if (_currentlyPlayingUrl == url) {
      // Aynı parçaya basıldı: Play/Pause toggle
      if (_isPlaying) {
        await _audioService.pausePreview();
        setState(() => _isPlaying = false);
      } else {
        await _audioService.playPreview(url);
        setState(() => _isPlaying = true);
      }
    } else {
      // Yeni parça seçildi
      await _audioService.stopPreview();
      await _audioService.playPreview(url);
      setState(() {
        _currentlyPlayingUrl = url;
        _isPlaying = true;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _tracks = [];
      _currentlyPlayingUrl = null;
      _isPlaying = false;
      _searchTerm = '';
    });
    _audioService.stopPreview();
  }

  @override
  void dispose() {
    _audioService.dispose();
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MelodyMaker'),
        actions: [
          if (_searchTerm.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
            ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      labelText: 'Artist, Song or Album',
                      prefixIcon: const Icon(Icons.search),
                      suffixIcon: _searchController.text.isNotEmpty
                          ? IconButton(
                              icon: const Icon(Icons.clear),
                              onPressed: _clearSearch,
                            )
                          : null,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10.0),
                      ),
                      filled: true,
                      fillColor: Colors.grey[200],
                    ),
                    onSubmitted: (_) => _search(),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton.icon(
                  icon: const Icon(Icons.search),
                  label: const Text('Search'),
                  onPressed: _search,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (_searchTerm.isNotEmpty && !_isLoading)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                children: [
                  Text(
                    'Results for "$_searchTerm"',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const Spacer(),
                  Text(
                    '${_tracks.length} tracks',
                    style: const TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 10),
          _isLoading
              ? Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(),
                        const SizedBox(height: 20),
                        Text('Searching for "$_searchTerm"...'),
                      ],
                    ),
                  ),
                )
              : _tracks.isEmpty
                  ? const Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                             Icon(Icons.music_note, size: 80, color: Colors.grey),
                             SizedBox(height: 20),
                             Text(
                              'Search for your favorite music',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                             SizedBox(height: 10),
                             Text(
                              'Try searching for artists, songs, or albums',
                              style: TextStyle(color: Colors.grey),
                            ),
                          ],
                        ),
                      ),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _tracks.length,
                        itemBuilder: (context, index) {
                          final track = _tracks[index];
                          final isCurrentTrackPlaying = _currentlyPlayingUrl == track.previewUrl && _isPlaying;
                          
                          return ListTile(
                            leading: CachedNetworkImage(
                              imageUrl: track.artworkUrl100,
                              placeholder: (_, __) => const CircularProgressIndicator(),
                              errorWidget: (_, __, ___) => const Icon(Icons.music_note),
                              width: 50,
                              height: 50,
                            ),
                            title: Text(track.trackName),
                            subtitle: Text(track.artistName),
                            trailing: IconButton(
                              icon: Icon(
                                isCurrentTrackPlaying ? Icons.pause : Icons.play_arrow,
                                color: isCurrentTrackPlaying ? Colors.blue : null,
                              ),
                              onPressed: () => _handlePlayPressed(track.previewUrl),
                            ),
                          );
                        },
                      ),
                    ),
        ],
      ),
      bottomNavigationBar: _currentlyPlayingUrl != null
          ? Container(
              height: 70,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                border: const Border(top: BorderSide(color: Colors.blue)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.music_note, color: Colors.blue, size: 30),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _tracks
                              .firstWhere((track) => track.previewUrl == _currentlyPlayingUrl)
                              .trackName,
                          style: const TextStyle(fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          _tracks
                              .firstWhere((track) => track.previewUrl == _currentlyPlayingUrl)
                              .artistName,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      _isPlaying ? Icons.pause_circle : Icons.play_circle,
                      color: Colors.blue,
                      size: 36,
                    ),
                    onPressed: () {
                      if (_currentlyPlayingUrl != null) {
                        _handlePlayPressed(_currentlyPlayingUrl!);
                      }
                    },
                  ),
                ],
              ),
            )
          : null,
    );
  }
}