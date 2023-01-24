import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper{
  static Future<void> createTables(sql.Database database) async{
    await database.execute(""" CREATE TABLE items(
    id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
    weight TEXT,
    _id TEXT,
    user TEXT,
    video_title TEXT,
    thumbnail TEXT,
    video_id TEXT,
    type TEXT,
    cat TEXT,
    package INTEGER,
    SIV TEXT,
    status INTEGER,
    duration INTEGER,
    view INTEGER,
    createdAt TEXT
    uploadtime TEXT
    modifiedAt TEXT
    __v INTEGER
    )
    """);
  }

  static Future<sql.Database> db() async{
    return sql.openDatabase(
        'simple.db',
        version: 1,
        onCreate: (sql.Database database, int version) async{
          await createTables(database);
        }
    );
  }

  static Future<int> createItem(
      String weight,
      String _id,
      String user,
      String video_title,
      String thumbnail,
      String video_id,
      String type,
      String cat,
      int package,
      String SIV,
      int status,
      int duration,
      int view,
      String  createdAt,
      String uploadtime,
      String modifiedAt,
      int __v
      ) async{
    final db = await SQLHelper.db();

    final data = {
      'weight': weight,
      '_id': _id,
      'user':user,
      'video_title':video_title,
      'thumbnail':thumbnail,
      'video_id':video_id,
      'type':type,
      'cat':cat,
      'package':package,
      'SIV':SIV,
      'status':status,
      'duration':duration,
      'view':view,
      'createdAt':createdAt,
      'uploadtime':uploadtime,
      'modifiedAt':modifiedAt,
      '__v':__v,
    };

    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace
    );
    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async{
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }
  static Future<List<Map<String, dynamic>>> getItem(int id) async{
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id]);
  }

  static Future<void> deleteItem(int id) async{
    final db = await SQLHelper.db();
    try{
      await db.delete('items', where: "id = ?", whereArgs: [id]);
    } catch (err){
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }

}