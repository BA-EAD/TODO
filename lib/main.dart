import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:to_do_app/core/di/injection_container.dart' as di;
import 'package:to_do_app/core/di/injection_container.dart';
import 'package:to_do_app/core/services/notification_service.dart';
import 'package:to_do_app/core/services/todo_service.dart';
import 'package:to_do_app/core/services/work_manager_box.dart';
import 'package:to_do_app/feat_todo/screens/onboarding_page.dart';
import 'package:to_do_app/models/language.dart';
import 'package:to_do_app/utils/app_imports.dart';
import 'package:workmanager/workmanager.dart';

import 'firebase_options.dart';

final navigatorKey = GlobalKey<NavigatorState>();

FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    //     options: const FirebaseOptions(
    //   apiKey: 'AIzaSyAjkWGJG2qkGxAe2o3w6sN1VeWtl_WCvzM',
    //   appId: '1:969392343439:android:2b8a17bdfed67d53be63fa',
    //   projectId: 'todoapp-32ebc',
    //   storageBucket: 'todoapp-32ebc.appspot.com',
    //   messagingSenderId: '969392343439',
    // )
  );
  await di.init();
  await _initializeHive();

  // Initialize background tasks
  Workmanager().initialize(_callbackDispatcher);

  // Initialize notifications
  await LocalNotificationsService.init();

  WorkManagerBox.initializeHiveBoxes();

  // Handle notification in terminated state
  await _handleInitialNotification();

  runApp(const MyApp());
}

Future<void> _initializeHive() async {
  final appDocumentDirectory = await getApplicationDocumentsDirectory();
  Hive.init(appDocumentDirectory.path);
  await Hive.initFlutter();
  Hive.registerAdapter<Todo>(TodoAdapter());
  await Hive.openBox<Todo>(AppStrings.tasksBox);
}

Future<void> _handleInitialNotification() async {
  var notificationAppLaunchDetails =
      await flutterLocalNotificationsPlugin.getNotificationAppLaunchDetails();
  if (notificationAppLaunchDetails?.didNotificationLaunchApp == true) {
    navigatorKey.currentState?.pushNamed('/home');
  }
}

@pragma("vm:entry-point")
void _callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    switch (taskName) {
      case AppStrings.taskName:
        await TodoService.syncTodos();
        break;
      default:
        if (kDebugMode) {
          print("Unknown task: $taskName");
        }
    }
    return Future.value(true);
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => sl<TodoBloc>()),
        ],
        child: ScreenUtilInit(
            designSize: const Size(430, 932),
            builder: (context, _) {
              return ChangeNotifierProvider(
                create: (context) => LocaleModel(),
                child: Consumer<LocaleModel>(
                  builder: (context, localeModel, child) => MaterialApp(
                    title: 'ToDo App',
                    localizationsDelegates:
                        AppLocalizations.localizationsDelegates,
                    supportedLocales: AppLocalizations.supportedLocales,
                    locale: localeModel.locale,
                    debugShowCheckedModeBanner: false,
                    theme: ThemeData(
                      colorScheme: ColorScheme.fromSeed(
                          seedColor: AppColors.primaryColor),
                      useMaterial3: true,
                    ),
                    home: const OnboardPage(),
                    routes: {
                      '/home': (context) => const HomePage(),
                    },
                  ),
                ),
              );
            }));
  }
}
