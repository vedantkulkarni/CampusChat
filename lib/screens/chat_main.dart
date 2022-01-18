import 'dart:ui';

import 'package:chat_app/screens/freshers.dart';
import 'package:chat_app/screens/seniors.dart';
import 'package:chat_app/utils/chat_engine.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/page_transition.dart';
import 'package:chat_app/utils/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

class ChatMain extends StatefulWidget {
  @override
  _ChatMainState createState() => _ChatMainState();
}

class _ChatMainState extends State<ChatMain>
    with SingleTickerProviderStateMixin {
  final user = FirebaseFirestore.instance.collection('Users');
  late final AnimationController animationController;
  late final Animation<double> fadeAnimation;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    animationController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 500));
    fadeAnimation = Tween(begin: 0.0, end: 1.0).animate(animationController);
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double h = MediaQuery.of(context).size.height;
    double w = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        drawer: Drawer(
          child: DrawerContent(),
        ),
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () {
                  FirebaseAuth.instance.signOut();
                },
                icon: const Icon(Icons.logout))
          ],
          title: const Text(
            'CampusChat',
            style: TextStyle(
                color: Constants.darkText,
                fontWeight: FontWeight.bold,
                fontSize: 25),
          ),
          centerTitle: true,
          iconTheme: const IconThemeData(
            color: Constants.darkText,
          ),
          backgroundColor: Constants.background,
          elevation: 0,
        ),
        body: Container(
          color: Constants.background,
          child: Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: FadeTransition(
                    opacity: fadeAnimation,
                    child: Container(
                      height: h,
                      width: w,

                      // child: Center(child: Text('Hi'),),
                      child: buildChatHome(animationController),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  FutureBuilder<DocumentSnapshot<Object?>> buildChatHome(
      AnimationController ctr1) {
    final AnimationController ctr = ctr1;
    return FutureBuilder<DocumentSnapshot>(
      future: user.doc(FirebaseAuth.instance.currentUser!.uid).get(),
      builder: (context, AsyncSnapshot<DocumentSnapshot> documentSnapshot) {
        if (documentSnapshot.hasError) {
          return const Text('Something went wrong!');
        } else if (documentSnapshot.hasData && !documentSnapshot.data!.exists) {
          return const Text('User does not exist');
        } else if (documentSnapshot.connectionState == ConnectionState.done) {
          Map<String, dynamic> data =
              documentSnapshot.data!.data() as Map<String, dynamic>;

          return ChatHome(data['username'].toString().split(' ')[0], ctr);
        } else {
          ctr.reset();
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}

class DrawerContent extends StatelessWidget {
  const DrawerContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
      child: Column(
        children: [
          Container(
            height: 200,
            // color: Colors.blue.withOpacity(0.5),
          ),
          Divider(
            color: Constants.darkText.withOpacity(0.4),
          ),
          Expanded(
              child: ListView(
            children: [
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: const [
                      Icon(Icons.person),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        'Profile',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: const [
                      Icon(
                        Icons.settings,
                        color: Constants.darkText,
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        'Settings',
                        style: TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.bold,
                            color: Constants.darkText),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: const [
                      Icon(Icons.inbox),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        'Inbox',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
              GestureDetector(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    children: const [
                      Icon(Icons.help),
                      SizedBox(
                        width: 50,
                      ),
                      Text(
                        'Help',
                        style: TextStyle(
                            fontSize: 17, fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }
} //Gets User's first name and passes down to ChatHome widget.

class ChatHome extends StatelessWidget {
  final String username;
  final AnimationController ctr;
  const ChatHome(this.username, this.ctr);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal: 30), //Left and right padding to entire screen
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(
            height: 20,
          ),
          GreetingMessage(username: username),
          const SizedBox(
            height: 30,
          ),
          UserDashboard(ctr),
          const SizedBox(
            height: 40,
          ),
          Expanded(child: ActivityList(ctr, username)),
          
        ],
      ),
    );
  }
}

class UserDashboard extends ConsumerWidget {
  final AnimationController ctr;
  const UserDashboard(
    this.ctr, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProvider = ref.watch(userDataProvider);
    myProvider.initializeFirebase();
    myProvider.getUserData();
    return FutureBuilder(
        future: myProvider.getUserData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting)
            return Container(
              height: 240,
              child: Center(
                  // child: CircularProgressIndicator(),
                  ),
            );
          // ctr.reset();
          ctr.forward();
          return Container(
            child: Column(
              children: [
                Container(
                  height: 20,
                  child: Row(
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
                ),
                const SizedBox(
                  height: 10,
                ),
                Container(
                    height: 210,
                    width: double.maxFinite,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            colors: [
                              Constants.secondaryThemeColor,
                              Constants.themeColor.withOpacity(0.7),
                            ],
                            begin: Alignment.bottomLeft,
                            end: Alignment.topRight),
                        boxShadow: [Constants.boxShadow],
                        borderRadius: const BorderRadius.only(
                            topRight: Radius.circular(100),
                            topLeft: Radius.circular(10),
                            bottomLeft: Radius.circular(10),
                            bottomRight: Radius.circular(10))),
                    child: Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.only(
                              top: 20, left: 20, right: 40, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Doubts',
                                        style: TextStyle(
                                            fontSize: 20,
                                            color: Constants.background
                                                .withOpacity(0.7),
                                            fontWeight: FontWeight.w200),
                                      ),
                                      const Text(
                                        'Solved',
                                        style: TextStyle(
                                            fontSize: 30,
                                            color: Constants.background,
                                            fontWeight: FontWeight.w200),
                                      ),
                                      const Divider(
                                        color: Colors.orangeAccent,
                                      ),
                                      Row(
                                        children: [
                                          Text(
                                            myProvider.monthlySolved.toString(),
                                            style: const TextStyle(
                                                fontSize: 40,
                                                color: Constants.background,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Text(
                                            '/${myProvider.monthlyGoal}',
                                            style: const TextStyle(
                                                fontSize: 40,
                                                color: Colors.orangeAccent,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Lottie.asset(
                                    'assets/images/chat_lottie.json'),
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
                          width: double.maxFinite,
                          padding: const EdgeInsets.only(
                              top: 10, right: 10, left: 20, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    'Rating :',
                                    style: TextStyle(
                                        color: Constants.background
                                            .withOpacity(0.7),
                                        fontWeight: FontWeight.w200,
                                        fontSize: 17),
                                  ),
                                  Row(
                                    children: List.generate(
                                      5,
                                      (index) {
                                        if (index + 1 <=
                                            myProvider.ratingStar) {
                                          return const Icon(
                                            Icons.star,
                                            color: Colors.orangeAccent,
                                            size: 15,
                                          );
                                        }

                                        return const Icon(
                                          Icons.star_border,
                                          color: Colors.orangeAccent,
                                          size: 19,
                                        );
                                      },
                                    ),
                                  )
                                ],
                              ),
                              GestureDetector(
                                onTap: () {
                                  ctr.reverse(from: 0.5);
                                },
                                child: Row(
                                  children: [
                                    Text(
                                      'Details',
                                      style: TextStyle(
                                          color: Constants.background
                                              .withOpacity(0.7),
                                          fontSize: 17,
                                          fontWeight: FontWeight.w200),
                                    ),
                                    const SizedBox(
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
                    )),
              ],
            ),
          );
        });
  }
}

class ActivityList extends StatelessWidget {
  AnimationController anim;
  String userFirstName;
  ActivityList(
    this.anim,
    this.userFirstName, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    const Map<int, dynamic> mp = {
      1: ['Freshers', 'Interact with freshers and solve their \ndoubts'],
      2: ['Seniors', 'Chat and get to know your Seniors'],
      3: ['Teachers', 'Consult some faculty'],
      4: ['Alumni', 'Get guidance from expert alumni']
    };

    const colorList = {
      1: [Color(0xFF5c5fdd), Color(0xFF778deb)],
      2: [Color(0xfff97a80), Color(0xfffeb094)],
      3: [
        Color(0xffff5287),
        Color(0xfffd99b9),
      ],
      4: [Color(0xfff97a80), Color(0xfffeb094)]
    };
    return Container(
      // color: Colors.blue.withOpacity(0.2),
      width: double.maxFinite,

      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'What\'s on your mind today?',
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 17,
                color: Colors.blueGrey),
          ),
          const SizedBox(
            height: 15,
          ),
          Expanded(
            child: Container(
              width: MediaQuery.of(context).size.width * 0.85,
              child: AnimationLimiter(
                child: ListView.builder(
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    return AnimationConfiguration.staggeredList(
                        position: index,
                        delay: const Duration(milliseconds: 100),
                        child: SlideAnimation(
                          horizontalOffset: 50,
                          duration: const Duration(milliseconds: 2500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          child: FadeInAnimation(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 35),
                              child: Column(
                                children: [
                                  HomeTile(
                                    userFirstName: userFirstName,
                                    infoList: mp[index + 1],
                                    colorList: colorList[index + 1]!,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                  itemCount: 3,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class HomeTile extends StatelessWidget {
  const HomeTile(
      {Key? key,
      required this.userFirstName,
      required this.colorList,
      required this.infoList})
      : super(key: key);

  final String userFirstName;
  final List<Color> colorList;
  final List<String> infoList;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 15, bottom: 5, left: 15),
      padding: const EdgeInsets.only(top: 10, left: 10),
      height: 120,
      decoration: BoxDecoration(
          gradient: LinearGradient(
              colors: colorList,
              begin: Alignment.bottomLeft,
              end: Alignment.topRight),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
                color: colorList[1].withOpacity(0.7),
                blurRadius: 20.0,
                offset: const Offset(10, 10)),
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                infoList.first,
                style: const TextStyle(
                    fontSize: 30,
                    color: Constants.background,
                    fontWeight: FontWeight.w400,
                    letterSpacing: 0),
              ),
              IconButton(
                  onPressed: () async {
                    
                    Navigator.push(
                        context, PageTransition(Freshers(userFirstName)));
                  },
                  icon: const Icon(
                    Icons.arrow_forward,
                    color: Constants.background,
                    size: 25,
                  ))
            ],
          ),
          Row(
            children: [
              Flexible(
                child: Text(
                  infoList[1],
                  softWrap: false,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                      color: Constants.background.withOpacity(0.8),
                      fontSize: 16,
                      fontWeight: FontWeight.w300),
                ),
              )
            ],
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
