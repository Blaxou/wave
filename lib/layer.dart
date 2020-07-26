import 'package:flutter/material.dart';

/// Meta data of layer
@immutable
class Layer {
  final Color color;
  final List<Color> gradient;
  final MaskFilter blur;
  final Path path;
  final double amplitude;
  final double phase;

  const Layer({
    this.color,
    this.gradient,
    this.blur,
    this.path,
    this.amplitude,
    this.phase,
  });
}
