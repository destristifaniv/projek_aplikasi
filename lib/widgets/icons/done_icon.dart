import 'package:flutter/material.dart';

class DoneIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const DoneIcon({
    Key? key,
    this.width = 37,
    this.height = 37,
    this.color = const Color(0xFFCC8A8A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _DoneIconPainter(color: color),
    );
  }
}

class _DoneIconPainter extends CustomPainter {
  final Color color;

  _DoneIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path();

    // This is a direct conversion of the SVG path to Flutter Path
    // Rule for the checkmark icon
    path.moveTo(size.width * 0.5, size.width * 0.9167);
    path.cubicTo(size.width * 0.2699, size.width * 0.9167, size.width * 0.0833, size.width * 0.7301, size.width * 0.0833, size.width * 0.5);
    path.cubicTo(size.width * 0.0833, size.width * 0.2699, size.width * 0.2699, size.width * 0.0833, size.width * 0.5, size.width * 0.0833);
    path.cubicTo(size.width * 0.7301, size.width * 0.0833, size.width * 0.9167, size.width * 0.2699, size.width * 0.9167, size.width * 0.5);
    path.cubicTo(size.width * 0.9167, size.width * 0.7301, size.width * 0.7301, size.width * 0.9167, size.width * 0.5, size.width * 0.9167);
    path.close();

    path.moveTo(size.width * 0.5, size.width * 0.8667);
    path.cubicTo(size.width * 0.5973, size.width * 0.8667, size.width * 0.6905, size.width * 0.8281, size.width * 0.7594, size.width * 0.7594);
    path.cubicTo(size.width * 0.8281, size.width * 0.6905, size.width * 0.8667, size.width * 0.5973, size.width * 0.8667, size.width * 0.5);
    path.cubicTo(size.width * 0.8667, size.width * 0.4027, size.width * 0.8281, size.width * 0.3095, size.width * 0.7594, size.width * 0.2406);
    path.cubicTo(size.width * 0.6905, size.width * 0.1719, size.width * 0.5973, size.width * 0.1333, size.width * 0.5, size.width * 0.1333);
    path.cubicTo(size.width * 0.4027, size.width * 0.1333, size.width * 0.3095, size.width * 0.1719, size.width * 0.2406, size.width * 0.2406);
    path.cubicTo(size.width * 0.1719, size.width * 0.3095, size.width * 0.1333, size.width * 0.4027, size.width * 0.1333, size.width * 0.5);
    path.cubicTo(size.width * 0.1333, size.width * 0.5973, size.width * 0.1719, size.width * 0.6905, size.width * 0.2406, size.width * 0.7594);
    path.cubicTo(size.width * 0.3095, size.width * 0.8281, size.width * 0.4027, size.width * 0.8667, size.width * 0.5, size.width * 0.8667);
    path.close();

    path.moveTo(size.width * 0.4512, size.width * 0.6066);
    path.lineTo(size.width * 0.6932, size.width * 0.3646);
    path.lineTo(size.width * 0.7285, size.width * 0.4);
    path.lineTo(size.width * 0.4806, size.width * 0.6479);
    path.cubicTo(size.width * 0.4714, size.width * 0.6571, size.width * 0.4619, size.width * 0.6617, size.width * 0.4512, size.width * 0.6617);
    path.cubicTo(size.width * 0.4404, size.width * 0.6617, size.width * 0.4309, size.width * 0.6571, size.width * 0.4217, size.width * 0.6479);
    path.lineTo(size.width * 0.2917, size.width * 0.5179);
    path.lineTo(size.width * 0.3271, size.width * 0.4825);
    path.lineTo(size.width * 0.4512, size.width * 0.6066);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}