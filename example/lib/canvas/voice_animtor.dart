import 'package:flutter/material.dart';
import 'dart:ui' as ui;

/// 作者： lixp
/// 创建时间： 2022/6/17 15:51
/// 类介绍：音波
class VoiceAnimation extends StatefulWidget {
  final ValueNotifier<double> voiceNum;

  const VoiceAnimation({Key? key, required this.voiceNum}) : super(key: key);

  @override
  _VoiceAnimationState createState() => _VoiceAnimationState();
}

class _VoiceAnimationState extends State<VoiceAnimation> {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(100, 140),
      painter: _VoicePainter(widget.voiceNum),
    );
  }
}

class _VoicePainter extends CustomPainter {
  final ValueNotifier<double> voiceNum;

  _VoicePainter(this.voiceNum) : super(repaint: voiceNum);

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = Colors.black87
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1;

    canvas.drawRRect(
        RRect.fromRectXY(
            Rect.fromCenter(
                center: Offset(size.width / 2, size.height / 2),
                width: size.width / 2,
                height: size.height),
            20,
            20),
        paint);

    canvas.drawRRect(
        RRect.fromRectXY(
            Rect.fromCenter(
                center: Offset(size.width / 2, size.height / 2),
                width: size.width / 2,
                height: size.height),
            20,
            20),
        paint
          ..style = PaintingStyle.fill
          ..shader = ui.Gradient.linear(
              Offset(size.width / 2, size.height),
              Offset(size.width / 2,
                  size.height - size.height * voiceNum.value / 120),
              [Colors.blue, Colors.red],
              [1.0 / 4, 1.0 / 1],
              TileMode.decal));
  }

  @override
  bool shouldRepaint(covariant _VoicePainter oldDelegate) {
    return voiceNum != oldDelegate.voiceNum;
  }
}
