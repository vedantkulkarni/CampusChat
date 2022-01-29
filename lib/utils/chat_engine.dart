import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/providers.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChatEngine extends StatefulWidget {
  final String userFirstName; //To identify whether user is Fresher or senior.
  ChatEngine(this.userFirstName, {Key? key}) : super(key: key);
  @override
  _ChatEngineState createState() => _ChatEngineState();
}

class _ChatEngineState extends State<ChatEngine> {
  late FirebaseFirestore firestore;
  late String uid;

  @override
  void initState() {
    // TODO: implement initState
    firestore = FirebaseFirestore.instance;
    uid = FirebaseAuth.instance.currentUser!.uid.toString();

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

                await Future.delayed(const Duration(milliseconds: 200), () {});
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
            'General Chat',
            style: TextStyle(
                color: Constants.darkText, fontWeight: FontWeight.bold),
          ),
        ),
        body: Container(
            color: Constants.background,
            child: Column(
              children: [
                Expanded(
                    child: GetMessages(
                  firestore,
                  uid,
                )),
                Consumer(
                  builder: (_, widgetRef, __) {
                    final usernameProvider = widgetRef.watch(userDataProvider);
                    return NewMessage(
                        firestore, uid, usernameProvider.userName);
                  },
                )
              ],
            )),
      ),
    );
  }
}

class NewMessage extends StatefulWidget {
  NewMessage(
    this.firestore,
    this.uid,
    this.username, {
    Key? key,
  }) : super(key: key);
  FirebaseFirestore firestore;
  String username;

  String uid;
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
    textcontroller =  TextEditingController();
  }

  @override
  void dispose() {
    textcontroller.dispose();
    super.dispose();
  }

  void sendMessage(String s) async {
    s = s.trim();

    await widget.firestore.collection('Colleges/PICT/GeneralChat').add({
      'message': s,
      'uid': widget.uid,
      'timestamp': Timestamp.now(),
      'username': widget.username
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
            child: Container(
              padding: const EdgeInsets.only(left: 15),
              height: 40,
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(40)),
              child: Align(
                alignment: Alignment.centerLeft,
                child: TextField(
                  cursorHeight: 20,
                  enableSuggestions: true,
                  minLines: 1,
                  maxLines: 30,
                  onChanged: (value) {
                    setState(() {
                      keyStroke = value;
                    });
                  },
                  controller: textcontroller,
                  decoration: const InputDecoration.collapsed(
                    hintText: 'Send a message',
                  ),
                ),
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
  String username;
  String uid;
  String nextUid;
  final Function checkWithPrevMessage;
  MessageChipUI(this.message, this.isMe, this.username, this.uid,
      this.checkWithPrevMessage, this.nextUid);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            !checkWithPrevMessage(uid, nextUid)
                ? const SizedBox(height: 10)
                : const SizedBox(),
            checkWithPrevMessage(uid, nextUid)
                ? Container()
                : isMe
                    ? Container()
                    : Padding(
                        padding:
                            const EdgeInsets.only(left: 5, right: 5, top: 5),
                        child: Text(
                          isMe ? 'You' : username,
                          style: const TextStyle(
                              color: Constants.darkText,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
            Flex(direction: Axis.horizontal, children: [
              Container(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.7,
                ),
                margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                padding: const EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    color: isMe ? Colors.grey.shade300 : Constants.themeColor,
                    borderRadius: BorderRadius.only(
                        topLeft: const Radius.circular(10),
                        topRight: const Radius.circular(10),
                        bottomLeft: isMe
                            ? const Radius.circular(10)
                            : const Radius.circular(2),
                        bottomRight: isMe
                            ? const Radius.circular(2)
                            : const Radius.circular(10)),
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
                      fontSize: 17),
                ),
              ),
            ]),
          ],
        ),
      ],
    );
  }
}

class GetMessages extends StatefulWidget {
  FirebaseFirestore firestore;
  String uid;

  GetMessages(
    this.firestore,
    this.uid, {
    Key? key,
  }) : super(key: key);

  @override
  State<GetMessages> createState() => _GetMessagesState();
}

class _GetMessagesState extends State<GetMessages> {
  bool checkWithPrevMessage(String uid, String nextUid) {
    if (nextUid == '') {
      return false;
    }
    if (nextUid != uid) {
      return false;
    }

    return true;
  }

  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> messageStream = widget.firestore
        .collection('Colleges/PICT/GeneralChat')
        .orderBy('timestamp', descending: true)
        .snapshots();
    return StreamBuilder(
      stream: messageStream,
      builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Container(
            child: Constants.progressIndicator,
          );
        }
        if (snapshot.connectionState == ConnectionState.done &&
            snapshot.hasError) {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
        if (snapshot.data!.docs.isEmpty) {
          return Center(
            child: Column(children: [
              Constants.progressIndicator,
              const SizedBox(height: 10,),
              const Text('Start Messaging!',style: TextStyle(fontSize: 23,color: Constants.darkText,fontWeight: FontWeight.bold),)
            ],),
          );
        }

        return ListView.builder(
          
          shrinkWrap: false,
          physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics()),
          reverse: true,
          itemBuilder: (context, index) {
            String nextUid;
            bool isMe = snapshot.data!.docs[index]['uid'] == widget.uid;
            if (index != snapshot.data!.docs.length - 1) {
              nextUid = snapshot.data!.docs[index + 1]['uid'];
            } else {
              nextUid = '';
            }

            return MessageChipUI(
                snapshot.data!.docs[index]['message'],
                isMe,
                snapshot.data!.docs[index]['username'],
                snapshot.data!.docs[index]['uid'],
                checkWithPrevMessage,
                nextUid);
          },
          itemCount: snapshot.data!.docs.length,
        );
      },
    );
  }
}
