import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:flutter/material.dart';

class CMDialog {
  static Future<T> showLoadingDialog<T>(BuildContext context, {bool barrierDismissible = false, String text = "加载中"}) {
    return showDialog<T>(
      context: context,
      barrierDismissible: barrierDismissible,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: Container(
              color: Colors.white,
              width: 200,
              height: 200,
              child: Column(
                children: [
                  CircularProgressIndicator(backgroundColor: Colors.black),
                  CMText(text: "加载中", fontSize: 17)
                ],
              ),
            ),
          ),
        );
      }
    );
  }
}