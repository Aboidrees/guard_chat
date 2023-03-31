import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:guard_chat/core/util/app_colors.dart';
import 'package:guard_chat/core/util/app_strings.dart';

class Constants {
  static void showMessageDialog(BuildContext context, {required String msg}) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: Text(msg, style: const TextStyle(color: Colors.black, fontSize: 16)),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.black,
                textStyle: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              child: const Text(AppStrings.ok),
            ),
          ],
        );
      },
    );
  }

  static void showOTPDialog(BuildContext context, {required Function(String verificationCode) verifyOTP}) {
    showDialog(
      context: context,
      builder: (context) {
        return CupertinoAlertDialog(
          title: const Text("OTP", style: TextStyle(color: Colors.black, fontSize: 16)),
          content: Material(
            color: Colors.red,
            type: MaterialType.transparency,
            textStyle: const TextStyle(color: Colors.red),
            child: OtpTextField(
              numberOfFields: 6,
              fieldWidth: 30,
              enabledBorderColor: AppColors.secondary.withOpacity(0.3),
              focusedBorderColor: AppColors.secondary,
              fillColor: Colors.transparent,
              filled: true,
              textStyle: const TextStyle(color: Colors.red),
              showFieldAsBox: false,
              onCodeChanged: (String code) {},
              onSubmit: verifyOTP,
            ),
          ),
        );
      },
    );
  }

  static void showToast({required String msg, Color? color, ToastGravity? gravity}) {
    Fluttertoast.showToast(
      msg: msg,
      toastLength: Toast.LENGTH_LONG,
      gravity: gravity ?? ToastGravity.BOTTOM,
      backgroundColor: color ?? AppColors.primary,
    );
  }
}

const kSendButtonTextStyle = TextStyle(
  color: AppColors.primary,
  fontWeight: FontWeight.bold,
  fontSize: 18.0,
);

var kMessageTextFieldDecoration = const InputDecoration(
  hintText: 'Type your message here...',
);

const kMessageContainerDecoration = BoxDecoration(
  border: Border(top: BorderSide(color: AppColors.primary, width: 0.3)),
);
