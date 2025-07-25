import 'package:flutter/material.dart';
import 'package:neonapp/screens/ad_screen.dart';
import 'package:neonapp/screens/comedy_screen.dart';
import 'package:neonapp/screens/flexible_screen.dart';
import 'package:neonapp/screens/future_tech_screen.dart';
import 'package:neonapp/screens/travel_screen.dart';
import 'package:neonapp/screens/welcome_screen.dart';
import 'package:neonapp/widgets/purchase_wrapper.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Neon Academy'),
        centerTitle: true,
        backgroundColor: Colors.green[200],
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => FlexibleScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text('Flexible Class'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const TravelScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text('expanded and padding'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const FutureTechScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text('future tech'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ComedyScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text('Comedy Club'),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>const WelcomeScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text('Hero'),
                ),
                   const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>const PurchaseWrapper()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text('Adapty'),
                ),
                  const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) =>const AdScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green[200],
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.all(20),
                  ),
                  child: const Text('Ad'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
