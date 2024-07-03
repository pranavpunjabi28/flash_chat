import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flash_chat/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

final _firestore = FirebaseFirestore.instance;
late dynamic loggedinUser;

class ChatScreen extends StatefulWidget {
  static const String id = "ChatScreen";

  const ChatScreen({super.key});

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final _auth = FirebaseAuth.instance;
  final Textediting_controller = TextEditingController();

  String? message;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getcurrentuser();
  }

  void getcurrentuser() async {
    try {
      final User = await _auth.currentUser;
      if (User != null) {
        loggedinUser = User;
        print(User.email);
      }
    } catch (e) {
      print(e);
    }
  }

  // void getmessages() async {
  //   print(datetimeobj);
  //   // final messages = await _firestore.collection("/messages").get();
  //   // for (var message in messages.docs) {
  //   //   print("${message.id} => ${message.data()}");
  //   // }
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: null,
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              onPressed: () async {
                //Implement logout functionality
                _auth.signOut();
                Navigator.pop(context);

                //getmessages();
                // getstream();
              }),
        ],
        title: const Text('⚡️Chat'),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const streambuild(),
            Container(
              decoration: kMessageContainerDecoration,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: Textediting_controller,
                      style: TextStyle(color: Colors.white),
                      onChanged: (value) {
                        //Do something with the user input.
                        message = value;
                      },
                      decoration: kMessageTextFieldDecoration,
                    ),
                  ),
                  MaterialButton(
                    onPressed: () {
                      Textediting_controller.clear();
                      //Implement send functionality.
                      _firestore.collection("/messages").add({
                        "sender": loggedinUser.email,
                        "text": message,
                        "timestamp": Timestamp.fromDate(DateTime.now())
                      });
                    },
                    child: const Text(
                      'Send',
                      style: kSendButtonTextStyle,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class streambuild extends StatelessWidget {
  const streambuild({super.key});

  // void getmessages() async {
  //   final messages = await _firestore.collection("/messages").get();
  //   for (var message in messages.docs) {
  //     print("${message.id} => ${message.data()}");
  //   }
  // }

  // void getstream() async {
  //   //final message = await _firestore.collection("/messages").snapshots();
  //   await for (var snapshot in _firestore.collection("/messages").snapshots()) {
  //     //or (var snapshot in message)
  //     for (var message in snapshot.docs) {
  //       print(message.data());
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    print("fetch");
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection("/messages")
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          //this snapshot is diffrent from getstreams snapshot at there we are dealing with the Firebase query snapshot
          //but here flutter Asyncsnapshot bcz we working on streambuilder however our our Asyncsnapshot contains query snapshot from Firebase
          // we can accsess the query snapshot through the async snapshot using data property of async snapshot after using data property
          //we can acsess the document property
          if (!snapshot.hasData) {
            return Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.blueAccent,
              ),
            );
          }
          final document = snapshot.data!.docs.reversed;
          var msg;
          var sender;
          Timestamp timestamp;
          List<Bubbletext> bubblemsgs = [];
          for (var message in document) {
            msg = message.get("text");
            sender = message.get("sender");
            timestamp = message.get('timestamp');
            final msgWidget = Bubbletext(
                sender: sender,
                text: msg,
                timestamp: timestamp,
                isme: (sender == loggedinUser.email));
            bubblemsgs.add(msgWidget);
          }
          return Expanded(
            child: ListView(
              children: bubblemsgs,
            ),
          );
        });
  }
}

class Bubbletext extends StatelessWidget {
  const Bubbletext(
      {super.key,
      required this.sender,
      required this.text,
      required this.timestamp,
      required this.isme});

  final String sender;
  final String text;
  final bool isme;
  final Timestamp timestamp;

  String gettime() {
    DateTime obj = timestamp.toDate();
    String data = DateFormat('kk:mm dd-MM-yy ').format(obj);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment:
            (isme) ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            style: TextStyle(color: Colors.blueGrey),
          ),
          Material(
            elevation: 5,
            borderRadius: (isme == false)
                ? BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    bottomRight: Radius.circular(30))
                : BorderRadius.only(
                    bottomLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                    topLeft: Radius.circular(30)),
            color: isme ? Colors.white10 : Colors.blueAccent,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      text,
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                    SizedBox(
                      height: 5,
                    ),
                    Text(
                      gettime(),
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}
