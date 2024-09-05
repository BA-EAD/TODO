import 'package:hive/hive.dart';
import 'package:to_do_app/core/services/notification_service.dart';
import 'package:to_do_app/core/services/todo_service.dart';
import 'package:to_do_app/models/todo.dart';
import 'package:to_do_app/utils/app_strings.dart';

import '../common.dart';

export 'package:cloud_firestore/cloud_firestore.dart';

class TodoService {
  static Future<void> syncTodos() async {
    String? currentUserId = await Common.getId();
    // var currentUserId = await PlatformDeviceId.getDeviceId ?? 'default';
    var box = await Hive.openBox<Todo>(AppStrings.tasksBox);

    List<Todo> notSyncedTodos =
        box.values.where((todo) => !todo.isSynced).toList();

    if (notSyncedTodos.isNotEmpty) {
      for (var todo in notSyncedTodos) {
        await _syncTodoToRemote(todo, currentUserId!);
        await _updateLocalTodoAsSynced(todo);
      }
      LocalNotificationsService.showSimpleNotification(
        title: "Sync Complete",
        body: "Your tasks have been successfully synchronized.",
      );
    }
  }

  static Future<void> _syncTodoToRemote(Todo todo, String userId) async {
    await FirebaseFirestore.instance
        .collection("todos")
        .doc(userId)
        .collection('user_todos')
        .doc(todo.id)
        .set({
      'title': todo.title,
      'description': todo.description,
      'createdDT': todo.createdDT,
      'updatedDT': todo.updatedDT,
      'isCompleted': todo.isCompleted,
      'isSynced': true,
      'lastUpdateDT': FieldValue.serverTimestamp()
    });
  }

  static Future<void> _updateLocalTodoAsSynced(Todo todo) async {
    var box = await Hive.openBox<Todo>(AppStrings.tasksBox);
    final updatedTodo = todo.copyWith(isSynced: true);
    await box.put(updatedTodo.id, updatedTodo);
  }
}
