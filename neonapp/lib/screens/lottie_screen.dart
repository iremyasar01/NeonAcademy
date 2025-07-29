import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class LottieScreen extends StatefulWidget {
  const LottieScreen({super.key});

  @override
 State<LottieScreen> createState() => _LottieScreenState();
}

class _LottieScreenState extends State<LottieScreen> with TickerProviderStateMixin {
  late AnimationController _lottieController;
  double _progress = 0.0;
  bool _isRunning = false;
  double _savedProgress = 0.0;
@override
void initState() {
  super.initState();
  _lottieController = AnimationController(
    vsync: this,
    duration: const Duration(seconds: 10),
  )..addListener(() {
     _updateProgress();
    });
}


  void _startSharpening() {
  setState(() {
    _isRunning = true;
    _lottieController.value = _savedProgress; 
    _lottieController.animateTo(
      1.0,
      duration: Duration(seconds: (10 - _savedProgress * 10).toInt()),
      curve: Curves.linear,
    );
  });
}


  void _stopSharpening() {
    setState(() {
      _isRunning = false;
      _savedProgress = _progress;
      _lottieController.stop();
    });
  }

  void _updateProgress() {
    setState(() {
      _progress = _lottieController.value;
    });
  }

  @override
  void dispose() {
    _lottieController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Normandy Photos"),
        centerTitle: true,
        backgroundColor: Colors.blue[800],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Image.asset('assets/images/normandy.jpeg'),
                if (_progress < 1.0)
                  BackdropFilter(
                    filter: ImageFilter.blur(
                      sigmaX: 10 * (1 - _progress),
                      sigmaY: 10 * (1 - _progress),
                    ),
                    child: Container(
                      color: Colors.black.withOpacity(0),
                    ),
                  ),
                Text(
                  '${(_progress * 100).toStringAsFixed(0)}%',
                  style: const TextStyle(
                    fontSize: 40,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 30),
            
            Lottie.asset(
              'assets/animations/Loading Animation.json',
              controller: _lottieController,
              height: 100,
              onLoaded: (composition) {
                _lottieController.duration = composition.duration;
              },
            ),

            LinearProgressIndicator(
              value: _progress,
              minHeight: 10,
              backgroundColor: Colors.grey[300],
              color: Colors.blue,
            ),

            const SizedBox(height: 20),
            
        
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _isRunning ? null : _startSharpening,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                  child: const Text('START'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _isRunning ? _stopSharpening : null,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    padding: const EdgeInsets.symmetric(horizontal: 30),
                  ),
                  child: const Text('STOP'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}