import 'package:chat_app/screens/fresher_doubts.dart';
import 'package:chat_app/screens/new_doubt.dart';
import 'package:chat_app/utils/chat_engine.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/page_transition.dart';
import 'package:flutter/material.dart';

class Freshers extends StatefulWidget {
  String userFirstName;
  Freshers(this.userFirstName, {Key? key}) : super(key: key);

  @override
  _FreshersState createState() => _FreshersState();
}

class _FreshersState extends State<Freshers> {
  @override
  Widget build(BuildContext context) {
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
          body: Container(
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
                        child: ListView(
                          physics: const BouncingScrollPhysics(
                              parent: AlwaysScrollableScrollPhysics()),
                          scrollDirection: Axis.horizontal,
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context, PageTransition(FresherDoubts()));
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Text(
                                          'Doubts',
                                          style: TextStyle(
                                              color: Constants.darkText,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Icon(Icons.arrow_forward)
                                      ],
                                    ),
                                    const Divider(
                                      indent: 5,
                                      endIndent: 5,
                                      color: Colors.orangeAccent,
                                    ),
                                    const Text(
                                      '22 doubts raised ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    PageTransition(ChatEngine(
                                        'Freshers', widget.userFirstName)));
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: const [
                                        Text(
                                          'Chat',
                                          style: TextStyle(
                                              color: Constants.darkText,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Icon(Icons.arrow_forward)
                                      ],
                                    ),
                                    const Divider(
                                      indent: 5,
                                      endIndent: 5,
                                      color: Colors.orangeAccent,
                                    ),
                                    const Text(
                                      '223 users online ',
                                      style: TextStyle(
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w300,
                                          fontSize: 15),
                                    )
                                  ],
                                ),
                              ),
                            ),
                            // Container(
                            //   padding: const EdgeInsets.all(15),
                            //   margin: const EdgeInsets.only(
                            //     left: 15,
                            //     bottom: 20,
                            //     top: 20,
                            //   ),
                            //   height: 150,
                            //   width: 150,
                            //   decoration: BoxDecoration(
                            //       borderRadius: BorderRadius.circular(30),
                            //       color: Colors.white,
                            //       boxShadow: [
                            //         BoxShadow(
                            //             color: Colors.grey.withOpacity(0.3),
                            //             blurRadius: 20,
                            //             offset: const Offset(5, 5))
                            //       ]),
                            //   child: Column(
                            //     mainAxisAlignment:
                            //         MainAxisAlignment.spaceEvenly,
                            //     children:  [
                            //      Row(
                            //         mainAxisAlignment:
                            //             MainAxisAlignment.spaceEvenly,
                            //         children: const [
                            //           Text(
                            //             'Doubts',
                            //             style: TextStyle(
                            //                 color: Constants.darkText,
                            //                 fontWeight: FontWeight.bold,
                            //                 fontSize: 20),
                            //           ),
                            //           Icon(Icons.arrow_forward)
                            //         ],
                            //       ),
                            //       const Divider(
                            //         indent: 5,
                            //         endIndent: 5,
                            //         color: Colors.orangeAccent,
                            //       ),
                            //       const Text(
                            //         '223 users online ',
                            //         style: TextStyle(
                            //             color: Colors.grey,
                            //             fontWeight: FontWeight.w300,
                            //             fontSize: 15),
                            //       )
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(context, PageTransition(NewDoubt()));
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
                                  color: Constants.themeColor.withOpacity(0.5),
                                  blurRadius: 20,
                                  offset: const Offset(10, 10))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
    );
  }
}
