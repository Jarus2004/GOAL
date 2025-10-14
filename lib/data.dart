import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'dart:developer' as developer;

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'dota.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE users(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          username TEXT UNIQUE,
          password TEXT
        )
      ''');
        await db.execute('''
        CREATE TABLE products(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT,
          price INTEGER,
          quantity INTEGER
        )
      ''');
      },
    );
  }

  // เพิ่ม user
  static Future<int> insertUser(Map<String, dynamic> user) async {
    final db = await database;
    return await db.insert('users', user);
  }

  // ตรวจสอบ user
  static Future<Map<String, dynamic>?> getUser(
    String username,
    String password,
  ) async {
    final db = await database;
    final result = await db.query(
      'users',
      where: 'username = ? AND password = ?',
      whereArgs: [username, password],
    );
    if (result.isNotEmpty) return result.first;
    return null;
  }

  //ระบบเพิ่มข้อมูลสินค้า
  static Future<int> insertProduct(Map<String, dynamic> product) async {
    final db = await database;
    return await db.insert('products', product);
  }

  //ระบบดึงข้อมูลสินค้า
  static Future<List<Map<String, dynamic>>> getProducts() async {
    final db = await database;
    return await db.query('products');
  }

  static Future<int> updateProduct(int id, Map<String, dynamic> product) async {
    final db = await database;
    return await db.update(
      'products',
      product,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // ระบบลบข้อมูลสินค้า (ลบทีละรายการ)
  static Future<int> deleteProduct(int id) async {
    final db = await database;
    return await db.delete('products', where: 'id = ?', whereArgs: [id]);
  }

  // อัปเดตจำนวนสินค้า (เพิ่ม/ลด)
  static Future<int> updateQuantity(int id, int quantity) async {
    final db = await database;
    return await db.update(
      'products',
      {'quantity': quantity},
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  static Future<void> clearProducts() async {
    final db = await database;
    await db.delete('products'); // ลบข้อมูลทั้งหมดในตาราง
    developer.log('Cleared all products from the database');
    await db.delete(
      'sqlite_sequence',
      where: 'name = ?',
      whereArgs: ['products'],
    );
  }
}

void printDbPath() async {
  final dbPath = await getDatabasesPath();
  developer.log('Database path: $dbPath');
  developer.log('Products: ${await DBHelper.getProducts()}');
}

void deleteDb() async {
  final dbPath = await getDatabasesPath();
  final path = join(dbPath, 'dota.db');
  await deleteDatabase(path);
  developer.log('Deleted database at $path');
}
