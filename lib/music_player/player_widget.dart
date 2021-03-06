import 'dart:async';
import 'package:FlutterCloudMusic/model/song.dart';
import 'package:FlutterCloudMusic/network/network.dart';
import 'package:FlutterCloudMusic/util/cmimage.dart';
import 'package:FlutterCloudMusic/util/cmtext.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'dart:math';

enum PlayerState { stopped, playing, paused }

class PlayerWidget extends StatefulWidget {
  final Song song;

  const PlayerWidget({
    Key key,
    @required this.song,
  }) : super(key: key);

  @override
  _PlayerWidgetState createState() => _PlayerWidgetState();
}

class _PlayerWidgetState extends State<PlayerWidget> with TickerProviderStateMixin {
  String url;
  AudioPlayer _audioPlayer;
  AudioPlayerState _audioPlayerState;
  Duration _duration;
  Duration _position;
  bool showLyric;

  PlayerState _playerState = PlayerState.stopped;
  StreamSubscription _positionSubscription;
  StreamSubscription _playerCompleteSubscription;
  StreamSubscription _playerErrorSubscription;
  StreamSubscription _playerStateSubscription;
  StreamSubscription<PlayerControlCommand> _playerControlCommandSubscription;

  get _isPlaying => _playerState == PlayerState.playing;
  get _isPaused => _playerState == PlayerState.paused;
  get _durationText => toSongDurationString(_duration);
  get _positionText => toSongDurationString(_position);


  _PlayerWidgetState();
  

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        AnimatedBuilder(animation: controller1, builder: (ctx, child){
          return buildMusicCircle();
        }),
        Spacer(),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon("ic_like", 54),
            icon("ic_music_previous", 71),
            if (!_isPlaying) icon("ic_music_play", 73, _togglePlay) else icon("ic_music_pause", 73, _togglePlay),
            icon("ic_music_next", 51),
            icon("ic_music_more", 54),
          ]
        ),
        Row(
          children: [
            SizedBox(width: 20),
            CMText(text: _positionText ?? "", color: Colors.white,),
            Expanded(
              child: Slider(
                onChanged: (v) {
                  final position = v * _duration.inMilliseconds;
                  _audioPlayer.seek(Duration(milliseconds: position.round()));
                },
                value: (_position != null &&
                        _duration != null &&
                        _position.inMilliseconds > 0 &&
                        _position.inMilliseconds < _duration.inMilliseconds)
                      ? _position.inMilliseconds / _duration.inMilliseconds
                      : 0.0,
              ),
            ),
            CMText(text: _durationText ?? "", color: Colors.white),
            SizedBox(width: 20)
          ],
        ),
      ],
    );
  }

  Stack buildMusicCircle() {
    return Stack(
        children: [
          Container(
            color: Colors.transparent,
            width: 1.sw,
            height: 600.h,
          ),
          positionedImage("record_background_border"),
          Positioned(
            left: 20,
            top: 80,
            child: Transform(
              transform: Matrix4.rotationZ(rotation1.value),
              alignment: Alignment.center,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  CMImage.named("cd_bg", width: 1.sw - 40, height: 1.sw - 40),
                  ClipOval(
                    child: CachedNetworkImage(imageUrl: widget.song.imgUrl, width: (1.sw - 40) / 1.6, height: (1.sw - 40) / 1.6),
                  )
                ]
              ),
            ),
          ),
          Positioned(
            left: 1.sw / 2,
            top: 60,
            child: AnimatedBuilder(
              animation: controller2,
              builder: (ctx, child) {
                return Transform(
                  origin: Offset(0,0),
                  transform: Matrix4.rotationZ(rotation2.value),
                  child: CMImage.named('cd_thumb', width: 92, height: 138)
                );
              },
            ),
          )
        ],
      );
  }

  positionedWidget(Widget child) {
    return Positioned(
      left: 20,
      right: 20,
      top: 80,
      height: 1.sw - 40,
      child: child,
    );
  }

  positionedImage(String imageName) {
    return Positioned(
      left: 20,
      top: 80,
      child: Transform(
        transform: Matrix4.rotationZ(rotation1.value),
        alignment: Alignment.center,
        child: CMImage.named(imageName, width: 1.sw - 40, height: 1.sw - 40),
      ),
    );
  }

  _togglePlay() {
    if (_isPlaying) {
      _pause();
    } else {
      _play();
    }
  }

  icon(String name, double size, [VoidCallback onTap]) {
    return Expanded(
      child: GestureDetector(
        child: CMImage.named(name, width: size, height: size),
        onTap: onTap,
      )
    );
  }

  @override
  void initState() {
    super.initState();
    _initAudioPlayer();
    _initAnimation();
    // _getLyric();
  }

  AnimationController controller1;
  Animation<double> rotation1;
  AnimationController controller2;
  Animation<double> rotation2;
  _initAnimation() {
    controller1 = AnimationController(
      duration: Duration(seconds: 10),
      vsync: this,
    );
    rotation1 = Tween<double>(begin: 0, end: 2 * pi).animate(controller1);
    controller2 = AnimationController(
      duration: Duration(seconds: 1),
      vsync: this
    );
    rotation2 = Tween<double>(begin: -0.15 * pi, end: - 0.03 * pi).animate(controller2);
  }

  _initAudioPlayer() {
    _audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
    _duration = Duration(seconds: widget.song.duration);
    // _audioPlayer.onDurationChanged.listen((d) {
    //   setState(() {
    //     _duration = d;
    //   });
    // });
    _positionSubscription = _audioPlayer.onAudioPositionChanged.listen((position) {
      setState(() {
        _position = position;
      });
    });
  
    _playerCompleteSubscription =
        _audioPlayer.onPlayerCompletion.listen((event) {
      _onComplete();
      setState(() {
        _position = _duration;
      });
    });
    _playerErrorSubscription = _audioPlayer.onPlayerError.listen((msg) {
      setState(() {
        print(msg);
        _playerState = PlayerState.stopped;
        _duration = Duration(seconds: 0);
        _position = Duration(seconds: 0);
      });
    });
    _playerControlCommandSubscription =
        _audioPlayer.onPlayerCommand.listen((command) {
          print("command");
    });
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() {
        _audioPlayerState = state;
        if (state == AudioPlayerState.PLAYING) {
          controller1.repeat();
          controller2.forward();
        } else {
          controller1.stop();
          controller2.reverse();
        }
      });
    });
    _audioPlayer.onSeekComplete.listen((s) {
      
    });
    _audioPlayer.onNotificationPlayerStateChanged.listen((state) {
      if (!mounted) return;
      setState(() => _audioPlayerState = state);
    });
  }

  _onComplete() {
    setState(() {
      _playerState = PlayerState.stopped;
    });
  }

  String _lyric;

  _getLyric() async {
    Response response = await dio.get("api/lyric/" + widget.song.lyricName);
    if (response.statusCode == 200) {
      setState(() {
        _lyric = response.data;
      });
    } else {
      setState(() {
        _lyric = "未能获取到歌词";
      });
    }
  }

  Future<int> _play() async {
    final playPosition = (_position != null &&
            _duration != null &&
            _position.inMilliseconds > 0 &&
            _position.inMilliseconds < _duration.inMilliseconds)
        ? _position
        : null;
    final result = await _audioPlayer.play(widget.song.songUrl, position: playPosition);
      setState(() {
        if (result == 1) {
          _playerState = PlayerState.playing;
          _audioPlayer.setPlaybackRate(playbackRate: 1.0);
        }
      });
    return result;
  }

  Future<int> _pause() async {
    final result = await _audioPlayer.pause();
    if (result == 1) setState(() => _playerState = PlayerState.paused);
    controller1.stop();
    return result;
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    _positionSubscription.cancel();
    _playerCompleteSubscription.cancel();
    _playerErrorSubscription?.cancel();
    _playerStateSubscription?.cancel();
    _playerControlCommandSubscription?.cancel();
    controller1.dispose();
    controller2.dispose();
    super.dispose();
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