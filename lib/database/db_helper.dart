import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/transaction_model.dart';

class DatabaseHelper {
  // Singleton pattern - ensures only one instance of the database exists
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  // Criteria Requirements:
  // Database Name: expense_tracker.db
  // Table Name: transactions
  static const String _dbName = 'expense_tracker.db';
  static const String tableName = 'transactions';

  // Get the database instance (initializes if null)
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB(_dbName);
    return _database!;
  }

  // Initialize and open the SQLite database
  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
    );
  }

  // Criteria Table Structure:
  // id: INTEGER PRIMARY KEY AUTOINCREMENT
  // title: TEXT
  // amount: REAL
  // category: TEXT
  // type: TEXT
  // date: TEXT
  Future<void> _createDB(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $tableName (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title TEXT,
        amount REAL,
        category TEXT,
        type TEXT,
        date TEXT
      )
    ''');
  }

  // 1. CREATE: Insert a new transaction into the database
  Future<int> insertTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.insert(tableName, transaction.toMap());
  }

  // 2. READ: Get all transactions from database (ordered by date descending)
  Future<List<TransactionModel>> getAllTransactions() async {
    final db = await database;
    final result = await db.query(
      tableName,
      orderBy: 'date DESC, id DESC',
    );
    return result.map((map) => TransactionModel.fromMap(map)).toList();
  }

  // 3. UPDATE: Update an existing transaction by id
  Future<int> updateTransaction(TransactionModel transaction) async {
    final db = await database;
    return await db.update(
      tableName,
      transaction.toMap(),
      where: 'id = ?',
      whereArgs: [transaction.id],
    );
  }

  // 4. DELETE: Delete a transaction by id
  Future<int> deleteTransaction(int id) async {
    final db = await database;
    return await db.delete(
      tableName,
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  // 5. CALCULATION: Calculate Total Income dynamically
  Future<double> getTotalIncome() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM $tableName WHERE type = ?',
      ['Income'],
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  // 6. CALCULATION: Calculate Total Expense dynamically
  Future<double> getTotalExpense() async {
    final db = await database;
    final result = await db.rawQuery(
      'SELECT SUM(amount) as total FROM $tableName WHERE type = ?',
      ['Expense'],
    );
    if (result.isNotEmpty && result.first['total'] != null) {
      return (result.first['total'] as num).toDouble();
    }
    return 0.0;
  }

  // Close the database
  Future<void> close() async {
    final db = await database;
    db.close();
  }
}
