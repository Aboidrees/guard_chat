// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:guard_chat/core/util/app_colors.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({
    Key? key,
    this.color,
    this.textColor,
    this.text,
    required this.onPressed,
  }) : super(key: key);
  final Color? color;
  final Color? textColor;
  final String? text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateColor.resolveWith((states) => color ?? AppColors.primary),
        foregroundColor: MaterialStateColor.resolveWith((states) => textColor ?? Colors.white),
      ),
      onPressed: onPressed,
      child: Text(text ?? ""),
    );
  }
}
