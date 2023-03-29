import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard_chat/constants.dart';
import 'package:guard_chat/core/app_colors.dart';
import 'package:guard_chat/core/app_routes.dart';
import 'package:guard_chat/widgets/rounded_button.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class AuthenticationScreen extends StatefulWidget {
  const AuthenticationScreen({super.key});
  @override
  State<AuthenticationScreen> createState() => _AuthenticationScreenState();
}

class _AuthenticationScreenState extends State<AuthenticationScreen> {
  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;
  late String verCode;

  @override
  void initState() {
    super.initState();
    redirectIfLoggedIn();
  }

  redirectIfLoggedIn() {
    setState(() => showSpinner = true);
    if (_auth.currentUser != null && context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.chat);
    }
    setState(() => showSpinner = false);
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
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Flexible(
                child: Hero(
                  tag: 'logo',
                  child: SizedBox(height: 200.0, child: Image.asset('images/logo.png')),
                ),
              ),
              const SizedBox(height: 48.0),
              const PhoneNumberForm()
            ],
          ),
        ),
      ),
    );
  }
}

class PhoneNumberForm extends StatefulWidget {
  const PhoneNumberForm({super.key});

  @override
  State<PhoneNumberForm> createState() => _PhoneNumberFormState();
}

class _PhoneNumberFormState extends State<PhoneNumberForm> {
  final _auth = FirebaseAuth.instance;

  bool showSpinner = false;
  late TextEditingController countryCode;
  late TextEditingController phoneNumber;
  late String verCode;

  @override
  void initState() {
    super.initState();
    redirectIfLoggedIn();
    countryCode = TextEditingController();
    phoneNumber = TextEditingController();
  }

  redirectIfLoggedIn() {
    setState(() => showSpinner = true);
    if (_auth.currentUser != null && context.mounted) {
      Navigator.pushReplacementNamed(context, AppRoutes.chat);
    }
    setState(() => showSpinner = false);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 48.0),
        Row(
          children: [
            Flexible(
              flex: 3,
              child: TextFormField(
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: countryCode,
                decoration: kTextFieldDecoration.copyWith(prefixText: "+"),
              ),
            ),
            const SizedBox(width: 8.0),
            Flexible(
              flex: 7,
              child: TextFormField(
                textAlign: TextAlign.center,
                controller: phoneNumber,
                decoration: kTextFieldDecoration.copyWith(
                  hintText: 'Enter phone number',
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        RoundedButton(
          color: AppColors.secondary,
          text: 'Next',
          onPressed: () async {
            setState(() => showSpinner = true);

            try {
              await _auth.verifyPhoneNumber(
                phoneNumber: "+${countryCode.text.trim()}${phoneNumber.text.trim()}",
                verificationCompleted: _auth.signInWithCredential,
                codeSent: (String verificationId, int? resendToken) => setState(() => verCode = verificationId),
                codeAutoRetrievalTimeout: (String verificationId) => setState(() => verCode = verificationId),
                verificationFailed: (FirebaseAuthException e) {
                  var message = "";

                  if (e.code == 'invalid-phone-number') {
                    message = 'The provided phone number is not valid.';
                  } else {
                    message = 'Something went wrong, try again later.';
                  }

                  debugPrint(message);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
                },
              );
            } on FirebaseAuthException catch (e) {
              if (e.code == 'user-not-found') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('No user found for that email.')),
                );
                debugPrint('No user found for that email.');
              } else if (e.code == 'wrong-password') {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Wrong password provided for that user.')),
                );
                debugPrint('Wrong password provided for that user.');
              }
            } catch (e) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
              debugPrint(e.toString());
            }

            // await _auth.signInWithCredential(PhoneAuthProvider.credential(verificationId: this.verCode, smsCode: smsCode));

            setState(() => showSpinner = false);
          },
        ),
      ],
    );
  }
}
