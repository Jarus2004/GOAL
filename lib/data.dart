import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static Database? _db;

  static Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _initDB();
    return _db!;
  }

  static Future<Database> _initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'shop.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
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

  // ดึงจำนวนสินค้า
  static Future<int?> getQuantity(int id) async {
    final db = await database;
    final result = await db.query(
      'products',
      columns: ['quantity'],
      where: 'id = ?',
      whereArgs: [id],
    );
    if (result.isNotEmpty) {
      return result.first['quantity'] as int;
    }
    return null;
  }
}
