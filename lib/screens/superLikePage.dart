import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SuperLike extends StatefulWidget {
  const SuperLike({Key? key}) : super(key: key);

  @override
  State<SuperLike> createState() => _SuperLikeState();
}

class _SuperLikeState extends State<SuperLike> {
  final int _numPages = 2;
  final PageController _pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  List likedList = [];
  List superLikedList = [];
  String lat = '';
  String lng = '';

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _numPages; i++) {
      list.add(i == _currentPage ? _indicator(true) : _indicator(false));
    }
    return list;
  }

  Widget _indicator(bool isActive) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      margin: const EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 26.0 : 18.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : const Color.fromARGB(255, 59, 59, 59),
        borderRadius: const BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/interfacesigno.png"),
        fit: BoxFit.cover,
      )),
      child: WillPopScope(
        onWillPop: () async => false,
        child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              elevation: 0,
              leading: const Text(''),
              title: Text("SUPER LIKE",
                  style: GoogleFonts.cinzelDecorative(
                      fontWeight: FontWeight.bold,
                      color: Color.fromARGB(255, 147, 132, 100))),
              centerTitle: true,
              backgroundColor: Color.fromARGB(0, 27, 27, 27),
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
              ],
              initialActiveIndex: 1, //optional, default as 0
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
            body: AnnotatedRegion<SystemUiOverlayStyle>(
              value: SystemUiOverlayStyle.light,
              child: Container(
                decoration: const BoxDecoration(
                  color: Color.fromARGB(0, 27, 27, 27),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.7,
                        child: PageView(
                          physics: const ClampingScrollPhysics(),
                          controller: _pageController,
                          onPageChanged: (int page) {
                            setState(() {
                              _currentPage = page;
                            });
                          },
                          children: <Widget>[
                            FutureBuilder<dynamic>(
                              future:
                                  getData(), // a previously-obtained Future<String> or null
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  List list = snapshot.data;
                                  print(list);
                                  if (list.isEmpty) {
                                    return Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Center(
                                          child: Text(
                                        'Sem Superlikes recebidos',
                                        style: GoogleFonts.quicksand(
                                            fontSize: 15,
                                            color: Color.fromARGB(
                                                255, 147, 132, 100),
                                            fontWeight: FontWeight.w600),
                                      )),
                                    );
                                  }
                                  return Container(
                                    child: Column(
                                      children: [
                                        Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Text('Recebidos',
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 147, 132, 100))),
                                        ),
                                        ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: list.length,
                                            itemBuilder: (context, index) {
                                              return Container(
                                                child: CupertinoListTile(
                                                    onTap: () async {
                                                      DocumentSnapshot
                                                          variable =
                                                          await FirebaseFirestore
                                                              .instance
                                                              .collection(
                                                                  'users')
                                                              .doc(uid)
                                                              .get();
                                                      lat =
                                                          variable['latitude'];
                                                      lng =
                                                          variable['longitude'];
                                                      Navigator.pushNamed(
                                                          context, '/userPage',
                                                          arguments: {
                                                            "uid": list[index]
                                                                ['uid'],
                                                            'name': list[index]
                                                                ['name'],
                                                            'info': list[index],
                                                            'lat': lat,
                                                            'lng': lng,
                                                          });
                                                    },
                                                    leading: CircleAvatar(
                                                        radius: 25,
                                                        backgroundColor:
                                                            const Color(
                                                                0xffFDCF09),
                                                        child: ClipRRect(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(50),
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
                                                            imageUrl: list[
                                                                        index]
                                                                    ['photos']
                                                                [0]['url'],
                                                            width: 100,
                                                            height: 100,
                                                          ),
                                                        )),
                                                    title: Text(
                                                        list[index]['name'],
                                                        style: GoogleFonts
                                                            .quicksand(
                                                                fontSize: 15,
                                                                color: Color
                                                                    .fromARGB(
                                                                        255,
                                                                        147,
                                                                        132,
                                                                        100))),
                                                    subtitle: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .spaceBetween,
                                                      children: [
                                                        Text('',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 14)),
                                                        Text('',
                                                            style: GoogleFonts
                                                                .quicksand(
                                                                    fontSize:
                                                                        15,
                                                                    color: Color
                                                                        .fromARGB(
                                                                            255,
                                                                            147,
                                                                            132,
                                                                            100))),
                                                      ],
                                                    )),
                                              );
                                            }),
                                      ],
                                    ),
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text('error',
                                      style: TextStyle(color: Colors.white));
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                            FutureBuilder<dynamic>(
                              future:
                                  superLikedReturn(), // a previously-obtained Future<String> or null
                              builder: (BuildContext context,
                                  AsyncSnapshot snapshot) {
                                if (snapshot.hasData) {
                                  List list = snapshot.data;
                                  print(list);
                                  if (list.isEmpty) {
                                    return Container(
                                      padding: const EdgeInsets.all(20),
                                      child: Center(
                                          child: Text('Sem Superlikes enviados',
                                              style: GoogleFonts.quicksand(
                                                  fontSize: 15,
                                                  color: Color.fromARGB(
                                                      255, 147, 132, 100)))),
                                    );
                                  }
                                  return Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: EdgeInsets.all(8.0),
                                        child: Text('Enviados',
                                            style: GoogleFonts.quicksand(
                                                fontSize: 15,
                                                color: Color.fromARGB(
                                                    255, 147, 132, 100))),
                                      ),
                                      ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: list.length,
                                          itemBuilder: (context, index) {
                                            return Container(
                                              child: CupertinoListTile(
                                                  onTap: () async {
                                                    DocumentSnapshot variable =
                                                        await FirebaseFirestore
                                                            .instance
                                                            .collection('users')
                                                            .doc(uid)
                                                            .get();
                                                    lat = variable['latitude'];
                                                    lng = variable['longitude'];
                                                    Navigator.pushNamed(
                                                        context, '/userPage',
                                                        arguments: {
                                                          "uid": list[index]
                                                              ['uid'],
                                                          'name': list[index]
                                                              ['name'],
                                                          'info': list[index],
                                                          'lat': lat,
                                                          'lng': lng,
                                                        });
                                                  },
                                                  leading: CircleAvatar(
                                                      radius: 25,
                                                      backgroundColor:
                                                          const Color(
                                                              0xffFDCF09),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(50),
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
                                                          imageUrl: list[index]
                                                                  ['photos'][0]
                                                              ['url'],
                                                          width: 100,
                                                          height: 100,
                                                        ),
                                                      )),
                                                  title: Text(
                                                      list[index]['name'],
                                                      style: const TextStyle(
                                                          color: Colors.white)),
                                                  subtitle: Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: const [
                                                      Text('',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.white,
                                                              fontSize: 14)),
                                                      Text('',
                                                          style: TextStyle(
                                                              color: Color
                                                                  .fromARGB(
                                                                      255,
                                                                      206,
                                                                      206,
                                                                      206),
                                                              fontSize: 12)),
                                                    ],
                                                  )),
                                            );
                                          }),
                                    ],
                                  );
                                } else if (snapshot.hasError) {
                                  return const Text('error',
                                      style: TextStyle(color: Colors.white));
                                } else {
                                  return const Center(
                                      child: CircularProgressIndicator());
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: _buildPageIndicator(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            bottomSheet: _currentPage == _numPages - 1
                ? const Text('')
                : const Text('')),
      ),
    );
  }

  Future<List> getData() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('superlikedme')
        .doc(uid)
        .get();

    List dataUser = [];
    List returnList = [];
    if (querySnapshot.exists) {
      dataUser = querySnapshot['id'];
    }

    for (int i = 0; i < dataUser.length; i++) {
      final like = await FirebaseFirestore.instance
          .collection('users')
          .doc(dataUser[i])
          .get();
      returnList.add(like);
    }

    return returnList;
  }

  Future<List> superLikedReturn() async {
    var querySnapshot = await FirebaseFirestore.instance
        .collection('superliked')
        .doc(uid)
        .get();

    List dataUser = [];
    List returnList = [];
    if (querySnapshot.exists) {
      dataUser = querySnapshot['id'];
    }

    for (int i = 0; i < dataUser.length; i++) {
      final like = await FirebaseFirestore.instance
          .collection('users')
          .doc(dataUser[i])
          .get();
      returnList.add(like);
    }

    return returnList;
  }
}
