import 'dart:ui';

import 'package:flutter/cupertino.dart';

class CustomCurvedEdges extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double h = size.height;
    double w = size.width;
    path.lineTo(0, 0);
    path.lineTo(w * 0.65, 0);

    path.quadraticBezierTo(w * 0.7, 0, w * 0.70, h * 0.07);
    path.quadraticBezierTo(w * 0.7, h * 0.25, w * 0.80, h * 0.25);
    path.quadraticBezierTo(w, h * 0.2, w, h * .40);

    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}

class CustomCurvedEdges2 extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    var path = Path();
    double h = size.height;
    double w = size.width;

    path.lineTo(0, 0);
    path.lineTo(w * 0.2, 0);
    path.quadraticBezierTo(w * 0.33, 0, w * 0.34, h * 0.18);
    path.quadraticBezierTo(w * 0.35, h * 0.35, w * 0.4, h * 0.36);
    path.quadraticBezierTo(w * 0.58, h * 0.36, w * 0.58, h * 0.36);
    path.quadraticBezierTo(w * 0.63, h * .37, w * 0.64, h * 0.22);
    path.quadraticBezierTo(w * 0.65, 0, w * 0.75, 0);
    path.lineTo(w * 0.8, 0);
    path.lineTo(w, 0);

    path.lineTo(w, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return true;
  }
}
