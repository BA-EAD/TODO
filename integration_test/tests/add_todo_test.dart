import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/main.dart' as todo_app;

import '../feat_todo/screens/home_page.dart';

void main() {
  group('TODO App Widget Test:', () {
    testWidgets('Validate TODO Creation', (WidgetTester tester) async {
      // Launch the app
      todo_app.main();
      await tester.pumpAndSettle(); // Wait for the app to settle

      // Create an instance of TodoHomeScreen
      final todoHomeScreen = TodoHomeScreen(tester);

      // Test data setup
      const title = 'Integration Test Task';
      const description = 'This task is added using Flutter Widget Test.';

      // Actions
      // Open add TODO screen via the FloatingActionButton
      await tester.tap(find.byType(FloatingActionButton));
      await tester.pumpAndSettle();

      // Add the TODO task
      await todoHomeScreen.addTodoTask(title, description);

      // Validate if the TODO is present
      final isTodoCreated = await todoHomeScreen.isTodoPresent(title);
      expect(isTodoCreated, true,
          reason:
              'The new TODO should be added and displayed on the home screen.');
    });
  });
}
