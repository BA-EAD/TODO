import 'dart:developer';

import 'package:to_do_app/feat_todo/repo/firestore_todo_repo.dart';
import 'package:to_do_app/utils/app_imports.dart';

import '../../core/common.dart';

class FireStoreTodoRepositoryImpl implements FireStoreTodoRepository {
  final CollectionReference _todosCollection =
      FirebaseFirestore.instance.collection('todos');
  String? currentUserId;

  FireStoreTodoRepositoryImpl() {
    _initializeCurrentUserId();
  }

  Future<void> _initializeCurrentUserId() async {
    currentUserId = await Common.getId();
    // currentUserId = await PlatformDeviceId.getDeviceId ?? 'default';
  }

  @override
  Future<void> addTodo(Todo todo) async {
    await _initializeCurrentUserId();
    try {
      await _todosCollection
          .doc(currentUserId)
          .collection('user_todos')
          .doc(todo.id)
          .set({
        'title': todo.title,
        'description': todo.description,
        'createdDT': todo.createdDT,
        'updatedDT': todo.updatedDT,
        'isCompleted': todo.isCompleted,
        'isSynced': true,
      });
    } catch (e) {
      log('Error adding todo: $e');
    }
  }

  @override
  Future<void> updateTodo(Todo todo) async {
    await _initializeCurrentUserId();
    try {
      await _todosCollection
          .doc(currentUserId)
          .collection('user_todos')
          .doc(todo.id)
          .update({
        'title': todo.title,
        'description': todo.description,
        'createdDT': todo.createdDT,
        'updatedDT': todo.updatedDT,
        'isCompleted': todo.isCompleted,
        'isSynced': todo.isSynced,
      });
    } catch (e) {
      log('Error updating todo: $e');
    }
  }

  @override
  Future<List<Todo>> getTodos() async {
    await _initializeCurrentUserId();
    List<Todo> firebaseTodos = [];
    try {
      var querySnapshot = await _todosCollection
          .doc(currentUserId)
          .collection('user_todos')
          .get();
      firebaseTodos = querySnapshot.docs.map((doc) {
        return Todo(
          id: doc.id,
          title: doc['title'],
          description: doc['description'],
          createdDT: doc['createdDT'].toDate(),
          updatedDT: doc['updatedDT'].toDate(),
          isCompleted: doc['isCompleted'],
          isSynced: doc['isSynced'],
        );
      }).toList();
    } catch (e) {
      log('Error fetching todos: $e');
    }
    return firebaseTodos;
  }

  @override
  Future<void> deleteTodo(String todoId) async {
    await _initializeCurrentUserId();
    try {
      await _todosCollection
          .doc(currentUserId)
          .collection('user_todos')
          .doc(todoId)
          .delete();
    } catch (e) {
      log('Error deleting todo: $e');
    }
  }
}
