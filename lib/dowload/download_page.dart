import 'package:FlutterCloudMusic/util/downloader.dart';
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
            // final task = value.tasks[index];
            TaskInfo task = TaskInfo(name: "名字", url: "");
            task.progress = 50;
            return Padding(
              padding: EdgeInsets.symmetric(horizontal:20, vertical: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                children: [
                  CMText(text: task.name ?? "未命名1", fontWeight: FontWeight.bold,fontSize: 22,),
                  Spacer(),
                  // if (task.status == DownloadTaskStatus.running)
                  CMText(text: (task.progress ?? 50).toString())
                  // if (task.status == DownloadTaskStatus.running) 
                    // CircularProgressIndicator(value: task.progress.toDouble() / 100.toDouble(), valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
                  // if (task.status == DownloadTaskStatus.complete) 
                    // Icon(Icons.close, color: Colors.black, size: 24.0),
                  // if (task.status == DownloadTaskStatus.complete)
                  //   Icon(Icons.done, coslor: Colors.black, size: 24.0),
                  // if (task.status == DownloadTaskStatus.enqueued)
                  //   CircularProgressIndicator(value: 0, valueColor: AlwaysStoppedAnimation<Color>(Colors.black),),
                ]
              ),
            );
          },
          itemCount: download ? value.tasks.length : 4,
        );
      },
    );
  }

  AppBar get appBar {
    return AppBar(
      backgroundColor: blackWhiteBg,
      title: CMText(text: "下载管理", fontWeight: FontWeight.bold,),
      elevation: 0,
      automaticallyImplyLeading: false,
      brightness: ThemeDataExtension.appBar(context),
    );
  }
}