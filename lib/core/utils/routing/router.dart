import 'package:flutter/cupertino.dart';
import 'package:task_manager_app/core/utils/routing/routes.dart';
import 'package:task_manager_app/features/home/views/pages/home_page.dart';

import '../../../features/auth/views/pages/login_page.dart';

Route<dynamic>? onGenerateRoute(RouteSettings settings) {
  switch (settings.name) {
    case AppRoutes.homeRoute:
      return CupertinoPageRoute(
          builder: (_) => const HomePage(), settings: settings);
    case AppRoutes.loginRoute:
      return CupertinoPageRoute(
          builder: (_) => const LoginPage(), settings: settings);

    default:
      return null;
  }
}
