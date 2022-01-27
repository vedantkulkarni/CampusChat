import 'package:chat_app/screens/auth.dart';
import 'package:chat_app/screens/chat_main.dart';
import 'package:chat_app/screens/doubts.dart';
import 'package:chat_app/screens/freshers.dart';
import 'package:chat_app/screens/profile.dart';
import 'package:chat_app/screens/teacher_list.dart';
import 'package:chat_app/utils/chat_engine.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/teacher_model.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Chirp'
      ),
      debugShowCheckedModeBanner: false,
      home: StreamBuilder(
        stream: FirebaseAuth.instance.userChanges(),
        builder: (context, userSnapShot) {
          if (userSnapShot.hasData) {
            return ChatMain();
          }
          return AuthScreen();
        },
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final Stream<QuerySnapshot> _messageStream = FirebaseFirestore.instance
        .collection('Users/d2yAm7uat41hvHxytd8n/messages')
        .snapshots();
    final message_doc = FirebaseFirestore.instance
        .collection('Users/d2yAm7uat41hvHxytd8n/messages');
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: StreamBuilder<QuerySnapshot>(
          stream: _messageStream,
          builder: (ctx, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasError) {
              return const Text('Something went wrong');
            }

            if (streamSnapshot.connectionState == ConnectionState.waiting) {
              return const Text("Loading");
            }
            final message_data = streamSnapshot.data!.docs;
            return ListView.builder(
              physics: const BouncingScrollPhysics(
                  parent: AlwaysScrollableScrollPhysics()),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(message_data[index]['messages'].toString()),
                );
              },
              itemCount: streamSnapshot.data!.docs.length,
            );
          }),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          message_doc.add({'messages': 'This was added by Vedant!'});
        },
      ),

      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}
