import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  static final _databaseName = 'todo.db';
  static final _databaseVersion = 1;

  DatabaseHelper._privateConstructor();
  static final DatabaseHelper instance = DatabaseHelper._privateConstructor();
  static Database _database;

  // return the database
  Future<Database> get database async {
    if(_database != null)
      return _database;
    
    _database = await _initDatabase();
    return _database;
  }

  // initiate the db, if it doesn't exist, create it
  _initDatabase() async{
    String path = join(await getDatabasesPath(), _databaseName);

    return await openDatabase(
      path,
      version: _databaseVersion,
      onCreate: (db, version) async {
        await db.execute(
          'CREATE TABLE tasks('
          'id INTEGER PRIMARY KEY, '
          'description TEXT, '
          'done INTEGER, '
          'createdAt TEXT, '
          'updateAt TEXT )'
        );
      }
    );
  }

  /*
   * Insert a new row in table
   * @param row - Map that contains the data to be inserted
   * @param table - Table name
   * @return Id of the new element 
   */
  Future<int> insert(String table, Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      return await db.insert(table, row);
    }catch(e) {
      print('*ERROR* $e');
      throw Error();
    }
  }

  /*
   * Get all the rows stored in table
   * @param table - Table name 
   * @return List of Map that contains the data
   */ 
  Future<List<Map<String, dynamic>>> query(String table) async {
    try {
      Database db = await instance.database;
      return await db.query(table);
    } catch(e) {
      print('*ERROR* $e');
      throw Error();
    }
  }


  /*
   * Query according to received query string
   * @param query - Query that will be executed
   * @return Query result
   */
  Future<List<Map<String, dynamic>>> rawQuery(String query) async {
    try {
      Database db = await instance.database;
      return await db.rawQuery(query);            // SELECT * FROM $table WHERE _id = $id for example
    } catch(e) {
      print('*ERROR* $e');
      throw Error();
    }
  }

  /*
   * Update a row using it's id
   * @param table - Table name
   * @param id - Row id
   * @param row - Data to be updated
   * @return 
   */
  Future<int> update(String table, int id, Map<String, dynamic> row) async {
    try {
      Database db = await instance.database;
      return await db.update(table, row, where: 'id = ?', whereArgs: [id]);
    } catch(e) {
      print('*ERROR* $e');
      throw Error();
    }
  }

  /*
   * Update a row according to received query string
   * @param query - Query that will be executed
   * @return Update result
   */
  Future<int> rawUpdate(String query) async {
    try {
      Database db = await instance.database;
      return await db.rawUpdate(query);
    } catch(e) {
      print('*ERROR* ${e.toString()}');
      throw Error();
    }
  }

  /*
   * Delete a row using it's id
   * @param table - Table name
   * @param id - Row id
   * @return
   */
  Future<int> delete(String table, int id) async {
    try {
      Database db = await instance.database;
      return await db.delete(table, where: 'id = ?', whereArgs: [id]);
    } catch(e) {
      print('*ERROR* $e');
      throw Error();
    }
  }
}