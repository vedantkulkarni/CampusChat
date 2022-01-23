import 'package:chat_app/screens/reply_to_doubt.dart';
import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/page_transition.dart';
import 'package:chat_app/utils/providers.dart';
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

  String daysBetween(DateTime from) {
    from = DateTime(from.year, from.month, from.day);
    var to = DateTime.now();
    final d = (to.difference(from).inHours / 24).round() - 1;
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
                      .where('uid', isEqualTo: myProvider.uid)
                      // .orderBy('timestamp', descending: true)
                      .snapshots()
                  : firestore
                      .collection('Colleges/PICT/Doubts')
                      .orderBy('timestamp', descending: true)
                      .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
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

                        String desc = snapshot.data!.docs[index]['desc'];
                        String username =
                            snapshot.data!.docs[index]['username'];
                        String timePosted = daysBetween(
                            snapshot.data!.docs[index]['timestamp'].toDate());
                        String replies = snapshot.data!.docs[index]
                                    ['replies'] ==
                                1
                            ? '1 Reply'
                            : '${snapshot.data!.docs[index]['replies'].toString()} replies';

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
                                            widget.isMyDoubts)));
                                  },
                                  child: Container(
                                    // constraints: BoxConstraints(maxHeight: 180),
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 10),

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
                                                    bottom: 10),
                                                decoration: const BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.only(
                                                            topLeft: Radius
                                                                .circular(10),
                                                            topRight:
                                                                Radius.circular(
                                                                    10)),
                                                    gradient: LinearGradient(
                                                        colors: [
                                                          Color(0xfff97a80),
                                                          Color(0xfffeb094)
                                                        ])),
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
                                                          style:
                                                              const TextStyle(
                                                            fontSize: 20,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            color: Constants
                                                                .background,
                                                          ),
                                                        ),
                                                        const SizedBox(
                                                          height: 5,
                                                        ),
                                                        Row(
                                                          children: [
                                                            Text(
                                                              timePosted,
                                                              style: TextStyle(
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                                color: Constants
                                                                    .background
                                                                    .withOpacity(
                                                                        0.6),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              width: 10,
                                                            ),
                                                            Text(
                                                              replies,
                                                              style: TextStyle(
                                                                color: Constants
                                                                    .background
                                                                    .withOpacity(
                                                                        0.6),
                                                                letterSpacing:
                                                                    0,
                                                                fontSize: 12,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                          ],
                                                        )
                                                      ],
                                                    ),
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                        Icons.thumb_up,
                                                        color: Constants
                                                            .background,
                                                        size: 20,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              left: 10,
                                              bottom: 10,
                                              top: 10,
                                              right: 5),
                                          child: Container(
                                            child: Text(
                                              desc,
                                              style: TextStyle(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.normal,
                                                  color: Constants.darkText
                                                      .withOpacity(0.8)),
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 6,
                                            ),
                                          ),
                                        ),
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
                  Container(
                    height: 300,
                    width: 300,
                    child: Lottie.network(
                        'https://assets3.lottiefiles.com/packages/lf20_r71cen62.json',
                        fit: BoxFit.contain),
                  ),
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
