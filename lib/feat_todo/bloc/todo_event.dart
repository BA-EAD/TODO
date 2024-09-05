import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo.dart';

@immutable
abstract class TodoEvent {}

// Event to load local todos
class LoadLocalTodos extends TodoEvent {}

// Event to load todos from Firebase (remote)
class LoadRemoteTodos extends TodoEvent {}

// Event to add a new todo locally
class AddLocalTodo extends TodoEvent {
  final Todo todo;
  AddLocalTodo({required this.todo});
}

// Event to update an existing todo locally
class UpdateLocalTodo extends TodoEvent {
  final Todo todo;
  UpdateLocalTodo({required this.todo});
}

// Event to sync local todos with Firebase
class SyncTodos extends TodoEvent {
  final List<Todo> todos;
  SyncTodos({required this.todos});
}

// Event to delete a todo locally and remotely
class DeleteTodo extends TodoEvent {
  final Todo todo;
  DeleteTodo({required this.todo});
}
