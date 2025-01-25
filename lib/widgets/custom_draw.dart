import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class CustomArc extends StatelessWidget {
  const CustomArc({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: CustomArcPainter(),
      size: const Size(220, 220), // Match the slider size
    );
  }
}

class CustomArcPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 4.0
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final double radius = size.width / 2;

    // We want a full circle dashed arc
    Path path = Path()
      ..addArc(
        Rect.fromCircle(
          center: Offset(radius, radius),
          radius: radius,
        ),
        0,
        2 * pi,
      );

    Path dashPath = Path();
    double dashWidth = 10;
    double dashSpace = 6;

    for (PathMetric pathMetric in path.computeMetrics()) {
      double distance = 0.0;
      while (distance < pathMetric.length) {
        final double nextDistance = distance + dashWidth;
        dashPath.addPath(
          pathMetric.extractPath(distance, nextDistance),
          Offset.zero,
        );
        distance = nextDistance + dashSpace;
      }
    }

    canvas.drawPath(dashPath, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
