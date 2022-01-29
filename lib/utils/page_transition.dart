import 'package:flutter/material.dart';

class PageTransition extends PageRouteBuilder {
  final Widget page;
  PageTransition(this.page)
      : super(
          pageBuilder: (context, animation, secondaryAnimation) => page,
          transitionDuration: const Duration(milliseconds: 500),
          reverseTransitionDuration: const Duration(milliseconds: 300),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            animation = CurvedAnimation(
                parent: animation,
                curve: Curves.fastLinearToSlowEaseIn,
                reverseCurve: Curves.fastOutSlowIn);
            return Align(
              child: SizeTransition(
                axis: Axis.horizontal,
                sizeFactor: animation,
                child: page,
                axisAlignment: 0,
              ),
              alignment: Alignment.centerRight,
            );
          },
        );
}
