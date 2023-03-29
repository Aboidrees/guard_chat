import 'package:guard_chat/screens/authentication_screen.dart';
import 'package:guard_chat/screens/chat_screen.dart';
import 'package:guard_chat/screens/welcome_screen.dart';

class Routes {
  static const String welcome = "welcome";
  static const String authentication = "login";
  static const String registration = "register";
  static const String chat = "chat";
}

final routes = {
  Routes.welcome: (context) => const WelcomeScreen(),
  Routes.authentication: (context) => const AuthenticationScreen(),
  Routes.chat: (context) => const ChatScreen(),
};
