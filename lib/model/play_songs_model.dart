import 'dart:async';

import 'package:FlutterCloudMusic/model/song.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';


class PlaySongsModel with ChangeNotifier {
  AudioPlayer _audioPlayer = AudioPlayer();
  StreamController<String> _curPositionController = StreamController<String>.broadcast();

  List<Song> _songs = [];
  int curIndex = 0;
  Duration curSongDuration;
  AudioPlayerState _curState;
  Duration curSongPosition;

  List<Song> get allSongs => _songs;
  Song get curSong => _songs[curIndex];
  Stream<String> get curPositionStream => _curPositionController.stream;
  AudioPlayerState get curState => _curState;

  void init() {
    _audioPlayer.setReleaseMode(ReleaseMode.STOP);
    _audioPlayer.onPlayerStateChanged.listen((state) {
      _curState = state;
      if (state == AudioPlayerState.COMPLETED) {
        nextPlay();
      }
      notifyListeners();
    });
    _audioPlayer.onDurationChanged.listen((d) {
      curSongDuration = d;
      notifyListeners();
    });
    _audioPlayer.onAudioPositionChanged.listen((p) { 
      curSongPosition = p;
      if (curSongDuration == null) {
        return;
      }
      sinkProgress(p.inMilliseconds > curSongDuration.inMilliseconds ? curSongDuration.inMilliseconds : p.inMilliseconds);
    });
  }

  sinkProgress(int m) {
    _curPositionController.sink.add('$m-${curSongDuration.inMilliseconds}');
  }

  playSong(Song song) {
    _songs.insert(curIndex, song);
  }
  
  void playSongs(List<Song> songs, {int index}) {
    this._songs = songs;
    if (index != null) curIndex = index;
    play();
  }

  void addSongs(List<Song> songs) {
    this._songs.addAll(songs);
  }


  void play() async {
    if (curSong.isLocal) {
      _audioPlayer.play(curSong.localPath, isLocal: true, position: curSongPosition);
    } else {
      _audioPlayer.play(curSong.songUrl, position: curSongPosition);
    }
  }
  Song prevSong;
  void playOrPause(Song song) async {
    if (prevSong != null && prevSong.id != song.id) {
      clear();
      if (song.isLocal) {
        await _audioPlayer.play(song.localPath, isLocal: true, position: curSongPosition);
      } else {
        await _audioPlayer.play(song.songUrl, position: curSongPosition);
      }
      prevSong = song;
      return;
    }
    if (curState == AudioPlayerState.PAUSED || curState == AudioPlayerState.STOPPED || curState == null) {
      if (song.isLocal) {
        await _audioPlayer.play(song.localPath, isLocal: true, position: curSongPosition);
      } else {
        await _audioPlayer.play(song.songUrl, position: curSongPosition);
      }
      prevSong = song;
    } else {
      pausePlay();
    }
  }

  void playOrNothing(Song song) async {
    if (prevSong != null && prevSong.id != song.id) {
      clear();
      if (song.isLocal) {
        await _audioPlayer.play(song.localPath, isLocal: true, position: curSongPosition);
      } else {
        await _audioPlayer.play(song.songUrl, position: curSongPosition);
      }
      prevSong = song;
      return;
    }
    if (curState == AudioPlayerState.PAUSED || curState == AudioPlayerState.STOPPED || curState == null) {
      if (song.isLocal) {
        await _audioPlayer.play(song.localPath, isLocal: true, position: curSongPosition);
      } else {
        await _audioPlayer.play(song.songUrl, position: curSongPosition);
      }
      prevSong = song;
    }
  }

  clear() {
    curSongPosition = Duration(seconds: 0);
  }

  void pausePlay() {
    _audioPlayer.pause();
  }

  void seekPlay(int milliseconds){
    _audioPlayer.seek(Duration(milliseconds: milliseconds));
    resumePlay();
  }

  void resumePlay() {
    _audioPlayer.resume();
  }

  void nextPlay(){
    if(curIndex >= _songs.length - 1){
      curIndex = 0;
    }else{
      curIndex++;
    }
    play();
  }

  void prePlay(){
    if(curIndex <= 0){
      curIndex = _songs.length - 1;
    }else{
      curIndex--;
    }
    play();
  }

  get isPlaying {
    return _audioPlayer.state == AudioPlayerState.PLAYING;
  }

  get isPaused {
    return _audioPlayer.state == AudioPlayerState.PAUSED;
  }

  get positionText {
    return toSongDurationString(curSongPosition);
  }

  get durationText {
    return toSongDurationString(curSongDuration);
  }

  @override
  void dispose() {
    super.dispose();
    _curPositionController.close();
    _audioPlayer.dispose();
  }

  String toSongDurationString(Duration duration) {
    if (duration == null) {
      return "00:00";
    }
    String twoDigits(int n) => n.toString().padLeft(2, "0");
    String twoDigitMinutes = twoDigits(duration.inMinutes.remainder(60));
    String twoDigitSeconds = twoDigits(duration.inSeconds.remainder(60));
    return "$twoDigitMinutes:$twoDigitSeconds";
  }
}