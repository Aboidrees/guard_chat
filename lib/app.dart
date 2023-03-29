import 'package:flutter/material.dart';
import 'package:guard_chat/config/themes/app_theme.dart';
import 'package:guard_chat/core/util/app_routes.dart';
import 'package:guard_chat/core/util/app_strings.dart';

class GuardChat extends StatelessWidget {
  const GuardChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppStrings.appName,
      debugShowCheckedModeBanner: false,
      theme: appTheme(),
      initialRoute: Routes.welcome,
      routes: routes,
    );
  }
}
