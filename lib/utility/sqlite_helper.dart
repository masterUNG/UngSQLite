import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:ungsqlite/models/todo_model.dart';

class SQLiteHelper {
  // Field
  String nameDatabase = 'todo.db';
  int versionDatabase = 1;
  String nameTable = 'todoTABLE';
  String columnId = 'id';
  String columnToDo = 'ToDo';

  // Method

  SQLiteHelper() {
    initDatabase();
  }

  Future<void> initDatabase() async {
    await openDatabase(join(await getDatabasesPath(), nameDatabase),
        onCreate: (Database database, int version) {
      return database.execute(
          'CREATE TABLE $nameTable ($columnId INTEGER PRIMARY KEY, $columnToDo TEXT)');
    }, version: versionDatabase);
  }

  Future<void> insertValueToSQLite(TodoModel model) async {
    Database database = await openDatabase(
      join(await getDatabasesPath(), nameDatabase),
    );

    try {
      database.insert(
        nameTable,
        model.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
      print('Insert OK');
    } catch (e) {
      print('e ===>>> ${e.toString()}');
    }
  }

  Future<List<TodoModel>> readAllData() async {
    Database database =
        await openDatabase(join(await getDatabasesPath(), nameDatabase));
    List<TodoModel> todoModels = List();
    List<Map<String, dynamic>> list = await database.query(nameTable);

    for (var map in list) {
      TodoModel model = TodoModel.fromMap(map);
      todoModels.add(model);
    }

    return todoModels;
  }

  Future<void> deleteSQLiteWhereId(int id) async {
    Database database =
        await openDatabase(join(await getDatabasesPath(), nameDatabase));

    try {
      await database.delete(nameTable, where: '$columnId = $id');
    } catch (e) {
      print('e of Delete ==>> ${e.toString()}');
    }
  }

  Future<void> updateSQLiteWhereId(TodoModel model) async {
    print('id ===>>> ${model.id}, ToDo new ====>>> ${model.todo}');
    Database database =
        await openDatabase(join(await getDatabasesPath(), nameDatabase));
    try {
      await database.update(nameTable, model.toMap(),
          where: '$columnId = ${model.id}');
    } catch (e) {
      print('e edit ==>> ${e.toString()}');
    }
  }
}
