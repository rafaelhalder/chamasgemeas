import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chamasgemeas/api/purchase_api.dart';
import 'package:chamasgemeas/screens/chatDetail.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutterfire_ui/firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:latlong2/latlong.dart' as lat;

import '../paywall_widget.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference match = FirebaseFirestore.instance.collection('match');
  String filter = '';
  String gende = '';
  String userLat = '';
  String userLng = '';
  String interest = '';
  List likedList = [];
  List superLikedList = [];
  List matchList = [];
  List listFilterAge = [0, 100];
  double listFilterDistance = 30;
  final double _value = 40.0;
  String superLikeText = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    filterList();
    loadList();
    getToken();
  }

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      FirebaseFirestore.instance.collection('users').doc(uid).update({
        'token': token,
      });
    });
  }

  Future<bool> _onWillPop(BuildContext context) async {
    bool? exitResult = await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
    return exitResult ?? false;
  }

  Future<bool?> _showExitDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (context) => _buildExitDialog(context),
    );
  }

  AlertDialog _buildExitDialog(BuildContext context) {
    return AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Color.fromARGB(255, 204, 171, 123))),
      elevation: 2,
      title: const Text('Chamas Gemeas', style: TextStyle(color: Colors.white)),
      content: const Text('Deseja fechar o aplicativo?',
          style: TextStyle(color: Colors.white)),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: Text('Não', style: TextStyle(color: Colors.white)),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(true),
          child: Text('Sim', style: TextStyle(color: Colors.white)),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    double boxInfo = size.height / 6.15;
    return WillPopScope(
      onWillPop: () => _onWillPop(context),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: const SystemUiOverlayStyle(
          systemNavigationBarIconBrightness: Brightness.light,
          statusBarIconBrightness: Brightness.light,
          statusBarBrightness: Brightness.light,
          statusBarColor: Colors.black,
          systemNavigationBarColor: Colors.black,
        ),
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/interfacesigno.png"),
            fit: BoxFit.cover,
          )),
          // decoration: BoxDecoration(gradient: backgroundnew()),
          child: Scaffold(
            extendBodyBehindAppBar: true,
            backgroundColor: Colors.transparent,
            bottomNavigationBar: ConvexAppBar.badge(
              const {5: Colors.redAccent},
              gradient: const LinearGradient(colors: [
                Color.fromARGB(255, 0, 0, 0),
                Color.fromARGB(255, 2, 1, 3),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              // ignore: prefer_const_literals_to_create_immutables
              items: [
                // ignore: prefer_const_constructors
                TabItem(
                    activeIcon: Icon(Icons.home, color: Colors.black),
                    icon: Icon(Icons.home,
                        color: Color.fromARGB(255, 204, 171, 123)),
                    title: 'Home'),
                const TabItem(
                    activeIcon: Icon(Icons.star, color: Colors.black),
                    icon: Icon(Icons.star,
                        color: Color.fromARGB(255, 204, 171, 123)),
                    title: 'Super'),
                const TabItem(
                    activeIcon: Icon(Icons.person, color: Colors.black),
                    icon: Icon(Icons.person,
                        color: Color.fromARGB(255, 204, 171, 123)),
                    title: 'Perfil'),
                const TabItem(
                    activeIcon: Icon(Icons.message, color: Colors.black),
                    icon: Icon(Icons.message,
                        color: Color.fromARGB(255, 204, 171, 123)),
                    title: 'Chats'),
                const TabItem(
                    activeIcon: Icon(Icons.settings, color: Colors.black),
                    icon: Icon(Icons.settings,
                        color: Color.fromARGB(255, 204, 171, 123)),
                    title: 'Opções'),
              ],
              initialActiveIndex: 0, //optional, default as 0
              onTap: (int i) {
                i == 0
                    ? Navigator.pushReplacement(
                        context,
                        PageRouteBuilder(
                          pageBuilder: (context, animation1, animation2) =>
                              const HomePage(),
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

                print('click index=$i');
              },
            ),
            body: NestedScrollView(
              floatHeaderSlivers: true,
              headerSliverBuilder: (context, _) => [
                SliverAppBar(
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
                  leadingWidth: size.width,
                  snap: true,
                  floating: true,
                  actions: [
                    Builder(
                      builder: (context) => IconButton(
                        icon: const Icon(Icons.list_outlined),
                        onPressed: () =>
                            Navigator.pushNamed(context, '/filter'),
                      ),
                    )
                  ],
                )
              ],
              body: FirestoreListView<Map<String, dynamic>>(
                  padding: EdgeInsets.zero,
                  query: listUsers(),
                  itemBuilder: (context, snapshot) {
                    Map<String, dynamic> user = snapshot.data();
                    List userList = user['photos'];
                    List newList = [];
                    for (int i = 0; i < userList.length; i++) {
                      if (userList[i]['name'] != 'nulo') {
                        newList.add(userList[i]['url']);
                      }
                    }
                    String userUid = user['uid'];
                    String userName = user['name'];
                    String userOccupation = user['occupation'];
                    int userAge = user['age'];
                    double userInt = double.parse(user['interested']);
                    double lats = double.parse(user['latitude']);
                    double lng = double.parse(user['longitude']);

                    /// double lngU = double.parse(userLng);
                    ///
                    String usergender = user['gender'];
                    double distancia = listFilterDistance;
                    var distance = const lat.Distance();

                    if (userLng != '') {
                      double lngU = double.parse(userLng);
                      double latU = double.parse(userLat);
                      final km = distance.as(lat.LengthUnit.Kilometer,
                          lat.LatLng(lats, lng), lat.LatLng(latU, lngU));
                      if (distancia > km) {
                        return Container();
                      }
                    }

                    int ageStartFilter = 0;
                    if (listFilterAge[0] != '') {
                      if (listFilterAge[0] != 0) {
                        ageStartFilter =
                            double.parse(listFilterAge[0].toString()).round();
                      }
                    }
                    int ageEndFilter =
                        double.parse(listFilterAge[1].toString()).round();
                    if (interest != '') {
                      if (interest != usergender) {
                        // return Container();
                      }
                    }
                    if (gende != '') {
                      if (userInt != gende) {
                        // return Container();
                      }
                    }
                    // if (userUid != uid) {
                    //   return Container();
                    // } else {
                    if (userUid == uid ||
                        userAge > ageEndFilter ||
                        userAge < ageStartFilter) {
                      return Container();
                    } else {
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 25),
                        child: Column(
                          children: [
                            Container(
                              height: size.height / 1.3,
                              width: size.width / 1,
                              decoration: BoxDecoration(
                                  color: const Color.fromARGB(255, 27, 27, 27),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          90, 133, 133, 133)),
                                  borderRadius: BorderRadius.circular(10)),
                              child: Column(
                                children: [
                                  GestureDetector(
                                    onTap: () async {
                                      String? uid = FirebaseAuth
                                          .instance.currentUser?.uid;

                                      DocumentSnapshot variable =
                                          await FirebaseFirestore.instance
                                              .collection('users')
                                              .doc(uid)
                                              .get();

                                      String lat = variable['latitude'];
                                      String lng = variable['longitude'];

                                      Navigator.pushNamed(context, '/userPage',
                                          arguments: {
                                            "uid": userUid,
                                            'name': userName,
                                            'info': user,
                                            'lat': lat,
                                            'lng': lng,
                                          });
                                    },
                                    child: ClipPath(
                                      clipper: CustomClipPath(),
                                      child: Container(
                                        height: size.height / 1.7,
                                        width: size.width,
                                        decoration: const BoxDecoration(
                                            borderRadius: BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                            color: Color.fromARGB(
                                                255, 27, 27, 27)),
                                        child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topRight: Radius.circular(10),
                                              topLeft: Radius.circular(10),
                                            ),
                                            child: CarouselSlider.builder(
                                              carouselController: _controller,
                                              options: CarouselOptions(
                                                  height: size.height / 1.6,
                                                  autoPlay: false,
                                                  autoPlayInterval:
                                                      const Duration(
                                                          seconds: 30),
                                                  reverse: false,
                                                  viewportFraction: 1,
                                                  aspectRatio: 2.0,
                                                  initialPage: 0,
                                                  enableInfiniteScroll: true,
                                                  autoPlayAnimationDuration:
                                                      const Duration(
                                                          milliseconds: 30000),
                                                  autoPlayCurve:
                                                      Curves.fastOutSlowIn,
                                                  scrollDirection:
                                                      Axis.horizontal,
                                                  onPageChanged:
                                                      (index, reason) {
                                                    setState(() {
                                                      _current = index;
                                                    });
                                                  }),
                                              itemCount: newList.length,
                                              itemBuilder: (context, itemIndex,
                                                  realIndex) {
                                                return CachedNetworkImage(
                                                  fadeInDuration:
                                                      const Duration(
                                                          milliseconds: 0),
                                                  fadeOutDuration:
                                                      const Duration(
                                                          milliseconds: 0),
                                                  width: size.width,
                                                  height: size.height,
                                                  fit: BoxFit.cover,
                                                  imageUrl: newList[itemIndex]
                                                      .toString(),
                                                );
                                              },
                                            )),
                                      ),
                                    ),
                                  ),
                                  //                     Row(
                                  //   mainAxisAlignment: MainAxisAlignment.center,
                                  //   children: userList.asMap().entries.map((entry) {
                                  //     return GestureDetector(
                                  //       onTap: () => _controller.animateToPage(entry.key),
                                  //       child: Container(
                                  //         width: 12.0,
                                  //         height: 12.0,
                                  //         margin: EdgeInsets.only(bottom: 8,right: 4,left: 4),
                                  //         decoration: BoxDecoration(
                                  //             shape: BoxShape.circle,
                                  //             color: (Theme.of(context).brightness == Brightness.dark
                                  //                     ? Color.fromARGB(255, 27, 27, 27)
                                  //                     : Colors.black)
                                  //                 .withOpacity(_current == entry.key ? 0.9 : 0.4)),
                                  //       ),
                                  //     );
                                  //   }).toList(),
                                  // ),
                                  Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            width: 0,
                                            color: const Color.fromARGB(
                                                255, 27, 27, 27)),
                                        color: const Color.fromARGB(
                                            255, 27, 27, 27),
                                        borderRadius: const BorderRadius.only(
                                          bottomRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                        )),
                                    height: boxInfo,
                                    width: size.width,
                                    child: Column(
                                      children: [
                                        Container(
                                          alignment: Alignment.centerLeft,
                                          height: boxInfo / 2,
                                          color: const Color.fromARGB(
                                              255, 27, 27, 27),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  children: [
                                                    Text(
                                                      '$userName,',
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              204,
                                                              171,
                                                              123),
                                                          fontSize: 20,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    const SizedBox(
                                                      width: 12,
                                                    ),
                                                    Text(
                                                      '$userAge',
                                                      style: const TextStyle(
                                                          color: Color.fromARGB(
                                                              255,
                                                              204,
                                                              171,
                                                              123),
                                                          fontSize: 22,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(
                                                  height: 3,
                                                ),
                                                Text(
                                                  userOccupation,
                                                  style: const TextStyle(
                                                      color: Color.fromARGB(
                                                          255, 204, 171, 123),
                                                      fontSize: 16),
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: boxInfo / 2,
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                width: 0,
                                                color: const Color.fromARGB(
                                                    255, 27, 27, 27)),
                                            color: const Color.fromARGB(
                                                255, 27, 27, 27),
                                            borderRadius:
                                                const BorderRadius.only(
                                              bottomRight: Radius.circular(9),
                                              bottomLeft: Radius.circular(9),
                                            ),
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 20),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceAround,
                                                children: [
                                                  GestureDetector(
                                                    onTap: () async {
                                                      superLike(
                                                          userUid, userName);
                                                    },
                                                    child: Container(
                                                        height: boxInfo / 2.5,
                                                        width: size.width * 0.4,
                                                        decoration: BoxDecoration(
                                                            color: !superLikedList
                                                                    .contains(
                                                                        userUid)
                                                                ? const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    204,
                                                                    171,
                                                                    123)
                                                                : Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Center(
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .solidStar,
                                                                color: Colors
                                                                    .white,
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                'Super Like',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                  GestureDetector(
                                                    onTap: !likedList
                                                            .contains(userUid)
                                                        ? () async {
                                                            verifyMatch(userUid,
                                                                userName);
                                                            setState(() {
                                                              if (!likedList
                                                                  .contains(
                                                                      userUid)) {
                                                                likedList.add(
                                                                    userUid);
                                                              }
                                                            });
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'liked')
                                                                .doc(uid)
                                                                .set({
                                                              "id": likedList
                                                            });

                                                            List listLikedMe =
                                                                [];

                                                            final likedme =
                                                                await FirebaseFirestore
                                                                    .instance
                                                                    .collection(
                                                                        'liked_me')
                                                                    .doc(userUid
                                                                        .toString())
                                                                    .get();

                                                            if (likedme
                                                                .exists) {
                                                              List listLikedMe =
                                                                  likedme['id'];
                                                            }

                                                            setState(() {
                                                              if (!listLikedMe
                                                                  .contains(
                                                                      uid)) {
                                                                listLikedMe
                                                                    .add(uid);
                                                              }
                                                            });
                                                            await FirebaseFirestore
                                                                .instance
                                                                .collection(
                                                                    'liked_me')
                                                                .doc(userUid
                                                                    .toString())
                                                                .set({
                                                              "id": listLikedMe
                                                            });
                                                          }
                                                        : () {
                                                            print('ja curtiu');
                                                          },
                                                    child: Container(
                                                        height: boxInfo / 2.5,
                                                        width: size.width * 0.4,
                                                        decoration: BoxDecoration(
                                                            color: !likedList
                                                                    .contains(
                                                                        userUid)
                                                                ? const Color
                                                                        .fromARGB(
                                                                    255,
                                                                    204,
                                                                    171,
                                                                    123)
                                                                : Colors.grey,
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        20)),
                                                        child: Center(
                                                          child: Row(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .center,
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: const [
                                                              FaIcon(
                                                                FontAwesomeIcons
                                                                    .solidHeart,
                                                                color:
                                                                    Colors.red,
                                                              ),
                                                              SizedBox(
                                                                width: 6,
                                                              ),
                                                              Text(
                                                                'Like',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black87,
                                                                    fontSize:
                                                                        15,
                                                                    fontWeight:
                                                                        FontWeight
                                                                            .bold),
                                                              ),
                                                            ],
                                                          ),
                                                        )),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  }),
            ),
          ),
        ),
      ),
    );
  }

  verifyMatch(String likedUid, String userName) async {
    Size size = MediaQuery.of(context).size;
    String urlPhotoLiked = '';
    String urlPhotoUser = '';
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    List usersLikedMe = [];
    List listMatch = [];
    List listMatch2 = [];
    final foundLikeMe =
        await FirebaseFirestore.instance.collection('liked_me').doc(uid).get();
    if (foundLikeMe.exists) {
      DocumentSnapshot variable = await FirebaseFirestore.instance
          .collection('users')
          .doc(likedUid)
          .get();
      urlPhotoLiked = variable['photos'][0]['url'];
      DocumentSnapshot variableUser =
          await FirebaseFirestore.instance.collection('users').doc(uid).get();
      urlPhotoUser = variableUser['photos'][0]['url'];
      usersLikedMe = foundLikeMe['id'];
    }
    final matchss =
        await FirebaseFirestore.instance.collection('matchs').doc(uid).get();
    if (matchss.exists) {
      listMatch = matchss['id'];
    }
    final matchss2 = await FirebaseFirestore.instance
        .collection('matchs')
        .doc(likedUid)
        .get();
    if (matchss2.exists) {
      listMatch2 = matchss2['id'];
    }

    usersLikedMe.contains(likedUid)
        ? await chats
            .where('users.$uid', isEqualTo: 1)
            .where('users.$likedUid', whereIn: [1, 2])
            .limit(1)
            .get()
            .then(
              (QuerySnapshot querySnapshot) async {
                if (querySnapshot.docs.isEmpty) {
                  await chats.add({
                    'users': {likedUid: 1, uid: 1},
                    'names': {
                      likedUid: userName,
                      uid: FirebaseAuth.instance.currentUser?.displayName
                    }
                  });
                  listMatch.add(likedUid);
                  await FirebaseFirestore.instance
                      .collection('matchs')
                      .doc(uid)
                      .set({'id': listMatch});

                  listMatch2.add(uid);
                  await FirebaseFirestore.instance
                      .collection('matchs')
                      .doc(likedUid)
                      .set({'id': listMatch});
                }
              },
            )
            .catchError((error) {})
        : print('');

    usersLikedMe.contains(likedUid)
        ? showGeneralDialog(
            context: context,
            barrierLabel: "Barrier",
            barrierDismissible: true,
            barrierColor: Colors.black.withOpacity(0.5),
            transitionDuration: const Duration(milliseconds: 100),
            pageBuilder: (_, __, ___) {
              return Expanded(
                child: Center(
                  child: Container(
                    height: size.height * 0.6,
                    margin: const EdgeInsets.symmetric(horizontal: 20),
                    decoration: BoxDecoration(
                        border: Border.all(
                            color: const Color.fromARGB(255, 204, 171, 123)),
                        color: Colors.black87,
                        borderRadius: BorderRadius.circular(40)),
                    child: SizedBox.expand(
                        child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 5),
                      child: Stack(children: [
                        Positioned.fill(
                          child: Align(
                              alignment: Alignment.topCenter,
                              child: Column(
                                children: [
                                  DefaultTextStyle(
                                    style: GoogleFonts.dancingScript(
                                      color: Colors.white,
                                      fontSize: 60,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    child: const Text('Match'),
                                  ),
                                  DefaultTextStyle(
                                    style: GoogleFonts.acme(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700,
                                    ),
                                    child: const Text('Envie uma mensagem'),
                                  ),
                                ],
                              )),
                        ),
                        Positioned.fill(
                          child: Align(
                              alignment: Alignment.center,
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.amber,
                                    child: CircleAvatar(
                                        radius: 80,
                                        backgroundColor:
                                            const Color(0xffFDCF09),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          child: CachedNetworkImage(
                                            fadeInDuration:
                                                const Duration(milliseconds: 0),
                                            fadeOutDuration:
                                                const Duration(milliseconds: 0),
                                            fit: BoxFit.cover,
                                            imageUrl: urlPhotoUser,
                                            width: 120,
                                            height: 120,
                                          ),
                                        )),
                                  ),
                                  CircleAvatar(
                                    radius: 55,
                                    backgroundColor: Colors.amber,
                                    child: CircleAvatar(
                                        radius: 80,
                                        backgroundColor:
                                            const Color(0xffFDCF09),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(55),
                                          child: CachedNetworkImage(
                                            fadeInDuration:
                                                const Duration(milliseconds: 0),
                                            fadeOutDuration:
                                                const Duration(milliseconds: 0),
                                            fit: BoxFit.cover,
                                            imageUrl: urlPhotoLiked,
                                            width: 120,
                                            height: 120,
                                          ),
                                        )),
                                  ),
                                ],
                              )),
                        ),
                        Positioned.fill(
                          child: Align(
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                SizedBox(
                                  width: size.width * 0.65,
                                  height: size.height * 0.055,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      primary: const Color.fromARGB(
                                          255, 204, 171, 123),
                                      side: const BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(152, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                      Navigator.push(
                                          context,
                                          CupertinoPageRoute(
                                              builder: (context) => ChatDetail(
                                                    friendUid: likedUid,
                                                    friendName: userName,
                                                  )));
                                    },
                                    icon: const Icon(
                                      Icons.message,
                                      size: 24.0,
                                    ),
                                    label: const Text('Chat'), // <-- Text
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                SizedBox(
                                  width: size.width * 0.65,
                                  height: size.height * 0.055,
                                  child: ElevatedButton.icon(
                                    style: ElevatedButton.styleFrom(
                                      shape: const StadiumBorder(),
                                      primary:
                                          const Color.fromARGB(255, 0, 0, 0),
                                      side: const BorderSide(
                                        width: 1,
                                        color:
                                            Color.fromARGB(152, 255, 255, 255),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    icon: const Icon(
                                      null,
                                      size: 24.0,
                                    ),
                                    label: const Text('Voltar'), // <-- Text
                                  ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ]),
                    )),
                  ),
                ),
              );
            },
            transitionBuilder: (_, anim, __, child) {
              Tween<Offset> tween;
              if (anim.status == AnimationStatus.reverse) {
                tween = Tween(begin: const Offset(-1, 0), end: Offset.zero);
              } else {
                tween = Tween(begin: const Offset(1, 0), end: Offset.zero);
              }

              return SlideTransition(
                position: tween.animate(anim),
                child: FadeTransition(
                  opacity: anim,
                  child: child,
                ),
              );
            },
          )
        : print('');
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

    switch (package.offeringIdentifier) {
      case Coins.idCoins1:
        coins += 1;
        break;
      default:
        break;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'coin': coins});
  }

  superLike(String likedUid, String userName) async {
    setState(() {});
    final verifyCoin =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    int coins = verifyCoin['coin'];
    print(coins);
    if (coins == 0) {
      fetchOffers();
      return null;
    }

    Size size = MediaQuery.of(context).size;
    String urlPhotoLiked = '';
    String urlPhotoUser = '';
    List usersLikedMe = [];
    List superLikedMe = [];
    final foundLikeMe =
        await FirebaseFirestore.instance.collection('liked_me').doc(uid).get();
    if (foundLikeMe.exists) {
      usersLikedMe = foundLikeMe['id'];
    }

    final foundSuperMe = await FirebaseFirestore.instance
        .collection('superlikedme')
        .doc(uid)
        .get();
    if (foundSuperMe.exists) {
      superLikedMe = foundSuperMe['id'];
    }

    DocumentSnapshot variable = await FirebaseFirestore.instance
        .collection('users')
        .doc(likedUid)
        .get();
    urlPhotoLiked = variable['photos'][0]['url'];

    showDialog(
        context: context,
        builder: (BuildContext context) {
          return Dialog(
            insetPadding: const EdgeInsets.all(20),

            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(40.0)), //this right here
            child: Container(
              height: size.height * 0.5,
              width: size.width * 1,
              decoration: BoxDecoration(
                  border: Border.all(
                      color: const Color.fromARGB(255, 204, 171, 123)),
                  color: Colors.black87,
                  borderRadius: BorderRadius.circular(40)),
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
                                fontWeight: FontWeight.w700,
                              ),
                              child: const Text('Super Like'),
                            ),
                            DefaultTextStyle(
                              style: GoogleFonts.acme(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                              ),
                              child: const Text('Envie uma mensagem'),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            CircleAvatar(
                              radius: 55,
                              backgroundColor: Colors.amber,
                              child: CircleAvatar(
                                  radius: 80,
                                  backgroundColor: const Color(0xffFDCF09),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(55),
                                    child: CachedNetworkImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 0),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 0),
                                      fit: BoxFit.cover,
                                      imageUrl: urlPhotoLiked,
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
                              border: Border.all(color: Colors.white24)),
                          child: TextField(
                              decoration: InputDecoration(
                                  contentPadding: EdgeInsets.all(10),
                                  hintText: 'Envia uma mensagem para sua chama',
                                  hintStyle: TextStyle(color: Colors.white)),
                              style: TextStyle(color: Colors.white),
                              maxLines: 6,
                              onChanged: (value) {
                                setState(() {
                                  superLikeText = value;
                                });
                              }),
                        )),
                  ),
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        margin: const EdgeInsets.only(bottom: 20),
                        width: size.width * 0.65,
                        height: size.height * 0.055,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            shape: const StadiumBorder(),
                            primary: const Color.fromARGB(255, 0, 0, 0),
                            side: const BorderSide(
                              width: 1,
                              color: Color.fromARGB(152, 255, 255, 255),
                            ),
                          ),
                          onPressed: () async {
                            if (superLikeText != '') {
                              setState(() {
                                if (!superLikedList.contains(likedUid)) {
                                  superLikedList.add(likedUid);
                                }
                                if (!likedList.contains(likedUid)) {
                                  likedList.add(likedUid);
                                }
                                if (!superLikedMe.contains(uid)) {
                                  superLikedMe.add(uid);
                                }
                              });
                              await FirebaseFirestore.instance
                                  .collection('superliked')
                                  .doc(uid)
                                  .set({"id": superLikedList});

                              await FirebaseFirestore.instance
                                  .collection('liked')
                                  .doc(uid)
                                  .set({"id": likedList});

                              await FirebaseFirestore.instance
                                  .collection('superlikedme')
                                  .doc(likedUid)
                                  .set({"id": superLikedMe});

                              await FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user?.uid)
                                  .update({'coin': coins - 1});

                              usersLikedMe.contains(likedUid)
                                  ? await chats
                                      .where('users.$uid', isEqualTo: 1)
                                      .where('users.$likedUid', whereIn: [1, 2])
                                      .limit(1)
                                      .get()
                                      .then(
                                        (QuerySnapshot querySnapshot) async {
                                          if (querySnapshot.docs.isEmpty) {
                                            await chats
                                                .where('users.$uid',
                                                    isEqualTo: 2)
                                                .where('users.$likedUid',
                                                    whereIn: [1, 2])
                                                .limit(1)
                                                .get()
                                                .then((QuerySnapshot
                                                    querySnapshot) async {
                                                  if (querySnapshot
                                                      .docs.isEmpty) {
                                                    await chats.add({
                                                      'users': {
                                                        uid: 1,
                                                        likedUid: 1
                                                      },
                                                      'names': {
                                                        uid: FirebaseAuth
                                                            .instance
                                                            .currentUser
                                                            ?.displayName,
                                                        likedUid: userName
                                                      }
                                                    });
                                                  }
                                                });

                                            await chats
                                                .where('users.$uid',
                                                    isEqualTo: 1)
                                                .where('users.$likedUid',
                                                    isEqualTo: 1)
                                                .limit(1)
                                                .get()
                                                .then(
                                              (QuerySnapshot
                                                  querySnapshot) async {
                                                if (querySnapshot
                                                    .docs.isNotEmpty) {
                                                  chats
                                                      .doc(querySnapshot
                                                          .docs.single.id)
                                                      .collection('messages')
                                                      .add({
                                                    'createdOn': DateTime.now(),
                                                    'uid': uid,
                                                    'friendName': userName,
                                                    'msg': superLikeText
                                                  });
                                                  print(querySnapshot
                                                      .docs.single.id);
                                                }
                                              },
                                            ).catchError((error) {});
                                          }
                                        },
                                      )
                                      .catchError((error) {})
                                  : await chats
                                      .where('users.$likedUid', isEqualTo: 1)
                                      .where('users.$uid', whereIn: [1, 2])
                                      .limit(1)
                                      .get()
                                      .then(
                                        (QuerySnapshot querySnapshot) async {
                                          if (querySnapshot.docs.isEmpty) {
                                            await chats.add({
                                              'users': {uid: 2, likedUid: 1},
                                              'names': {
                                                uid: FirebaseAuth.instance
                                                    .currentUser?.displayName,
                                                likedUid: userName
                                              }
                                            });

                                            await chats
                                                .where('users.$uid',
                                                    isEqualTo: 2)
                                                .where('users.$likedUid',
                                                    isEqualTo: 1)
                                                .limit(1)
                                                .get()
                                                .then(
                                              (QuerySnapshot
                                                  querySnapshot) async {
                                                if (querySnapshot
                                                    .docs.isNotEmpty) {
                                                  chats
                                                      .doc(querySnapshot
                                                          .docs.single.id)
                                                      .collection('messages')
                                                      .add({
                                                    'createdOn': DateTime.now(),
                                                    'uid': uid,
                                                    'friendName': userName,
                                                    'msg': superLikeText
                                                  });
                                                  print(querySnapshot
                                                      .docs.single.id);
                                                }
                                              },
                                            ).catchError((error) {});
                                          }
                                        },
                                      )
                                      .catchError((error) {});
                            }
                            Navigator.of(context).pop();
                          },
                          icon: const Icon(
                            null,
                            size: 24.0,
                          ),
                          label: const Text('Enviar'), // <-- Text
                        ),
                      ),
                    ),
                  )
                ]),
              ),
            ),
          );
        });
  }

  Query<Map<String, dynamic>> listUsers() {
    final listUsers = FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: true);

    return listUsers;
  }

  void loadList() async {
    List listLike = [];
    List listSuperLike = [];
    List matchs = [];
    String gender = '';
    String interested = '';
    String lat = '';
    String lng = '';

    final like =
        await FirebaseFirestore.instance.collection('liked').doc(uid).get();

    if (like.exists) {
      listLike = like['id'];
    }

    final gendes =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (gendes.exists) {
      gender = gendes['gender'];
      interested = gendes['interested'];
      lat = gendes['latitude'];
      lng = gendes['longitude'];
    }

    final match =
        await FirebaseFirestore.instance.collection('matchs').doc(uid).get();

    if (match.exists) {
      matchs = match['id'];
    }

    final superlike = await FirebaseFirestore.instance
        .collection('superliked')
        .doc(uid)
        .get();

    if (superlike.exists) {
      listSuperLike = superlike['id'];
    }

    setState(() {
      gende = gender;
      interest = interested;
      likedList = listLike;
      superLikedList = listSuperLike;
      matchList = matchs;
      userLat = lat;
      userLng = lng;
    });
  }

  void filterList() async {
    final filter =
        await FirebaseFirestore.instance.collection('filter').doc(uid).get();

    if (filter.exists) {
      listFilterAge = filter['age'];
      String distance = filter['distance'].toString();
      distance = distance.replaceAll("[", ""); // myString is "s t r"
      distance = distance.replaceAll("]", ""); // myString is "s t r"

      double distance_value = double.parse((distance).toString());
      listFilterDistance = distance_value;
    }
  }
}

class CustomClipPath extends CustomClipper<Path> {
  bool reverse;

  CustomClipPath({this.reverse = false});

  final int _coefficient = 16;
  double get _minStep => 1 / _coefficient;
  double get _preCenter => _minStep * (_coefficient / 2 - 1);
  double get _postCenter => _minStep * (_coefficient / 2 + 1);
  double get _preEnd => _minStep * (_coefficient - 2);

  @override
  Path getClip(Size size) {
    var path = Path();
    if (!reverse) {
      path.lineTo(0.0, size.height - 20);

      var firstControlPoint = Offset(size.width / 4, size.height);
      var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint =
          Offset(size.width - (size.width / 3.25), size.height - 65);
      var secondEndPoint = Offset(size.width, size.height - 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height - 40);
      path.lineTo(size.width, 0.0);
      path.close();
    } else {
      path.lineTo(0.0, 20);

      var firstControlPoint = Offset(size.width / 4, 0.0);
      var firstEndPoint = Offset(size.width / 2.25, 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
      var secondEndPoint = Offset(size.width, 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
