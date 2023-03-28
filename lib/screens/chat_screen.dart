import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:guard_chat/constants.dart';
import 'package:guard_chat/core/app_colors.dart';
import 'package:guard_chat/core/app_routes.dart';

final _messages = FirebaseFirestore.instance.collection("messages");

final _auth = FirebaseAuth.instance;

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late User loggedInUser;
  late TextEditingController message;

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
      _messages.add({
        'text': message.text.trim(),
        'sender': loggedInUser.email,
      }).then((value) => message.clear());
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
          actions: <Widget>[
            IconButton(icon: const Icon(Icons.logout), onPressed: _auth.signOut),
          ],
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

class MessagesStream extends StatefulWidget {
  const MessagesStream({super.key});

  @override
  State<MessagesStream> createState() => _MessagesStreamState();
}

class _MessagesStreamState extends State<MessagesStream> {
  late User loggedInUser;

  @override
  void initState() {
    super.initState();
    _auth.authStateChanges().listen(currentUserListener);
  }

  void currentUserListener(User? user) {
    if (user == null) {
      Navigator.pushNamed(context, AppRoutes.welcome);
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

          final messages = snapshot.data?.docs;

          return ListView.builder(
            reverse: true,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            physics: const FixedExtentScrollPhysics(),
            itemCount: messages?.length ?? 0,
            itemBuilder: (context, index) {
              return MessageBubble(text: messages?[index].data()['text'], sender: messages?[index].data()['sender']);
            },
          );
        },
      ),
    );
  }

  bool isMe(String sender) => (sender == loggedInUser.email);
}

class MessageBubble extends StatelessWidget {
  const MessageBubble({super.key, required this.sender, required this.text});

  final String sender;
  final String text;

  bool isMe(String sender) => (sender == _auth.currentUser?.email);

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe(sender) ? Alignment.centerRight : Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Material(
          elevation: 1,
          color: isMe(sender) ? AppColors.containerSecondary.withRed(230) : AppColors.containerSecondary.withRed(190),
          borderRadius: BorderRadius.circular(8),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Text(text, style: const TextStyle(fontSize: 15.0)),
          ),
        ),
      ),
    );
  }
}
