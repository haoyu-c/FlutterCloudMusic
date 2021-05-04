import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import 'package:FlutterCloudMusic/moments/moment.dart';
import 'package:intl/intl.dart';

import '../utils.dart';

class MomentRow extends StatelessWidget {
  final Moment moment;
  const MomentRow({
    Key key,
    this.moment,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final momentPublishDate = DateTime.fromMillisecondsSinceEpoch(moment.createAt);
    var formatter = DateFormat('yyyy年MM月dd日');
    String formattedDate = formatter.format(momentPublishDate);
    bool hasPhotos = moment.images.length > 0;
    final imageWidgets = moment.images.map((e) => CachedNetworkImage(imageUrl: e));
    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () {},
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          20.h,
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              20.w,
              ClipOval(child: CachedNetworkImage(imageUrl: moment.user.avatarUrl, width: 35, height: 35,)),
              10.w,
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    CMText(text: moment.user.username, fontSize: 17, height: 17.5/15, color: AppState.of(context).themeData.labelColor,),
                    CMText(text: formattedDate, fontSize: 14, height: 17.5/14, color: AppState.of(context).themeData.secondaryLabelColor,),
                    10.h,
                    CMText(text: moment.content, fontSize: 17, fontWeight: FontWeight.bold,),
                    10.h,
                    functionItems
                  ],
                ),
              ),
              20.w
            ],
          ),
          20.h,
          Divider(height: 0.5, color: AppState.of(context).themeData.separatorColor)
        ]
      ),
    );
  }

  Widget functionItem(int value) {
    return Expanded(
      child: Center(
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CMImage.named("ic_comment_like", width: 16, height: 16),
            5.w,
            CMText(text: moment.likeCount.toString(), fontSize: 17),
          ],
        ),
      )
    );
  }

  Widget get functionItems {
    return Row(
      children: [
        functionItem(moment.likeCount),
        functionItem(moment.postCount),
        functionItem(moment.commentCount),
        Expanded(child: 
          CMImage.named("More", width: 32, height: 30)
        ),
      ],
    );
  }
  
}
