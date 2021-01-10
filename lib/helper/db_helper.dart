/*
 * @Author: your name
 * @Date: 2021-01-09 15:14:53
 * @LastEditTime: 2021-01-10 14:06:38
 * @LastEditors: Please set LastEditors
 * @Description: In User Settings Edit
 * @FilePath: /flutter/udemy_flutter_sec13/lib/helper/db_helper.dart
 */
//将数据永久保存到手机内存上
import 'package:sqflite/sqflite.dart' as sql; //将数据保存到sql数据库中
import 'package:path/path.dart' as pathsys;

class DBHelper {
  //获取database
  static Future<sql.Database> database() async {
    //找到sql数据库在手机上保存的位置
    final dbPath = await sql.getDatabasesPath();
    //访问指定数据库，拿到数据库对象
    return sql.openDatabase(
      //pathsys.join把数据库在硬盘上的位置，和需要访问的数据库的名字连接起来
      pathsys.join(dbPath, 'places.db'),
      //如果打开指定的数据库没有成功,则新建
      onCreate: (db, version) {
        return db.execute(
            //REAL就是mysql中的double类型
            'CREATE TABLE user_places(id TEXT PRIMARY KEY, title TEXT, image TEXT, location_lat REAL, location_lng REAL, address TEXT)');
      },
      //指定数据库版本
      version: 1,
    );
  }

  //插入 sql
  static Future<void> insert(String table, Map<String, Object> data) async {
    //将新信息插入数据库
    final db = await DBHelper.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace, //有冲突数据直接覆盖
    );
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBHelper.database();
    //返回一个list of map
    return db.query(table);
  }
}
