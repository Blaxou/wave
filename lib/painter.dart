import 'dart:math';

import 'package:flutter/material.dart';

import 'layer.dart';

class CustomWavePainter extends CustomPainter {
  final Color color;
  final List<Color> gradient;
  final Alignment gradientBegin;
  final Alignment gradientEnd;
  final MaskFilter blur;

  double waveAmplitude;

  Animation<double> wavePhaseValue;

  double waveFrequency;

  double heightPercentange;

  double _tempA = 0.0;
  double _tempB = 0.0;
  double viewWidth = 0.0;
  final Paint _paint = Paint();

  CustomWavePainter({
    this.color,
    this.gradient,
    this.gradientBegin,
    this.gradientEnd,
    this.blur,
    this.heightPercentange,
    this.waveFrequency,
    this.wavePhaseValue,
    this.waveAmplitude,
    Listenable repaint,
  }) : super(repaint: repaint);

  void _setPaths(double viewCenterY, Size size, Canvas canvas) {
    final Layer _layer = Layer(
      path: Path(),
      color: color,
      gradient: gradient,
      blur: blur,
      amplitude: (-1.6 + 0.8) * waveAmplitude,
      phase: wavePhaseValue.value * 2 + 30,
    );

    _layer.path.reset();
    _layer.path.moveTo(
        0.0,
        viewCenterY +
            _layer.amplitude * _getSinY(_layer.phase, waveFrequency, -1));
    for (int i = 1; i < size.width + 1; i++) {
      _layer.path.lineTo(
          i.toDouble(),
          viewCenterY +
              _layer.amplitude * _getSinY(_layer.phase, waveFrequency, i));
    }

    _layer.path.lineTo(size.width, size.height);
    _layer.path.lineTo(0.0, size.height);
    _layer.path.close();
    if (_layer.color != null) {
      _paint.color = _layer.color;
    }
    if (_layer.gradient != null) {
      final rect = Offset.zero &
          Size(size.width, size.height - viewCenterY * heightPercentange);
      _paint.shader = LinearGradient(
              begin: gradientBegin ?? Alignment.bottomCenter,
              end: gradientEnd ?? Alignment.topCenter,
              colors: _layer.gradient)
          .createShader(rect);
    }
    if (_layer.blur != null) {
      _paint.maskFilter = _layer.blur;
    }

    _paint.style = PaintingStyle.fill;
    canvas.drawPath(_layer.path, _paint);
  }

  @override
  void paint(Canvas canvas, Size size) {
    final double viewCenterY = size.height * (heightPercentange + 0.1);
    viewWidth = size.width;
    _setPaths(viewCenterY, size, canvas);
  }

  @override
  bool shouldRepaint(CustomWavePainter oldDelegate) => false;

  double _getSinY(
      double startradius, double waveFrequency, int currentposition) {
    if (_tempA == 0) {
      _tempA = pi / viewWidth;
    }
    if (_tempB == 0) {
      _tempB = 2 * pi / 360.0;
    }

    return sin(
        _tempA * waveFrequency * (currentposition + 1) + startradius * _tempB);
  }
}
