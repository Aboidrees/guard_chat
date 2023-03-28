import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard_chat/core/app_colors.dart';
import 'package:guard_chat/core/app_routes.dart';
import 'package:guard_chat/widgets/rounded_button.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> with SingleTickerProviderStateMixin {
  final _auth = FirebaseAuth.instance;
  late AnimationController controller;
  late Animation animation;

  @override
  void initState() {
    _auth.authStateChanges().listen((User? user) {
      if (user != null) Navigator.pushNamed(context, AppRoutes.chat);
    });

    super.initState();

    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animation = ColorTween(begin: AppColors.containerPrimary, end: AppColors.containerSecondary).animate(controller);
    controller.forward();
    controller.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: animation.value,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag: 'logo',
                  child: SizedBox(height: 120.0, child: Image.asset('images/logo.png')),
                ),
                AnimatedTextKit(
                  repeatForever: true,
                  animatedTexts: [
                    TypewriterAnimatedText(
                      'Guard Chat',
                      textStyle: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w900),
                      speed: const Duration(milliseconds: 200),
                    )
                  ],
                )
              ],
            ),
            const SizedBox(height: 140.0),
            RoundedButton(
              color: AppColors.secondary,
              text: 'Log In',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.login),
            ),
            RoundedButton(
              color: AppColors.secondary,
              text: 'Register',
              onPressed: () => Navigator.pushNamed(context, AppRoutes.registration),
            ),
          ],
        ),
      ),
    );
  }
}
