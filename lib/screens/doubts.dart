import 'package:chat_app/screens/reply_to_doubt.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/page_transition.dart';
import 'package:chat_app/utils/providers.dart';
import 'package:chat_app/utils/upvote.dart';
import 'package:chat_app/utils/user_data.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class Doubts extends ConsumerStatefulWidget {
  final bool isMyDoubts;
  Doubts(this.isMyDoubts);
  @override
  _DoubtsState createState() => _DoubtsState();
}

class _DoubtsState extends ConsumerState<Doubts> {
  late FirebaseFirestore firestore;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    firestore = FirebaseFirestore.instance;
  }

  String sorting = 'timestamp';
  void defineSorting(String value) {
    setState(() {
      sorting = value;
    });
  }

  String daysBetween(DateTime from) {
    from = DateTime(from.year, from.month, from.day);
    var to = DateTime.now();
    final d = (to.difference(from).inHours / 24).round() - 1;
    if (d == -1) return 'Today';
    if (d == 0)
      return 'Today';
    else if (d == 1)
      return 'Yesterday';
    else
      return '$d days ago';
    ;
  }

  @override
  Widget build(BuildContext context) {
    final myProvider = ref.watch(userDataProvider);
    final attendanceProvider = ref.watch(attendanceDataProvider);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.background,
          elevation: 0,
          title: const Text(
            ' Doubts',
            style: TextStyle(
                color: Constants.darkText, fontWeight: FontWeight.bold),
          ),
          actions: [
            const Center(
              child: Text(
                'Sorting',
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 17,
                    fontWeight: FontWeight.bold),
              ),
            ),
            PopupMenuButton<String>(
                onSelected: (value) => defineSorting(value),
                icon: const Icon(Icons.sort),
                itemBuilder: (context) => [
                      const PopupMenuItem(
                        child: Text("Upload Date"),
                        value: 'timestamp',
                      ),
                      const PopupMenuItem(
                        child: Text("Upvotes"),
                        value: 'upvotes',
                      )
                    ])
          ],
          leading: IconButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.arrow_back)),
          iconTheme: const IconThemeData(color: Constants.darkText),
        ),
        body: Container(
          height: double.maxFinite,
          width: MediaQuery.of(context).size.width,
          color: Constants.background,
          child: StreamBuilder<QuerySnapshot>(
              stream: widget.isMyDoubts
                  ? firestore //1fYZzZBotnX2gxEuL2aSZPNQPD53
                      .collection('Colleges/PICT/Doubts')
                      // .orderBy('timestamp', descending: true)
                      .where('uid', isEqualTo: myProvider.uid)
                      .snapshots()
                  : firestore
                      .collection('Colleges/PICT/Doubts')
                      .orderBy(sorting, descending: true)
                      .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                    child: Constants.progressIndicator,
                  );
                }
                if (snapshot.data == null) return Text('Null was returned');
                if (snapshot.hasData && snapshot.data!.docs.isEmpty)
                  return NoDoubts();

                return Container(
                  child: AnimationLimiter(
                    child: ListView.builder(
                      cacheExtent: 5,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemBuilder: (context, index) {
                        String doubtId = snapshot.data!.docs[index].id;
                        bool isUpvoted = snapshot
                            .data!.docs[index]['Upvoted By']
                            .contains(myProvider.uid);
                        String desc = snapshot.data!.docs[index]['desc'].trim();
                        String upvotes =
                            snapshot.data!.docs[index]['upvotes'].toString();
                        String username = snapshot.data!.docs[index]['uid'] ==
                                FirebaseAuth.instance.currentUser!.uid
                            ? 'You'
                            : snapshot.data!.docs[index]['username'];
                        String timePosted = daysBetween(
                            snapshot.data!.docs[index]['timestamp'].toDate());
                        String replies =
                            snapshot.data!.docs[index]['replies'].toString();
                        String grade =
                            snapshot.data!.docs[index]['grade'].toString();

                        return AnimationConfiguration.staggeredList(
                            delay: const Duration(milliseconds: 100),
                            position: index,
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 2500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: FadeInAnimation(
                                child: GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        PageTransition(ReplyToDoubt(
                                            desc,
                                            username,
                                            timePosted,
                                            doubtId,
                                            widget.isMyDoubts,
                                            grade)));
                                  },
                                  child: Container(
                                    // constraints: BoxConstraints(maxHeight: 180),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 5),

                                    decoration: BoxDecoration(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.5),
                                              blurRadius: 20,
                                              offset: const Offset(5, 5)),
                                        ]),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Container(
                                                padding: const EdgeInsets.only(
                                                    top: 10,
                                                    left: 10,
                                                    right: 10,
                                                    bottom: 5),
                                                decoration: const BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.only(
                                                          topLeft:
                                                              Radius.circular(
                                                                  10),
                                                          topRight:
                                                              Radius.circular(
                                                                  10)),
                                                ),
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        Text(
                                                          username,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                          style: const TextStyle(
                                                              fontSize: 16,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .bold,
                                                              color: Constants
                                                                  .secondaryThemeColor),
                                                        ),
                                                        const SizedBox(
                                                          height: 2,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              grade,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Constants
                                                                    .darkText
                                                                    .withOpacity(
                                                                        0.6),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    UpVote(doubtId, isUpvoted)
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10, bottom: 10, right: 5),
                                          child: Container(
                                            child: Text(
                                              desc,
                                              style: const TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w300,
                                                  color: Colors.black),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 6,
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 10),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                timePosted,
                                                style: TextStyle(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  color: Constants.darkText
                                                      .withOpacity(0.6),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons
                                                            .chat_bubble_outline,
                                                        size: 15,
                                                        color: Constants
                                                            .darkText
                                                            .withOpacity(0.8),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        replies,
                                                        style: TextStyle(
                                                          color: Constants
                                                              .darkText
                                                              .withOpacity(0.8),
                                                          letterSpacing: 0,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                  const SizedBox(
                                                    width: 10,
                                                  ),
                                                  Row(
                                                    children: [
                                                      Icon(
                                                        Icons.favorite_border,
                                                        size: 15,
                                                        color: Constants
                                                            .darkText
                                                            .withOpacity(0.8),
                                                      ),
                                                      const SizedBox(
                                                        width: 5,
                                                      ),
                                                      Text(
                                                        upvotes,
                                                        style: TextStyle(
                                                          color: Constants
                                                              .darkText
                                                              .withOpacity(0.8),
                                                          letterSpacing: 0,
                                                          fontSize: 13,
                                                          fontWeight:
                                                              FontWeight.w300,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                curve: Curves.fastLinearToSlowEaseIn,
                                duration: const Duration(milliseconds: 2500),
                              ),
                            ));
                      },
                      itemCount: snapshot.data!.docs.length,
                    ),
                  ),
                );
              }),
        ),
      ),
    );
  }
}
// Text(snapshot.data!.docs[index]['desc'])

class NoDoubts extends StatelessWidget {
  const NoDoubts({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Container(
        child: Scaffold(
          body: Container(
            color: Constants.background,
            child: Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Constants.errorLottie,
                  const SizedBox(
                    height: 40,
                  ),
                  const Text(
                    'Looks like we could not find any doubts!',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w400,
                        color: Constants.darkText),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
