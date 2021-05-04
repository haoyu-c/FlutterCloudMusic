import 'package:FlutterCloudMusic/model/app_state.dart';
import 'package:flutter/material.dart';

extension BrightnessExtension on Brightness {
  Brightness get reversed {
    return (this == Brightness.light) ? Brightness.dark : Brightness.light;
  }
}

extension ThemeDataExtension on ThemeData {
  bool get isLight {
    return brightness == Brightness.light;
  }

  static Brightness appBar(BuildContext context) {
    return AppState.of(context).themeData.appBarTheme.brightness;
  }

  Color get labelColor {
    return theme(0x000000ff, 0xffffffff);
  }

  Color get secondaryLabelColor {
    return theme(0x3c3c4399, 0xebebf599);
  }

  Color get systemFillColor {
    return theme(0x78788033, 0x7878805b);
  }

  Color get secondarySystemFillColor {
    return theme(0x78788028, 0x78788051);
  }

  Color get systemBackgroundColor {
    return theme(0xffffffff, 0x000000ff);
  }

  Color get secondarySystemBackground {
    return theme(0xf2f2f7ff, 0x1c1c1eff);
  }

  Color get systemGroupedBackgroundColor {
    return theme(0xf2f2f7ff, 0x000000ff);
  }

  Color get secondarySystemGroupedBackgroundColor {
    return theme(0xffffffff, 0x1c1c1eff);
  }

  Color get separatorColor {
    return theme(0x3c3c4349, 0x54545899);
  }

  Color get bottomBarColor {
    return theme(0xfefefeff, 0x121212ff);
  }

  Color theme(int light, int dark) {
    return isLight ? RGBAColor(light) : RGBAColor(dark);
  }

}

int transform2ARGB(int value) {
  final alpha = value & 0xff;
  final colorWithoutAlpha = (value >> 8) & 0xffffff;
  final colorRgbaValue = (alpha << 24) | colorWithoutAlpha;
  return colorRgbaValue;
}

class RGBAColor extends Color {
  RGBAColor.fromARGB(int a, int r, int g, int b) : super.fromARGB(a, r, g, b);
  RGBAColor(int value) : super(
    transform2ARGB(value)
  );
}

