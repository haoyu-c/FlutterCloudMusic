import 'package:FlutterCloudMusic/entrance/application.dart';
import 'package:flutter/material.dart';

import 'dart:isolate';
import 'dart:ui';
import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:FlutterCloudMusic/utils.dart';
class Downloader extends ChangeNotifier {

  List<TaskInfo> _tasks = [];
  List<TaskInfo> get tasks {
    return _tasks;
  }
  ReceivePort _port = ReceivePort();
  String _localPath;

  init() async {
    if (download) {
      _bindBackgroundIsolate();
      await _prepare();
      await _refreshDownloadTask();
      FlutterDownloader.registerCallback(downloadCallback);
    }
  }


  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
    if (!isSuccess) {
      _bindBackgroundIsolate();
      return;
    }
    _port.listen((dynamic data) {
      print('UI Isolate Callback: $data');
      String id = data[0];
      DownloadTaskStatus status = data[1];
      int progress = data[2];

      if (_tasks != null && _tasks.isNotEmpty) {
        final task = _tasks.firstWhere((task) => task.taskId == id);
        if (task != null) {
          task.status = status;
          task.progress = progress;
        }
      }
      notifyListeners();
    });
  }

  Future<bool> _checkPermission() async {
    if (Platform.isAndroid) {
      final status = await Permission.storage.status;
      if (status != PermissionStatus.granted) {
        final result = await Permission.storage.request();
        if (result == PermissionStatus.granted) {
          return true;
        }
      } else {
        return true;
      }
    } else {
      return true;
    }
    return false;
  }

  void requestDownload({String name, String url}) async {
    TaskInfo task = TaskInfo(name: name ?? "无名", url: url);
    task.taskId = await FlutterDownloader.enqueue(
        url: task.url,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
    _tasks.add(task);
    Application.shared.sp.setString(task.taskId, task.name);
    _refreshDownloadTask();
    notifyListeners();
  }

  void _delete(TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    Application.shared.sp.remove(task.taskId);
    notifyListeners();
  }

  static void downloadCallback(
      String id, DownloadTaskStatus status, int progress) {
      print(
          'Background Isolate Callback: task ($id) is in status ($status) and process ($progress)');

    final SendPort send =
        IsolateNameServer.lookupPortByName('downloader_send_port');
    send.send([id, status, progress]);
  }

  Future<Null> _prepare() async {
    final tasks = await FlutterDownloader.loadTasks();
    _localPath = (await _findLocalPath()) + Platform.pathSeparator + 'Download';
    final savedDir = Directory(_localPath);
    bool hasExisted = await savedDir.exists();
    if (!hasExisted) {
      savedDir.create();
    }
  }

  _refreshDownloadTask() async {
    final tasks = await FlutterDownloader.loadTasks();
    this._tasks = tasks.map((task) {
      String taskId = task.taskId;
      String name = Application.shared.sp.getString(taskId);
      TaskInfo info = TaskInfo(name: name,url: task.taskId);
      info.taskId = task.taskId;
      info.filename = task.filename;
      info.progress = task.progress;
      info.savedDir = task.savedDir;
      info.status = task.status;
      info.timeCreated = info.timeCreated;
      return info;
    }).toList();
  }

  Future<String> _findLocalPath() async {
    final directory = Platform.isAndroid
        ? await getExternalStorageDirectory()
        : await getApplicationDocumentsDirectory();
    return directory.path;
  }

}

class TaskInfo {
  String name;
  String taskId;
  int progress = 0;
  DownloadTaskStatus status = DownloadTaskStatus.undefined;
  String url;
  String filename;
  String savedDir;
  int timeCreated;
  TaskInfo({this.name, this.url});
}