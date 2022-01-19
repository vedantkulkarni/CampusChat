import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:intl/intl.dart';
import 'package:lottie/lottie.dart';

class FresherDoubts extends StatefulWidget {
  @override
  _FresherDoubtsState createState() => _FresherDoubtsState();
}

class _FresherDoubtsState extends State<FresherDoubts> {
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
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Constants.background,
          elevation: 0,
          title: const Text(
            'Fresher Doubts',
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
          color: Constants.background,
          child: FutureBuilder<QuerySnapshot>(
              future: firestore
                  .collection('Freshers/Doubts/doubts')
                  .orderBy('timestamp', descending: true)
                  .get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasData && snapshot.data!.docs.isEmpty)
                  return NoDoubts();
                return Container(
                  padding: const EdgeInsets.all(20),
                  child: AnimationLimiter(
                    child: ListView.builder(
                      cacheExtent: 5,
                      physics: const BouncingScrollPhysics(
                          parent: AlwaysScrollableScrollPhysics()),
                      itemBuilder: (context, index) {
                        return AnimationConfiguration.staggeredList(
                            delay: const Duration(milliseconds: 100),
                            position: index,
                            child: SlideAnimation(
                              duration: const Duration(milliseconds: 2500),
                              curve: Curves.fastLinearToSlowEaseIn,
                              child: FadeInAnimation(
                                child: Container(
                                  height: 180,
                                  margin: const EdgeInsets.all(10),
                                  padding: const EdgeInsets.only(
                                      left: 0, top: 10, right: 0),
                                  decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(
                                          Radius.circular(10)),
                                      color: Colors.white,
                                      boxShadow: [
                                        BoxShadow(
                                            color: Colors.grey.withOpacity(0.5),
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
                                        padding: const EdgeInsets.only(
                                            left: 10, right: 10),
                                        child: Column(
                                          children: [
                                            Container(
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: [
                                                  const Text(
                                                    'Topic',
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                    style: TextStyle(
                                                      color: Constants
                                                          .secondaryThemeColor,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(daysBetween(snapshot
                                                      .data!
                                                      .docs[index]['timestamp']
                                                      .toDate()))
                                                ],
                                              ),
                                            ),
                                            Divider(
                                              thickness: 1,
                                              color: Constants.themeColor
                                                  .withOpacity(0.7),
                                            ),
                                            Container(
                                              height: 80,
                                              width: double.maxFinite,
                                              child: Text(
                                                snapshot.data!.docs[index]
                                                    ['desc'],
                                                style: TextStyle(
                                                    fontSize: 14,
                                                    fontWeight:
                                                        FontWeight.normal,
                                                    color: Constants.darkText
                                                        .withOpacity(0.8)),
                                                overflow: TextOverflow.ellipsis,
                                                maxLines: 4,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        decoration: const BoxDecoration(
                                            color:
                                                Constants.secondaryThemeColor,
                                            borderRadius: BorderRadius.only(
                                                bottomLeft: Radius.circular(10),
                                                bottomRight:
                                                    Radius.circular(10))),
                                        width: double.maxFinite,
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  snapshot.data!.docs[index]
                                                      ['username'],
                                                  style: const TextStyle(
                                                    color: Constants.background,
                                                    letterSpacing: 0,
                                                    fontSize: 16,
                                                    fontWeight: FontWeight.w600,
                                                  ),
                                                ),
                                                Text(
                                                  snapshot.data!.docs[index][
                                                              'seniorStatus'] ==
                                                          1
                                                      ? 'Fresher'
                                                      : 'Senior ',
                                                  overflow: TextOverflow.fade,
                                                  style: TextStyle(
                                                    fontSize: 14,
                                                    color: Constants.background
                                                        .withOpacity(0.7),
                                                    fontWeight: FontWeight.w300,
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Container(
                                              child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Row(
                                                    children: [
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                          Icons.thumb_up,
                                                          color: Constants
                                                              .background,
                                                          size: 20,
                                                        ),
                                                      ),
                                                      IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(
                                                          Icons
                                                              .arrow_forward_ios,
                                                          size: 20,
                                                          color: Constants
                                                              .background,
                                                        ),
                                                      ),
                                                      // IconButton(
                                                      //     onPressed: () {},
                                                      //     icon: const Icon(
                                                      //       Icons
                                                      //           .favorite_border,
                                                      //       size: 20,
                                                      //     ))
                                                    ],
                                                  )
                                                ],
                                              ),
                                            )
                                          ],
                                        ),
                                      )
                                    ],
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
