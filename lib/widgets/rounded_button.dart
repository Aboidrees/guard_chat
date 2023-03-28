import 'package:flutter/material.dart';
import 'package:guard_chat/core/app_colors.dart';

class RoundedButton extends StatelessWidget {
  const RoundedButton({super.key, this.color, this.text, required this.onPressed});
  final Color? color;
  final String? text;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Material(
        elevation: 5.0,
        color: color,
        borderRadius: BorderRadius.circular(30.0),
        child: MaterialButton(
          onPressed: onPressed,
          minWidth: 200.0,
          height: 42.0,
          child: Text(text!, style: const TextStyle(color: AppColors.containerSecondary, fontSize: 20.0)),
        ),
      ),
    );
  }
}
