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
            // child: Center(child: Text('Hi'),),
            child: buildChatHome(),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            FirebaseAuth.instance.signOut();
          },
          child: Icon(Icons.logout),
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
}

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
            height: 50,
          ),
          Container(
            decoration: BoxDecoration(
                color: Constants.secondaryThemeColor,
                borderRadius: BorderRadius.circular(20)),
            height: 130,
            child: Center(
              child: Text(
                'Will contain latest updates and news!',
                style: Constants.listTile,
              ),
            ),
          ),
          const SizedBox(
            height: 50,
          ),
          Expanded(child: ActivityList())
        ],
      ),
    );
  }
}

class ActivityList extends StatelessWidget {
  const ActivityList({
    Key? key,
  }) : super(key: key);

  static const List<String> activityList = [
    'Interact with Seniors.',
    'Solve a doubt!',
    'Have a piece of the general chat.',
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
              physics: BouncingScrollPhysics(),
              children: List.generate(activityList.length, (index) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          color: Constants.themeColor),
                      height: 70,
                      width: MediaQuery.of(context).size.width * 0.75,
                      child: ListTile(
                        trailing: Icon(
                          Icons.arrow_forward_ios,
                          color: Colors.white,
                        ),
                        title: Text(
                          activityList[index],
                          style: Constants.listTile,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 10,
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
