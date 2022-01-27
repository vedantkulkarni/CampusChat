import 'dart:convert';
import 'dart:io';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/user_data.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:html/parser.dart' as html;
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';

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
          title: Text(
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
        body: SingleChildScrollView(
            child: provider.isLoaded
                ? AttendanceBody(provider: provider)
                : FutureBuilder(
                    future: provider.authAndRequestApi(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting)
                        return Container(
                          color: Constants.background,
                          height: MediaQuery.of(context).size.height,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        );
                      if (snapshot.hasError)
                        return Container(
                          child: Center(
                            child: Text("Error occured"),
                          ),
                        );

                      return AttendanceBody(provider: provider);
                    },
                  )),
      ),
    );
  }
}

class AttendanceBody extends StatelessWidget {
  const AttendanceBody({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final AttendanceData provider;

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
                                    provider.username.trim(),
                                    style: const TextStyle(
                                        color: Constants.background,
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ]),
                            Text(
                              '${provider.grade.trim()}   DIV-${provider.division.trim()}',
                              style: TextStyle(
                                  color: Constants.background.withOpacity(0.6),
                                  fontSize: 14,
                                  fontWeight: FontWeight.w100),
                            ),
                            // Text(
                            //   'Division ${provider.division.trim()}',
                            //   style: TextStyle(
                            //       color: Constants.background.withOpacity(0.6),
                            //       fontSize: 14,
                            //       fontWeight: FontWeight.w100),
                            // )
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
                              '${provider.averageAttendance}%',
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
            child: Text(
              'Subject Attendance',
              style: TextStyle(
                  color: Constants.darkText.withOpacity(0.7),
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return AttendanceCard(provider.subjectList[index]);
              },
              itemCount: provider.subjectList.length,
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
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
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
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Constants.darkText),
                ),
              ),
              const SizedBox(
                height: 5,
              ),
              Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: FittedBox(
                        child: Text(
                          'Attended',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Color(0xfff97a80)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: FittedBox(
                        child: Text(
                          sub.attendedLecs,
                          style: const TextStyle(
                              color: Color(0xfff97a80),
                              fontSize: 15,
                              fontWeight: FontWeight.w500),
                        ),
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
                      child: FittedBox(
                        child: Text(
                          'Total',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Constants.darkText.withOpacity(0.7)),
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    Container(
                      child: FittedBox(
                        child: Text(
                          sub.totalLecs,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
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
