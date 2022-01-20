import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

class ReplyToDoubt extends StatefulWidget {
  @override
  _ReplyToDoubtState createState() => _ReplyToDoubtState();
}

class _ReplyToDoubtState extends State<ReplyToDoubt> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Container(
            child: Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(color: Constants.darkText),
        backgroundColor: Constants.background,
        elevation: 0,
        title: const Text(
          'Reply',
          style: TextStyle(
              fontSize: 25,
              color: Constants.darkText,
              fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            FocusScope.of(context).unfocus();
            Navigator.pop(context);
          },
        ),
      ),
      body: Container(
        color: Constants.background,
      
      ),
    )));
  }
}
