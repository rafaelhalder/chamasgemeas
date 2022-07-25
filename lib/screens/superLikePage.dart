import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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
    return Scaffold(
        appBar: AppBar(
          leading: const Text(''),
          title:
              const Text("Super Like", style: TextStyle(color: Colors.white)),
          centerTitle: true,
          backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        ),
        bottomNavigationBar: ConvexAppBar(
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 0, 0, 0),
            Color.fromARGB(255, 2, 1, 3),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            // ignore: prefer_const_constructors
            TabItem(
                activeIcon: const Icon(Icons.people, color: Colors.black),
                icon: const Icon(Icons.people,
                    color: Color.fromARGB(255, 204, 171, 123)),
                title: 'Home'),
            const TabItem(
                activeIcon: Icon(Icons.star, color: Colors.black),
                icon:
                    Icon(Icons.star, color: Color.fromARGB(255, 204, 171, 123)),
                title: 'Super like'),
            const TabItem(
                activeIcon: Icon(Icons.person, color: Colors.black),
                icon: Icon(Icons.person,
                    color: Color.fromARGB(255, 204, 171, 123)),
                title: 'Perfil'),
            const TabItem(
                activeIcon: Icon(Icons.message, color: Colors.black),
                icon: Icon(Icons.message,
                    color: Color.fromARGB(255, 204, 171, 123)),
                title: 'Mensagens'),
          ],
          initialActiveIndex: 1, //optional, default as 0
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

            print('click index=$i');
          },
        ),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
            decoration: const BoxDecoration(
              color: Color.fromARGB(255, 27, 27, 27),
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
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List list = snapshot.data;
                              print(list);
                              if (list.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  child: const Center(
                                      child: Text(
                                    'Sem Superlikes recebidos',
                                    style: TextStyle(color: Colors.white),
                                  )),
                                );
                              }
                              return Container(
                                child: Column(
                                  children: [
                                    const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: Text('Recebidos',
                                          style:
                                              TextStyle(color: Colors.white)),
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
                                                        const Color(0xffFDCF09),
                                                    child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50),
                                                      child: CachedNetworkImage(
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
                                                title: Text(list[index]['name'],
                                                    style: const TextStyle(
                                                        color: Colors.white)),
                                                subtitle: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: const [
                                                    Text('1232131313',
                                                        style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 14)),
                                                    Text('312313131313',
                                                        style: TextStyle(
                                                            color:
                                                                Color.fromARGB(
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
                              getData2(), // a previously-obtained Future<String> or null
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.hasData) {
                              List list = snapshot.data;
                              print(list);
                              if (list.isEmpty) {
                                return Container(
                                  padding: const EdgeInsets.all(20),
                                  child: const Center(
                                      child: Text('Sem Superlikes enviados',
                                          style:
                                              TextStyle(color: Colors.white))),
                                );
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('Enviados',
                                        style: TextStyle(color: Colors.white)),
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
                                                      "uid": list[index]['uid'],
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
                                                      const Color(0xffFDCF09),
                                                  child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    child: CachedNetworkImage(
                                                      fadeInDuration:
                                                          const Duration(
                                                              milliseconds: 0),
                                                      fadeOutDuration:
                                                          const Duration(
                                                              milliseconds: 0),
                                                      fit: BoxFit.cover,
                                                      imageUrl: list[index]
                                                          ['photos'][0]['url'],
                                                      width: 100,
                                                      height: 100,
                                                    ),
                                                  )),
                                              title: Text(list[index]['name'],
                                                  style: const TextStyle(
                                                      color: Colors.white)),
                                              subtitle: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceBetween,
                                                children: const [
                                                  Text('1232131313',
                                                      style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 14)),
                                                  Text('312313131313',
                                                      style: TextStyle(
                                                          color: Color.fromARGB(
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
        bottomSheet:
            _currentPage == _numPages - 1 ? const Text('') : const Text(''));
  }

  Future<List> getData() async {
    var querySnapshota = await FirebaseFirestore.instance
        .collection('superlikedme')
        .doc(uid)
        .get();

    List teste = [];
    List returne = [];
    if (querySnapshota.exists) {
      teste = querySnapshota['id'];
    }

    for (int i = 0; i < teste.length; i++) {
      final like = await FirebaseFirestore.instance
          .collection('users')
          .doc(teste[i])
          .get();
      returne.add(like);
    }

    return returne;
    // return querySnapshota;
  }

  Future<List> getData2() async {
    var querySnapshota = await FirebaseFirestore.instance
        .collection('superliked')
        .doc(uid)
        .get();

    List teste = [];
    List returne = [];
    if (querySnapshota.exists) {
      teste = querySnapshota['id'];
    }

    for (int i = 0; i < teste.length; i++) {
      final like = await FirebaseFirestore.instance
          .collection('users')
          .doc(teste[i])
          .get();
      returne.add(like);
    }

    return returne;
    // return querySnapshota;
  }
}
