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
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as not;
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';

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
  final controllerName = TextEditingController(text: 'Johannes Milke');
  final controllerEmail =
      TextEditingController(text: 'noreply@chamasgemeas.com');
  final controllerSubject = TextEditingController(text: 'My Subject');
  final controllerMessage = TextEditingController(text: 'My Message');

  late not.AndroidNotificationChannel channel;
  late not.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      not.FlutterLocalNotificationsPlugin();
  final friendUid;
  final friendName;
  final currentUserId = FirebaseAuth.instance.currentUser?.uid;
  String? currentUserName = FirebaseAuth.instance.currentUser?.displayName;
  var chatDocId;
  var photo;
  var photoFriendme;
  var photome;
  var status;
  String defaultPhoto =
      'https://firebasestorage.googleapis.com/v0/b/chamas-gemeas.appspot.com/o/images%2Fdefault%2Fperson_blank.png?alt=media&token=a48cac17-1f89-4aed-a0b2-ba38699d516f';
  final _textController = TextEditingController();
  String? tokenAuth = "";
  _ChatDetailState(this.friendUid, this.friendName);
  @override
  void initState() {
    super.initState();
    checkUser();
    requestPermission();
    getToken();
    photoUser(friendUid);
    initInfo();
    // loadFCM();
    // listenFCM();
  }

  void requestPermission() async {
    FirebaseMessaging messaging = FirebaseMessaging.instance;

    NotificationSettings settings = await messaging.requestPermission(
        alert: true,
        announcement: false,
        badge: false,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true);
    if (settings.authorizationStatus == AuthorizationStatus.authorized) {
      print('user granted per');
    } else if (settings.authorizationStatus ==
        AuthorizationStatus.provisional) {
      print('provisional grant');
    } else {
      print('declined');
    }
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

  void saveToken(String token) async {
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUserId)
        .update({'token': token});
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      setState(() {
        tokenAuth = token;
        print('my token is $token');
      });
      saveToken(token!);
    });
  }

  initInfo() {
    var androidInitialize =
        const not.AndroidInitializationSettings('@mipmap/ic_launcher');
    var iOSInitialize = const not.IOSInitializationSettings();
    var initializationSettings = not.InitializationSettings(
        android: androidInitialize, iOS: iOSInitialize);
    flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: (String? payload) async {
      try {
        if (payload != null && payload.isNotEmpty) {
        } else {}
      } catch (e) {}
      return;
    });

    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('------------onMessage------------');
      // print(
      //     "onMessage: ${message.notification?.title}/${message.notification?.body}");
      // not.BigTextStyleInformation bigTextStyleInformation =
      //     not.BigTextStyleInformation(
      //   message.notification!.body.toString(),
      //   htmlFormatBigText: true,
      //   contentTitle: message.notification?.title.toString(),
      //   htmlFormatContentTitle: true,
      // );
      // not.AndroidNotificationDetails androidPlatformChannelSpeficics =
      //     not.AndroidNotificationDetails(
      //   'dbfood',
      //   'dbfood',
      //   importance: not.Importance.high,
      //   styleInformation: bigTextStyleInformation,
      //   priority: not.Priority.high,
      //   playSound: true,
      // );

      // not.NotificationDetails platformChannelSpeficics =
      //     not.NotificationDetails(
      //         android: androidPlatformChannelSpeficics,
      //         iOS: const not.IOSNotificationDetails());
      // await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
      //     message.notification?.body, platformChannelSpeficics,
      //     payload: message.data['body']);
    });
  }

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
                print(chatDocId);
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

  Future<bool> canSend() async {
    var tes2 = await FirebaseFirestore.instance
        .collection('chats')
        .doc(chatDocId)
        .get();

    Map<String, dynamic> data = tes2.data()!;

    if (data['users']['$friendUid'] == 1 || data['users']['$friendUid'] == 2) {
      return true;
    }

    return false;
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

    final currentUsers = FirebaseAuth.instance.currentUser?.uid;

    DocumentSnapshot variableme = await FirebaseFirestore.instance
        .collection('users')
        .doc(currentUsers)
        .get();

    List listPhotosme = variableme['photos'];
    String photoFriendme = listPhotosme[0]['url'];
    String photoFriend = defaultPhoto;
    print(photoFriendme);

    List listPhotos = variable['photos'];
    photoFriend = listPhotos[0]['url'];
    bool statusperson = variable['status'];
    String tokens = variable['token'];
    setState(() {
      photome = photoFriendme;
      photo = photoFriend;
      status = statusperson;
      tokenAuth = tokens;
    });
  }

  void loadFCM() async {
    if (!kIsWeb) {
      channel = const not.AndroidNotificationChannel(
          'high_importance_channel', // id
          'High Importance Notifications', // title
          importance: not.Importance.defaultImportance,
          ledColor: Colors.amber,
          enableVibration: true);

      flutterLocalNotificationsPlugin = not.FlutterLocalNotificationsPlugin();

      /// Create an Android Notification Channel.
      ///
      /// We use this channel in the `AndroidManifest.xml` file to override the
      /// default FCM channel to enable heads up notifications.
      await flutterLocalNotificationsPlugin.cancelAll();
      await flutterLocalNotificationsPlugin
          .resolvePlatformSpecificImplementation<
              not.AndroidFlutterLocalNotificationsPlugin>()
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
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/interfacesigno.png"),
        fit: BoxFit.cover,
      )),
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

          if (snapshot.hasData) {
            return Scaffold(
              bottomNavigationBar: ConvexAppBar(
                color: Colors.black,
                gradient: const LinearGradient(colors: [
                  Color.fromARGB(255, 211, 202, 189),
                  Color.fromARGB(255, 211, 202, 189),
                ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
                // ignore: prefer_const_literals_to_create_immutables
                items: [
                  // ignore: prefer_const_constructors
                  TabItem(
                      activeIcon: Container(
                          alignment: Alignment.center,
                          child: FaIcon(FontAwesomeIcons.yinYang,
                              color: Colors.black)),
                      icon:
                          FaIcon(FontAwesomeIcons.yinYang, color: Colors.black),
                      title: 'Home'),
                  const TabItem(
                      activeIcon: Icon(Icons.star, color: Colors.black),
                      icon: Icon(Icons.star, color: Colors.black),
                      title: 'Super'),
                  const TabItem(
                      activeIcon: Icon(Icons.person, color: Colors.black),
                      icon: Icon(Icons.person, color: Colors.black),
                      title: 'Perfil'),
                  const TabItem(
                      activeIcon: Icon(Icons.message, color: Colors.black),
                      icon: Icon(Icons.message, color: Colors.black),
                      title: 'Chats'),
                  const TabItem(
                      activeIcon: Icon(Icons.settings, color: Colors.black),
                      icon: Icon(Icons.settings, color: Colors.black),
                      title: 'Opções'),
                ],
                initialActiveIndex: 3, //optional, default as 0
                onTap: (int i) {
                  i == 0
                      ? Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                HomePage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        )
                      : const Text('');
                  i == 1
                      ? Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const SuperLike(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        )
                      : const Text('');
                  i == 2
                      ? Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const ProfilePage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        )
                      : const Text('');
                  i == 3
                      ? Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const Chats(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        )
                      : const Text('');
                  i == 4
                      ? Navigator.pushReplacement(
                          context,
                          PageRouteBuilder(
                            pageBuilder: (context, animation1, animation2) =>
                                const PreferencePage(),
                            transitionDuration: Duration.zero,
                            reverseTransitionDuration: Duration.zero,
                          ),
                        )
                      : const Text('');
                  print('click index=$i');
                },
              ),
              appBar: PreferredSize(
                preferredSize: const Size.fromHeight(100.0),
                child: SizedBox(
                  height: 110,
                  child: CupertinoNavigationBar(
                    trailing: GestureDetector(
                        child: Icon(
                          Icons.list_outlined,
                          color: Color.fromARGB(255, 211, 202, 189),
                        ),
                        onTap: () => showMaterialModalBottomSheet(
                              context: context,
                              builder: (context) => Container(
                                color: Color.fromARGB(108, 0, 0, 0),
                                height:
                                    MediaQuery.of(context).size.height * 0.3,
                                child: Container(
                                  padding: EdgeInsets.all(5),
                                  color: Colors.black87,
                                  child: Wrap(
                                    children: [
                                      TextButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size.fromHeight(50),
                                          textStyle: TextStyle(fontSize: 20),
                                        ),
                                        child: Text(
                                          'Bloquear usuário',
                                          style: TextStyle(
                                              color: Color.fromARGB(
                                                  255, 218, 193, 136)),
                                        ),
                                        onPressed: () => blockUser(),
                                      ),
                                      Divider(
                                        color:
                                            Color.fromARGB(118, 218, 193, 136),
                                      ),
                                      TextButton(
                                        style: ElevatedButton.styleFrom(
                                          minimumSize: Size.fromHeight(50),
                                          textStyle: TextStyle(fontSize: 20),
                                        ),
                                        child: Text(
                                          'Reportar',
                                          style: TextStyle(color: Colors.red),
                                        ),
                                        onPressed: () => sendEmail(
                                          name: this.friendName,
                                          email: 'contato@chamasgemeas.com',
                                          subject: '$friendUid',
                                          message: controllerMessage.text,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            )),
                    leading: CupertinoNavigationBarBackButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/chats');
                      },
                      color: Color.fromARGB(255, 208, 201, 134),
                    ),
                    backgroundColor: Color.fromARGB(238, 20, 11, 4),
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
                                imageUrl: photo != null ? photo : defaultPhoto,
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
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/interfacesigno.png"),
                  fit: BoxFit.cover,
                )),
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
                                    horizontal: 15.0, vertical: 10),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    isSender(data['uid'].toString())
                                        ? CircleAvatar(
                                            radius: 33,
                                            backgroundColor:
                                                const Color(0xffFDCF09),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                fadeInDuration: const Duration(
                                                    milliseconds: 0),
                                                fadeOutDuration: const Duration(
                                                    milliseconds: 0),
                                                fit: BoxFit.cover,
                                                imageUrl: photome != null
                                                    ? photome
                                                    : defaultPhoto,
                                                width: 80,
                                                height: 80,
                                              ),
                                            ))
                                        : Text(''),
                                    ChatBubble(
                                      elevation: 1,
                                      clipper: ChatBubbleClipper1(
                                        nipRadius: 0,
                                        radius: 5,
                                        nipHeight: 0,
                                        nipWidth: 0,
                                        type: isSender(data['uid'].toString())
                                            ? BubbleType.sendBubble
                                            : BubbleType.receiverBubble,
                                      ),
                                      alignment:
                                          getAlignment(data['uid'].toString()),
                                      backGroundColor: isSender(
                                              data['uid'].toString())
                                          ? Color.fromARGB(255, 240, 240, 240)
                                          : Color.fromARGB(255, 208, 201, 134),
                                      child: Container(
                                        constraints: BoxConstraints(
                                          maxWidth: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.60,
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                DefaultTextStyle(
                                                  style: GoogleFonts.raleway(
                                                    color: isSender(data['uid']
                                                            .toString())
                                                        ? Colors.white
                                                        : Colors.white,
                                                    fontSize: 15,
                                                  ),
                                                  child: Padding(
                                                    padding: const EdgeInsets
                                                            .symmetric(
                                                        horizontal: 4),
                                                    child: Text(
                                                      data['msg'],
                                                      maxLines: 100,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    ),
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
                                                    color: isSender(data['uid']
                                                            .toString())
                                                        ? const Color.fromARGB(
                                                            255, 200, 200, 200)
                                                        : const Color.fromARGB(
                                                            255, 200, 200, 200),
                                                    fontSize: 10,
                                                  ),
                                                  child: Text(
                                                    style: TextStyle(
                                                        color: Colors.black),
                                                    data['createdOn'] == null
                                                        ? DateFormat('hh:mm a')
                                                            .format(
                                                                DateTime.now())
                                                        : DateFormat('hh:mm a')
                                                            .format(data[
                                                                    'createdOn']
                                                                .toDate()),
                                                  ),
                                                )
                                              ],
                                            )
                                          ],
                                        ),
                                      ),
                                    ),
                                    isSender(data['uid'].toString())
                                        ? Text('')
                                        : CircleAvatar(
                                            radius: 30,
                                            backgroundColor:
                                                const Color(0xffFDCF09),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(50),
                                              child: CachedNetworkImage(
                                                fadeInDuration: const Duration(
                                                    milliseconds: 0),
                                                fadeOutDuration: const Duration(
                                                    milliseconds: 0),
                                                fit: BoxFit.cover,
                                                imageUrl: photo != null
                                                    ? photo
                                                    : defaultPhoto,
                                                width: 80,
                                                height: 80,
                                              ),
                                            )),
                                  ],
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
                              padding:
                                  const EdgeInsets.only(left: 18.0, top: 5),
                              child: SizedBox(
                                height: MediaQuery.of(context).size.width * 0.1,
                                child: CupertinoTextField(
                                  style: GoogleFonts.raleway(
                                    color: Colors.black,
                                    fontSize: 15,
                                  ),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color:
                                          Color.fromARGB(255, 211, 202, 189)),
                                  controller: _textController,
                                ),
                              ),
                            ),
                          ),
                          CupertinoButton(
                              child: const Icon(
                                Icons.send_sharp,
                                color: Color.fromARGB(255, 211, 202, 189),
                              ),
                              onPressed: () async {
                                if (_textController.text != "") {
                                  var tese = await canSend();
                                  if (tese == true) {
                                    sendMessage(_textController.text);
                                    sendPushMessage(_textController.text,
                                        currentUserName, tokenAuth);
                                  }
                                }
                              })
                        ],
                      ),
                      SizedBox(
                        height: 40,
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

  void blockUser() async {
    await chats.doc(chatDocId).update({
      'users': {friendUid: 1, currentUserId: 3},
    });

    Navigator.pushNamed(context, '/chats');
  }

  Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final serviceId = 'service_veh5s9i';
    final templateId = 'template_c5epiyk';
    final userId = 'xDYWDYgAVAzkk3hQ1';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': friendUid,
          'user_message': message,
        },
      }),
    );

    if (response.statusCode == 200) {
      chats.doc(chatDocId).update({
        'users': {friendUid: 1, currentUserId: 3},
      });

      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Denuncia enviada com sucesso!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
      Navigator.pushNamed(context, '/chats');
    } else {
      chats.doc(chatDocId).update({
        'users': {friendUid: 1, currentUserId: 3},
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Falha no envio da denuncia!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
      Navigator.pushNamed(context, '/chats');
    }
  }
}
