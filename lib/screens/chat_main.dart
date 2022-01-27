import 'dart:ui';

import 'package:chat_app/screens/details.dart';
import 'package:chat_app/screens/doubts.dart';
import 'package:chat_app/screens/freshers.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:chat_app/screens/teacher_list.dart';

import 'package:chat_app/utils/chat_engine.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/page_transition.dart';
import 'package:chat_app/utils/providers.dart';
import 'package:chat_app/utils/user_data.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:lottie/lottie.dart';

class ChatMain extends ConsumerStatefulWidget {
  @override
  _ChatMainState createState() => _ChatMainState();
}

class _ChatMainState extends ConsumerState<ChatMain>
    with SingleTickerProviderStateMixin {
  final user = FirebaseFirestore.instance.collection('Colleges/PICT/Users');
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
    final userProvider = ref.watch(userDataProvider);

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
                      child: userProvider.isLoaded
                          ? ChatHome(userProvider.userName, animationController)
                          : FutureBuilder(
                              future: userProvider.getUserData(),
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  animationController.forward();
                                  return Container(
                                      height: h,
                                      width: w,
                                      child: Constants.progressIndicator);
                                }

                                if (snapshot.hasError) {
                                  animationController.forward();
                                  return Container(
                                    child: Column(
                                      children: [
                                        Constants.errorLottie,
                                        const SizedBox(
                                          height: 20,
                                        ),
                                        const Text('Couldn\'t find anything for you',style: Constants.errorText,)
                                      ],
                                    ),
                                  );
                                }
                                animationController.reverse();
                                animationController.reset();
                                animationController.forward();
                                return ChatHome(
                                    userProvider.userName, animationController);
                              },
                            ),
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
}

class ChatHome extends StatelessWidget {
  final String username;
  final AnimationController animationController;
  const ChatHome(this.username, this.animationController);

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
          // GreetingMessage(username: username),

          UserDashboard(animationController),
          const SizedBox(
            height: 40,
          ),
          Expanded(child: ActivityList(animationController, username)),
        ],
      ),
    );
  }
}

class UserDashboard extends ConsumerWidget {
  final AnimationController animationController;
  const UserDashboard(
    this.animationController, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final myProvider = ref.watch(userDataProvider);
    final attendanceProvider = ref.watch(attendanceDataProvider);
    attendanceProvider.authAndRequestApi();
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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
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
                      ],
                    ),
                  ),
                  Column(
                    children: [
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
                                      color:
                                          Constants.background.withOpacity(0.7),
                                      fontWeight: FontWeight.w200,
                                      fontSize: 17),
                                ),
                                Row(
                                  children: List.generate(
                                    5,
                                    (index) {
                                      if (index + 1 <= myProvider.ratingStar) {
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
                                Navigator.push(
                                    context, PageTransition(Details()));
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
                      const SizedBox(
                        height: 10,
                      )
                    ],
                  ),
                ],
              )),
        ],
      ),
    );
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
      1: ['Doubts', 'Ask and solve some doubts'],
      2: ['My Attendance', 'Check your attendance and know your teachers'],
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
                  shrinkWrap: true,
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
                                      index: index),
                                ],
                              ),
                            ),
                          ),
                        ));
                  },
                  itemCount: 2,
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
      required this.infoList,
      required this.index})
      : super(key: key);

  final String userFirstName;
  final List<Color> colorList;
  final List<String> infoList;
  final index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index == 0)
          Navigator.push(context, PageTransition(Freshers(userFirstName)));
        else
          Navigator.push(context, PageTransition(Profile()));
      },
      child: Container(
        margin: const EdgeInsets.only(
          top: 15,
          bottom: 5,
        ),
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
                      fontSize: 25,
                      color: Constants.background,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0),
                ),
                const Padding(
                  padding: EdgeInsets.only(right: 15),
                  child: Icon(
                    Icons.arrow_forward,
                    color: Constants.background,
                    size: 25,
                  ),
                )
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 15),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      infoList[1],
                      style: TextStyle(
                          color: Constants.background.withOpacity(0.8),
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

//Drawer
class DrawerContent extends ConsumerWidget {
  DrawerContent({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, ref) {
    final myProvider = ref.watch(userDataProvider);
    return Container(
      color: Constants.background,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        child: Column(
          children: [
            Container(
                width: double.maxFinite,
                margin: EdgeInsets.symmetric(vertical: 20),
                child: Column(
                  children: [
                    Container(
                      width: double.maxFinite,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(150)),
                      child: Lottie.asset('assets/images/person_lottie.json',
                          fit: BoxFit.fill),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 10),
                      child: Text(
                        myProvider.isLoaded ? myProvider.userName : 'User',
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                        overflow: TextOverflow.fade,
                      ),
                    )
                  ],
                )
                // color: Colors.blue.withOpacity(0.5),
                ),
            // Divider(
            //   color: Constants.darkText.withOpacity(0.4),
            // ),
            Expanded(
                child: ListView(
              children: [
                GestureDetector(
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.notifications,
                          color: Constants.darkText.withOpacity(0.5),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        const Text(
                          'Notifications',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, PageTransition(Doubts(true)));
                  },
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.book,
                          color: Constants.darkText.withOpacity(0.5),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        const Text(
                          'My Doubts',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context, PageTransition(TeacherList()));
                  },
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.person,
                          color: Constants.darkText.withOpacity(0.5),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        const Text(
                          'Teachers',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(context,
                        PageTransition(ChatEngine('Freshers', 'Vedant')));
                  },
                  child: Container(
                    width: double.maxFinite,
                    padding: const EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      children: [
                        Icon(
                          Icons.chat,
                          color: Constants.darkText.withOpacity(0.5),
                        ),
                        const SizedBox(
                          width: 50,
                        ),
                        const Text(
                          'Chat',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.w300),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ))
          ],
        ),
      ),
    );
  }
}
