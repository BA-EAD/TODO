import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:workmanager/workmanager.dart';

import '../../utils/app_strings.dart';

class WorkManagerBox {
  static late Box<String> frequencyBox;
  static late Box<bool> workManagerBox;

  static void initializeHiveBoxes() async {
    workManagerBox = await Hive.openBox<bool>(AppStrings.isWorkMangerStarted);
    frequencyBox = await Hive.openBox<String>(AppStrings.frequencyBox);
    debugPrint('WORKMANAGERBOX: $workManagerBox', wrapWidth: 1024);
    debugPrint('FREQUENCYBOX: $frequencyBox', wrapWidth: 1024);
  }

  static void setupBackgroundProcess() async {
    debugPrint('WORKMANAGERBOX====>: $workManagerBox', wrapWidth: 1024);
    final isStarted = workManagerBox.get(AppStrings.isWorkMangerStarted);
    if (isStarted == null) {
      await Workmanager().cancelAll();
      final uniqueIdentifier = DateTime.now().second.toString();
      await Workmanager().registerPeriodicTask(
        uniqueIdentifier,
        AppStrings.taskName,
        frequency: const Duration(hours: 6),
        constraints: Constraints(
          networkType: NetworkType.connected,
        ),
      );
      workManagerBox.put(AppStrings.isWorkMangerStarted, true);
    }
  }
}
