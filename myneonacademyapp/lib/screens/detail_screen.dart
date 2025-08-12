import 'package:flutter/material.dart';
import 'package:myneonacademyapp/models/cartoons_model.dart';
import '../utils/rating_system.dart';
import '../widgets/star_rating.dart';

class DetailScreen extends StatefulWidget {
  final CartoonsModel cartoon;

  const DetailScreen({super.key, required this.cartoon});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  double _userRating = 0.0;
  bool _isLoading = true; // Başlangıçta true olacak

  @override
  void initState() {
    super.initState();
    _loadRating();
  }

  void _loadRating() async {
    try {
      final rating = await RatingSystem.getRating(widget.cartoon.id);
      if (mounted) {
        setState(() {
          _userRating = rating;
          _isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Puan yükleme hatası: $e');
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _saveRating(double newRating) async {
    // Hemen arayüzü güncelle
    setState(() => _userRating = newRating);
    
    try {
      await RatingSystem.saveRating(widget.cartoon.id, newRating);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Puan kaydedildi: $newRating')),
        );
      }
    } catch (e) {
      debugPrint('Puan kaydetme hatası: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Puan kaydedilemedi!')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.cartoon.title ?? "Detay"),
        backgroundColor: Colors.blue[700],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImage(),
            const SizedBox(height: 20),
            Text(
              widget.cartoon.title ?? "Başlık Yok",
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 10,
              children: (widget.cartoon.genre ?? [])
                  .map((genre) => Chip(label: Text(genre)))
                  .toList(),
            ),
            const SizedBox(height: 15),
            Row(
              children: [
                const Icon(Icons.calendar_today, size: 16),
                const SizedBox(width: 5),
                Text("Yıl: ${widget.cartoon.year ?? 'Bilinmiyor'}"),
                const SizedBox(width: 20),
                const Icon(Icons.tv, size: 16),
                const SizedBox(width: 5),
                Text("Bölüm: ${widget.cartoon.episodes ?? 'Bilinmiyor'}"),
              ],
            ),
            const SizedBox(height: 10),
            if (widget.cartoon.creator != null && widget.cartoon.creator!.isNotEmpty)
              Text(
                "Yaratıcılar: ${widget.cartoon.creator!.join(', ')}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 20),
            const Text("Puanınız:", textAlign: TextAlign.center),
            
            // Yükleme durumuna göre ya yıldızları göster ya da progress
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : StarRating(
                    initialRating: _userRating,
                    onRatingChanged: _saveRating,
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (widget.cartoon.image?.startsWith('assets/') ?? false) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.asset(
          widget.cartoon.image!,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
        ),
      );
    }
    
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: Image.network(
        widget.cartoon.image ?? '',
        height: 250,
        width: double.infinity,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildPlaceholder();
        },
      ),
    );
  }

  Widget _buildPlaceholder() {
    return Container(
      height: 250,
      color: Colors.grey[200],
      child: Center(
        child: Image.asset(
          'assets/images/no_image.png',
          height: 200,
        ),
      ),
    );
  }
}