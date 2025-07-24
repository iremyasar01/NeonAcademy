import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:neonapp/screens/welcome_screen.dart';
import 'package:neonapp/widgets/transition.dart';

class SuccessScreen extends StatelessWidget {
  final XFile? selectedImage;
  const SuccessScreen({super.key, this.selectedImage});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 80,
              backgroundImage: selectedImage != null
                  ? FileImage(File(selectedImage!.path))
                  : const AssetImage('assets/images/maze.jpeg') as ImageProvider,
              backgroundColor: Colors.transparent,
            ),
            const SizedBox(height: 40),
            Text(
              "Congratulations, you did it!",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 20),
            Text(
              "You have proven yourself as a true Vampire Hunter!",
              style: Theme.of(context).textTheme.titleLarge,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.pushAndRemoveUntil(
                  context,
                  createFadeRoute(const WelcomeScreen()),
                  (Route<dynamic> route) => false,
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[700],
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text("RETURN TO ACADEMY", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
