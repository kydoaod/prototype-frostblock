import 'package:flutter/material.dart';
import 'dart:math';

class CircularIndicator extends StatelessWidget {
  final double progress; // Value between 0 and 1
  final Color startColor;
  final Color endColor;
  final String temperature;
  final String label;
  final double size;

  const CircularIndicator({
    super.key,
    required this.progress,
    required this.startColor,
    required this.endColor,
    required this.temperature,
    required this.label,
    this.size = 200,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Background Circle (Progress Arc Base)
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: [
                  Colors.grey.shade300,
                  Colors.grey.shade100,
                ],
                center: Alignment.center,
                radius: 1.0,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 8,
                  offset: Offset(4, 4),
                ),
              ],
            ),
          ),
          // Gradient Progress Arc
          SizedBox(
            width: size,
            height: size,
            child: CustomPaint(
              painter: _GradientArcPainter(
                progress: progress,
                startColor: startColor,
                endColor: endColor,
              ),
            ),
          ),
          // Inner Circle
          Container(
            width: size * 0.75, // Inner circle is smaller
            height: size * 0.75,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 4,
                  offset: Offset(-2, -2),
                ),
                BoxShadow(
                  color: Colors.black26,
                  blurRadius: 6,
                  offset: Offset(4, 4),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  temperature,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    color: startColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Colors.grey,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _GradientArcPainter extends CustomPainter {
  final double progress;
  final Color startColor;
  final Color endColor;

  _GradientArcPainter({
    required this.progress,
    required this.startColor,
    required this.endColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // Outer stroke width adjustment
    final double strokeWidth = size.width * 0.15; // Manipis ang stroke
    final double adjustedRadius = (size.width / 2) - (strokeWidth / 2); // Panatilihin ang inner edge

    final Paint paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..shader = SweepGradient(
        startAngle: -pi / 2,
        endAngle: (2 * pi * progress) - pi / 2,
        colors: [
          startColor, 
          startColor.withOpacity(0.3),  // Intermediate Color
          endColor
        ],
      stops: const [0.0, 0.5, 1.0],         // Define transition points
      ).createShader(
        Rect.fromLTWH(0, 0, size.width, size.height),
      )
      ..strokeCap = StrokeCap.round;

    final Rect rect = Rect.fromCircle(
      center: Offset(size.width / 2, size.height / 2),
      radius: adjustedRadius, // Gamitin ang adjusted radius
    );

    canvas.drawArc(rect, -pi / 2, 2 * pi * progress, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
