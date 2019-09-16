library db_open_helper;

import 'dart:async';
import 'dart:io';

import 'package:dulce_gusto_toolkit/coupons/coupon.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:synchronized/synchronized.dart';


final DbHelper dbHelper = new DbHelper._private();

class DbHelper {
  Database _database;
  String _databasePath;
  Lock _lock = Lock();

  DbHelper._private();


  _initialize() async {
    _databasePath = await getDatabasesPath();
    try {
      await Directory(_databasePath).create(recursive: true);
    } catch (_) {}
  }


  Future<Database> _open() async {
    if (_database != null){
      return _database;
    }

    await _initialize();

    await _lock.synchronized(() async {
      if (_database == null){
        _database = await _openDb();
      }
    });

    return _database;
  }

  close() async {
    _database.close();
  }

  Future<Database> _openDb() async {
    String path = join(_databasePath, 'createDbb');

    var database = await openDatabase(path, version: 1, onCreate: _createDb);
    return database;
  }

  FutureOr<void> _createDb(Database db, int version) async {
    await db.execute(
        "create table coupons(id integer primary key, code text, dateAdded integer, status integer, lastMessage text, dateLastAttempt integer)");
  }

  Future<Coupon> insertBonus(Coupon coupon) async {
    var db = await _openDb();
    int id = await db.insert(Coupon.tableName, coupon.toMap());
    return coupon.copyWith(id: id);
  }

  Future<void> updateBonus(Coupon bonus) async{
    var db = await _openDb();
    await db.update(Coupon.tableName, bonus.toMap(), where: 'id = ?', whereArgs: [bonus.id]);
  }


  Future<List<Coupon>> allBonus() async {
    var maps = await _database.query(Coupon.tableName);

    return List.generate(maps.length, (index) {
      return Coupon.fromMap(maps[index]);
    });
  }

}
