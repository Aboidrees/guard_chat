import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard_chat/config/constants.dart';
import 'package:guard_chat/config/routes/app_routes.dart';
import 'package:guard_chat/core/util/app_strings.dart';
import 'package:guard_chat/core/util/error_message.dart';
import 'package:guard_chat/features/chat/presentation/widgets/message_stream.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  User? loggedInUser;
  late TextEditingController message;

  final _messages = FirebaseFirestore.instance.collection("messages");
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    _auth.authStateChanges().listen(currentUserListener);
    message = TextEditingController();
    super.initState();
  }

  void currentUserListener(User? user) {
    log(user.toString());
    if (user == null) {
      Navigator.pushNamed(context, Routes.welcome);
    } else {
      loggedInUser = user;
    }
  }

  void sendMessage() {
    try {
      if (message.text.trim().isNotEmpty) {
        _messages.add({
          'text': message.text.trim(),
          'sender': loggedInUser?.phoneNumber,
        }).then((value) => message.clear());
      }
    } catch (e) {
      errorMessage(context, msg: AppErrorMessages.failedToSend);
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          leadingWidth: 0.0,
          title: Text(loggedInUser?.displayName ?? loggedInUser?.phoneNumber ?? ""),
          centerTitle: true,
          actions: [IconButton(icon: const Icon(Icons.logout), onPressed: _auth.signOut)],
        ),
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              const MessagesStream(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: TextFormField(controller: message, decoration: kMessageTextFieldDecoration)),
                    IconButton(
                      onPressed: () => Constants.showOTPDialog(
                        context,
                        verifyOTP: (verificationCode) {
                          log(verificationCode);
                        },
                      ),
                      icon: const Icon(Icons.send),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
