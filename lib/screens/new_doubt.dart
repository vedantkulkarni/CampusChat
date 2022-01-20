import 'package:chat_app/utils/constants.dart';
import 'package:chat_app/utils/providers.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';

class NewDoubt extends ConsumerStatefulWidget {
  @override
  _NewDoubtState createState() => _NewDoubtState();
}

class _NewDoubtState extends ConsumerState<NewDoubt> {
  late final TextEditingController textEditingController;
  late final userProvider;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textEditingController = new TextEditingController();
    userProvider = ref.read(userDataProvider);
  }

  Future<void> uploadDoubt(String s) async {
    final userProvider = ref.read(userDataProvider);
    String seniorStatus =
        userProvider.seniorStatus == 1 ? 'Freshers' : 'Seniors';
    final doubtRef =
        userProvider.firestore.collection('Freshers/Doubts/doubts');
    final result = await doubtRef.add({
      'desc': ' $s',
      'timestamp': Timestamp.now(),
      'uid': userProvider.uid,
      'username': userProvider.userName,
      'seniorStatus': userProvider.seniorStatus,
      'upvotes': 0
    });
  }

  @override
  Widget build(BuildContext context) {
    final userProvider = ref.watch(userDataProvider);
    final mediaQuery = MediaQuery.of(context).size;
    return Container(
      height: mediaQuery.height,
      width: mediaQuery.width,
      child: SafeArea(
        child: Scaffold(
            appBar: AppBar(
              iconTheme: const IconThemeData(color: Constants.darkText),
              backgroundColor: Constants.background,
              elevation: 0,
              actions: [
                IconButton(
                    onPressed: () {
                      FocusScope.of(context).unfocus();
                    },
                    icon: const Icon(
                      Icons.done,
                      size: 25,
                    ))
              ],
              title: const Text(
                'New Doubt',
                style: TextStyle(
                    fontSize: 25,
                    color: Constants.darkText,
                    fontWeight: FontWeight.bold),
              ),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  FocusScope.of(context).unfocus();
                  Navigator.pop(context);
                },
              ),
            ),
            body: Container(
              color: Constants.background,
              height: double.maxFinite,
              width: double.maxFinite,
              padding: const EdgeInsets.symmetric(horizontal: 0, vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: [
                        Container(
                          margin: const EdgeInsets.only(left: 20, top: 40),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                userProvider.userName,
                                style: const TextStyle(
                                    fontSize: 20,
                                    color: Constants.darkText,
                                    fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Icon(
                                    Icons.edit,
                                    size: 16,
                                    color: Constants.darkText.withOpacity(0.5),
                                  ),
                                  Container(
                                    height: 20,
                                    child: Align(
                                      alignment: Alignment.bottomLeft,
                                      child: Text(
                                        'on ${DateFormat.yMMMMd(
                                          'en_US',
                                        ).format(DateTime.now())} at ${DateFormat.jm().format(DateTime.now())}',
                                        style: TextStyle(
                                            fontSize: 12,
                                            color: Constants.darkText
                                                .withOpacity(0.5),
                                            fontWeight: FontWeight.w300),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  )
                                ],
                              )
                            ],
                          ),
                        ),
                        Container(
                          width: double.maxFinite,
                          height: 300,
                          margin: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.white,
                              boxShadow: [
                                BoxShadow(
                                    color: Colors.grey.withOpacity(0.3),
                                    blurRadius: 20,
                                    offset: const Offset(5, 5))
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.all(15),
                            child: TextField(
                              controller: textEditingController,
                              autocorrect: true,
                              decoration: const InputDecoration(
                                border: InputBorder.none,
                                hintText: 'Ask Something.....',
                              ),
                              enableSuggestions: true,
                              expands: true,
                              maxLines: null,
                            ),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              ElevatedButton(
                                onPressed:
                                    (textEditingController.text.length == 0)
                                        ? null
                                        : () async {
                                            FocusScope.of(context).unfocus();
                                            await uploadDoubt(
                                                textEditingController.text);
                                            textEditingController.clear();
                                            Navigator.pop(context);
                                          },
                                style: ElevatedButton.styleFrom(
                                    elevation: 5,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    primary: Constants.secondaryThemeColor,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15)),
                                child: const Text(
                                  'Submit',
                                  style: TextStyle(
                                      color: Constants.background,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold),
                                ),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
            )),
      ),
    );
  }
}
