import 'package:flutter/material.dart';
import 'dart:math';

class CircularIndicator extends StatelessWidget {
  final double progress; // Value between 0 and 1
  final Color progressColor;
  final double size;

  const CircularIndicator({
    super.key,
    required this.progress,
    required this.progressColor,
    this.size = 150,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
          ),
          // Progress Arc
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _CircularArcPainter(
                progress: progress,
                color: progressColor,
              ),
            ),
          ),
          // Center Content
          const Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "29°F",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Text(
                "Outdoor Temperature",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CircularArcPainter extends CustomPainter {
  final double progress;
  final Color color;

  _CircularArcPainter({required this.progress, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final double angle = 2 * pi * progress;
    final Rect rect = Rect.fromLTWH(0, 0, size.width, size.height);

    canvas.drawArc(rect, -pi / 2, angle, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
