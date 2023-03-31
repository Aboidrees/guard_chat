import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard_chat/config/constants.dart';
import 'package:guard_chat/config/routes/app_routes.dart';
import 'package:guard_chat/core/util/app_colors.dart';
import 'package:guard_chat/core/util/app_strings.dart';
import 'package:guard_chat/core/util/assets_manager.dart';
import 'package:guard_chat/core/util/error_message.dart';
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
      Navigator.pushReplacementNamed(context, Routes.chat);
    }
    setState(() => showSpinner = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
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
                  tag: HeroTags.logo,
                  child: SizedBox(height: 200.0, child: Image.asset(ImgAssets.logo)),
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
  late FocusNode countryCodeFocus;
  late FocusNode phoneNumberFocus;

  @override
  void initState() {
    super.initState();
    redirectIfLoggedIn();
    countryCodeFocus = FocusNode();
    phoneNumberFocus = FocusNode();
    countryCode = TextEditingController(text: "+");
    phoneNumber = TextEditingController();
  }

  redirectIfLoggedIn() {
    setState(() => showSpinner = true);
    if (_auth.currentUser != null && context.mounted) {
      Navigator.pushReplacementNamed(context, Routes.chat);
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
                focusNode: countryCodeFocus,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: countryCode,
                onChanged: (value) => (value.toString().length >= 4) ? phoneNumberFocus.requestFocus() : null,
              ),
            ),
            const SizedBox(width: 8.0),
            Flexible(
              flex: 7,
              child: TextFormField(
                focusNode: phoneNumberFocus,
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                controller: phoneNumber,
                decoration: const InputDecoration(hintText: AppStrings.phoneFieldHint),
                onChanged: (value) => (value.toString().isEmpty) ? countryCodeFocus.requestFocus() : null,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        RoundedButton(
          color: AppColors.secondary,
          text: AppStrings.next,
          onPressed: () async {
            setState(() => showSpinner = true);
            phoneAuthentication("+${countryCode.text.trim()}${phoneNumber.text.trim()}");
            setState(() => showSpinner = false);
          },
        ),
      ],
    );
  }

  Future<void> phoneAuthentication(String phoneNumber) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: _auth.signInWithCredential,
        codeSent: (String verificationId, int? resendToken) => setState(() => verCode = verificationId),
        codeAutoRetrievalTimeout: (String verificationId) => setState(() => verCode = verificationId),
        verificationFailed: (FirebaseAuthException e) {
          var message = "";
          log(e.message.toString());
          switch (e.code) {
            case AppErrorCodes.invalidPhoneNumber:
              message = AppErrorMessages.invalidPhoneNumber;
              break;
            case AppErrorCodes.tooManyRequests:
              message = AppErrorMessages.tooManyRequests;
              break;

            default:
              message = AppErrorMessages.unknownError;
          }
          errorMessage(context, msg: message);
        },
      );
      if (context.mounted) {
        Constants.showOTPDialog(
          context,
          verifyOTP: (verificationCode) async {
            if (await verifyOTP(verificationCode)) {
              if (context.mounted) Navigator.pushNamed(context, Routes.chat);
            }
          },
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == AppErrorCodes.userNotFound) {
        errorMessage(context, msg: AppErrorMessages.userNotFound);
      } else if (e.code == AppErrorCodes.wrongPassword) {
        errorMessage(context, msg: AppErrorMessages.wrongPassword);
      }
    } catch (e) {
      log(e.toString());
      errorMessage(context, msg: e.toString());
    }
  }

  Future<bool> verifyOTP(String otp) async {
    final provider = PhoneAuthProvider.credential(verificationId: verCode, smsCode: otp);
    final credentials = await _auth.signInWithCredential(provider);
    log(credentials.user.toString());
    return credentials.user != null;
  }
}
