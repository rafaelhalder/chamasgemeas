import 'dart:convert';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:http/http.dart' as http;

class MatchUsers extends StatefulWidget {
  const MatchUsers({Key? key}) : super(key: key);

  @override
  State<MatchUsers> createState() => _MatchUsersState();
}

class _MatchUsersState extends State<MatchUsers> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    String userList = arguments['userLiked'];
    var photoUserActual = arguments['photo'];
    var photoUserAt = arguments['photoUser'];
    var photoUserName = arguments['name'];
    bool _visible = true;
    String photoUser = '';
    updateMatch(userList, photoUserName, photoUserAt);

    return SafeArea(
      child: Container(
        decoration: BoxDecoration(
            color: Color.fromARGB(0, 241, 95, 95),
            image: DecorationImage(
              image: AssetImage("assets/images/DEUMATCH.png"),
              fit: BoxFit.cover,
            )),
        height: size.height * 0.83,
        child: Stack(
          children: [
            Positioned.fill(
                child: Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                opacity: _visible == true ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 2000),
                child: CircleAvatar(
                  radius: 120,
                  child: Center(
                    child: new ClipRRect(
                      borderRadius: BorderRadius.circular(120),
                      child: new Row(
                        children: <Widget>[
                          Image.network(
                            photoUserActual,
                            width: 120.0,
                            height: 240.0,
                            fit: BoxFit.cover,
                          ),
                          ClipRRect(
                            child: Image.network(
                              photoUserAt,
                              width: 120.0,
                              height: 240.0,
                              fit: BoxFit.cover,
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            )),
            Positioned.fill(
                child: Align(
              alignment: Alignment.center,
              child: AnimatedOpacity(
                onEnd: () => print('Fade FlutterLogo'),
                opacity: _visible == true ? 0.1 : 0.0,
                duration: const Duration(milliseconds: 5000),
                child: Spin(
                  infinite: true,
                  child: Image.asset(
                    'assets/images/ying.png',
                    height: 280,
                  ),
                ),
              ),
            )),
            Positioned.fill(
                child: Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 80),
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    style: const TextStyle(
                      fontSize: 22.0,
                      color: Color.fromARGB(255, 238, 238, 238),
                    ),
                    children: <TextSpan>[
                      TextSpan(
                          text: 'VOCÊS SE\n',
                          style: GoogleFonts.quicksand(
                              fontSize: 25,
                              color: Color.fromARGB(255, 207, 202, 187),
                              fontWeight: FontWeight.w700)),
                      TextSpan(
                          text: 'COMPLETAM',
                          style: GoogleFonts.quicksand(
                              fontSize: 40,
                              color: Color.fromARGB(255, 207, 202, 187),
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                ),
              ),
            )),
            Padding(
              padding: const EdgeInsets.only(bottom: 50),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 50),
                    child: Container(
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 115, 114, 114)),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.message,
                            color: Colors.white,
                          ),
                          SizedBox(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/chats');
                            },
                            child: Center(
                                child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Color.fromARGB(255, 238, 238, 238),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'ENVIAR MENSAGEM',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 207, 202, 187),
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            )),
                          ),
                          SizedBox(),
                          SizedBox(),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 30),
                    child: Container(
                      height: size.height * 0.06,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Color.fromARGB(255, 115, 114, 114)),
                          borderRadius: BorderRadius.circular(20)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Icon(
                            Icons.person,
                            color: Colors.white,
                          ),
                          SizedBox(),
                          GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/home');
                            },
                            child: Center(
                                child: RichText(
                              textAlign: TextAlign.center,
                              text: TextSpan(
                                style: const TextStyle(
                                  fontSize: 22.0,
                                  color: Color.fromARGB(255, 238, 238, 238),
                                ),
                                children: <TextSpan>[
                                  TextSpan(
                                      text: 'CONTINUAR NAVEGANDO',
                                      style: GoogleFonts.quicksand(
                                          fontSize: 18,
                                          color: Color.fromARGB(
                                              255, 207, 202, 187),
                                          fontWeight: FontWeight.w700)),
                                ],
                              ),
                            )),
                          ),
                          SizedBox(),
                          SizedBox(),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void updateMatch(userLiked, name, photo) async {
    CollectionReference chats = FirebaseFirestore.instance.collection('chats');

    String urlPhotoLiked = '';
    String urlPhotoUser = '';
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    List usersLikedMe = [];
    List listMatch = [];
    List listMatch2 = [];
    String userList = userLiked;
    String userListName = '';
    String userListPhoto = photo;
    String tokenUser = '';

    final foundLikeMe =
        await FirebaseFirestore.instance.collection('liked_me').doc(uid).get();
    if (foundLikeMe.exists) {
      DocumentSnapshot variable = await FirebaseFirestore.instance
          .collection('users')
          .doc(userList)
          .get();
      urlPhotoLiked = variable['photos'][0]['url'];
      DocumentSnapshot variableUser =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      urlPhotoUser = variableUser['photos'][0]['url'];
      userListName = variableUser['name'];
      usersLikedMe = foundLikeMe['id'];
    }
    final matchss =
        await FirebaseFirestore.instance.collection('matchs').doc(uid).get();
    if (matchss.exists) {
      listMatch = matchss['id'];
    }

    final tokenUserLiked = await FirebaseFirestore.instance
        .collection('users')
        .doc(userList)
        .get();
    if (tokenUserLiked.exists) {
      tokenUser = tokenUserLiked['token'];
    }

    final matchss2 = await FirebaseFirestore.instance
        .collection('matchs')
        .doc(userList)
        .get();
    if (matchss2.exists) {
      listMatch2 = matchss2['id'];
    }

    usersLikedMe.contains(userList)
        ? sendPushMessage('Você recebeu um like', 'Like', tokenUser)
        : print('');

    usersLikedMe.contains(userList)
        ? await chats
            .where('users.$uid', isEqualTo: 1)
            .where('users.$userList', whereIn: [1, 2])
            .limit(1)
            .get()
            .then(
              (QuerySnapshot querySnapshot) async {
                if (querySnapshot.docs.isEmpty) {
                  await chats.add({
                    'users': {userList: 1, uid: 1},
                    'names': {userList: name, uid: userListName}
                  });
                  listMatch.add(userList);
                  await FirebaseFirestore.instance
                      .collection('matchs')
                      .doc(uid)
                      .set({'id': listMatch});

                  listMatch2.add(uid);
                  await FirebaseFirestore.instance
                      .collection('matchs')
                      .doc(userList)
                      .set({'id': listMatch});
                }
              },
            )
            .catchError((error) {})
        : print('');
  }

  void sendPushMessage(
      String message, String? currentUserName, String? token) async {
    try {
      await http.post(
        Uri.parse('https://fcm.googleapis.com/fcm/send'),
        headers: <String, String>{
          'Content-Type': 'application/json',
          'Authorization':
              'key=AAAAhIRIRac:APA91bGld0gKYT_K5i7BTRCOdxBz14Qj4Cs85LmDd2bCSZOlEHaV2GvbxVGk307kQqGY5y3AXqjVbye-7CkIH0jTYnnAmfjNfxTpvGYTfvQ3CDvdlvdKRjrB-T7Lgn17YdanVXO4eQdZ',
        },
        body: jsonEncode(
          <String, dynamic>{
            'notification': <String, dynamic>{
              'body': '$message',
              'title': '$currentUserName',
              'android-channel_id': 'dbfood'
            },
            'priority': 'high',
            'data': <String, dynamic>{
              'click_action': 'FLUTTER_NOTIFICATION_CLICK',
              'id': '1',
              'status': 'done'
            },
            "to": "$token",
          },
        ),
      );
      print('sendeed');
    } catch (e) {
      print("error push notification");
    }
  }
}
