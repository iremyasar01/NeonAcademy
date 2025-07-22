import 'package:flutter/material.dart';

class GallerySection extends StatelessWidget {
   GallerySection({super.key});
  final List<Map<String, String>> galleryItems = [
    {"image": "assets/images/standup.jpeg", "title": "Stand-Up Night"},
    {"image": "assets/images/improv.jpeg", "title": "Improv Comedy"},
    {"image": "assets/images/comedyfest.jpeg", "title": "Comedy Festival"},
    {"image": "assets/images/club.jpeg", "title": "Comedy Club"},
  ];

 

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Gallery", 
               style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          SizedBox(
            height: 150,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: galleryItems.map((item) => 
                _buildGalleryItem(item['image']!, item['title']!)
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGalleryItem(String imagePath, String title) {
    return Container(
      width: 120,
      margin: const EdgeInsets.only(right: 10),
      child: Column(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(15),
              child: Image.asset(
                imagePath,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
         const SizedBox(height: 5),
          Text(title, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}