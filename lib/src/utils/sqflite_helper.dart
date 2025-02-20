import 'package:mapospace_flutter_sdk/src/events/sale_event.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class SaleEventDatabaseHelper {
  static final SaleEventDatabaseHelper _instance =
      SaleEventDatabaseHelper._internal();

  factory SaleEventDatabaseHelper() => _instance;

  SaleEventDatabaseHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initializeDatabase();
    return _database!;
  }

  Future<Database> _initializeDatabase() async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final path =
        join(documentsDirectory.path, 'sale_events_db.db'); // Change db name

    return openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE sale_events (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            order_id TEXT NOT NULL,
            products TEXT NOT NULL,
            order_value TEXT NOT NULL,
            payment_status TEXT NOT NULL,
            payment_type TEXT NOT NULL,
            coupon_code TEXT,
            timestamp TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<void> insertSaleEvent(SaleEvent event) async {
    final db = await database;
    await db.insert(
      'sale_events',
      event.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<SaleEvent>> getUnsentSaleEvents() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('sale_events');

    return List.generate(maps.length, (i) {
      return SaleEvent.fromMap(maps[i]);
    });
  }

  Future<void> deleteSaleEvent(int id) async {
    final db = await database;
    await db.delete(
      'sale_events',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
