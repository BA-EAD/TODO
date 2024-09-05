import 'package:get_it/get_it.dart';
import 'package:to_do_app/feat_todo/bloc/todo_bloc.dart';
import 'package:to_do_app/feat_todo/repo/firestore_todo_repo.dart';
import 'package:to_do_app/feat_todo/repo/firestore_todo_repo_impl.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize external dependencies
  _initExternalDependencies();

  // Initialize repositories
  _initRepositories();

  // Initialize Blocs
  _initBlocs();
}

Future<void> _initBlocs() async {
  sl.registerFactory(() => TodoBloc(
      sl())); // Registers TodoBloc with dependency injection for TodoRepository
}

void _initRepositories() {
  sl.registerLazySingleton<FireStoreTodoRepository>(
      () => FireStoreTodoRepositoryImpl()); // Registers TodoRepository
}

void _initExternalDependencies() {}
