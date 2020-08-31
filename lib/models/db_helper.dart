import 'dart:async';
import 'dart:io' as io;
import 'package:kaku/models/db_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';

import 'db_model.dart';

class DBHelper {
  static Database _db;
  static const String DB_NAME = 'kaku.db';

  // Create the Table colums
  static const String PAYMENTS_TABLE = 'payments';
  static const String STOCKS_TABLE = 'stocks';

  // Create the stocks Table colums
  static const String STOCKS_ID = 'id';
  static const String STOCKS_VENDOR_ID = 'vendor_id';
  static const String PRODUCT_ID = 'product_id';
  static const String COST_PRICE = 'cost_price';
  static const String SELLING_PRICE = 'selling_price';
  static const String INITIAL_QUANTITY = 'initial_quantity';
  static const String CURRENT_QUANTITY = 'current_quantity';
  static const String COST_VALUE = 'cost_value';
  static const String DISCOUNT = 'discount';
  static const String EXPIRY_DATE = 'expiry_date';
  static const String TOTAL_VALUE = 'total_value';
  static const String DESCRIPTION = 'description';
  static const String STOCKS_AUTHORIZER = 'authorizer';
  static const String STOCKS_DELETED_AT = 'deleted_at';
  static const String STOCKS_CREATED_AT = 'created_at';
  static const String STOCKS_UPDATED_AT = 'updated_at';

  // Create the payments Table colums
  static const String PAYMENTS_ID = 'id';
  static const String PAYMENTS_VENDOR_ID = 'vendor_id';
  static const String INVOICE_NO = 'invoice_no';
  static const String RECEIPT_NO = 'receipt_no';
  static const String AMOUNT_PAID = 'amount_paid';
  static const String NOTE = 'note';
  static const String PAYMENT_METHOD = 'payment_method';
  static const String PAYEMENTS_AUTHORIZER = 'authorizer';
  static const String STATUS = 'status';
  static const String PAYMENTS_DELETED_AT = 'deleted_at';
  static const String PAYMENTS_CREATED_AT = 'created_at';
  static const String PAYMENTS_UPDATED_AT = 'updated_at';

  static const String URL = 'url';
  static const String THUMBNAIL_URL = 'thumbnailUrl';

  // Initialize the Database
  Future<Database> get db async {
    if (null != _db) {
      return _db;
    }
    _db = await initDb();
    return _db;
  }

  initDb() async {
    // Get the Device's Documents directory to store the Offline Database...
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, DB_NAME);
    var db = await openDatabase(path, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(Database db, int version) async {
    // Create the DB Table
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $PAYMENTS_TABLE ($PAYMENTS_ID INTEGER PRIMARY KEY, $PAYMENTS_VENDOR_ID TEXT, $INVOICE_NO TEXT, $RECEIPT_NO TEXT, $AMOUNT_PAID TEXT, $NOTE TEXT, $PAYMENT_METHOD TEXT, $PAYEMENTS_AUTHORIZER TEXT, $STATUS TEXT, $PAYMENTS_DELETED_AT TEXT, $PAYMENTS_CREATED_AT TEXT, $PAYMENTS_UPDATED_AT TEXT)");
    await db.execute(
        "CREATE TABLE IF NOT EXISTS $STOCKS_TABLE ($STOCKS_ID INTEGER PRIMARY KEY, $STOCKS_VENDOR_ID TEXT, $PRODUCT_ID TEXT, $COST_PRICE TEXT, $SELLING_PRICE TEXT, $INITIAL_QUANTITY TEXT, $CURRENT_QUANTITY TEXT, $COST_VALUE TEXT, $DISCOUNT TEXT, $EXPIRY_DATE TEXT, $TOTAL_VALUE TEXT, $DESCRIPTION TEXT, $STOCKS_AUTHORIZER TEXT, $PAYMENTS_DELETED_AT TEXT, $PAYMENTS_CREATED_AT TEXT, $PAYMENTS_UPDATED_AT TEXT)");
  }

  // Method to insert the Stock record to the Database
  Future<Stock> save(Stock stock) async {
    var dbClient = await db;
    // this will insert the Album object to the DB after converting it to a json
    stock.id = (await dbClient.insert(STOCKS_TABLE, stock.toJson())) as String;
    return stock;
  }

  // Method to return all Stocks from the DB
  Future<Stock> getStocks() async {
    var dbClient = await db;
    // specify the column names you want in the result set
    List<Map> maps = await dbClient.query(STOCKS_TABLE, columns: [
      STOCKS_ID,
      PRODUCT_ID,
      STOCKS_VENDOR_ID,
      SELLING_PRICE,
      DISCOUNT,
      STOCKS_CREATED_AT,
      CURRENT_QUANTITY,
      INITIAL_QUANTITY
    ]);
    Stock allStock = Stock();
    List<Stock> stocks = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        stocks.add(Stock.fromJson(maps[i]));
      }
    }
    allStock.stock = stocks;

    return allStock;
  }

  // Method to delete a Stock from the Database ....NOt needeD
  Future<int> delete(int id) async {
    var dbClient = await db;
    return await dbClient
        .delete(STOCKS_TABLE, where: '$STOCKS_ID = ?', whereArgs: [id]);
  }

  // Method to Update a Stock in the Database
  Future<int> update(Stock stock) async {
    var dbClient = await db;
    return await dbClient.update(STOCKS_TABLE, stock.toJson(),
        where: '$STOCKS_ID = ?', whereArgs: [stock.id]);
  }

  // Method to Truncate the Table DONE
  Future<void> truncateTable(String TABLE) async {
    var dbClient = await db;
    return await dbClient.delete(TABLE);
  }

  // Method to Close the Database DONE
  Future close() async {
    var dbClient = await db;
    dbClient.close();
  }
}
