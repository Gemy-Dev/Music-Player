import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../utils/const.dart';

double radius = 135;
double strokeWidth = 30;

class CircularSlider extends StatefulWidget {
  final ValueChanged<double> onAngleChanged;

  const CircularSlider({
    Key? key,
    required this.onAngleChanged,
  }) : super(key: key);

  @override
  State<CircularSlider> createState() => _CircularSliderState();
}

class _CircularSliderState extends State<CircularSlider> {
  Offset _currentDragOffset = Offset.zero;

  double currentAngle = 0;

  double startAngle = toRadian(0);

  double totalAngle = toRadian(180);

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.of(context).size;
    Size canvasSize = Size(screenSize.width, screenSize.width );
    Offset center = canvasSize.center(Offset.zero);
    Offset knobPos = toPolar(center - Offset(strokeWidth, strokeWidth),
        currentAngle + startAngle, radius);

    return Stack(
      children: [
        CustomPaint(
          size: canvasSize,
          painter: SliderPainter(
            startAngle: startAngle,
            currentAngle: currentAngle,
          ),
          child: Container(),
        ),
        Positioned(
          left: knobPos.dx,
          top: knobPos.dy+70,
          child: GestureDetector(
            onPanStart: (details) {
              RenderBox getBox = context.findRenderObject() as RenderBox;
              _currentDragOffset = getBox.globalToLocal(details.globalPosition);
            },
            onPanUpdate: (details) {
              var previousOffset = _currentDragOffset;
              _currentDragOffset += details.delta;
              print(_currentDragOffset);
              var angle = currentAngle +
                  toAngle(_currentDragOffset, center) -
                  toAngle(previousOffset, center);
              currentAngle = normalizeAngle(angle);
              widget.onAngleChanged(currentAngle);
              setState(() {});
            },
            child: const _Knob(),
          ),
        ),
      ],
    );
  }
}

class SliderPainter extends CustomPainter {
  final double startAngle;
  final double currentAngle;

  SliderPainter({required this.startAngle, required this.currentAngle});

  @override
  void paint(Canvas canvas, Size size) {
    Offset center = size.center(Offset.zero);

    Rect rect = Rect.fromCircle(center: center, radius: radius);
    var rainbowPaint = Paint()
      ..shader = SweepGradient(colors: colors).createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      rect,
      -0,
      math.pi ,
      false,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = strokeWidth..strokeCap = StrokeCap.round,
    );

    canvas.drawArc(rect, 0, currentAngle, false, rainbowPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}

class _Knob extends StatelessWidget {
  const _Knob({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      width: 60,
      decoration: BoxDecoration(
          color: const Color(0xff0b1623),
          shape: BoxShape.circle,
          border: Border.all(color: Colors.white, width: 3.0)),
    );
  }
}