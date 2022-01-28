import 'dart:convert';
import 'dart:io';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/user_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:html/parser.dart' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:cookie_jar/cookie_jar.dart';

class Profile extends ConsumerStatefulWidget {
  Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends ConsumerState<Profile> {
  @override
  Widget build(BuildContext context) {
    final provider = ref.watch(attendanceDataProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.background,
          elevation: 0,
          title: const Text(
            'Profile',
            style: TextStyle(
                color: Constants.darkText, fontWeight: FontWeight.bold),
          ),
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: const IconThemeData(color: Constants.darkText),
        ),
        body: provider.isLoaded
            ? AttendanceBody(provider: provider)
            : FutureBuilder(
                future: provider.authAndRequestApi(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Constants.background,
                      height: MediaQuery.of(context).size.height,
                      child: Constants.progressIndicator,
                    );
                  }

                  if (snapshot.hasError) {
                    return Container(
                      child: const Center(
                        child: Text("Error occured"),
                      ),
                    );
                  }

                  return AttendanceBody(provider: provider);
                },
              ),
      ),
    );
  }
}

class AttendanceBody extends StatefulWidget {
  const AttendanceBody({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final AttendanceData provider;

  @override
  State<AttendanceBody> createState() => _AttendanceBodyState();
}

class _AttendanceBodyState extends State<AttendanceBody> {
  int filter = 0;
  void changeFilter(int value) {
    setState(() {
      filter = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Constants.background,
      height: MediaQuery.of(context).size.height,
      child: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                gradient: const LinearGradient(colors: [
                  Color(0xfff97a80),
                  Color(0xfffeb094),
                ])),
            child: Padding(
              padding: EdgeInsets.all(10),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Flex(
                                direction: Axis.vertical,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.provider.username.trim(),
                                    style: const TextStyle(
                                        color: Constants.background,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            Text(
                              '${widget.provider.grade!.trim()}   DIV-${widget.provider.division.trim()}',
                              style: TextStyle(
                                  color: Constants.background.withOpacity(0.6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Colors.white),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            flex: 2,
                            child:
                                Flex(direction: Axis.vertical, children: const [
                              Text(
                                'Avg. Attendance ',
                                style: TextStyle(
                                    color: Constants.darkText,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ]),
                          ),
                          Flexible(
                            flex: 1,
                            child: Text(
                              '${widget.provider.averageAttendance}%',
                              style: const TextStyle(
                                  color: Constants.darkText,
                                  fontSize: 25,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
          Container(
            width: double.maxFinite,
            padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Subject Attendance',
                  style: TextStyle(
                      color: Constants.darkText.withOpacity(0.7),
                      fontSize: 25,
                      fontWeight: FontWeight.bold),
                ),
                PopupMenuButton<int>(
                  // onSelected: (value) => defineSorting(value),
                  icon: const Icon(Icons.sort),
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("All"),
                      value: 0,
                    ),
                    const PopupMenuItem(
                      child: Text("Theory"),
                      value: 1,
                    ),
                    const PopupMenuItem(
                      child: Text("Practical"),
                      value: 2,
                    ),
                    const PopupMenuItem(
                      child: Text("Tutorial"),
                      value: 3,
                    )
                  ],
                  onSelected: (value) {
                    changeFilter(value);
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: AnimationLimiter(
              child: ListView.builder(
                physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics()),
                itemBuilder: (context, index) {
                  if (filter != 0) {
                    if (widget.provider.subjectList[index].status == filter) {
                      return AnimationConfiguration.staggeredList(
                        position: index,
                        delay: const Duration(milliseconds: 100),
                        child: SlideAnimation(
                          duration: const Duration(milliseconds: 2500),
                          curve: Curves.fastLinearToSlowEaseIn,
                          horizontalOffset: 30,
                          verticalOffset: 300,
                          child: FlipAnimation(
                            duration: const Duration(milliseconds: 3000),
                            curve: Curves.fastLinearToSlowEaseIn,
                            flipAxis: FlipAxis.y,
                            child: AttendanceCard(
                                widget.provider.subjectList[index]),
                          ),
                        ),
                      );
                    }
                  } else {
                    return AnimationConfiguration.staggeredList(
                      position: index,
                      delay: const Duration(milliseconds: 100),
                      child: SlideAnimation(
                        duration: const Duration(milliseconds: 2500),
                        curve: Curves.fastLinearToSlowEaseIn,
                        horizontalOffset: 30,
                        verticalOffset: 300,
                        child: FlipAnimation(
                          duration: const Duration(milliseconds: 3000),
                          curve: Curves.fastLinearToSlowEaseIn,
                          flipAxis: FlipAxis.y,
                          child: FadeInAnimation(
                            duration: const Duration(milliseconds: 2000),
                            child: AttendanceCard(
                                widget.provider.subjectList[index]),
                          ),
                        ),
                      ),
                    );
                  }
                  return Container();
                },
                itemCount: widget.provider.subjectList.length,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AttendanceCard extends StatelessWidget {
  final SubjectModel sub;
  const AttendanceCard(this.sub, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        width: double.maxFinite,
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                  color: Colors.grey.withOpacity(0.4),
                  blurRadius: 15,
                  offset: Offset(5, 5))
            ],
            color: Colors.white),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                child: Text(
                  sub.subjectName,
                  softWrap: true,
                  style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Constants.darkText),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Attendance',
                    style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Constants.darkText.withOpacity(0.6)),
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text('${sub.percent}%',
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xfff97a80),
                      ))
                ],
              ),
              const SizedBox(
                height: 5,
              ),
              const Divider(
                thickness: 1,
              ),
              Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                Row(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child:const Text(
                            'Attended',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Color(0xfff97a80)),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          child: Text(
                            sub.attendedLecs,
                            style: const TextStyle(
                                color: Color(0xfff97a80),
                                fontSize: 15,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          child: Text(
                            'Total',
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: Constants.darkText.withOpacity(0.7)),
                          ),
                        ),
                        const SizedBox(
                          width: 5,
                        ),
                        Container(
                          child: Text(
                            sub.totalLecs,
                            style: const TextStyle(
                                fontSize: 15, fontWeight: FontWeight.w500),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  child: Text(
                    sub.status == 1
                        ? 'THEORY'
                        : sub.status == 2
                            ? 'PRACTICAL'
                            : sub.status == 3
                                ? 'TUTORIAL'
                                : '',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w500,
                      color: sub.status == 1
                          ? Colors.brown
                          : sub.status == 2
                              ? Constants.secondaryThemeColor
                              : sub.status == 3
                                  ? Colors.blueAccent
                                  : Colors.black,
                    ),
                  ),
                ),
              ]),
              const SizedBox(
                height: 10,
              ),
              Text(
                'Teachers',
                style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Constants.darkText.withOpacity(0.7)),
              ),
              const SizedBox(
                height: 5,
              ),
              Text(
                sub.subjectTeachers,
                style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: Constants.darkText),
              ),
            ],
          ),
        ));
  }
}
