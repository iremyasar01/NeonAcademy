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

  @override
  void initState() {
    super.initState();
    _loadRating();
  }

  void _loadRating() async {
    final rating = await RatingSystem.getRating(widget.cartoon.id!);
    setState(() => _userRating = rating);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.cartoon.title ?? "Detay",
        ),
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
            if (widget.cartoon.creator != null &&
                widget.cartoon.creator!.isNotEmpty)
              Text(
                "Yaratıcılar: ${widget.cartoon.creator!.join(', ')}",
                style: Theme.of(context).textTheme.bodySmall,
              ),
            const SizedBox(height: 20),
            const Text("Puanınız:", textAlign: TextAlign.center),
            StarRating(
              initialRating: _userRating,
              onRatingChanged: (newRating) {
                setState(() => _userRating = newRating);
                RatingSystem.saveRating(widget.cartoon.id!, newRating);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Boş URL kontrolü
    if (widget.cartoon.image == null || widget.cartoon.image!.isEmpty) {
      return Container(
        height: 250,
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.image, size: 100)),
      );
    }

    try {
      // Geçerli URL kontrolü
      final uri = Uri.parse(widget.cartoon.image!);
      if (!uri.isAbsolute) {
        throw const FormatException('Geçersiz URL');
      }

      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Image.network(
          widget.cartoon.image!,
          height: 250,
          width: double.infinity,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return _buildErrorImage();
          },
        ),
      );
    } catch (e) {
      return _buildErrorImage();
    }
  }

  Widget _buildErrorImage() {
    return Container(
      height: 250,
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.broken_image, size: 100)),
    );
  }
}
