import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:FlutterCloudMusic/comment/comment.dart';
import 'package:intl/intl.dart';

class CommentRow extends StatelessWidget {
  final Comment comment;
  final Function() callback;

  const CommentRow({
    Key key,
    this.comment,
    this.callback,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final commentDate = DateTime.fromMillisecondsSinceEpoch(comment.time);
    var formatter = DateFormat('yyyy年MM月dd日');
    String formattedDate = formatter.format(commentDate);
    final contentColumn = Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5),
        CMText(text: comment.user.nickname, fontSize: 14, color: Color(0xff676767)),
        CMText(text: formattedDate, fontSize: 11, color: Colors.grey,),
        SizedBox(height: 10),
        CMText(text: comment.content, fontSize: 17, color: Colors.black, maxLines: 10000),
        SizedBox(height: 10),
        CMText(text: comment.replies.length.toString() + "条回复>", fontSize: 14, color: Colors.blue),
        SizedBox(height: 15),
      ],
    );
    final contentRow = Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 15),
        ClipOval(child: CachedNetworkImage(imageUrl: comment.user.avatarUrl, width: 35, height: 35,)),
        SizedBox(width: 10),
        Expanded(
          child: contentColumn
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CMText(text: "2105", fontSize: 14, color: Colors.grey),
          ],
        )
      ],
    );
    final columnWithDivider = Column(
      children: [
        SizedBox(height: 10),
        contentRow,
        Divider(
          height: 0.5,
          indent: 55,
          color: Colors.grey
        )
      ],
    );
    final row = GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        if (callback != null) {callback();}
      },
      child: columnWithDivider,
    );
    return row;
  }
}
