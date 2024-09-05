import 'package:flutter/material.dart';
import 'package:to_do_app/models/todo.dart';

@immutable
abstract class TodoState {}

// Initial state when the BLoC is first created
class TodoInitial extends TodoState {}

// State while todos are being loaded
class TodoLoading extends TodoState {}

// State when local todos have been successfully loaded
class LocalTodosLoaded extends TodoState {
  final List<Todo?> todos;

  LocalTodosLoaded(this.todos);
}

// State when remote todos from Firebase have been successfully loaded
class RemoteTodosLoaded extends TodoState {
  final List<Todo?> todos;

  RemoteTodosLoaded(this.todos);
}

// State indicating a successful todo operation, such as adding, updating, or deleting
class TodoOperationSuccess extends TodoState {
  final String message;

  TodoOperationSuccess(this.message);
}

// State indicating an error occurred during a todo operation
class TodoOperationFailure extends TodoState {
  final String errorMessage;

  TodoOperationFailure(this.errorMessage);
}
