import 'package:flutter/material.dart';

class CloseIcon extends StatelessWidget {
  final double width;
  final double height;
  final Color color;

  const CloseIcon({
    Key? key,
    this.width = 35,
    this.height = 35,
    this.color = const Color(0xFFCC8A8A),
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(width, height),
      painter: _CloseIconPainter(color: color),
    );
  }
}

class _CloseIconPainter extends CustomPainter {
  final Color color;

  _CloseIconPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final Path path = Path();

    // This is a direct conversion of the SVG path to Flutter Path
    path.moveTo(size.width * 0.5, 0);
    path.cubicTo(size.width * 0.2239, 0, 0, size.width * 0.2239, 0, size.width * 0.5);
    path.cubicTo(0, size.width * 0.7761, size.width * 0.2239, size.width, size.width * 0.5, size.width);
    path.cubicTo(size.width * 0.7761, size.width, size.width, size.width * 0.7761, size.width, size.width * 0.5);
    path.cubicTo(size.width, size.width * 0.2239, size.width * 0.7761, 0, size.width * 0.5, 0);
    path.close();

    path.moveTo(size.width * 0.5, size.width * 0.9385);
    path.cubicTo(size.width * 0.2588, size.width * 0.9385, size.width * 0.0625, size.width * 0.7412, size.width * 0.0625, size.width * 0.5);
    path.cubicTo(size.width * 0.0625, size.width * 0.2588, size.width * 0.2588, size.width * 0.0625, size.width * 0.5, size.width * 0.0625);
    path.cubicTo(size.width * 0.7412, size.width * 0.0625, size.width * 0.9375, size.width * 0.2588, size.width * 0.9375, size.width * 0.5);
    path.cubicTo(size.width * 0.9375, size.width * 0.7412, size.width * 0.7412, size.width * 0.9385, size.width * 0.5, size.width * 0.9385);
    path.close();

    path.moveTo(size.width * 0.6768, size.width * 0.3232);
    path.cubicTo(size.width * 0.6456, size.width * 0.2925, size.width * 0.5962, size.width * 0.2925, size.width * 0.5655, size.width * 0.3232);
    path.lineTo(size.width * 0.5, size.width * 0.3887);
    path.lineTo(size.width * 0.4345, size.width * 0.3232);
    path.cubicTo(size.width * 0.4038, size.width * 0.2925, size.width * 0.3544, size.width * 0.2925, size.width * 0.3232, size.width * 0.3232);
    path.cubicTo(size.width * 0.2925, size.width * 0.3544, size.width * 0.2925, size.width * 0.4038, size.width * 0.3232, size.width * 0.4345);
    path.lineTo(size.width * 0.3887, size.width * 0.5);
    path.lineTo(size.width * 0.3232, size.width * 0.5655);
    path.cubicTo(size.width * 0.2925, size.width * 0.5962, size.width * 0.2925, size.width * 0.6456, size.width * 0.3232, size.width * 0.6768);
    path.cubicTo(size.width * 0.3544, size.width * 0.7075, size.width * 0.4038, size.width * 0.7075, size.width * 0.4345, size.width * 0.6768);
    path.lineTo(size.width * 0.5, size.width * 0.6113);
    path.lineTo(size.width * 0.5655, size.width * 0.6768);
    path.cubicTo(size.width * 0.5962, size.width * 0.7075, size.width * 0.6456, size.width * 0.7075, size.width * 0.6768, size.width * 0.6768);
    path.cubicTo(size.width * 0.7075, size.width * 0.6456, size.width * 0.7075, size.width * 0.5962, size.width * 0.6768, size.width * 0.5655);
    path.lineTo(size.width * 0.6113, size.width * 0.5);
    path.lineTo(size.width * 0.6768, size.width * 0.4345);
    path.cubicTo(size.width * 0.7075, size.width * 0.4038, size.width * 0.7075, size.width * 0.3544, size.width * 0.6768, size.width * 0.3232);
    path.close();

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}