import 'dart:ui';

import 'package:chat_app/utils/constants.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ChatMain extends StatefulWidget {
  @override
  _ChatMainState createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain> {
  final user = FirebaseFirestore.instance.collection('Users');

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Container(
            height: h,
            width: w,
            color: Constants.background,
            // child: Center(child: Text('Hi'),),
            child: buildChatHome(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: const Icon(Icons.logout),
        ),
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Object?>> buildChatHome() {
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> documentSnapshot) {
        if (documentSnapshot.hasError)
          return Text('Something went wrong!');
        else if (documentSnapshot.hasData && !documentSnapshot.data!.exists)
          return Text('User does not exist');
        else if (documentSnapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              documentSnapshot.data!.data() as Map<String, dynamic>;
          return ChatHome(data['username'].toString().split(' ')[0]);
        } else
          return Center(
            child: CircularProgressIndicator(),
          );
      },
    );
  }
} //Gets User's first name and passes down to ChatHome widget.

class ChatHome extends StatelessWidget {
  String username;
  ChatHome(this.username);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 30), //Left and right padding to entire screen
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 70,
          ),
          GreetingMessage(username: username),
          const SizedBox(
            height: 30,
          ),
          Row(
            children: const [
              Text(
                'Dashboard',
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 17,
                    color: Colors.blueGrey),
              )
            ],
          ),
          SizedBox(
            height: 10,
          ),
          UserDashboard(),
          const SizedBox(
            height: 50,
          ),
          Expanded(child: ActivityList())
        ],
      ),
    );
  }
}

class UserDashboard extends StatelessWidget {
  const UserDashboard({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
              Constants.secondaryThemeColor,
              Constants.themeColor.withOpacity(0.7),
            ], begin: Alignment.bottomLeft, end: Alignment.topRight),
            boxShadow: [Constants.boxShadow],
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(100),
                topLeft: Radius.circular(10),
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10))),
        height: 225,
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(
                  top: 30, left: 20, right: 40, bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Doubts',
                        style: TextStyle(
                            fontSize: 20,
                            color: Constants.background.withOpacity(0.7),
                            fontWeight: FontWeight.w200),
                      ),
                      const Text(
                        'Solved',
                        style: TextStyle(
                            fontSize: 30,
                            color: Constants.background,
                            fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: Constants.background),
                  )
                ],
              ),
            ),
            const Divider(
              indent: 20,
              endIndent: 20,
              // color: Constants.background,
              color: Colors.orangeAccent,
            ),
            Container(
              padding:
                  EdgeInsets.only(top: 10, right: 10, left: 20, bottom: 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        'Rating :',
                        style: TextStyle(
                            color: Constants.background.withOpacity(0.7),
                            fontWeight: FontWeight.w200,
                            fontSize: 17),
                      ),
                      const Icon(
                        Icons.star_rate,
                        color: Colors.orangeAccent,
                      ),
                      const Icon(
                        Icons.star_border,
                        color: Colors.orangeAccent,
                      ),
                      const Icon(
                        Icons.star_border,
                        color: Colors.orangeAccent,
                      ),
                      const Icon(
                        Icons.star_border,
                        color: Colors.orangeAccent,
                      ),
                      const Icon(
                        Icons.star_border,
                        color: Colors.orangeAccent,
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: Row(
                      children: [
                        Text(
                          'Details',
                          style: TextStyle(
                              color: Constants.background.withOpacity(0.7),
                              fontSize: 17,
                              fontWeight: FontWeight.w200),
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        const Icon(
                          Icons.arrow_forward,
                          color: Colors.orangeAccent,
                        )
                      ],
                    ),
                  )
                ],
              ),
            ),
          ],
        ));
  }
}

class ActivityList extends StatelessWidget {
  const ActivityList({
    Key? key,
  }) : super(key: key);

  static const List<String> activityList = [
    'Interact with Seniors.',
    'Solve a doubt!',
    'General Chat',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s on your mind today?',
            style: Constants.body1,
          ),
          const SizedBox(
            height: 30,
          ),
          Expanded(
            child: ListView(
              physics: const BouncingScrollPhysics(),
              children: List.generate(activityList.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                                color: Colors.grey.withOpacity(0.2),
                                blurRadius: 15,
                                offset: const Offset(15.0, 15.0))
                          ]),
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ListTile(
                        trailing: const  Icon(
                          Icons.arrow_forward_ios,
                          color: Constants.darkText,
                        ),
                        title: Text(
                          activityList[index],
                          style: Constants.listTile,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    )
                  ],
                );
              }),
            ),
          )
        ],
      ),
    );
  }
}

class GreetingMessage extends StatelessWidget {
  const GreetingMessage({
    Key? key,
    required this.username,
  }) : super(key: key);

  final String username;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Hi ,",
            style: Constants.hi,
          ),
          const SizedBox(
            height: 10,
          ),
          Text(username, style: Constants.display1)
        ],
      ),
    );
  }
}
