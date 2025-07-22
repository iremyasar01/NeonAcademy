import 'package:flutter/material.dart';
import 'package:neonapp/models/comedy_show_model.dart';
import '../widgets/club_image.dart';
import '../widgets/gallery_section.dart';
import '../widgets/joke_of_the_day.dart';
import '../widgets/show_card.dart';

class ComedyScreen extends StatelessWidget {
  ComedyScreen({super.key});
  final List<ComedyShowModel> shows = [
    ComedyShowModel("Matt Rife: Naturel Selection", "aug 3", "19:30", "53.65",
        "assets/images/matt.jpeg"),
    ComedyShowModel(
        "Updating", "aug 5", "21:00", "90", "assets/images/updating.jpeg"),
    ComedyShowModel(
        "Tolgshow", "aug 12", "20:00", "110", "assets/images/tolgshow.jpeg"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurple[100],
        title: const Text("Comedy Club",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const ClubImage(),
            _buildShowsSection(),
            GallerySection(),
            const JokeOfTheDay(),
          ],
        ),
      ),
    );
  }

  Widget _buildShowsSection() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Upcoming Shows",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 15),
          ...shows.map((show) => ShowCard(show: show)),
        ],
      ),
    );
  }
}
