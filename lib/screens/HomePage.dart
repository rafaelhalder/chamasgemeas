import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    teste();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Text('ola'),
    );
  }

  teste() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    List fileName = variable['photos'];
    String name = variable['name'];
    print(fileName);
  }
}
