import 'package:flutter/material.dart';
import 'package:myneonacademyapp/models/cartoons_model.dart';
import 'package:myneonacademyapp/screens/category_screen.dart';


class GenreChipList extends StatelessWidget {
  final List<String> genres;
  final List<CartoonsModel> cartoons;
  
  const GenreChipList({
    super.key,
    required this.genres,
    required this.cartoons,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: genres.length,
        itemBuilder: (context, index) {
          final genre = genres[index];
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: ActionChip(
              label: Text(genre),
              onPressed: () => _navigateToCategory(context, genre),
            ),
          );
        },
      ),
    );
  }

  void _navigateToCategory(BuildContext context, String genre) {
    final filtered = cartoons.where((c) => c.genre?.contains(genre) ?? false).toList();
    
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryScreen(
          category: genre,
          cartoons: filtered,
        ),
      ),
    );
  }
}