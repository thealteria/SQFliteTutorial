import 'dart:async';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:sqlite_database_tutorial/models/User.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = new DatabaseHelper.internal();
  factory DatabaseHelper() => _instance;

  final String tableUser = "userTable";
  final String columnId = "id";
  final String columnUsername = "username";
  final String columnPassword = "password";

  static Database _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  DatabaseHelper.internal();

  initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "maindb.db");

    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute("CREATE TABLE $tableUser($columnId INTEGER PRIMARY KEY, "
        "$columnUsername TEXT, $columnPassword TEXT)");
  }

  //insertion
  Future<int> saveUser(User user) async {
    var dbClient = await db;
    int res = await dbClient.insert("$tableUser", user.toMap());
    return res;
  }

  //get users
  Future<List> getAllUsers() async {
    var dbClient = await db;
    var result = await dbClient.rawQuery("SELECT * FROM $tableUser");
    return result.toList();
  }

  Future<int> getCount() async {
    var dbClient = await db;
    return Sqflite.firstIntValue(
        await dbClient.rawQuery("SELECT COUNT (*) FROM $tableUser"));
  }

  //get single user
  Future<User> getUser(int id) async {
    var dbClient = await db;
    var result = await dbClient
        .rawQuery("SELECT * FROM $tableUser WHERE $columnId = $id");
    if (result.length == 0) {
      return null;
    }
    return new User.fromMap(result.first);
  }

  //delete user
  Future<int> deleteUser(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(tableUser, where: "$columnId = ?", whereArgs: [id]);
  }

  //update user
  Future<int> updateUser(User user) async {
    var dbClient = await db;
    return await dbClient.update(tableUser, user.toMap(),
        where: "$columnId = ?", whereArgs: [user.id]);
  }

  //close db
  Future close() async {
    var dbClient = await db;
    return dbClient.close();
  }
}
