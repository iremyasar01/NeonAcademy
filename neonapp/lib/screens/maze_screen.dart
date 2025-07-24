import 'package:flutter/material.dart';
import 'package:neonapp/screens/succes_screen.dart';
import 'package:neonapp/widgets/transition.dart';
import '../widgets/direction_button.dart';

class MazeScreen extends StatefulWidget {
  final int step;

  const MazeScreen({super.key, required this.step});

  @override
  State<MazeScreen> createState() => _MazeScreenState();
}

class _MazeScreenState extends State<MazeScreen> {
  final List<String> correctPath = [
    'up',
    'right',
    'right',
    'down',
    'left',
    'up',
    'left'
  ];
  bool _isTrapped = false;

  void _navigate(String direction) {
    if (_isTrapped) return;

    if (direction == correctPath[widget.step]) {
      if (widget.step == correctPath.length - 1) {
        Navigator.pushReplacement(
          context,
          createFadeRoute(const SuccessScreen()),
        );
      } else {
        Navigator.push(
          context,
          _getDirectionRoute(direction, MazeScreen(step: widget.step + 1)),
        );
      }
    } else {
      setState(() => _isTrapped = true);
      Future.delayed(const Duration(seconds: 2), () {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
          context,
          createFadeRoute(const MazeScreen(step: 0)),
          (Route<dynamic> route) => false,
        );
      });
    }
  }

  PageRouteBuilder<dynamic> _getDirectionRoute(String direction, Widget page) {
    switch (direction) {
      case 'up':
        return slideRoute(page, const Offset(0, 1));
      case 'right':
        return zoomSlideRoute(page, const Offset(-1, 0));
      case 'left':
        return pushRoute(page);
      case 'down':
        return coverRoute(page, const Offset(0, -1));
      default:
        return createFadeRoute(page);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[100],
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 60,
                  backgroundImage: AssetImage('assets/images/maze.jpeg'),
                  backgroundColor: Colors.transparent,
                ),
                const SizedBox(height: 40),
                Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    DirectionButton(
                        direction: 'up',
                        icon: Icons.arrow_upward,
                        onPressed: () => _navigate('up')),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DirectionButton(
                            direction: 'left',
                            icon: Icons.arrow_back,
                            onPressed: () => _navigate('left')),
                        const SizedBox(width: 60),
                        DirectionButton(
                            direction: 'right',
                            icon: Icons.arrow_forward,
                            onPressed: () => _navigate('right')),
                      ],
                    ),
                    DirectionButton(
                        direction: 'down',
                        icon: Icons.arrow_downward,
                        onPressed: () => _navigate('down')),
                  ],
                ),
              ],
            ),
          ),
          if (_isTrapped)
            Container(
              color: Colors.black.withOpacity(0.8),
              child: Center(
                child: Text(
                  "You're trapped, try again!",
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
