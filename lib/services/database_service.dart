import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

// Classe responsável pela interação com o banco de dados SQLite
class DatabaseHelper {
  static const _databaseName = "todoDatabase.db";
  static const _databaseVersion = 1;

  static const table = 'todo_items';

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

  // Inicializa o banco de dados e cria a tabela
  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  // Cria a tabela no banco de dados
  Future _onCreate(Database db, int version) async {
    await db.execute('''
          CREATE TABLE $table (
            $columnId INTEGER PRIMARY KEY,
            $columnTitle TEXT NOT NULL,
            $columnIsDone INTEGER NOT NULL
          )
          ''');
  }

  // Insere um novo item no banco de dados
  Future<int> insert(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = await db.insert(table, row);
    print('Inserted item with id: $id and data: $row');
    return id;
  }

  // Consulta todos os registros da tabela
  Future<List<Map<String, dynamic>>> queryAllRows() async {
    Database db = await instance.database;
    List<Map<String, dynamic>> items =
        await db.query(table, orderBy: '$columnId DESC');
    print('Fetched ${items.length} items from database.');
    return items;
  }

  // Atualiza um registro no banco de dados
  Future<int> update(Map<String, dynamic> row) async {
    Database db = await instance.database;
    int id = row['_id'];
    print('Updating item with ID $id with data: $row');
    return await db.update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Exclui um registro do banco de dados
  Future<int> delete(int id) async {
    Database db = await instance.database;
    int affectedRows =
        await db.delete(table, where: '$columnId = ?', whereArgs: [id]);
    print('Deleted item with id: $id. Affected rows: $affectedRows');
    return affectedRows;
  }
}
