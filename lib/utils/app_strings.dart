import 'package:to_do_app/utils/app_imports.dart';

class AppStrings {
  static const String tasksBox = 'tasksBox';
  static const String frequencyBox = 'frequencyBox';
  static const String isWorkMangerStarted = 'isWorkMangerStarted';
  static const String taskName = "syncTodos";

  static const String fontName = 'Manrope';
  static const String fontNameManRope = 'Manrope';

  static const String prefStringsNotSyncedTodos = 'prefStringsNotSyncedTodos';

  static const addTaskFormKey = GlobalObjectKey<FormState>('addTask');
  static const updateTaskFormKey = GlobalObjectKey<FormState>('updateTask');

  static const addTitleKey = ValueKey('addTitleKey');
  static const addDescKey = ValueKey('addDescKey');
  static const updateTitleKey = ValueKey('updateTitleKey');
  static const updateDescKey = ValueKey('updateDescKey');
  static const addTodoKey = ValueKey('addTodoKey');
  static const updateTodoKey = ValueKey('updateTodoKey');
  static const addTodoFABKey = ValueKey('addTodoFABKey');
  static const editTodoKey = ValueKey('editTodoKey');
  static const deleteTodoKey = ValueKey('deleteTodoKey');
  static const shareTodoKey = ValueKey('shareTodoKey');
  static const popUpKey = ValueKey('popUpKey');
}

extension StringExtension on String {
  String toCapitalized() =>
      length > 0 ? '${this[0].toUpperCase()}${substring(1).toLowerCase()}' : '';

  String? isValidTitle(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    if (isEmpty) {
      return locale.empty_title;
    } else if (trim().length < 2) {
      return locale.title_limit;
    } else if (trim().length > 20) {
      return locale.title_char_limit;
    } else {
      return null;
    }
  }

  String? isValidDesc(BuildContext context) {
    var locale = AppLocalizations.of(context)!;
    if (isEmpty) {
      return locale.empty_desc;
    } else if (trim().length < 5) {
      return locale.desc_limit;
    } else {
      return null;
    }
  }
}
