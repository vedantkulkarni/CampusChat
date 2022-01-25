import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

class TeacherModel extends StatefulWidget {
  final String name;
  final String uid;
  final List<dynamic> subjects;
  final String email;
  final String contact;

  TeacherModel(this.uid, this.name, this.subjects, this.email, this.contact);

  @override
  State<TeacherModel> createState() => _TeacherModelState();
}

class _TeacherModelState extends State<TeacherModel> {
  String convertSubjectList(List<dynamic> list) {
    String s = '';
    s = list.toString();

    return s;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                blurRadius: 20,
                color: Colors.grey.withOpacity(0.6),
                offset: const Offset(10, 10))
          ]),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.only(top: 10, left: 10),
            height: 70,
            width: double.maxFinite,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(10),
                    topRight: Radius.circular(10)),
                gradient: LinearGradient(colors: [
                  Color(0xfff97a80),
                  Color(0xfffeb094),
                ])),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
                  style: const TextStyle(
                    fontSize: 23,
                    fontWeight: FontWeight.bold,
                    color: Constants.background,
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Text(
                  convertSubjectList(widget.subjects),
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w400,
                    color: Constants.background.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: FittedBox(
                        child: Text(
                          'Email ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Constants.darkText.withOpacity(0.7)),
                        ),
                      ),
                    ),
                    Container(
                      child: FittedBox(
                        child: Text(
                          widget.email,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 10,
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      child: FittedBox(
                        child: Text(
                          'Whatsapp ',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w500,
                              color: Constants.darkText.withOpacity(0.7)),
                        ),
                      ),
                    ),
                    Container(
                      child: FittedBox(
                        child: Text(
                          widget.contact,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.w500),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
