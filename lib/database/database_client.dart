import 'package:FlutterCloudMusic/model/song.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseClient {
  Database _db;

  create() async {
    await _db.execute("""
      CREATE TABLE songs(id TEXT,userId TEXT,songUrl TEXT,name TEXT,lyricUrl TEXT)
    """);
  }

  upsertSong(Song song) async {
    int id = 0;
    var count = Sqflite.firstIntValue(await _db
        .rawQuery("SELECT COUNT(*) FROM songs WHERE id = ?", [song.id]));
    if (count == 0) {
      id = await _db.insert("songs", song.toDbMap());
    } else {
      await _db
          .update("songs", song.toDbMap(), where: "id= ?", whereArgs: [song.id]);
    }
    return id;
  }

}