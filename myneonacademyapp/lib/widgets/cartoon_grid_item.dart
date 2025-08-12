import 'package:flutter/material.dart';
import '../models/cartoons_model.dart';

class CartoonGridItem extends StatelessWidget {
  final CartoonsModel cartoon;
  final VoidCallback onTap;
  
  const CartoonGridItem({
    super.key,
    required this.cartoon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                child: _buildImage(),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    cartoon.title ?? 'Başlık Yok',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    cartoon.year?.toString() ?? 'Yıl Yok',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    // Boş URL kontrolü
    if (cartoon.image == null || cartoon.image!.isEmpty) {
      return Container(
        color: Colors.grey[200],
        child: const Center(child: Icon(Icons.image, size: 40)),
      );
    }
    
    try {
      // Geçerli URL kontrolü
      final uri = Uri.parse(cartoon.image!);
      if (!uri.isAbsolute) {
        throw const FormatException('Geçersiz URL');
      }
      
      return Image.network(
        cartoon.image!,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) {
          return _buildErrorImage();
        },
      );
    } catch (e) {
      return _buildErrorImage();
    }
  }

  Widget _buildErrorImage() {
    return Container(
      color: Colors.grey[200],
      child: const Center(child: Icon(Icons.broken_image, size: 40)),
    );
  }
}