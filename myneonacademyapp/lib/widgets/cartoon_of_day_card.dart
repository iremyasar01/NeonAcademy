import 'package:flutter/material.dart';
import '../models/cartoons_model.dart';

class CartoonOfDayCard extends StatelessWidget {
  final CartoonsModel cartoon;
  final VoidCallback onTap;
  
  const CartoonOfDayCard({
    super.key,
    required this.cartoon,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(16),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.only(top: 16),
              child: Text(
                "Günün Çizgi Filmi",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: _buildImage(),
              ),
            ),
            ListTile(
              title: Text(
                cartoon.title ?? 'Başlık Yok',
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              subtitle: Text(
                cartoon.genre?.join(', ') ?? 'Tür Yok',
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if (cartoon.image?.startsWith('assets/') ?? false) {
      return Image.asset(
        cartoon.image!,
        height: 200,
        width: double.infinity,
        fit: BoxFit.cover,
      );
    }
    
    return Image.network(
      cartoon.image ?? '',
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        return _buildPlaceholder();
      },
    );
  }

  Widget _buildPlaceholder() {
    return Image.asset(
      'assets/images/no_image.png',
      height: 200,
      width: double.infinity,
      fit: BoxFit.cover,
    );
  }
}