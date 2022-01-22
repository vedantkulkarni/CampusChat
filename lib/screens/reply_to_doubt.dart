import 'package:chat_app/screens/doubts.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReplyToDoubt extends ConsumerStatefulWidget {
  final String desc;
  final String username;
  final String timePosted;
  final String doubtId;
  ReplyToDoubt(this.desc, this.username, this.timePosted, this.doubtId);
  @override
  _ReplyToDoubtState createState() => _ReplyToDoubtState();
}

class _ReplyToDoubtState extends ConsumerState<ReplyToDoubt> {
  late CollectionReference replyReference;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    final myProvider = ref.read(userDataProvider);
    replyReference = myProvider.firestore.collection('Colleges/PICT/Doubts');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          iconTheme: const IconThemeData(color: Constants.darkText),
          backgroundColor: Constants.background,
          elevation: 0,
          title: const Text(
            'Doubt',
            style: TextStyle(
                fontSize: 25,
                color: Constants.darkText,
                fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
                onPressed: () {},
                child: const Text(
                  'Reply',
                  style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Constants.secondaryThemeColor),
                ))
          ],
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              FocusScope.of(context).unfocus();
              Navigator.pop(context);
            },
          ),
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          color: Constants.background,
          child: Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    // color: Colors.blue.withOpacity(0.5),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.username,
                          style: const TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: Constants.secondaryThemeColor,
                          ),
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          'Posted ${widget.timePosted}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: Colors.grey,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),

                        Flex(
                          direction: Axis.vertical,
                          children: [
                            Container(child: Text(widget.desc)),
                          ],
                        ),

                        const SizedBox(
                          height: 30,
                        ),
                        const Text(
                          'Answers',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Constants.darkText,
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        GetReplies(replyReference, widget.doubtId)
                        // Text('hi')
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class GetReplies extends StatelessWidget {
  final CollectionReference replyReference;
  final String doubtId;
  const GetReplies(
    this.replyReference,
    this.doubtId, {
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.6,
      child: FutureBuilder<QuerySnapshot>(
        future: replyReference.doc(doubtId).collection('Replies').get(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) return Text('Not found vrons!');
          if (snapshot.hasData && snapshot.data!.docs.isEmpty)
            return Text('not found');

          final List? replyList = snapshot.data!.docs;
          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        width: 1, color: Constants.secondaryThemeColor)),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        snapshot.data!.docs[index]['username'],
                        style: const TextStyle(
                            color: Constants.secondaryThemeColor,
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Flex(
                        direction: Axis.vertical,
                        children: [Text(snapshot.data!.docs[index]['desc'])],
                      )
                    ],
                  ),
                ),
              );
            },
            itemCount: replyList!.length,
          );
        },
      ),
    );
  }
}
