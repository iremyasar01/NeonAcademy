import 'package:flutter/material.dart';
import 'package:neonapp/widgets/transition.dart';
import '../screens/maze_screen.dart';


class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Vampire Hunter's Maze"),
        backgroundColor: Colors.brown[200],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Welcome to the maze.\nIf you succeed, you are ready for the real world",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  createFadeRoute(const MazeScreen(step: 0)),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.brown[200],
                padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              ),
              child: const Text("BEGIN THE HUNT", style: TextStyle(fontSize: 18)),
            ),
          ],
        ),
      ),
    );
  }
}
