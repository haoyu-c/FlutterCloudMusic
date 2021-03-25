import 'package:FlutterCloudMusic/comment/comment_content.dart';
import 'package:FlutterCloudMusic/comment/comment_dialog.dart';
import 'package:FlutterCloudMusic/comment/comment_row.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:FlutterCloudMusic/comment/comment.dart';
import 'package:FlutterCloudMusic/network/network.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';

class CommentPage extends StatefulWidget {
  final String songId;
  const CommentPage({
    Key key,
    this.songId,
  }) : super(key: key);
  @override
  _CommentPageState createState() => _CommentPageState();
}

class _CommentPageState extends State<CommentPage> {
  List<Comment> comments;
  @override
  Widget build(BuildContext context) {
    final listView = ListView.builder(
      shrinkWrap: true,
      itemBuilder: (context, index) {
        return GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            CommentDialog.show(context, Map(), null);
          },
          child: commentRow(index),
        );
      },
      itemCount: (comments == null) ? 0 : comments.length,
    );
    final column = Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        header,
        Expanded(
          child: listView,
        ),
        Divider(color: Color(0xffcbcbcb),height: 0.5),
        GestureDetector(
          behavior: HitTestBehavior.translucent,
          onTap: () {
            CommentDialog.show(context, Map(), null);
          },
          child: Column(
            children: [
              IgnorePointer(
                child: CommentContent(autoFocus: false),
              ),
              KeyboardVisibilityBuilder(
                builder: (context, visible) => Container(
                  color: Color(0xfffefefe),
                  height: visible ? 0 : MediaQuery.of(context).viewPadding.bottom,
                ),
              )
            ],
          ),
        ),
      ],
    );
    return Scaffold(
      appBar: appBar,
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: column,
      ),
    );
  }
  commentRow(int index) {
    final comment = comments[index];
    return CommentRow(
      comment: comment,
      callback: () => CommentDialog.show(context, {}, null),
    );
  }

  int selectedOptionIndex = 0;

  get header {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CMText(text: "评论区", fontSize: 17),
          Spacer(),
          CMText(text: "最热"),
          SizedBox(width: 5),
          sortSeperator,
          SizedBox(width: 5),
          CMText(text: "最新")
        ],
      ),
    );
  }

  get appBar {
    return AppBar(
      title: CMText(
        text: "评论",
        fontSize: 17,
        fontWeight: FontWeight.bold,
        color: Colors.black,
      ),
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      elevation: 0,
      actions: [
        GestureDetector(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: CMImage.named("share", color: Colors.white, width: 24,height: 24),
          ),
        )
      ],
    );
  }

  sortOption(String text, int index) {
    final isSelected = (selectedOptionIndex == index);
    final textWidget = CMText(text: text, 
      fontSize: 17, 
      color: isSelected ? Colors.black : Colors.grey,
      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
    );
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {
        selectedOptionIndex = index;
      },
      child: Padding(
        padding: EdgeInsets.symmetric(vertical:5, horizontal: 5),
        child: textWidget,
      ),
    );
  }

  get sortSeperator {
    return Container(
      width: 0.5,
      height: 10,
      color: Colors.grey,
    );
  }

  @override
  void initState() { 
    super.initState();
    getComments();
  }

  getComments() async {
    try {
      final realDio = await dioFuture;
      final response = await realDio.get('api/comments/' + widget.songId);
      List responseList = response.data;
      comments = responseList.map((e) => Comment.fromMap(e)).toList();
      if (comments.isNotEmpty) {
        setState(() {
          this.comments = comments;
        });
      }
    } on DioError catch (error) {
      print(error);
    }
  }
}