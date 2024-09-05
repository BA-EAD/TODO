import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/utils/app_strings.dart';

class HiveDataStore {
  HiveDataStore._privateConstructor();

  static final HiveDataStore _instance = HiveDataStore._privateConstructor();

  factory HiveDataStore() {
    return _instance;
  }

  static const String _boxName = AppStrings.tasksBox;

  Future<Box<Todo>> _getBox() async {
    if (!Hive.isBoxOpen(_boxName)) {
      await Hive.openBox<Todo>(_boxName);
    }
    return Hive.box<Todo>(_boxName);
  }

  /// Add new task
  Future<void> addTask({required Todo task}) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  /// Get a single task by id
  Future<Todo?> getTask({required String id}) async {
    final box = await _getBox();
    return box.get(id);
  }

  /// Get all tasks
  Future<List<Todo>> getAllTasks() async {
    final box = await _getBox();
    return box.values.toList();
  }

  /// Update an existing task
  Future<void> updateTask({required Todo task}) async {
    final box = await _getBox();
    await box.put(task.id, task);
  }

  /// Delete a task
  Future<void> deleteTask({required String id}) async {
    final box = await _getBox();
    await box.delete(id);
  }

  /// Listen to changes in the task box
  ValueListenable<Box<Todo>> listenToTask() {
    return Hive.box<Todo>(_boxName).listenable();
  }
}
