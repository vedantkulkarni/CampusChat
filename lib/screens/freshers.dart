import 'package:flutter/material.dart';
class Freshers extends StatefulWidget {
  Freshers({Key? key}) : super(key: key);

  @override
  _FreshersState createState() => _FreshersState();
}

class _FreshersState extends State<Freshers> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Center(child: Text('Hello freshers'),),
      ),
    );
  }
}