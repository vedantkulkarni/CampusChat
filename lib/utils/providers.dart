import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod/riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

final userDataProvider = Provider<UserInfoProvider>((ref) {
  return UserInfoProvider();
});

class UserInfoProvider  {
  bool isLoaded = false;
  late FirebaseAuth auth;
  late FirebaseFirestore firestore;
  late String userName;
  late String uid;
  int seniorStatus = 1;

  late int ratingStar;
  late int ratingValue;
  int monthlyGoal = 10;
  int monthlySolved = 1;
  bool vis = false; // Password form field visibility icon

  Future<void> initializeFirebase() async {
    auth = FirebaseAuth.instance;
    firestore = FirebaseFirestore.instance;
    uid = auth.currentUser!.uid;
  }

  Future<void> getUserData() async {
    await initializeFirebase();
    
    print('firebase initialized');
    print('uid is $uid');
    final userData = await firestore
        .collection('Colleges/PICT/Users')
        .doc(uid)
        .get()
        .then((documentSnapshot) {
      if (!documentSnapshot.exists) {
        print('no doc found');
      }
      return documentSnapshot.data();
    });
    if (userData == null || userData.isEmpty) {
      throw Exception();
    }
    userName = userData['username'];

    ratingStar = userData['ratingStar'];
    ratingValue = userData['ratingValue'];
    monthlyGoal = userData['monthlyGoal'];
    monthlySolved = userData['monthlySolved'];
   
    isLoaded = true;
  }

  void resetVisIcon() {
    vis = false;
  }

  void toggleVisIcon() {
    vis = !vis;
  }
}
