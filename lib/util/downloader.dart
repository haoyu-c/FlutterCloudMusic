import 'package:FlutterCloudMusic/entrance/application.dart';
import 'package:FlutterCloudMusic/model/song.dart';
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
      await refreshDownloadTask();
      FlutterDownloader.registerCallback(downloadCallback);
    }
  }


  void _bindBackgroundIsolate() {
    bool isSuccess = IsolateNameServer.registerPortWithName(
        _port.sendPort, 'downloader_send_port');
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
      if (progress == 100) {
        Future.delayed(Duration(milliseconds: 200), () {
          refreshDownloadTask();
        });
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

  void requestDownloadSong(Song song) async {
    String name = song.name;
    String url = song.songUrl;
    TaskInfo task = TaskInfo(name: name ?? "无名", url: url);
    task.taskId = await FlutterDownloader.enqueue(
        url: task.url,
        headers: {"auth": "test_for_sql_encoding"},
        savedDir: _localPath,
        showNotification: true,
        openFileFromNotification: true);
    _tasks.add(task);
    Application.shared.sp.setString(task.taskId, song.toJson());
    refreshDownloadTask();
    notifyListeners();
  }

  void delete(TaskInfo task) async {
    await FlutterDownloader.remove(
        taskId: task.taskId, shouldDeleteContent: true);
    Application.shared.sp.remove(task.taskId);
    refreshDownloadTask();
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

  DownloadTaskStatus statusOf(Song song) {
    TaskInfo task = _tasks.firstWhere((task) => task.song.name == song.name, orElse: () {
      return null;
    });
    if (task == null) {
      return null;
    }
    return task.status;
  }

  refreshDownloadTask() async {
    final tasks = await FlutterDownloader.loadTasks();
    this._tasks = tasks.map((task) {
      String taskId = task.taskId;
      String json = Application.shared.sp.getString(taskId);
      Song song = Song.fromJson(json);
      TaskInfo info = TaskInfo(name: song.name,url: task.taskId);
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
  Song get song {
    final songJson = Application.shared.sp.getString(taskId);
    return Song.fromJson(songJson);
  }
}