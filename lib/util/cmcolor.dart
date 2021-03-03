import 'dart:ui';

class CMColor {
  static white(double white, {double opacity = 1}) {
    return Color.fromRGBO((white * 255).toInt(), (white * 255).toInt(), (white * 255).toInt(), opacity);
  }
}