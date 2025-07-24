import 'package:flutter/material.dart';

PageRouteBuilder<dynamic> createFadeRoute(Widget page) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

PageRouteBuilder<dynamic> slideRoute(Widget page, Offset begin) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final tween = Tween(begin: begin, end: Offset.zero).chain(CurveTween(curve: Curves.easeOut));
      return SlideTransition(position: animation.drive(tween), child: child);
    },
  );
}

PageRouteBuilder<dynamic> zoomSlideRoute(Widget page, Offset begin) {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => page,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final slideTween = Tween(begin: begin, end: Offset.zero).chain(CurveTween(curve: Curves.easeOut));
      final zoomTween = Tween(begin: 0.5, end: 1.0).chain(CurveTween(curve: Curves.easeOut));
      return SlideTransition(
        position: animation.drive(slideTween),
        child: ScaleTransition(scale: animation.drive(zoomTween), child: child),
      );
    },
  );
}

PageRouteBuilder<dynamic> pushRoute(Widget page) {
  return slideRoute(page, const Offset(1.0, 0.0));
}

PageRouteBuilder<dynamic> coverRoute(Widget page, Offset begin) {
  return slideRoute(page, begin);
}
