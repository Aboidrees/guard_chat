import 'package:flutter/material.dart';
import 'package:guard_chat/core/util/app_colors.dart';

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.isMe, required this.text});

  final bool isMe;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Material(
          elevation: 1,
          color: isMe ? AppColors.containerSecondary.withRed(230) : AppColors.containerSecondary.withRed(190),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(isMe ? 15 : 2),
            topRight: Radius.circular(isMe ? 2 : 15),
            bottomLeft: const Radius.circular(15),
            bottomRight: const Radius.circular(15),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(text, style: const TextStyle(fontSize: 15.0)),
          ),
        ),
      ),
    );
  }
}
