import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';

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
              future: firestore.collection('Freshers/Doubts/doubts').get(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting)
                  return Center(child: CircularProgressIndicator());
                if (snapshot.hasData && snapshot.data!.docs.isEmpty)
                  return Text("nothing");
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
                                  padding: const EdgeInsets.all(10),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      const Text(
                                        'Topic',
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                            color: Constants.darkText,
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      const Divider(
                                        indent: 20,
                                        endIndent: 20,
                                        color: Colors.orangeAccent,
                                      ),
                                      Container(
                                        height: 70,
                                        width: double.maxFinite,
                                        child: const Text(
                                          'descdklsdfjask;ldfjsdjlksdgjlsdajgsoadgh0asjlkasjg;lasdh hgl;kas glk jalkg jsgoasjdgo  alskjgoias g sga;fkljsd gasdk gaklsdjg;alks glkasjg ;laskjg ;lkasjgl;skadjg l;skadjg ;alsk g  asdg;lksjg ;lksjg ;las g laskjglsdk;glgjlksg sd sladkfjsladkfjlksdfjlsdkfsdf sfg lskjglskdjglksd ',
                                          style: TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.w300,
                                              color: Colors.grey),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 4,
                                        ),
                                      ),
                                      const Divider(
                                        height: 0,
                                        color: Colors.orangeAccent,
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            const Text(
                                              'Username',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    IconButton(
                                                      onPressed: () {},
                                                      icon: const Icon(
                                                          Icons.arrow_upward),
                                                    ),
                                                    IconButton(
                                                        onPressed: () {},
                                                        icon: const Icon(Icons
                                                            .arrow_downward))
                                                  ],
                                                )
                                              ],
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