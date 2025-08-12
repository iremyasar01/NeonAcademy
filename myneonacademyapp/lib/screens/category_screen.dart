import 'package:flutter/material.dart';
import 'package:myneonacademyapp/models/cartoons_model.dart';
import 'detail_screen.dart';

class CategoryScreen extends StatelessWidget {
  final String category;
  final List<CartoonsModel> cartoons;
  
  const CategoryScreen({
    super.key,
    required this.category,
    required this.cartoons,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.builder(
        itemCount: cartoons.length,
        itemBuilder: (context, index) {
          final cartoon = cartoons[index];
          return ListTile(
            leading: cartoon.image != null
                ? Image.network(
                    cartoon.image!,
                    width: 50,
                    height: 50,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => 
                      const Icon(Icons.image),
                  )
                : const Icon(Icons.image),
            title: Text(cartoon.title ?? ''),
            subtitle: Text(cartoon.genre?.join(', ') ?? ''),
            trailing: const Icon(Icons.arrow_forward_ios, size: 16),
            onTap: () => _navigateToDetail(context, cartoon),
          );
        },
      ),
    );
  }

  void _navigateToDetail(BuildContext context, CartoonsModel cartoon) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => DetailScreen(cartoon: cartoon),
      ),
    );
  }
}