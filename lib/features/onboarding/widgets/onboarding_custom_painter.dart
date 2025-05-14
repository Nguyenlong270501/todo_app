import 'package:flutter/cupertino.dart';

class OnboardingCustomPainter extends CustomPainter {
  final Color color;

  OnboardingCustomPainter({required this.color});
  @override
  void paint(Canvas canvas, Size size) {
    final paint =
        Paint()
          ..style = PaintingStyle.fill
          ..strokeWidth = 5
          ..color = color;

    final path = Path();

    path.lineTo(0, size.height - 80);
    path.quadraticBezierTo(
      size.width * 0.2,
      size.height - 10,
      size.width * .5,
      size.height - 60,
    );
    path.quadraticBezierTo(
      size.width * 0.7,
      size.height - 10,
      size.width,
      size.height - 70,
    );
    path.lineTo(size.width, 0);
    path.lineTo(0, 0);
    path.close();

    canvas.drawPath(path, paint);

    const circleRadius = 45.0;
    var circleCenter = Offset(size.width * .5, size.height - 40);

    canvas.drawCircle(circleCenter, circleRadius, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return false;
  }
}
