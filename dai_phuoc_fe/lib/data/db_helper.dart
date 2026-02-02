import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper{
  static final DatabaseHelper _instance = DatabaseHelper._internal();
  factory DatabaseHelper() => _instance;
  DatabaseHelper._internal();

  static Database? _database;

  Future<Database> get db async {
    _database ??= await _initDb();
    return _database!;
  }
  
  Future<Database> _initDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'daiphuoc.db');

    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate (Database db, int version) async{
    await db.execute(
      '''
      CREATE TABLE daiphuoc_users
      (
        id INTERGER PRIMARY KEY,
        hoten TEXT,
        socmnd TEXT,
        sdt TEXT,
        ngaysinh NUMERIC,
        phai TEXT,
        dantoc TEXT,
        quoctich TEXT,
        tinhthanh TEXT,
        phuongxa TEXT
      )
      '''
    );
  }

  // Future<int> insertUser (UserResponse user) async{
  //   Database db = await instance.db;
  //   return await db.insert('daiphuoc_users', user.toJson());
  // }

  // // Find user
  // Future<UserResponse?> getUserById (int id) async{
  //   final db = await instance.db;
  //   final result = await db.query(
  //     'daiphuoc_users',
  //     where: 'id = ?',
  //     whereArgs: [id]
  //   );

  //   if (result.isNotEmpty) {
  //     return UserResponse.fromJson(result.first);
  //   }
  //   return null;
  // }
}