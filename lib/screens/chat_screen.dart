import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard_chat/constants.dart';
import 'package:guard_chat/core/app_routes.dart';
import 'package:guard_chat/widgets/message_stream.dart';

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late User loggedInUser;
  late TextEditingController message;

  final _messages = FirebaseFirestore.instance.collection("messages");
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen(currentUserListener);
    message = TextEditingController();
  }

  void currentUserListener(User? user) {
    if (user == null) {
      Navigator.pushNamed(context, AppRoutes.welcome);
    } else {
      loggedInUser = user;
    }
  }

  void sendMessage() {
    try {
      if (message.text.trim().isNotEmpty) {
        _messages.add({
          'text': message.text.trim(),
          'sender': loggedInUser.email,
        }).then((value) => message.clear());
      }
    } catch (e) {
      debugPrint("Field to send");
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          automaticallyImplyLeading: false,
          leadingWidth: 0.0,
          title: const Text('⚡️Chat'),
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
                decoration: kMessageContainerDecoration,
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Expanded(child: TextFormField(controller: message, decoration: kMessageTextFieldDecoration)),
                    TextButton(
                      onPressed: sendMessage,
                      child: const Text('Send', style: kSendButtonTextStyle),
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
