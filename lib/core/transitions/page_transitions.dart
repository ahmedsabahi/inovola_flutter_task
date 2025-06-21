import 'package:flutter/material.dart';

class SlideUpPageRoute extends PageRouteBuilder {
  final Widget child;
  final Duration duration;

  SlideUpPageRoute({
    required this.child,
    this.duration = const Duration(milliseconds: 300),
  }) : super(
         pageBuilder: (context, animation, secondaryAnimation) => child,
         transitionDuration: duration,
         reverseTransitionDuration: duration,
         transitionsBuilder: (context, animation, secondaryAnimation, child) {
           const begin = Offset(0.0, 1.0);
           const end = Offset.zero;
           const curve = Curves.easeInOutCubic;

           var tween = Tween(
             begin: begin,
             end: end,
           ).chain(CurveTween(curve: curve));

           return SlideTransition(
             position: animation.drive(tween),
             child: child,
           );
         },
       );
}
