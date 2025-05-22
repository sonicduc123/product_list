import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/product_model.dart';

class FavoriteService {
  Database? database;

  final String databaseName = "product_list.db";
  final String productTable = 'product';
  static final String id = 'id';
  static final String title = 'title';
  static final String price = 'price';
  static final String thumbnail = 'thumbnail';
  static final String isFavorite = 'is_favorite';

  Future<void> open() async {
    database = await openDatabase(
      join(await getDatabasesPath(), databaseName),
      onCreate: (db, version) {
        return db.execute(
            '''
          CREATE TABLE IF NOT EXISTS $productTable(
            $id INTEGER PRIMARY KEY, 
            $title TEXT, 
            $price REAL,
            $thumbnail TEXT,
            $isFavorite INTEGER
          )
          '''
        );
      },
      version: 1,
    );
  }

  Future<void> close() async {
    await database?.close();
  }

  Future<int?> insert(ProductModel product) async {
    await open();

    int? id = await database?.insert(
      productTable,
      product.toJson(),
      conflictAlgorithm: ConflictAlgorithm.fail,
    );

    await close();

    return id;
  }

  Future<List<Map<String, Object?>>?> getList({List<String>? columns}) async {
    await open();

    final List<Map<String, Object?>>? listMap = await database?.query(
      productTable,
      columns: columns,
    );

    await close();

    return listMap;
  }

  Future<int?> delete(int id) async {
    await open();

    int? count = await database?.delete(
      productTable,
      where: '${FavoriteService.id} = ?',
      whereArgs: [id],
    );

    await close();

    return count; // the number of rows affected
  }
}