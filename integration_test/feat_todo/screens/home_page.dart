import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/feat_todo/widgets/todo_tile.dart';
import 'package:to_do_app/utils/app_imports.dart';

class TodoHomeScreen {
  late WidgetTester tester;

  TodoHomeScreen(this.tester);

  final _addTodoFAB = find.byKey(AppStrings.addTodoFABKey);
  final _todoTitleField = find.byKey(AppStrings.addTitleKey);
  final _todoDescField = find.byKey(AppStrings.addDescKey);
  final _addTodoButton = find.byKey(AppStrings.addTodoKey);

  final _todoEditPopup = find.byKey(AppStrings.popUpKey);
  final _editButton = find.byKey(AppStrings.editTodoKey);
  final _updateTitleField = find.byKey(AppStrings.updateTitleKey);
  final _updateDescField = find.byKey(AppStrings.updateDescKey);
  final _updateTodoButton = find.byKey(AppStrings.updateTodoKey);

  Finder _todoLocator = find.byType(TodoTile);

  /// Add a new todo task
  Future<void> addTodoTask(String title, String description) async {
    await tester.tap(_addTodoFAB, warnIfMissed: true);
    await tester.pumpAndSettle();

    await tester.enterText(_todoTitleField, title);
    await tester.enterText(_todoDescField, description);
    await tester.tap(_addTodoButton, warnIfMissed: true);

    await tester.pumpAndSettle();
  }

  /// Update an existing todo task
  Future<void> updateTodoTask(String updatedTitle, String updatedDesc) async {
    await tester.tap(_todoLocator, warnIfMissed: true);
    await tester.pumpAndSettle();

    await tester.tap(_todoEditPopup, warnIfMissed: true);
    await tester.pumpAndSettle();

    await tester.tap(_editButton, warnIfMissed: true);
    await tester.pumpAndSettle();

    await tester.enterText(_updateTitleField, updatedTitle);
    await tester.enterText(_updateDescField, updatedDesc);

    await tester.tap(_updateTodoButton, warnIfMissed: true);
    await tester.pumpAndSettle();
  }

  /// Check if the todo is displayed in the list
  Future<bool> isTodoPresent(String title) async {
    _todoLocator =
        find.descendant(of: find.byType(TodoTile), matching: find.text(title));
    return tester.any(_todoLocator);
  }

  /// Check if the todo has been updated
  Future<bool> isTodoUpdated(String updatedTitle) async {
    _todoLocator = find.descendant(
        of: find.byType(TodoTile), matching: find.text(updatedTitle));
    return tester.any(_todoLocator);
  }
}
