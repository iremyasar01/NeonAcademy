import 'package:flutter/material.dart';
import 'package:myneonacademyapp/models/track_model.dart';
import 'package:myneonacademyapp/services/audio_service.dart';
import 'package:myneonacademyapp/services/music_api_service.dart';
import 'package:myneonacademyapp/utils/music_result.dart';
import 'package:myneonacademyapp/widgets/empty_state.dart';
import 'package:myneonacademyapp/widgets/music_search_bar.dart';
import 'package:myneonacademyapp/widgets/now_playing_bar.dart';
import 'package:myneonacademyapp/widgets/recommend_header.dart';
import 'package:myneonacademyapp/widgets/track_card.dart';

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
  List<Track> _recommendedTracks = [];
  bool _isLoading = false;
  bool _isRecommendedLoading = false;
  String? _currentlyPlayingUrl;
  bool _isPlaying = false;
  String _searchTerm = '';

  @override
  void initState() {
    super.initState();
    _loadRecommendedTracks();
  }

  // Önerilen parçaları yükle
  void _loadRecommendedTracks() async {
    setState(() => _isRecommendedLoading = true);
    try {
      _recommendedTracks = await _musicService.getRecommendedTracks();
    } catch (e) {
      debugPrint('Önerilen parça yükleme hatası: $e');
    } finally {
      setState(() => _isRecommendedLoading = false);
    }
  }

  // Arama fonksiyonu
  void _search() async {
    if (_searchController.text.isEmpty) return;
    
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
        SnackBar(content: Text('Hata: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  // Oynat/Duraklat fonksiyonu
  void _handlePlayPressed(String url) async {
    if (_currentlyPlayingUrl == url) {
      if (_isPlaying) {
        await _audioService.pausePreview();
        setState(() => _isPlaying = false);
      } else {
        await _audioService.playPreview(url);
        setState(() => _isPlaying = true);
      }
    } else {
      await _audioService.stopPreview();
      await _audioService.playPreview(url);
      setState(() {
        _currentlyPlayingUrl = url;
        _isPlaying = true;
      });
    }
  }

  // Arama temizleme fonksiyonu
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
        title: const Text('MelodyMaker', style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
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
          // Arama çubuğu widget'ı
          SearchBarWidget(
            controller: _searchController,
            onSearch: _search,
            onClear: _clearSearch,
          ),
          
          // Arama sonuçları başlığı
          if (_searchTerm.isNotEmpty && !_isLoading)
            ResultsHeader(searchTerm: _searchTerm, trackCount: _tracks.length),
          
          // Önerilenler başlığı
          if (_searchTerm.isEmpty && !_isRecommendedLoading)
            RecommendedHeader(onRefresh: _loadRecommendedTracks),
          
          const SizedBox(height: 10),
          
          // İçerik alanı
          _buildContentArea()
        ],
      ),
      // Şu anda çalan çubuk
      bottomNavigationBar: _buildNowPlayingBar(),
    );
  }

  // Ana içerik alanını oluştur
  Widget _buildContentArea() {
    if (_isLoading) {
      return _buildLoadingIndicator();
    }
    
    if (_searchTerm.isNotEmpty) {
      return _tracks.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.search_off,
              title: 'No tracks found',
              subtitle: 'Try a different search term',
            )
          : _buildTrackList();
    }
    
    if (_isRecommendedLoading) {
      return const Expanded(child: Center(child: CircularProgressIndicator()));
    }
    
    return _buildRecommendedGrid();
  }

  // Yükleme göstergesi
  Widget _buildLoadingIndicator() {
    return Expanded(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const CircularProgressIndicator(),
            const SizedBox(height: 20),
            Text('"$_searchTerm" aranıyor...'),
          ],
        ),
      ),
    );
  }

  // Parça listesi (arama sonuçları)
  Widget _buildTrackList() {
    return Expanded(
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 80),
        itemCount: _tracks.length,
        itemBuilder: (context, index) {
          final track = _tracks[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: TrackCard(
              track: track,
              isPlaying: _currentlyPlayingUrl == track.previewUrl && _isPlaying,
              onPlayPressed: () => _handlePlayPressed(track.previewUrl),
              isListMode: true,
            ),
          );
        },
      ),
    );
  }

  // Önerilen parçalar grid'i
  Widget _buildRecommendedGrid() {
    return Expanded(
      child: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.7,
        ),
        itemCount: _recommendedTracks.length,
        itemBuilder: (context, index) {
          return TrackCard(
            track: _recommendedTracks[index],
            isPlaying: _currentlyPlayingUrl == _recommendedTracks[index].previewUrl && _isPlaying,
            onPlayPressed: () => _handlePlayPressed(_recommendedTracks[index].previewUrl),
            isListMode: false,
          );
        },
      ),
    );
  }

  // Şu anda çalan çubuk
  Widget? _buildNowPlayingBar() {
    if (_currentlyPlayingUrl == null) return null;
    
    final currentTrack = _tracks.firstWhere(
      (track) => track.previewUrl == _currentlyPlayingUrl,
      orElse: () => _recommendedTracks.firstWhere(
        (track) => track.previewUrl == _currentlyPlayingUrl,
      ),
    );
    
    return NowPlayingBar(
      track: currentTrack,
      isPlaying: _isPlaying,
      onPlayPressed: () => _handlePlayPressed(_currentlyPlayingUrl!),
    );
  }
}