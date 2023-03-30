import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard_chat/config/routes/app_routes.dart';
import 'package:guard_chat/features/chat/presentation/widgets/message_bubble.dart';

class MessagesStream extends StatefulWidget {
  const MessagesStream({super.key});

  @override
  State<MessagesStream> createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  late User loggedInUser;
  final _messages = FirebaseFirestore.instance.collection("messages");
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen(currentUserListener);
  }

  void currentUserListener(User? user) {
    if (user == null) {
      Navigator.pushNamed(context, Routes.welcome);
    } else {
      loggedInUser = user;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        stream: _messages.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());

          final messages = snapshot.data?.docs.reversed.toList();

          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            itemCount: messages?.length ?? 0,
            itemBuilder: (context, index) {
              final text = messages?[index].data()['text'];
              final sender = messages?[index].data()['sender'];
              final isMe = (sender == _auth.currentUser?.phoneNumber);

              return MessageBubble(text: text, isMe: isMe);
            },
          );
        },
      ),
    );
  }
}
