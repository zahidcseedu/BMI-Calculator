import 'package:flutter/material.dart';
import 'dart:math';

class BMIGaugeWidget extends StatelessWidget {
  final double bmi;
  final String status;

  const BMIGaugeWidget({
    required this.bmi,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(350, 180),
      painter: BMIGaugePainter(
        bmi: bmi,
        status: status,
      ),
    );
  }
}

class BMIGaugePainter extends CustomPainter {
  final double bmi;
  final String status;

  BMIGaugePainter({
    required this.bmi,
    required this.status,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height * 0.7);
    final radius = size.width / 2.5;

    // Draw gauge background
    _drawGaugeBackground(canvas, center, radius);

    // Draw needle
    _drawNeedle(canvas, center, radius);

    // Draw center circle
    _drawCenterCircle(canvas, center);
  }

  void _drawGaugeBackground(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 30;

    // Underweight range (red) - 0 to 18.5
    paint.color = Colors.redAccent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi,
      (18.5 / 40) * pi,
      false,
      paint,
    );

    // Normal range (green) - 18.5 to 25
    paint.color = Color(0xFF24D876);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi + (18.5 / 40) * pi,
      ((25 - 18.5) / 40) * pi,
      false,
      paint,
    );

    // Overweight range (yellow) - 25 to 30
    paint.color = Colors.amber;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi + (25 / 40) * pi,
      ((30 - 25) / 40) * pi,
      false,
      paint,
    );

    // Obesity range (red) - 30 to 40
    paint.color = Colors.deepOrangeAccent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -pi + (30 / 40) * pi,
      ((40 - 30) / 40) * pi,
      false,
      paint,
    );

    // Draw tick marks
    _drawTickMarks(canvas, center, radius);
  }

  void _drawTickMarks(Canvas canvas, Offset center, double radius) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 2;

    final values = [0, 10, 20, 30, 40];
    for (var value in values) {
      final angle = -pi + (value / 40) * pi;
      final start = Offset(
        center.dx + (radius - 8) * cos(angle),
        center.dy + (radius - 8) * sin(angle),
      );
      final end = Offset(
        center.dx + (radius + 5) * cos(angle),
        center.dy + (radius + 5) * sin(angle),
      );
      canvas.drawLine(start, end, paint);

      // Draw text labels
      final textPainter = TextPainter(
        text: TextSpan(
          text: value.toString(),
          style: TextStyle(
            color: Colors.white,
            fontSize: 10,
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      textPainter.layout();

      final labelOffset = Offset(
        center.dx + (radius + 15) * cos(angle) - textPainter.width / 2,
        center.dy + (radius + 15) * sin(angle) - textPainter.height / 2,
      );
      textPainter.paint(canvas, labelOffset);
    }
  }

  void _drawNeedle(Canvas canvas, Offset center, double radius) {
    final angle = -pi + (bmi.clamp(0, 40) / 40) * pi;

    // Draw needle line
    final needlePaint = Paint()
      ..color = Colors.white
      ..strokeWidth = 3;

    final needleEnd = Offset(
      center.dx + (radius - 20) * cos(angle),
      center.dy + (radius - 20) * sin(angle),
    );

    canvas.drawLine(center, needleEnd, needlePaint);

    // Draw filled triangle pointing AWAY from center (towards gauge)
    final arrowSize = 14.0;

    // Base of triangle is behind the needle tip
    final baseCenter = Offset(
      needleEnd.dx - arrowSize * cos(angle),
      needleEnd.dy - arrowSize * sin(angle),
    );

    final arrowAngle1 = angle + pi / 2;
    final arrowAngle2 = angle - pi / 2;
    final baseWidth = 7.0;

    final arrowPoint1 = Offset(
      baseCenter.dx + baseWidth * cos(arrowAngle1),
      baseCenter.dy + baseWidth * sin(arrowAngle1),
    );
    final arrowPoint2 = Offset(
      baseCenter.dx + baseWidth * cos(arrowAngle2),
      baseCenter.dy + baseWidth * sin(arrowAngle2),
    );

    final trianglePath = Path()
      ..moveTo(needleEnd.dx, needleEnd.dy) // tip
      ..lineTo(arrowPoint1.dx, arrowPoint1.dy)
      ..lineTo(arrowPoint2.dx, arrowPoint2.dy)
      ..close();

    final trianglePaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;

    canvas.drawPath(trianglePath, trianglePaint);
  }

  void _drawCenterCircle(Canvas canvas, Offset center) {
    final paint = Paint()
      ..color = Color(0xFF0A2F51)
      ..style = PaintingStyle.fill;

    canvas.drawCircle(center, 12, paint);

    final borderPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    canvas.drawCircle(center, 12, borderPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
