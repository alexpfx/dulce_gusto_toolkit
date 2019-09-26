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

  Future<Database> getDb() async {
    if (_database != null) {
      return _database;
    }

    await _initialize();

    await _lock.synchronized(() async {
      if (_database == null) {
        _database = await _openDb();
      }
    });

    return _database;
  }

  close() async {
    _database.close();
  }

  Future<Database> _openDb() async {
    if (_databasePath == null) {
      throw Exception("Are you trying to call the wrong method?");
    }
    String path = join(_databasePath, 'database.db');



    var database = await openDatabase(path, version: 13, onCreate: _createDb, onUpgrade: _upgradeDb);
    return database;
  }

  FutureOr<void> _createDb(Database db, int version) async {

    await db.execute("drop table if exists ${Coupon.tableName};");

    print('onCreate******************************');
    await db.execute("create table ${Coupon.tableName}("
        "${Coupon.columnId} integer primary key autoincrement, "
        "${Coupon.columnCode} text not null, "
        "${Coupon.columnDateAdded} integer not null, "
        "${Coupon.columnStatus} integer, ${Coupon.columnLastMessage} text, "
        "${Coupon.columnDateLastAttempt} integer, "
        "${Coupon.columnMarkedForDelection} boolean check(${Coupon.columnMarkedForDelection} in(0,1)));");
  }



  Future<Coupon> insertBonus(Coupon coupon) async {
    var db = await getDb();
    int id = await db.insert(Coupon.tableName, coupon.toMap());
    return coupon.copyWith(id: id);
  }

  Future<int> saveOrUpdateBonus(Coupon bonus) async {
    var db = await getDb();
    print("saveOrUpdateBonus");
    var bonusMap = bonus.toMap();
    if (bonus.id == null) {
      print("insert");
      return await db.insert(Coupon.tableName, bonusMap);
    } else {
      print("update: ${bonus.markedForDelection}");
      return await db.update(Coupon.tableName, bonusMap,
          where: 'id = ?', whereArgs: [bonus.id]);
    }
  }

  Future<List<Coupon>> allBonus() async {
    var db = await getDb();
    var maps = await db.query(Coupon.tableName, orderBy: "${Coupon.columnDateAdded} desc");

    return List.generate(maps.length, (index) {
      return Coupon.fromMap(maps[index]);
    });
  }

  Future<Coupon> theBonus(int id) async {
    var map = (await _database.query(Coupon.tableName,
            distinct: true, where: 'id = ?', whereArgs: [id]))
        .first;
    return Coupon.fromMap(map);
  }

  FutureOr<void> _upgradeDb(Database db, int oldVersion, int newVersion) {
    _createDb(db, newVersion);

  }
}
