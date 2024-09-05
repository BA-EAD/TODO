import 'package:flutter_test/flutter_test.dart';
import 'package:to_do_app/main.dart' as todo_app;

import '../feat_todo/screens/home_page.dart';

void main() {
  group('TODO App Widget Tests:', () {
    testWidgets('Verify TODO Update Functionality',
        (WidgetTester tester) async {
      // Launch the TODO app
      todo_app.main();
      await tester.pumpAndSettle(); // Wait for the app to stabilize

      final todoHomeScreen = TodoHomeScreen(tester);

      // Define test data
      const initialTitle = 'Initial TODO Item';
      const updatedTitle = 'Updated TODO Item';
      const initialDescription =
          'This TODO item was added for testing purposes.';
      const updatedDescription = 'The TODO item description has been updated.';

      // Perform actions
      // Add a new TODO item
      await todoHomeScreen.addTodoTask(initialTitle, initialDescription);
      final isTodoCreated = await todoHomeScreen.isTodoPresent(initialTitle);
      expect(isTodoCreated, true,
          reason:
              'The TODO item should be created and visible on the home screen.');

      // Update the TODO item
      await todoHomeScreen.updateTodoTask(updatedTitle, updatedDescription);
      final isTodoUpdated = await todoHomeScreen.isTodoPresent(updatedTitle);
      expect(isTodoUpdated, true,
          reason:
              'The TODO item should be updated and visible on the home screen.');
    });
  });
}
