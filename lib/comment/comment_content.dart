import 'package:FlutterCloudMusic/network/network.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CommentContent extends StatefulWidget {
  final Map<String, dynamic> params;
  final Function(String) callback;
  final bool autoFocus;

  const CommentContent({
    Key key,
    this.params,
    this.callback,
    this.autoFocus = true,
  }) : super(key: key);

  @override
  _CommentContentState createState() => _CommentContentState();
}

class _CommentContentState extends State<CommentContent> {
  String currentComment;
  @override
  Widget build(BuildContext context) {
    final textField = TextField(
      textInputAction: TextInputAction.send,
      decoration: InputDecoration(
        isDense: true,
        hintText: "说点什么吧, 也许Ta都听得到",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.all( Radius.circular(15.0)),
          borderSide: BorderSide(color: Colors.transparent, width: 5.0),
        ),
        fillColor: Color(0xfff7f7f7),
        filled: true,
        contentPadding: EdgeInsets.fromLTRB(12, 8, 8, 8)
      ),
      style: TextStyle(color: Colors.black, fontSize: 14),
      autofocus: widget.autoFocus,
      onChanged: (text) {
        setState(() {
          currentComment = text;
        });
      },
      maxLines: null,
      onSubmitted: (text) {
        if (widget.callback != null) {
          widget.callback(text);
          Network.postComment({"content": text, "songId": "43b82c23-2e83-474f-869d-adb373119fbb"});
        }
      },
    );
    final theme = Theme(
          data: ThemeData(
            primaryColor: Colors.transparent,
            primaryColorDark: Colors.transparent,
          ),
          child: textField);
    final padding = Padding(
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
      child: theme,
    );
    return Container(
      color: Color(0xfffefefe),
      width: 1.sw,
      child: padding,
    );
  }
}