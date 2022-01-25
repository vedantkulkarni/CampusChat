import 'package:chat_app/screens/doubts.dart';
import 'package:chat_app/screens/new_doubt.dart';
import 'package:chat_app/utils/chat_engine.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/page_transition.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class Freshers extends StatefulWidget {
  String userFirstName;

  Freshers(this.userFirstName, {Key? key}) : super(key: key);

  @override
  _FreshersState createState() => _FreshersState();
}

class _FreshersState extends State<Freshers> {
  var no_of_doubts = 0;
  var no_of_profiles = 0;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    FirebaseFirestore.instance
        .collection('Colleges/PICT/Doubts')
        .get()
        .then((value) {
      no_of_doubts = value.docs.length;
      setState(() {});
    });

    FirebaseFirestore.instance
        .collection('Colleges/PICT/Users')
        .get()
        .then((value) {
      no_of_profiles = value.docs.length;
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    List<List<String>> uiInfo = [
      ['Doubts', '${no_of_doubts} doubts raised'],
      ['Profiles', '${no_of_profiles}  available'],
    ];
    return SafeArea(
      child: Container(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Constants.background,
            elevation: 0,
            leading: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.arrow_back)),
            iconTheme: const IconThemeData(color: Constants.darkText),
          ),
          body: SingleChildScrollView(
            child: Container(
              color: Constants.background,
              padding: const EdgeInsets.only(),
              child: Column(
                children: [
                  Container(
                    height: 250,
                    width: double.maxFinite,
                    child: Image.asset(
                      'assets/images/business-leader.png',
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  SizedBox(
                    height: 180,
                    child: Column(
                      children: [
                        Expanded(
                          child: AnimationLimiter(
                            child: ListView.builder(
                              physics: const BouncingScrollPhysics(),
                              scrollDirection: Axis.horizontal,
                              itemBuilder: (context, index) {
                                return AnimationConfiguration.staggeredList(
                                  position: index,
                                  delay: const Duration(milliseconds: 200),
                                  child: SlideAnimation(
                                    horizontalOffset: 20,
                                    duration:
                                        const Duration(milliseconds: 2500),
                                    curve: Curves.fastLinearToSlowEaseIn,
                                    child: FadeInAnimation(
                                      child: MyListTile(
                                          widget.userFirstName, uiInfo, index),
                                    ),
                                  ),
                                );
                              },
                              itemCount: 1,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                              context, PageTransition(NewDoubt(false)));
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              vertical: 20, horizontal: 20),
                          margin: const EdgeInsets.symmetric(horizontal: 20),
                          height: 120,
                          width: 300,
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                  colors: [
                                    Constants.secondaryThemeColor,
                                    Constants.themeColor,
                                  ],
                                  begin: Alignment.bottomLeft,
                                  end: Alignment.topRight),
                              boxShadow: [
                                BoxShadow(
                                    color:
                                        Constants.themeColor.withOpacity(0.5),
                                    blurRadius: 20,
                                    offset: const Offset(10, 10))
                              ]),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: const [
                                  Text(
                                    'Have a doubt?',
                                    style: TextStyle(
                                        color: Constants.background,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  )
                                ],
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                'Ask a helpful community of talented \nseniors!',
                                style: TextStyle(
                                  color: Colors.white.withOpacity(0.6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w300,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class MyListTile extends StatelessWidget {
  const MyListTile(
    this.userFirstName,
    this.list,
    this.index, {
    Key? key,
  }) : super(key: key);
  final userFirstName;
  final list;
  final index;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (index == 0) {
          Navigator.push(context, PageTransition(Doubts(false)));
        } else if (index == 1) {
          Navigator.push(
              context, PageTransition(ChatEngine('Freshers', userFirstName)));
        }
      },
      child: Container(
        padding: const EdgeInsets.all(15),
        margin: const EdgeInsets.only(
          left: 15,
          bottom: 20,
          top: 20,
        ),
        height: 150,
        width: 150,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(5, 5))
            ]),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Text(
                  list[index][0],
                  style: const TextStyle(
                      color: Constants.darkText,
                      fontWeight: FontWeight.bold,
                      fontSize: 20),
                ),
                const Icon(Icons.arrow_forward)
              ],
            ),
            const Divider(
              indent: 5,
              endIndent: 5,
              color: Colors.orangeAccent,
            ),
            Text(
              list[index][1],
              style: const TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.w300,
                  fontSize: 15),
            )
          ],
        ),
      ),
    );
  }
}
// GestureDetector(
//                               onTap: () {
                                
//                               },
//                             )