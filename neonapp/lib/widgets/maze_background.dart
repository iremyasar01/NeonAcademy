import 'package:flutter/material.dart';

class MazeBackground extends StatelessWidget {
  const MazeBackground({super.key});

  @override
  Widget build(BuildContext context) {
    return  Hero(
      tag: 'maze-background',
      flightShuttleBuilder: (_, animation, direction, fromContext, toContext) {
        return FadeTransition(
          opacity: animation.drive(Tween(begin: 0.0, end: 1.0)),
          child: toContext.widget,
        );
      },
      child: const Material(
        child: SizedBox.expand(
          child: DecoratedBox(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/maze.jpeg'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(
                  Colors.black54,
                  BlendMode.darken,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}