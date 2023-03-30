import 'package:flutter/material.dart';
import 'package:guard_chat/core/util/app_strings.dart';
import 'package:guard_chat/features/authentication/presentation/screens/authentication_screen.dart';
import 'package:guard_chat/features/chat/presentation/screens/chat_screen.dart';
import 'package:guard_chat/features/welcome/presentation/screens/welcome_screen.dart';

class Routes {
  static const String welcome = "welcome";
  static const String authentication = "login";
  static const String registration = "register";
  static const String chat = "chat";
}

class AppRoutes {
  static Route? onGenerateRoute(RouteSettings routeSettings) {
    switch (routeSettings.name) {
      case Routes.welcome:
        return MaterialPageRoute(builder: (context) => const WelcomeScreen());
      case Routes.authentication:
        return MaterialPageRoute(builder: (context) => const AuthenticationScreen());
      case Routes.chat:
        return MaterialPageRoute(builder: (context) => const ChatScreen());
      default:
        return undefinedRoute();
    }
  }

  static Route<dynamic> undefinedRoute() {
    return MaterialPageRoute(
      builder: (context) => const Scaffold(
        body: Center(child: Text(AppErrorMessages.noRoute)),
      ),
    );
  }
}
