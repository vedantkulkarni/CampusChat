import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ChatEngine extends StatefulWidget {
  final String status;
  final String userFirstName; //To identify whether user is Fresher or senior.
  ChatEngine(this.status, this.userFirstName, {Key? key}) : super(key: key);
  @override
  _ChatEngineState createState() => _ChatEngineState();
}

class _ChatEngineState extends State<ChatEngine> {
  late FirebaseFirestore firestore;
  late String username;

  @override
  void initState() {
    // TODO: implement initState
    firestore = FirebaseFirestore.instance;
    username = FirebaseAuth.instance.currentUser!.uid.toString();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            onPressed: () async {
              if (!FocusScope.of(context).hasPrimaryFocus) {
                FocusScope.of(context).unfocus();

                await Future.delayed(Duration(milliseconds: 200), () {});
              }

              Navigator.of(context).pop();
            },
            icon: const Icon(
              Icons.arrow_back,
              color: Constants.darkText,
            ),
          ),
          backgroundColor: Constants.background,
          elevation: 5,
          title: const Text(
            'Freshers General Chat',
            style: TextStyle(
                color: Constants.darkText, fontWeight: FontWeight.bold),
          ),
          actions: [
            PopupMenuButton(
                icon: const Icon(
                  Icons.more_vert,
                  color: Constants.darkText,
                ),
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text('First'),
                        value: 1,
                      ),
                      const PopupMenuItem(
                        child: Text('Second'),
                        value: 2,
                      )
                    ])
          ],
        ),
        body: Container(
            color: Constants.background,
            child: Column(
              children: [
                Expanded(
                    child: GetMessages(firestore, username, widget.status,
                        widget.userFirstName)),
                NewMessage(
                    firestore, username, widget.status, widget.userFirstName)
              ],
            )),
      ),
    );
  }
}

class NewMessage extends StatefulWidget {
  NewMessage(
    this.firestore,
    this.username,
    this.status,
    this.userFirstName, {
    Key? key,
  }) : super(key: key);
  FirebaseFirestore firestore;
  String username;
  String status;
  String userFirstName;
  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  late TextEditingController textcontroller;
  String keyStroke = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textcontroller = new TextEditingController();
  }

  @override
  void dispose() {
    textcontroller.dispose();
    super.dispose();
  }

  void sendMessage(String s) async {
    s = s.trim();

    await widget.firestore
        .collection('${widget.status}/generalChat/messages')
        .add({
      'message': s,
      'username': widget.username,
      'timestamp': Timestamp.now(),
      'userFirstName': widget.userFirstName
    });
    textcontroller.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              onChanged: (value) {
                setState(() {
                  keyStroke = value;
                });
              },
              controller: textcontroller,
              decoration: const InputDecoration(
                label: Text('Send a message'),
              ),
            ),
          ),
          IconButton(
              onPressed: (keyStroke.trim().length == 0)
                  ? null
                  : () {
                      sendMessage(textcontroller.text);
                    },
              icon: const Icon(Icons.send))
        ],
      ),
    );
  }
}

class MessageChipUI extends StatelessWidget {
  final String message;
  final bool isMe;
  String userFirstName;
  MessageChipUI(this.message, this.isMe, this.userFirstName);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: Text(
                isMe ? 'You' : userFirstName,
                style: TextStyle(
                    color: Constants.darkText, fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              margin: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
              padding: EdgeInsets.all(10.0),
              width: 150,
              decoration: BoxDecoration(
                  color: isMe ? Colors.grey.shade300 : Constants.themeColor,
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(10),
                      topRight: Radius.circular(10),
                      bottomLeft:
                          isMe ? Radius.circular(10) : Radius.circular(2),
                      bottomRight:
                          isMe ? Radius.circular(2) : Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                        color: isMe
                            ? Colors.grey.shade300.withOpacity(0.8)
                            : Constants.themeColor.withOpacity(0.5),
                        blurRadius: 40)
                  ]),
              child: Text(
                message,
                style: TextStyle(
                  color: isMe ? Constants.darkText : Constants.background,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class GetMessages extends StatefulWidget {
  FirebaseFirestore firestore;
  String username;
  String status;
  String userFirstName;
  GetMessages(
    this.firestore,
    this.username,
    this.status,
    this.userFirstName, {
    Key? key,
  }) : super(key: key);

  @override
  State<GetMessages> createState() => _GetMessagesState();
}

class _GetMessagesState extends State<GetMessages> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> messageStream = widget.firestore
        .collection('${widget.status}/generalChat/messages')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError) {
          return Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.data!.docs == null) {
          return Center(
            child: Text('No data was found'),
          );
        }

        return ListView.builder(
          cacheExtent: 2,
          shrinkWrap: true,
          physics:
              BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          reverse: true,
          itemBuilder: (context, index) {
            bool isMe =
                snapshot.data!.docs[index]['username'] == widget.username;
            return MessageChipUI(snapshot.data!.docs[index]['message'], isMe,
                snapshot.data!.docs[index]['userFirstName']);
          },
          itemCount: snapshot.data!.docs.length,
        );
      },
    );
  }
}
