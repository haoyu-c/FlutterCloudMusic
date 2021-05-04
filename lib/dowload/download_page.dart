import 'package:FlutterCloudMusic/model/song.dart';
import 'package:FlutterCloudMusic/music_player/music_player_page.dart';
import 'package:FlutterCloudMusic/music_player/player_widget.dart';
import 'package:FlutterCloudMusic/util/downloader.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../utils.dart';


class DownloadPage extends StatefulWidget {
  @override
  _DownloadPageState createState() => _DownloadPageState();
}

class _DownloadPageState extends State<DownloadPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar,
      body: body,
    );
  }

  Widget get body {
    return Consumer<Downloader>(
      builder: (ctx, value, child) {
        return ListView.builder(
          itemBuilder: (BuildContext ctx, int index) {
            final task = value.tasks[index];
            final padding = Padding(
              padding: EdgeInsets.symmetric(horizontal:20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CMText(text: task.name ?? "无名", fontWeight: FontWeight.bold,fontSize: 22,),
                  Spacer(),
                  if (task.status == DownloadTaskStatus.running) 
                    CMText(text: task.progress.toString()),
                  if (task.status == DownloadTaskStatus.running)
                    CircularProgressIndicator(value: task.progress.toDouble() / 100.toDouble(), valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
                  if (task.status == DownloadTaskStatus.failed) 
                    CMText(text: "下载失败"),
                  if (task.status == DownloadTaskStatus.failed)
                    Icon(Icons.close, color: Colors.black, size: 24.0),
                  if (task.status == DownloadTaskStatus.complete)
                    Icon(Icons.done, color: Colors.black, size: 24.0),
                  if (task.status == DownloadTaskStatus.enqueued)
                    CMText(text: "等待下载"),
                  if (task.status == DownloadTaskStatus.undefined)
                    CMText(text: "未知状态"),
                ]
              ),
            );
            final slidable = Slidable(
              child: padding,
              actionPane: SlidableDrawerActionPane(),
              actionExtentRatio: 0.25,
              secondaryActions: [
                IconSlideAction(
                  caption: 'Delete',
                  color: Colors.red,
                  icon: Icons.delete,
                  onTap: () {
                    value.delete(task);
                  },
                ),
              ],
            );
            return GestureDetector(
              child: slidable,
              behavior: HitTestBehavior.translucent,
              onTap: () {
                if (task.savedDir == null || task.filename == null) {
                  showSnackBar("无法打开文件");
                } else {
                  String path = task.savedDir + '/' + task.filename;
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (ctx) {
                      Song song = task.song;
                      song.localPath = path;
                      return MusicPlayerPage(song: song);
                    })
                  );
                }
              }
            );
          },
          itemCount: download ? value.tasks.length : 4,
        );
      },
    );
  }

  showSnackBar(String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  AppBar get appBar {
    return AppBar(
      backgroundColor: blackWhiteBg,
      title: CMText(text: "下载管理", fontWeight: FontWeight.bold,),
      elevation: 0,
      automaticallyImplyLeading: false,
      brightness: ThemeDataExtension.appBar(context),
      actions: [
        GestureDetector(
          onTap: () {
            context.read<Downloader>().refreshDownloadTask();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Icon(Icons.refresh, color: Colors.black),
          ),
        )
      ],
    );
  }
}