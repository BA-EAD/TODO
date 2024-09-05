import 'package:flutter/material.dart';
import 'package:to_do_app/core/repo/local_db_repo.dart';

class BaseWidget extends InheritedWidget {
  BaseWidget({super.key, required this.child}) : super(child: child);

  final HiveDataStore dataStore = HiveDataStore();
  @override
  final Widget child;

  static BaseWidget of(BuildContext context) {
    final base = context.dependOnInheritedWidgetOfExactType<BaseWidget>();
    if (base != null) {
      return base;
    } else {
      throw StateError('Could not find ancestor widget of type BaseWidget');
    }
  }

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) {
    return false;
  }
}
