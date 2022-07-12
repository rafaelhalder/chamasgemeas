import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/registerStep4.dart';
import 'package:chamasgemeas/screens/registerStep5.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/registerStep7.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({Key? key}) : super(key: key);

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  int newUser = 0;

  @override
  void initState() {
    verify();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (newUser == 1) {
      // return const WelcomePage();
      return RegisterStep5();
    } else if (newUser == 2) {
      return  RegisterStep5();
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  verify() async {
    final snapShot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!snapShot.exists) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
          'aboutMe': '',
          'age': 0,
          'city': '',
          'country': '',
          'gender': '',
          'height': 0,
          'interested': '',
          'latitude': '',
          'longitude': '',
          'zodiac': '',
          'whatsapp': '',
          'finished': false,
          'weight': '',
          'occupation': '',
          'typeInterested': '',
          'status': true,
          'uid': uid,
          'name': user?.displayName,
          "photos": [
            {'name': 'nulo', 'url': 'nulo', 'id': '1'},
            {'name': 'nulo', 'url': 'nulo', 'id': '2'},
            {'name': 'nulo', 'url': 'nulo', 'id': '3'},
            {'name': 'nulo', 'url': 'nulo', 'id': '4'},
            {'name': 'nulo', 'url': 'nulo', 'id': '5'},
            {'name': 'nulo', 'url': 'nulo', 'id': '6'},
            {'name': 'nulo', 'url': 'nulo', 'id': '7'},
            {'name': 'nulo', 'url': 'nulo', 'id': '8'},
            {'name': 'nulo', 'url': 'nulo', 'id': '9'},
          ]
        });

        await FirebaseFirestore.instance.collection('filter').doc(uid).set({
          'distance': 80,
          "age": [0, 80]
        });
      } on FirebaseException catch (e) {
        print(e.message);
        rethrow;
      }

      setState(() {
        newUser = 1;
      });
    } else {
      DocumentSnapshot variable =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();

      bool finishedRegister = variable['finished'];
      if (finishedRegister == true) {
        setState(() {
          newUser = 2;
        });
      } else {
        setState(() {
          newUser = 1;
        });
      }
    }
  }
}
