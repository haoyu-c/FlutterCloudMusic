import 'package:FlutterCloudMusic/comment/comment_content.dart';
import 'package:flutter/material.dart';

class CommentDialog extends StatelessWidget {

  final Map<String, dynamic> params;
  final Function(String) callback;
  const CommentDialog({
    Key key,
    this.params,
    this.callback,
  }) : super(key: key);

  static show(BuildContext context, Map<String, dynamic> params, Function(String) callback) {
    showDialog(
      barrierColor: Colors.transparent,
      context: context,
      builder: (context) {
        return GestureDetector(
          onTap: () {
            Navigator.of(context).pop();
          },
          behavior: HitTestBehavior.translucent,
          child: CommentDialog(params: params, callback: callback)
        );
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    final padding = Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: CommentContent(params: params, callback: callback),
      ),
    );
    return Material(
      child: padding,
      color: Colors.transparent,
    );
  }
}
