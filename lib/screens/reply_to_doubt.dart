import 'package:chat_app/screens/doubts.dart';
import 'package:chat_app/screens/new_doubt.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/page_transition.dart';
import 'package:chat_app/utils/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class ReplyToDoubt extends ConsumerStatefulWidget {
  final String desc;
  final String username;
  final String timePosted;
  final String doubtId;
  final bool isMyDoubts;
  ReplyToDoubt(
      this.desc, this.username, this.timePosted, this.doubtId, this.isMyDoubts);
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

  Future<void> deleteDoubt(BuildContext context) async {
    final doubtRef =
        ref.read(userDataProvider).firestore.collection('Colleges/PICT/Doubts');
    doubtRef.doc(widget.doubtId).delete().then((value) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
          'Deletion Successful',
          style: TextStyle(color: Constants.background),
        ),
        backgroundColor: Colors.green,
      ));
      Navigator.pop(context);
    });
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
            widget.isMyDoubts
                ? IconButton(
                    onPressed: () async {
                      await deleteDoubt(context);
                    },
                    icon: const Icon(Icons.delete))
                : TextButton(
                    onPressed: () {
                      Navigator.push(
                          context,
                          PageTransition(NewDoubt(
                            true,
                            doubtId: widget.doubtId,
                          )));
                    },
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
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          color: Constants.background,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Container(
                  // color: Colors.blue.withOpacity(0.5),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Colors.white,
                            boxShadow: [
                              BoxShadow(
                                  blurRadius: 20,
                                  color: Colors.grey.withOpacity(0.4),
                                  offset: const Offset(10, 10))
                            ]),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.only(
                                  top: 10, left: 10, right: 10),
                              width: double.maxFinite,
                              decoration: const BoxDecoration(
                                borderRadius: BorderRadius.only(
                                    topLeft: Radius.circular(10),
                                    topRight: Radius.circular(10)),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        widget.username,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Constants.secondaryThemeColor,
                                        ),
                                      ),
                                      Text(
                                        'Posted ${widget.timePosted}',
                                        style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w400,
                                          color: Constants.darkText
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'SE IT',
                                    style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w400,
                                      color:
                                          Constants.darkText.withOpacity(0.6),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Flex(
                              direction: Axis.vertical,
                              children: [
                                Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text(
                                      widget.desc,
                                      style: const TextStyle(
                                          fontSize: 17,
                                          fontWeight: FontWeight.w500),
                                    )),
                              ],
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(
                        height: 30,
                      ),
                      const Padding(
                        padding: EdgeInsets.only(left: 20, top: 10, bottom: 10),
                        child: Text(
                          'Replies',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.w300,
                            color: Constants.darkText,
                          ),
                        ),
                      ),

                      GetReplies(
                          replyReference, widget.doubtId, widget.isMyDoubts)
                      // Text('hi')
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class GetReplies extends StatefulWidget {
  final CollectionReference replyReference;
  final String doubtId;
  final bool isMyDoubt;
  const GetReplies(
    this.replyReference,
    this.doubtId,
    this.isMyDoubt, {
    Key? key,
  }) : super(key: key);

  @override
  State<GetReplies> createState() => _GetRepliesState();
}

class _GetRepliesState extends State<GetReplies> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // height: MediaQuery.of(context).size.height * 0.6,
      child: StreamBuilder<QuerySnapshot>(
        stream: widget.replyReference
            .doc(widget.doubtId)
            .collection('Replies')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.data == null) return Text('Not found vrons!');
          if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            Container(
              child: Column(
                children: [
                  Constants.errorLottie,
                  const SizedBox(
                    height: 20,
                  ),
                  const Text(
                    'Nope! Not a single reply.',
                    style: Constants.errorText,
                  )
                ],
              ),
            );
          }

          return ListView.builder(
            physics: const NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return Container(
                decoration: BoxDecoration(
                  color: Constants.background,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(left: 50, right: 10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Divider(
                        thickness: 0.1,
                        height: 30,
                        color: Constants.darkText,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            snapshot.data!.docs[index]['username'],
                            style: const TextStyle(
                                color: Constants.secondaryThemeColor,
                                fontSize: 15,
                                fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            DateFormat.MMMd()
                                .format(snapshot.data!.docs[index]['timestamp']
                                    .toDate())
                                .toString(),
                            style: TextStyle(
                                color: Colors.grey.withOpacity(0.6),
                                fontSize: 12),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Flex(
                        direction: Axis.vertical,
                        children: [
                          Text(
                            snapshot.data!.docs[index]['desc'],
                            style: const TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w300,
                            ),
                          )
                        ],
                      ),
                      widget.isMyDoubt &&
                              !snapshot.data!.docs[index]
                                  ['isAckwnoledgedByUser'] &&
                              !(snapshot.data!.docs[index]['uid'] ==
                                  FirebaseAuth.instance.currentUser!.uid)
                          ? ReplyFeedback(
                              snapshot.data!.docs[index]['uid'],
                              widget.doubtId,
                              snapshot.data!.docs[index].id,
                            )
                          : Container()
                    ],
                  ),
                ),
              );
            },
            itemCount: snapshot.data!.docs.length,
          );
        },
      ),
    );
  }
}

class ReplyFeedback extends StatefulWidget {
  final String replyUserId;
  final String replyId;
  final String doubtId;
  const ReplyFeedback(
    this.replyUserId,
    this.doubtId,
    this.replyId, {
    Key? key,
  }) : super(key: key);

  @override
  State<ReplyFeedback> createState() => _ReplyFeedbackState();
}

class _ReplyFeedbackState extends State<ReplyFeedback> {
  var myheight = 40.0;
  void updateHeight() {
    setState(() {
      myheight = 0.0;
    });
  }

  Future<void> increaseRating() async {
    final firestore =
        FirebaseFirestore.instance.collection('Colleges/PICT/Users');

    final doubtRef =
        FirebaseFirestore.instance.collection('Colleges/PICT/Doubts');
    await doubtRef
        .doc(widget.doubtId)
        .collection('Replies')
        .doc(widget.replyId)
        .update({'isAckwnoledgedByUser': true});
    final ratingValue =
        await firestore.doc(widget.replyUserId).get().then((value) {
      return value.data()!['ratingValue'];
    });
    final doubtsSolved =
        await firestore.doc(widget.replyUserId).get().then((value) {
      return value.data()!['monthlySolved'];
    });
    final result = await firestore.doc(widget.replyUserId).update(
        {'ratingValue': ratingValue + 1, 'monthlySolved': doubtsSolved + 1});
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      height: myheight,
      curve: Curves.fastLinearToSlowEaseIn,
      duration: const Duration(milliseconds: 500),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Did this reply solve your doubt?',
            style: TextStyle(color: Colors.grey.withOpacity(0.8), fontSize: 14),
          ),
          Row(
            children: [
              TextButton(
                  onPressed: () {
                    increaseRating();
                    updateHeight();
                  },
                  child: const Text(
                    'Yes',
                    style: TextStyle(color: Colors.green),
                  )),
              TextButton(
                  onPressed: () {},
                  child: const Text('No', style: TextStyle(color: Colors.red)))
            ],
          )
        ],
      ),
    );
  }
}
