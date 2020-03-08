import 'dart:async';
import 'package:safe_money/models/model.dart';
import 'package:sqflite/sqflite.dart';

abstract class DB {
  static Database _db;
  static int get _version => 1;

  static Future<void> init() async {
    if (_db != null) {
      return;
    }

    try {
      String _path = await getDatabasesPath() + 'example';
      _db = await openDatabase(_path, version: _version, onCreate: onCreate);
      print('aaa');
    } catch (ex) {
      print(ex);
    }
  }

  static void onCreate(Database db, int version) async {
    await db.execute('''CREATE TABLE goal(
          id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
          sum INTEGER NOT NULL,
          name STRING NOT NULL,
          startDate STRING NOT NULL,
          haveSum INTEGER NOT NULL,
          needSum INTEGER NOT NULL
          )''');

    // await db.execute('''CREATE TABLE transaction(
    //       id INTEGER PRIMARY KEY NOT NULL,
    //       date STRING NOT NULL,
    //       time STRING NOT NULL,
    //       type STRING NOT NULL,
    //       sum INTEGER NOT NULL,
    //       goalId INTEGER NOT NULL,
    //       FOREIGN KEY (goalId) REFERENCES goal (id) ON DELETE NO ACTION ON UPDATE NO ACTION
    //       ) ''');
  }

  static Future<List<Map<String, dynamic>>> query(String table) async =>
      _db.query(table);

  static Future<int> insert(String table, Model model) async =>
      await _db.insert(table, model.toMap());

  static Future<int> update(String table, Model model) async => await _db
      .update(table, model.toMap(), where: 'id = ?', whereArgs: [model.id]);

  static Future<int> delete(String table, Model model) async =>
      await _db.delete(table, where: 'id = ?', whereArgs: [model.id]);
}
