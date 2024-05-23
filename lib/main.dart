import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:task_manager_app/core/repositories/main_repository.dart';
import 'package:task_manager_app/core/utils/routing/routes.dart';

import 'core/di/injection_container.dart';
import 'core/utils/routing/router.dart';
import '/core/di/injection_container.dart' as di;
import 'core/utils/theme_manager.dart';

 void main() async {
   await initialize();
  runApp(const MyApp());
}
Future<void> initialize() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
      overlays: [SystemUiOverlay.bottom, SystemUiOverlay.top]);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await di.configure();
}
final GlobalKey<NavigatorState> navigator = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late final isLogin ;
@override
  void initState() {
 isLogin = getIt<MainRepository>().getUserCredentials();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Sizer(
      builder: (context, orientation, deviceType) {
        return MaterialApp(
          title: 'Task Manager',
          theme: getApplicationTheme(),
          initialRoute: isLogin == null ? AppRoutes.loginRoute : AppRoutes.homeRoute,
          debugShowCheckedModeBanner: false,
          onGenerateRoute: onGenerateRoute,
          navigatorKey: navigator,
        );
      },
    );
  }
}
