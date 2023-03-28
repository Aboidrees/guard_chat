import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard_chat/constants.dart';
import 'package:guard_chat/core/app_colors.dart';
import 'package:guard_chat/core/app_routes.dart';
import 'package:guard_chat/widgets/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});
  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;

  late TextEditingController email;
  late TextEditingController password;

  @override
  void initState() {
    super.initState();
    email = TextEditingController();
    password = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: ModalProgressHUD(
        inAsyncCall: showSpinner,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Hero(
                tag: 'logo',
                child: SizedBox(height: 200.0, child: Image.asset('images/logo.png')),
              ),
              const SizedBox(height: 48.0),
              TextFormField(
                keyboardType: TextInputType.emailAddress,
                textAlign: TextAlign.center,
                controller: email,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your username'),
              ),
              const SizedBox(height: 8.0),
              TextFormField(
                obscureText: true,
                textAlign: TextAlign.center,
                controller: password,
                decoration: kTextFieldDecoration.copyWith(hintText: 'Enter your password'),
              ),
              const SizedBox(height: 24.0),
              RoundedButton(
                color: AppColors.secondary,
                text: 'Register',
                onPressed: () async {
                  setState(() => showSpinner = true);
                  try {
                    final newCredential = await _auth.createUserWithEmailAndPassword(email: email.text.trim(), password: password.text.trim());

                    if (newCredential.user != null && context.mounted) {
                      Navigator.pushReplacementNamed(context, AppRoutes.chat);
                    }
                  } on FirebaseAuthException catch (e) {
                    if (e.code == 'weak-password') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('The password provided is too weak.')),
                      );
                      debugPrint('The password provided is too weak.');
                    } else if (e.code == 'email-already-in-use') {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('The account already exists for that email.')),
                      );
                      debugPrint('The account already exists for that email.');
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(e.toString())),
                    );
                    debugPrint(e.toString());
                  }
                  setState(() => showSpinner = false);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
