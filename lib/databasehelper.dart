import 'dart:ffi';

import 'package:path/path.dart';
import 'package:practice1/models/task.dart';
import 'package:practice1/models/todo.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseHelper {
  Future<Database> database() async {
    return openDatabase(join(await getDatabasesPath(), 'tasks.db'),
        onCreate: (db, version) async {
      // Run the CREATE TABLE statement on the database.
      await db.execute(
        "CREATE TABLE tasks(id INTEGER PRIMARY KEY, title TEXT, description TEXT)",
      );
      await db.execute(
        "CREATE TABLE todo(id INTEGER PRIMARY KEY, title TEXT , isdone INTEGER, taskid INTEGER)",
      );

      return db;
    }, version: 1);
  }

  Future<int> insertTask(Task task) async {
    int taskid = 0;
    Database _db = await database();
    await _db
        .insert('tasks', task.toMap(),
            conflictAlgorithm: ConflictAlgorithm.replace)
        .then((value) {
      taskid = value;
    });
    return taskid;
  }

  Future<void> updateTaskTitle(int id, String title) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE tasks SET title = '$title' WHERE id = '$id' ");
  }

  Future<void> updateTaskDescription(int id, String description) async {
    Database _db = await database();
    await _db.rawUpdate(
        "UPDATE tasks SET description = '$description' WHERE id = '$id' ");
  }

  Future<void> insertTodo(Todo todo) async {
    Database _db = await database();
    await _db.insert('todo', todo.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<Task>> getTasks() async {
    Database _db = await database();

    List<Map<String, dynamic>> taskMap = await _db.query('tasks');

    return List.generate(taskMap.length, (index) {
      return Task(
          id: taskMap[index]['id'],
          title: taskMap[index]['title'],
          description: taskMap[index]['description']);
    });
  }

  Future<List<Todo>> getTodo(int taskid) async {
    Database _db = await database();

    List<Map<String, dynamic>> todoMap =
        await _db.rawQuery("SELECT * FROM todo WHERE taskid = $taskid");

    return List.generate(todoMap.length, (index) {
      return Todo(
          id: todoMap[index]['id'],
          title: todoMap[index]['title'],
          isdone: todoMap[index]['isdone'],
          taskid: todoMap[index]['taskid']);
    });
  }

  Future<void> updateTodoDone(int id, int isdone) async {
    Database _db = await database();
    await _db.rawUpdate("UPDATE todo SET isdone = '$isdone' WHERE id = '$id' ");
  }

  Future<void> deleteTask(int id) async {
    Database _db = await database();
    await _db.rawDelete("DELETE FROM tasks WHERE id = '$id'");
    await _db.rawDelete("DELETE FROM todo WHERE taskid = '$id'");
  }
}
