import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/WelcomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

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
      return WelcomePage();
    } else if (newUser == 2) {
      // return const WelcomePage();
      return const HomePage();
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
          'coin': 1,
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
          'premium': false,
          'uid': uid,
          'name': user?.displayName,
          "photos": [
            {
              'name': 'first',
              'url':
                  'https://firebasestorage.googleapis.com/v0/b/chamas-gemeas.appspot.com/o/images%2Fdefault%2Fperson_blank.png?alt=media&token=a48cac17-1f89-4aed-a0b2-ba38699d516f',
              'id': '1'
            },
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
