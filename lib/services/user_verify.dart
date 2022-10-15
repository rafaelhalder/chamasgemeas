import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/WelcomePage.dart';
import 'package:chamasgemeas/screens/termsAccept.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class VerifyUser extends StatefulWidget {
  const VerifyUser({Key? key}) : super(key: key);

  @override
  State<VerifyUser> createState() => _VerifyUserState();
}

class _VerifyUserState extends State<VerifyUser> {
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  int newUser = 0;
  late Image background;
  late Image iconMenu1;
  late Image iconMenu2;
  late Image iconMenu3;
  late Image iconMenu4;
  late Image iconMenu5;
  late Image iconMenu6;
  late Image iconMenu7;

  @override
  void initState() {
    verify();
    super.initState();
    background = Image.asset('assets/images/Magia.png');
    iconMenu1 = Image.asset('assets/images/Magia Natural.png');
    iconMenu2 = Image.asset('assets/images/mago.png');
    iconMenu3 = Image.asset('assets/images/Mediunidade.png');
    iconMenu4 = Image.asset('assets/images/Quânticos.png');
    iconMenu5 = Image.asset('assets/images/Yoga e Meditação.png');
    iconMenu6 = Image.asset('assets/images/Buscador.png');
    iconMenu7 = Image.asset('assets/images/Cura Holística.png');
  }

  @override
  void didChangeDependencies() {
    precacheImage(background.image, context);
    precacheImage(iconMenu1.image, context);
    precacheImage(iconMenu2.image, context);
    precacheImage(iconMenu3.image, context);
    precacheImage(iconMenu4.image, context);
    precacheImage(iconMenu5.image, context);
    precacheImage(iconMenu6.image, context);
    precacheImage(iconMenu7.image, context);
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if (newUser == 1) {
      return TermsAccept();
    } else if (newUser == 2) {
      // return const WelcomePage();
      return HomePage();
    } else {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
  }

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .update({'token': token});
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      saveToken(token!);
    });
  }

  verify() async {
    final snapShot =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    print('adsadasdasdsaaasd');
    if (!snapShot.exists) {
      print('30438340433489y430438');

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
          'token': '',
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

      getToken();

      bool finishedRegister = variable['finished'];
      if (finishedRegister == true) {
        if (mounted) {
          setState(() {
            newUser = 2;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            newUser = 1;
          });
        }
      }
    }
  }
}
