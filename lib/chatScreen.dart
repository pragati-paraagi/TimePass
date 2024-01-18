import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final _firestore = FirebaseFirestore.instance;
User? loggedInUser;
ScrollController _scrollController = ScrollController();

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController(text: '');
  final _auth = FirebaseAuth.instance;

  String message = '';
  TextEditingController search = TextEditingController();

  void currentUser() async {
    try {
      final user = await _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void messagesStream() async {
    await for (var snapshot in _firestore.collection('messages').orderBy('timestamp').snapshots()) {
      for (var message in snapshot.docs) {
        print(message.data());
      }
    }
  }

  @override
  void initState() {
    super.initState();
    currentUser();
    _scrollController = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF111328),
        appBar: AppBar(
          backgroundColor: Color(0xFFEB1555),
          leading: null,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
              icon: Icon(Icons.close),
            ),
          ],
          title: Center(
            child: Text(
              'CONVOSPHERE',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              MessageStream(),

              SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  SizedBox(
                    width: 15,
                  ),
                  Expanded(
                    child: TextField(
                      controller: messageTextController,
                      cursorColor: Color(0xFFEB1555),
                      decoration: InputDecoration(
                        hintText: 'Type your message here',
                        hintStyle: TextStyle(color: Colors.white),
                      ),
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        message = value;
                      },
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  FloatingActionButton(
                    backgroundColor: Color(0xFFEB1555),
                    child: Icon(
                      Icons.send,
                      color: Colors.white,
                    ),
                    onPressed: () {
                      if (loggedInUser != null) {
                        _firestore.collection('messages').add({
                          'text': message,
                          'sender': loggedInUser!.email,
                          'timestamp': FieldValue.serverTimestamp(),
                        });
                      }
                      messagesStream();
                      messageTextController.clear();
                      setState(() {});
                    },
                  ),
                  SizedBox(
                    width: 8,
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class MessageStream extends StatelessWidget {
  const MessageStream({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: _firestore.collection('messages').orderBy('timestamp').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(
              backgroundColor: Color(0xFFEB1555),
            ),
          );
        }
        final messages = snapshot.data?.docs;
        List<Widget> bubbleWidgets = [];

        for (var message in messages!) {
          final messageText = message.data()?['text'];
          final messageSender = message.data()?['sender'];
          final currentUser = loggedInUser?.email ?? '';

          if (messageText != null && messageSender != null) {
            final bubble = Bubble(
              sender: messageSender,
              text: messageText,
              isMe: currentUser == messageSender,
            );
            bubbleWidgets.add(bubble);
          }
        }

        WidgetsBinding.instance!.addPostFrameCallback((_) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        });

        return Expanded(
          child: ListView(
            controller: _scrollController,
            children: bubbleWidgets,
          ),
        );
      },
    );
  }
}

class Bubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;

  Bubble({required this.sender, required this.text, required this.isMe});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(
              color: Colors.white,
              fontSize: 10,
            ),
          ),
          Material(
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(isMe ? 30.0 : 0.0),
              topRight: Radius.circular(isMe ? 0.0 : 30.0),
              bottomLeft: Radius.circular(30.0),
              bottomRight: Radius.circular(30.0),
            ),
            elevation: 5,
            color: isMe ? Color(0xFFEB1555) : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 20.0),
              child: Text(
                '$text',
                style: TextStyle(
                  color: isMe ? Colors.white : Color(0xFFEB1555),
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
