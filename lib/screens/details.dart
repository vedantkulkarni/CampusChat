import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';

class Details extends StatelessWidget {
  const Details({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Constants.background,
        child: const Center(
          child: Text(
            'Details Screen',
            style: TextStyle(
                fontSize: 25,
                color: Constants.darkText,
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
