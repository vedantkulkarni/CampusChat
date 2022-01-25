import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/providers.dart';
import 'package:chat_app/utils/teacher_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

class TeacherList extends ConsumerStatefulWidget {
  @override
  ConsumerState<TeacherList> createState() => _TeacherListState();
}

class _TeacherListState extends ConsumerState<TeacherList> {
  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(userDataProvider);
    return SafeArea(
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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 20, top: 10),
              child: Text(
                'Teachers',
                style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                    color: Constants.darkText),
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Expanded(
                child: FutureBuilder<QuerySnapshot>(
              future: FirebaseFirestore.instance
                  .collection('Colleges/PICT/Teachers')
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.data == null) return Text('Null was returned');
                if (snapshot.hasData && snapshot.data!.docs.isEmpty)
                  return Text('No');

                return AnimationLimiter(
                  child: ListView.builder(
                    itemBuilder: (context, index) {
                      String uid = snapshot.data!.docs[index].id;
                      String name = snapshot.data!.docs[index]['name'];
                      String email = snapshot.data!.docs[index]['email'];
                      String contact =
                          '+91 ${snapshot.data!.docs[index]['whatsapp']}';
                      List<dynamic> subjects =
                          snapshot.data!.docs[index]['subjects'];

                      return AnimationConfiguration.staggeredList(
                          position: index,
                          delay: const Duration(milliseconds: 100),
                          child: SlideAnimation(
                            curve: Curves.fastLinearToSlowEaseIn,
                            duration: const Duration(milliseconds: 2500),
                            child: FadeInAnimation(
                              child: TeacherModel(
                                  uid, name, subjects, email, contact),
                            ),
                          ));
                    },
                    itemCount: snapshot.data!.docs.length,
                  ),
                );
              },
            ))
          ],
        ),
      ),
    ));
  }
}
