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
  bool newUser = false;

  @override
  void initState() {
    super.initState();
    verify();
  }

  @override
  Widget build(BuildContext context) {
    if (newUser == true) {}
    return Container();
  }

  verify() async {
    final snapShot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (!snapShot.exists) {
      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).set({
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
        newUser = true;
      });
    } else {
      setState(() {
        newUser = false;
      });
    }
  }
}
