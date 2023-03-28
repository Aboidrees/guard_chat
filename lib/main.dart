import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:guard_chat/core/app_colors.dart';
import 'package:guard_chat/core/app_routes.dart';
import 'package:guard_chat/screens/chat_screen.dart';
import 'package:guard_chat/screens/login_screen.dart';
import 'package:guard_chat/screens/registration_screen.dart';
import 'package:guard_chat/screens/welcome_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const FlashChat());
}

class FlashChat extends StatelessWidget {
  const FlashChat({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: AppColors.headPrimary),
          bodyLarge: TextStyle(color: AppColors.headPrimary),
        ),
      ),
      // theme: ThemeData.light(),
      initialRoute: AppRoutes.welcome,
      routes: {
        AppRoutes.chat: (context) => const ChatScreen(),
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.welcome: (context) => const WelcomeScreen(),
        AppRoutes.registration: (context) => const RegistrationScreen(),
      },
    );
  }
}
