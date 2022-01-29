import 'package:chat_app/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userDataProvider = Provider<UserInfoProvider>((ref) {
  return UserInfoProvider();
});

class UserInfoProvider {
  bool isLoaded = false;
  late FirebaseAuth auth;
  late FirebaseFirestore firestore;
  late String userName;
  late String uid;
  int seniorStatus = 1;
  late String loginId;

  bool vis = false;
  late String doubtsRaised; // Password form field visibility icon

  Future<void> initializeFirebase() async {
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    uid = auth.currentUser!.uid;
  }

  Future<void> getUserData() async {
    await initializeFirebase();

    doubtsRaised =
        await firestore.collection(Constants.doubtPath).get().then((value) {
      return value.docs.length.toString();
    });

    final userData = await firestore
        .collection(Constants.userPath)
        .doc(uid)
        .get()
        .then((documentSnapshot) {
      if (!documentSnapshot.exists) {
        
        throw Exception();
      }
      return documentSnapshot.data();
    });
    if (userData == null || userData.isEmpty) {
      throw Exception();
    }
    userName = userData['username'];
    loginId = userData['loginId'];

    isLoaded = true;
  }

  void resetVisIcon() {
    vis = false;
  }

  void toggleVisIcon() {
    vis = !vis;
  }
}
