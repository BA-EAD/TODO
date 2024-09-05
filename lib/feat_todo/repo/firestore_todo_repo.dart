import 'package:to_do_app/utils/app_imports.dart';

abstract class FireStoreTodoRepository {
  Future<void> addTodo(Todo todo);
  Future<void> updateTodo(Todo todo);
  Future<List<Todo>> getTodos();
  Future<void> deleteTodo(String todoId);
}
