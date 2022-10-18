import 'package:chamasgemeas/api/purchase_api.dart';
import 'package:chamasgemeas/paywall_widget.dart';
import 'package:chamasgemeas/provider/card_provider.dart';
import 'package:chamasgemeas/screens/WelcomePage.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/tinder_card.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../paywall_widget.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart'
    as not;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  String textoChat = '';
  String? tokenAuth = "";
  late not.AndroidNotificationChannel channel;
  late not.FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      not.FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    requestPermission();
    // getToken();
    initInfo();
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
      print(
          "onMessage: ${message.notification?.title}/${message.notification?.body}");
      not.BigTextStyleInformation bigTextStyleInformation =
          not.BigTextStyleInformation(
        message.notification!.body.toString(),
        htmlFormatBigText: true,
        contentTitle: message.notification?.title.toString(),
        htmlFormatContentTitle: true,
      );
      not.AndroidNotificationDetails androidPlatformChannelSpeficics =
          not.AndroidNotificationDetails(
        'dbfood',
        'dbfood',
        importance: not.Importance.high,
        styleInformation: bigTextStyleInformation,
        priority: not.Priority.high,
        playSound: true,
      );

      not.NotificationDetails platformChannelSpeficics =
          not.NotificationDetails(
              android: androidPlatformChannelSpeficics,
              iOS: const not.IOSNotificationDetails());
      await flutterLocalNotificationsPlugin.show(0, message.notification?.title,
          message.notification?.body, platformChannelSpeficics,
          payload: message.data['body']);
    });
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

  // void saveToken(String token) async {
  //   await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(uid)
  //       .update({'token': token});
  // }

  // void getToken() async {
  //   await FirebaseMessaging.instance.getToken().then((token) {
  //     setState(() {
  //       tokenAuth = token;
  //       print('my token is $token');
  //     });
  //     saveToken(token!);
  //   });
  // }

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/interfacesigno.png"),
          fit: BoxFit.cover,
        )),
        child: WillPopScope(
          onWillPop: () async => false,
          child: Scaffold(
            appBar: AppBar(
              automaticallyImplyLeading: false,
              backgroundColor: Color.fromARGB(128, 0, 0, 0),
              leading: Image.asset(
                'assets/images/logo.png',
                height: 45,
              ),
              title: IconButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/likeMe');
                },
                icon: const FaIcon(FontAwesomeIcons.solidHeart,
                    color: Colors.red),
              ),
              centerTitle: true,
              leadingWidth: MediaQuery.of(context).size.width,
              actions: [
                Builder(
                  builder: (context) => IconButton(
                    icon: const Icon(Icons.list_outlined),
                    onPressed: () => Navigator.pushNamed(context, '/filter'),
                  ),
                )
              ],
            ),
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
                    icon: FaIcon(FontAwesomeIcons.yinYang, color: Colors.black),
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
                // const TabItem(
                //     activeIcon: Icon(Icons.settings, color: Colors.black),
                //     icon: Icon(Icons.settings, color: Colors.black),
                //     title: '222222'),
              ],

              initialActiveIndex: 0, //optional, default as 0
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
                              SuperLike(),
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
                              // Container(),
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
                              // Container(),
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
                i == 5
                    ? Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              WelcomePage(),
                          transitionDuration: Duration.zero,
                          reverseTransitionDuration: Duration.zero,
                        ),
                      )
                    : const Text('');

                print('click index=$i');
              },
            ),
            backgroundColor: Colors.transparent,
            body: SafeArea(
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.all(16),
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                        height: MediaQuery.of(context).size.height * 0.70,
                        child: buildCards()),
                    buildButtons(),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildCards() {
    print(uid);

    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;

    return users.isEmpty
        ? Center(
            child: Text(
              '',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        : Stack(
            children: users
                .map((user) => TinderCard(
                      user: user,
                      isFront: users.last == user,
                    ))
                .toList(),
          );
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffersByIds(Coins.allIds);

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No Plans Found')));
    } else {
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      showMaterialModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Color.fromARGB(231, 0, 0, 0),
        builder: (context) => PaywallWidget(
            packages: packages,
            title: 'Chamas Premium',
            description: 'Veja quem te curtiu.',
            onClickedPackage: (package) async {
              final isSuccess = await PurchaseApi.purchasePackage(package);

              if (isSuccess) {
                await addCoinsPackag2e(package);
                await Fluttertoast.showToast(
                    msg: "Compra realizada com sucesso.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                await Fluttertoast.showToast(
                    msg: "falha na compra.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

              Navigator.pop(context);
            }),
      );

      final offer = offerings.first;
      print('Offer: $offer');
    }
  }

  Future<void> addCoinsPackag2e(Package package) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    final foundLikeMe =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    int coins = foundLikeMe['coin'];
    switch (package.product.identifier) {
      case Coins.idCoins2:
        coins += 1;
        break;
      case Coins.idCoins3:
        coins += 10;
        break;
      case Coins.idCoins4:
        coins += 100;
        break;
      case Coins.idCoins5:
        coins += 1;
        break;
      case Coins.idCoins6:
        coins += 10;
        break;
      case Coins.idCoins8:
        coins += 100;
        break;
      default:
        break;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'coin': coins});
  }

  Future<int> consUser() async {
    final verifyCoin =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    int coins = verifyCoin['coin'];
    return coins;
  }

  Widget buildButtons() {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;
    String photoUserActual = '';
    if (users.isNotEmpty) {
      photoUserActual = users.last.photos[0]['url'];
    }
    if (users.isEmpty) {
      final provider = Provider.of<CardProvider>(context, listen: false);

      print(uid);
      provider.resetUsers();
    }

    return users.isEmpty
        ? Text('')
        : Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 22),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.75,
                padding: EdgeInsets.symmetric(vertical: 5),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 218, 193, 136),
                    borderRadius: BorderRadius.circular(40)),
                child: Container(
                  height: 70,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              getColor(Colors.white, Colors.white, isDislike),
                          backgroundColor:
                              getColor(Colors.grey, Colors.red, isDislike),
                          side:
                              getBorder(Colors.white, Colors.white, isDislike),
                        ),
                        child: Icon(Icons.clear, size: 46),
                        onPressed: () {
                          final provider =
                              Provider.of<CardProvider>(context, listen: false);
                          provider.dislike();
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              getColor(Colors.white, Colors.white, isSuperLike),
                          backgroundColor:
                              getColor(Colors.amber, Colors.amber, isSuperLike),
                          side: getBorder(
                              Colors.white, Colors.white, isSuperLike),
                        ),
                        child: Icon(Icons.star, size: 40),
                        onPressed: () async {
                          int coin = await consUser();
                          print(coin);
                          if (coin == 0) {
                            fetchOffers();
                            return null;
                          }
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return Dialog(
                                  insetPadding: const EdgeInsets.all(20),

                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          40.0)), //this right here
                                  child: Container(
                                    height: size.height * 0.8,
                                    width: size.width * 1,
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 207, 202, 187)),
                                        color: Colors.black87,
                                        borderRadius:
                                            BorderRadius.circular(40)),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Stack(children: [
                                        Positioned.fill(
                                          child: Align(
                                              alignment: Alignment.topCenter,
                                              child: Column(
                                                children: [
                                                  DefaultTextStyle(
                                                    style: GoogleFonts.acme(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    child: const Text(
                                                        'Super Like'),
                                                  ),
                                                  DefaultTextStyle(
                                                    style: GoogleFonts.acme(
                                                      color: Colors.white,
                                                      fontSize: 20,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                    ),
                                                    child: const Text(
                                                        'Envie uma mensagem'),
                                                  ),
                                                  const SizedBox(
                                                    height: 10,
                                                  ),
                                                  CircleAvatar(
                                                    radius: 55,
                                                    backgroundColor:
                                                        Colors.transparent,
                                                    child: CircleAvatar(
                                                        radius: 80,
                                                        backgroundColor:
                                                            Colors.transparent,
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(55),
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            fadeOutDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            fit: BoxFit.cover,
                                                            imageUrl:
                                                                photoUserActual,
                                                            width: 120,
                                                            height: 120,
                                                          ),
                                                        )),
                                                  )
                                                ],
                                              )),
                                        ),
                                        Positioned.fill(
                                          top: 80,
                                          child: Align(
                                              alignment: Alignment.center,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                    color: Colors.black,
                                                    border: Border.all(
                                                        color: Colors.white24)),
                                                child: TextField(
                                                    decoration: InputDecoration(
                                                        contentPadding:
                                                            EdgeInsets.all(10),
                                                        hintText:
                                                            'Envia uma mensagem para sua chama',
                                                        hintStyle: TextStyle(
                                                            color:
                                                                Colors.white)),
                                                    style: TextStyle(
                                                        color: Colors.white),
                                                    maxLines: 6,
                                                    onChanged: (value) {
                                                      setState(() {
                                                        textoChat = value;
                                                      });
                                                    }),
                                              )),
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.bottomCenter,
                                            child: Container(
                                              alignment: Alignment.center,
                                              width: size.width * 0.65,
                                              height: size.height * 0.055,
                                              child: ElevatedButton.icon(
                                                style: ElevatedButton.styleFrom(
                                                  shape: const StadiumBorder(),
                                                  primary: const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                  side: const BorderSide(
                                                    width: 1,
                                                    color: Color.fromARGB(
                                                        152, 255, 255, 255),
                                                  ),
                                                ),
                                                onPressed: () async {
                                                  final provider =
                                                      Provider.of<CardProvider>(
                                                          context,
                                                          listen: false);
                                                  CollectionReference chats =
                                                      FirebaseFirestore.instance
                                                          .collection('chats');
                                                  if (textoChat != '') {
                                                    List usersLikedMe = [];
                                                    String usuarioUid =
                                                        users.last.uid;
                                                    String usuarioName =
                                                        users.last.name;
                                                    String tokenUsuaria =
                                                        users.last.token;
                                                    int coins = 0;
                                                    provider.superLike();

                                                    final foundLikeMe =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection(
                                                                'liked_me')
                                                            .doc(uid)
                                                            .get();
                                                    if (foundLikeMe.exists) {
                                                      usersLikedMe =
                                                          foundLikeMe['id'];
                                                    }

                                                    final distances =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(uid)
                                                            .get();

                                                    if (distances.exists) {
                                                      coins = distances['coin'];
                                                    }

                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(user?.uid)
                                                        .update({
                                                      'coin': coins - 1
                                                    });
                                                    usersLikedMe.contains(
                                                            usuarioUid)
                                                        ? await chats
                                                            .where('users.$uid',
                                                                isEqualTo: 1)
                                                            .where(
                                                                'users.$usuarioUid',
                                                                whereIn: [
                                                                  1,
                                                                  2
                                                                ])
                                                            .limit(1)
                                                            .get()
                                                            .then(
                                                              (QuerySnapshot
                                                                  querySnapshot) async {
                                                                if (querySnapshot
                                                                    .docs
                                                                    .isEmpty) {
                                                                  await chats
                                                                      .where(
                                                                          'users.$uid',
                                                                          isEqualTo:
                                                                              2)
                                                                      .where(
                                                                          'users.$usuarioUid',
                                                                          whereIn: [
                                                                            1,
                                                                            2
                                                                          ])
                                                                      .limit(1)
                                                                      .get()
                                                                      .then((QuerySnapshot
                                                                          querySnapshot) async {
                                                                        if (querySnapshot
                                                                            .docs
                                                                            .isEmpty) {
                                                                          await chats
                                                                              .add({
                                                                            'users':
                                                                                {
                                                                              uid: 1,
                                                                              usuarioUid: 1
                                                                            },
                                                                            'names':
                                                                                {
                                                                              uid: FirebaseAuth.instance.currentUser?.displayName,
                                                                              usuarioUid: usuarioName
                                                                            }
                                                                          });
                                                                        }
                                                                      });

                                                                  await chats
                                                                      .where(
                                                                          'users.$uid',
                                                                          isEqualTo:
                                                                              1)
                                                                      .where(
                                                                          'users.$usuarioUid',
                                                                          isEqualTo:
                                                                              1)
                                                                      .limit(1)
                                                                      .get()
                                                                      .then(
                                                                    (QuerySnapshot
                                                                        querySnapshot) async {
                                                                      if (querySnapshot
                                                                          .docs
                                                                          .isNotEmpty) {
                                                                        chats
                                                                            .doc(querySnapshot.docs.single.id)
                                                                            .collection('messages')
                                                                            .add({
                                                                          'createdOn':
                                                                              DateTime.now(),
                                                                          'uid':
                                                                              uid,
                                                                          'friendName':
                                                                              usuarioName,
                                                                          'msg':
                                                                              textoChat
                                                                        });
                                                                        print(querySnapshot
                                                                            .docs
                                                                            .single
                                                                            .id);
                                                                      }
                                                                    },
                                                                  ).catchError(
                                                                          (error) {});
                                                                }
                                                              },
                                                            )
                                                            .catchError(
                                                                (error) {})
                                                        : await chats
                                                            .where(
                                                                'users.$usuarioUid',
                                                                isEqualTo: 1)
                                                            .where('users.$uid',
                                                                whereIn: [1, 2])
                                                            .limit(1)
                                                            .get()
                                                            .then(
                                                              (QuerySnapshot
                                                                  querySnapshot) async {
                                                                if (querySnapshot
                                                                    .docs
                                                                    .isEmpty) {
                                                                  await chats
                                                                      .add({
                                                                    'users': {
                                                                      uid: 2,
                                                                      usuarioUid:
                                                                          1
                                                                    },
                                                                    'names': {
                                                                      uid: FirebaseAuth
                                                                          .instance
                                                                          .currentUser
                                                                          ?.displayName,
                                                                      usuarioUid:
                                                                          usuarioName
                                                                    }
                                                                  });

                                                                  await chats
                                                                      .where(
                                                                          'users.$uid',
                                                                          isEqualTo:
                                                                              2)
                                                                      .where(
                                                                          'users.$usuarioUid',
                                                                          isEqualTo:
                                                                              1)
                                                                      .limit(1)
                                                                      .get()
                                                                      .then(
                                                                    (QuerySnapshot
                                                                        querySnapshot) async {
                                                                      if (querySnapshot
                                                                          .docs
                                                                          .isNotEmpty) {
                                                                        chats
                                                                            .doc(querySnapshot.docs.single.id)
                                                                            .collection('messages')
                                                                            .add({
                                                                          'createdOn':
                                                                              DateTime.now(),
                                                                          'uid':
                                                                              uid,
                                                                          'friendName':
                                                                              usuarioName,
                                                                          'msg':
                                                                              textoChat
                                                                        });
                                                                        print(querySnapshot
                                                                            .docs
                                                                            .single
                                                                            .id);
                                                                      }
                                                                    },
                                                                  ).catchError(
                                                                          (error) {});
                                                                }
                                                              },
                                                            )
                                                            .catchError(
                                                                (error) {});
                                                    sendPushMessage(
                                                        'Você recebeu um super like',
                                                        'Super Like',
                                                        tokenUsuaria);

                                                    Navigator.of(context).pop();
                                                  }
                                                },
                                                icon: const Icon(
                                                  null,
                                                  size: 1.0,
                                                ),
                                                label: const Text(
                                                    'Enviar'), // <-- Text
                                              ),
                                            ),
                                          ),
                                        )
                                      ]),
                                    ),
                                  ),
                                );
                              });

                          final provider =
                              Provider.of<CardProvider>(context, listen: false);

                          // provider.superLike();
                        },
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          foregroundColor:
                              getColor(Colors.white, Colors.white, isLike),
                          backgroundColor:
                              getColor(Colors.pink, Colors.pink, isLike),
                          side: getBorder(Colors.white, Colors.white, isLike),
                        ),
                        child: Icon(Icons.favorite, size: 40),
                        onPressed: () {
                          final provider =
                              Provider.of<CardProvider>(context, listen: false);

                          String photo = provider.photoUser;
                          String actualUser = users.last.uid.toString();
                          String actualUserName = users.last.name.toString();
                          String fileActual = users.last.photos[0]['url'];
                          provider.like();
                          verifyMatch(
                              actualUser, fileActual, actualUserName, photo);
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  verifyMatch(actualUser, photo, name, photoUser) async {
    List likedMe = [];

    final foundLikeMe =
        await FirebaseFirestore.instance.collection('liked_me').doc(uid).get();
    if (foundLikeMe.exists) {
      likedMe = foundLikeMe['id'];
    }

    if (likedMe.contains(actualUser)) {
      Navigator.pushNamed(context, '/matchScreen', arguments: {
        "userLiked": actualUser,
        'photo': photo,
        'name': name,
        'photoUser': photoUser
      });
    }
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    final getColor = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    final getBorder = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };

    return MaterialStateProperty.resolveWith(getBorder);
  }
}
