import 'dart:async';

import 'package:to_do_app/feat_todo/repo/firestore_todo_repo.dart';
import 'package:to_do_app/utils/app_imports.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final FireStoreTodoRepository fireStoreTodoRepository;
  final HiveDataStore dataStore = HiveDataStore();

  TodoBloc(this.fireStoreTodoRepository) : super(TodoInitial()) {
    // Load local todos
    on<LoadLocalTodos>((event, emit) async {
      try {
        emit(TodoLoading());

        final todos = await dataStore.getAllTasks();
        if (todos.isNotEmpty) {
          await Future.delayed(const Duration(seconds: 2));
        }
        emit(LocalTodosLoaded(todos));
      } catch (e) {
        emit(TodoOperationFailure('Failed to load local todos.'));
      }
    });

    // Load todos from Firebase (remote)
    on<LoadRemoteTodos>((event, emit) async {
      try {
        emit(TodoLoading());

        // Add 2-second delay
        await Future.delayed(const Duration(seconds: 2));

        final todosFb = await fireStoreTodoRepository.getTodos();
        emit(RemoteTodosLoaded(todosFb));
        emit(LocalTodosLoaded(todosFb));
      } catch (e) {
        emit(TodoOperationFailure('Failed to load remote todos.'));
      }
    });

    // Add new local todo
    on<AddLocalTodo>((event, emit) async {
      try {
        emit(TodoLoading());
        await dataStore.addTask(task: event.todo);
        emit(TodoOperationSuccess('Todo added successfully.'));
      } catch (e) {
        emit(TodoOperationFailure('Failed to add todo.'));
      }
    });

    // Update existing local todo
    on<UpdateLocalTodo>((event, emit) async {
      try {
        emit(TodoLoading());
        await dataStore.updateTask(task: event.todo);
        emit(TodoOperationSuccess('Todo updated successfully.'));
      } catch (e) {
        emit(TodoOperationFailure('Failed to update todo.'));
      }
    });

    // Sync local todos with Firebase
    on<SyncTodos>((event, emit) async {
      try {
        emit(TodoLoading());
        for (var todo in event.todos) {
          final todoUpdate = todo.copyWith(isSynced: true);
          await fireStoreTodoRepository.addTodo(todo);
          await dataStore.updateTask(task: todoUpdate);
        }
        emit(TodoOperationSuccess('Todos synced successfully.'));
      } catch (e) {
        emit(TodoOperationFailure('Failed to sync todos.'));
      }
    });

    // Delete todo locally and remotely
    on<DeleteTodo>((event, emit) async {
      try {
        emit(TodoLoading());
        await dataStore.deleteTask(id: event.todo.id);
        await fireStoreTodoRepository.deleteTodo(event.todo.id);
        emit(TodoOperationSuccess('Todo deleted successfully.'));
      } catch (e) {
        emit(TodoOperationFailure('Failed to delete todo.'));
      }
    });
  }
}
