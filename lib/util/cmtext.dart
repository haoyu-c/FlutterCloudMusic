import 'package:FlutterCloudMusic/util/constants.dart';
import 'package:flutter/material.dart';

class CMText extends StatelessWidget {
  final String text;
  final String fontName;
  final double fontSize;
  final double height;
  final Color color;
  final FontWeight fontWeight;
  final TextAlign textAlign;
  final maxLines;

  CMText(
      {@required this.text,
      this.fontName = pingFangSCRegular,
      this.fontSize,
      this.color = Colors.black,
      this.height,
      this.fontWeight = FontWeight.normal,
      this.textAlign,
      this.maxLines,
      Key key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: this.textAlign,
      maxLines: maxLines,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        decoration: TextDecoration.none,
        fontFamily: this.fontName,
        fontSize: this.fontSize,
        height: this.height,
        fontWeight: this.fontWeight,
        color: this.color
      ),
    );
  }
}
