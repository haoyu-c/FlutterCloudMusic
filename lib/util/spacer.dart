import 'package:flutter/material.dart';

class HSpacer extends StatelessWidget {
  final double height;
  const HSpacer(
    this.height,
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(height: height);
  }
}

class VSpacer extends StatelessWidget {
  final double width;
  const VSpacer(
    this.width,
  );
  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width);
  }
}

extension SpacerExtension on double {
  HSpacer get h {
    return HSpacer(this);
  }
  VSpacer get w {
    return VSpacer(this);
  }
}

extension IntSpacerExtension on int {
  HSpacer get h {
    return HSpacer(this.toDouble());
  }
  VSpacer get w {
    return VSpacer(this.toDouble());
  }
}