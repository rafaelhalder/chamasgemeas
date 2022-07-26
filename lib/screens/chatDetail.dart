import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_1.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;

class ChatDetail extends StatefulWidget {
  final friendUid;
  final friendName;

  const ChatDetail({Key? key, this.friendUid, this.friendName})
      : super(key: key);

  @override
  _ChatDetailState createState() => _ChatDetailState(friendUid, friendName);
}

class _ChatDetailState extends State<ChatDetail> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference userFriend =
      FirebaseFirestore.instance.collection('users');

  late AndroidNotificationChannel channel;
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;
  final friendUid;
  final friendName;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  String? currentUserName = FirebaseAuth.instance.currentUser?.displayName;
  var chatDocId;
  var photo;
  var status;
  final _textController = TextEditingController();
  String? tokenAuth = "";

  _ChatDetailState(this.friendUid, this.friendName);
  @override
  void initState() {
    super.initState();
    checkUser();
    // getToken();
    photoUser(friendUid);
    loadFCM();
    listenFCM();
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

  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     setState(() {
  //       tokenAuth =
  //           'cgCmtHNWT4KPcubS-t_lcz:APA91bHgSCX_9ZfgYJ5AOBa3wXXtbiaXI7giA4zRy3LNyyViA5JzNrgP3sl_c3nOfH9vrpOg58hJYGcahls-rxlrb8v7QR2JYggM1_3KdVGGpMHMrp-qobtirtL7TVAUzpo42ZXD2Ieu';
  //       print(token);
  //     });
  //   });
  // }

  void listenFCM() async {
    // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    //   RemoteNotification? notification = message.notification;
    //   AndroidNotification? android = message.notification?.android;
    //   if (notification != null && android != null && !kIsWeb) {
    //     flutterLocalNotificationsPlugin.show(
    //       notification.hashCode,
    //       notification.title,
    //       notification.body,
    //       NotificationDetails(
    //         android: AndroidNotificationDetails(
    //           channel.id,
    //           channel.name,
    //         ),
    //       ),
    //     );
    //   }
    // });
  }

  void checkUser() async {
    await chats
        .where('users.$currentUserId', isEqualTo: 1)
        .where('users.$friendUid', whereIn: [1, 2])
        .limit(1)
        .get()
        .then(
          (QuerySnapshot querySnapshot) async {
            if (querySnapshot.docs.isNotEmpty) {
              setState(() {
                chatDocId = querySnapshot.docs.single.id;
              });
            }
          },
        )
        .catchError((error) {});
  }

  void sendMessage(String msg) {
    // print(FieldValue.serverTimestamp());
    if (msg == '') return;

    chats.doc(chatDocId).update({
      'users': {friendUid: 1, currentUserId: 1},
    });

    chats.doc(chatDocId).collection('messages').add({
      'createdOn': DateTime.now(),
      'uid': currentUserId,
      'friendName': friendName,
      'msg': msg
    }).then((value) {
      _textController.text = '';
    });
  }

  bool isSender(String friend) {
    return friend == currentUserId;
  }

  Alignment getAlignment(friend) {
    if (friend == currentUserId) {
      return Alignment.topRight;
    }
    return Alignment.topLeft;
  }

  void photoUser(friendUid) async {
    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc(friendUid)
        .get();

    List listPhotos = variable['photos'];
    String photoFriend = listPhotos[0]['url'];
    bool statusperson = variable['status'];
    String tokens = variable['token'];
    setState(() {
      photo = photoFriend;
      status = statusperson;
      tokenAuth = tokens;
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: Importance.defaultImportance,
          ledColor: Colors.amber,
          enableVibration: true);

      flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin.cancelAll();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin>()
          ?.createNotificationChannel(channel);

      /// Update the iOS foreground notification presentation options to allow
      /// heads up notifications.
      await FirebaseMessaging.instance
          .setForegroundNotificationPresentationOptions(
        alert: false,
        badge: true,
        sound: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 27, 27, 27),
      child: StreamBuilder<QuerySnapshot>(
        stream: chats
            .doc(chatDocId)
            .collection('messages')
            .orderBy('createdOn', descending: true)
            .snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text("Something went wrong"),
            );
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: DefaultTextStyle(
                  style: TextStyle(color: Colors.grey),
                  child: Text("Carregando")),
            );
          }

          if (snapshot.hasData) {
            return Scaffold(
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(100.0),
                child: SizedBox(
                  height: 110,
                  child: CupertinoNavigationBar(
                    backgroundColor: const Color.fromARGB(255, 27, 27, 27),
                    middle: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xffFDCF09),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                fadeInDuration: const Duration(milliseconds: 0),
                                fadeOutDuration:
                                    const Duration(milliseconds: 0),
                                fit: BoxFit.cover,
                                imageUrl: photo,
                                width: 80,
                                height: 80,
                              ),
                            )),
                        const SizedBox(
                          width: 5,
                        ),
                        Text(
                          friendName,
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                    previousPageTitle: "",
                  ),
                ),
              ),
              body: Container(
                color: const Color.fromARGB(255, 27, 27, 27),
                child: SafeArea(
                  child: Column(
                    children: [
                      Expanded(
                        child: ListView(
                          reverse: true,
                          children: snapshot.data!.docs.map(
                            (DocumentSnapshot document) {
                              Map<String, dynamic> data =
                                  document.data() as Map<String, dynamic>;
                              print(data['uid'].toString());
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 15.0),
                                child: ChatBubble(
                                  elevation: 1,
                                  clipper: ChatBubbleClipper1(
                                    radius: 0,
                                    nipHeight: 0,
                                    nipRadius: 0,
                                    nipWidth: 0,
                                    type: isSender(data['uid'].toString())
                                        ? BubbleType.sendBubble
                                        : BubbleType.receiverBubble,
                                  ),
                                  alignment:
                                      getAlignment(data['uid'].toString()),
                                  margin: const EdgeInsets.only(top: 20),
                                  backGroundColor:
                                      isSender(data['uid'].toString())
                                          ? const Color.fromRGBO(0, 93, 75, 1)
                                          : const Color.fromRGBO(31, 44, 52, 1),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth:
                                          MediaQuery.of(context).size.width *
                                              0.7,
                                    ),
                                    child: Column(
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            DefaultTextStyle(
                                              style: GoogleFonts.raleway(
                                                color: isSender(
                                                        data['uid'].toString())
                                                    ? Colors.white
                                                    : Colors.white,
                                                fontSize: 15,
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: Text(data['msg'],
                                                    maxLines: 100,
                                                    overflow:
                                                        TextOverflow.ellipsis),
                                              ),
                                            )
                                          ],
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            DefaultTextStyle(
                                              style: GoogleFonts.raleway(
                                                color: isSender(
                                                        data['uid'].toString())
                                                    ? const Color.fromARGB(
                                                        255, 200, 200, 200)
                                                    : const Color.fromARGB(
                                                        255, 200, 200, 200),
                                                fontSize: 10,
                                              ),
                                              child: Text(
                                                data['createdOn'] == null
                                                    ? DateFormat('hh:mm a')
                                                        .format(DateTime.now())
                                                    : DateFormat('hh:mm a')
                                                        .format(
                                                            data['createdOn']
                                                                .toDate()),
                                              ),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          ).toList(),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 18.0),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.width * 0.1,
                                child: CupertinoTextField(
                                  readOnly: status == true ? false : true,
                                  style: GoogleFonts.raleway(
                                    color: Colors.white,
                                    fontSize: 15,
                                  ),
                                  decoration: const BoxDecoration(
                                      color: Color.fromARGB(255, 26, 48, 61)),
                                  controller: _textController,
                                ),
                              ),
                            ),
                          ),
                          status == true
                              ? CupertinoButton(
                                  child: const Icon(Icons.send_sharp),
                                  onPressed: () {
                                    sendMessage(_textController.text);
                                    sendPushMessage(_textController.text,
                                        currentUserName, tokenAuth);
                                  })
                              : CupertinoButton(
                                  child: const Icon(Icons.send_sharp,
                                      color: Colors.grey),
                                  onPressed: () => {})
                        ],
                      )
                    ],
                  ),
                ),
              ),
            );
          } else {
            return Text('');
          }
        },
      ),
    );
  }
}
