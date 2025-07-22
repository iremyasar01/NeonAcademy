import 'package:flutter/material.dart';
import '../../services/joke_service.dart';

class JokeOfTheDay extends StatefulWidget {
  const JokeOfTheDay({super.key});

  @override
  State<JokeOfTheDay> createState() => _JokeOfTheDayState();
}

class _JokeOfTheDayState extends State<JokeOfTheDay> {
  late Future<String> _jokeFuture;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _jokeFuture = JokeService.fetchRandomJoke();
  }

  void _refreshJoke() {
    setState(() {
      _isLoading = true;
      _jokeFuture = JokeService.fetchRandomJoke().then((joke) {
        setState(() => _isLoading = false);
        return joke;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.deepPurple[50],
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.deepPurple[200]!),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
             const Text("Daily Joke", 
                   style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
              IconButton(
                icon: _isLoading 
                  ? const CircularProgressIndicator()
                  : const Icon(Icons.refresh, color: Colors.purple),
                onPressed: _isLoading ? null : _refreshJoke,
              ),
            ],
          ),
          FutureBuilder<String>(
            future: _jokeFuture,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: CircularProgressIndicator(),
                );
              }
              
              if (snapshot.hasError) {
                return const Text(
                  "Joke is missing! try again later please 😢",
                  textAlign: TextAlign.center,
                );
              }
              
              return Column(
                children: [
                  const SizedBox(height: 10),
                  Text(
                    snapshot.data ?? "No joke available",
                    textAlign: TextAlign.center,
                    style: const TextStyle(fontStyle: FontStyle.italic, fontSize: 18),
                  ),
                  const SizedBox(height: 15),
                  const Icon(Icons.sentiment_very_satisfied, 
                       color: Colors.purple, size: 36),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}