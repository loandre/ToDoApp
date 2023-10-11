import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "todoDatabase.db";
  static final _databaseVersion = 1;

  static final table = 'todo_items';

  static const columnId = '_id';
  static const columnTitle = 'title';
  static const columnIsDone = 'isDone';

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();

  static Database? _database;
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnIsDone INTEGER NOT NULL
          )
          ''');
  }

  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = await db.insert(table, row);
    print('Inserted item with id: $id and data: $row');
    return id;
  }

  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> items =
        await db.query(table, orderBy: '$columnId DESC');
    print('Fetched ${items.length} items from database.');
    return items;
  }

  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['_id'];
    print('Updating item with ID $id with data: $row');
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    int affectedRows =
        await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    print('Deleted item with id: $id. Affected rows: $affectedRows');
    return affectedRows;
  }
}
