class Lyric {
  String lyric;
  Duration startTime;
  Duration endTime;
  double offset;
  Lyric({
    this.lyric,
    this.startTime,
    this.endTime,
    this.offset
  });

  static List<Lyric> fromatLyricString(String lyricString) {
    // ^ 匹配开头, \[ 匹配 [, \d{2} 匹配两个数字, eg: [00:17.65]让我掉下眼泪的 
    RegExp reg = RegExp(r"^\[\d{2}");
    List<Lyric> result = lyricString.split('\n').where((r) => reg.hasMatch(r)).map((s) {
      String time = s.substring(0, s.indexOf(']'));
      String lyric = s.substring(s.indexOf('[') + 1);
      time = s.substring(1, time.length - 1);
      int hourIndex = time.indexOf(":");
      int minuteIndex = time.indexOf(".");
      return Lyric(
        lyric: lyric,
        startTime: Duration(
          minutes: int.parse(time.substring(0, hourIndex)),
          seconds: int.parse(
            time.substring(hourIndex + 1, minuteIndex)
          ),
          milliseconds: int.parse(time.substring((minuteIndex + 1))),
        ),
      );
    }).toList();
    for (int i = 0; i < result.length; i++) {
      result[i].endTime = result[i + 1].startTime;
    }
    result[result.length - 1].endTime = Duration(hours: 1);
    return result;
  }
}
