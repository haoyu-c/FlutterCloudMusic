import 'package:flutter/material.dart';

class CMImage {
  static Image named(String name,
      {String suffix, double width, double height, Color color}) {
    String imageName;
    if (suffix == null) {
      imageName = "$name.png";
    } else {
      imageName = "$name.$suffix";
    }
    return Image.asset("images/$imageName",
        width: width, height: height, color: color);
  }

  static String imageNamed(String name, {String suffix}) {
    String imageName;
    if (suffix == null) {
      imageName = "$name.png";
    } else {
      imageName = "$name.$suffix";
    }
    return "images/$imageName";
  }
}

String imageNamed(String name) {
  return "images/$name.png";
}
