import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard_chat/core/util/app_colors.dart';
import 'package:guard_chat/core/util/app_routes.dart';
import 'package:guard_chat/core/util/app_strings.dart';
import 'package:guard_chat/core/util/assets_manager.dart';
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
    super.initState();
    _auth.authStateChanges().listen((User? user) => (user != null) ? Navigator.pushNamed(context, Routes.chat) : null);
    controller = AnimationController(duration: const Duration(milliseconds: 500), vsync: this);
    animation = ColorTween(begin: AppColors.backgroundAccent, end: AppColors.background).animate(controller);
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Expanded(
              child: Row(
                children: <Widget>[
                  Hero(tag: HeroTags.logo, child: SizedBox(height: 120.0, child: Image.asset(ImgAssets.logo))),
                  AnimatedTextKit(
                    repeatForever: true,
                    animatedTexts: [
                      TypewriterAnimatedText(
                        AppStrings.appName,
                        textStyle: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.w900),
                        speed: const Duration(milliseconds: 200),
                      )
                    ],
                  )
                ],
              ),
            ),
            const SizedBox(height: 60.0),
            // const Spacer(),

            RoundedButton(
              color: AppColors.secondary,
              text: AppStrings.getStarted,
              onPressed: () => Navigator.pushNamed(context, Routes.authentication),
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
