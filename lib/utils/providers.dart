import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userDataProvider = Provider<UserInfoProvider>((ref) {
  return UserInfoProvider();
});

class UserInfoProvider {
  late FirebaseAuth auth;
  late FirebaseFirestore firestore;
  late String userName;
  late String uid;
  late int seniorStatus;
  late int ratingStar;
  late int ratingValue;
  late int monthlyGoal;
  int monthlySolved = 1;
  bool vis = false; // Password form field visibility icon

  Future<bool> initializeFirebase() async {
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    uid = auth.currentUser!.uid;
    return true;
  }

  Future<bool> getUserData() async {
    print('comming here');
    final userData = await firestore
        .collection('Colleges/PICT/Users')
        .doc(uid.toString())
        .get()
        .then((documentSnapshot) {
      if (!documentSnapshot.exists) {
        print('no doc found');
      }
      return documentSnapshot.data();
    });
    if (userData == null || userData.isEmpty) return false;
    userName = userData['username'];
    seniorStatus = userData['seniorStatus'];
    ratingStar = userData['ratingStar'];
    ratingValue = userData['ratingValue'];
    monthlyGoal = userData['monthlyGoal'];
    monthlySolved = userData['monthlySolved'];

    return true;
  }

  void resetVisIcon() {
    vis = false;
  }

  void toggleVisIcon() {
    vis = !vis;
  }
}
