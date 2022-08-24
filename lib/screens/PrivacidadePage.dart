import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:chamasgemeas/services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacidadePage extends StatefulWidget {
  const PrivacidadePage({Key? key}) : super(key: key);

  @override
  State<PrivacidadePage> createState() => _PrivacidadePageState();
}

class _PrivacidadePageState extends State<PrivacidadePage> {
  double _value = 0;
  double _startValue = 0;
  double _endValue = 0;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  var user = FirebaseAuth.instance.currentUser;
  final Uri _url = Uri.parse('https://chamasgemeas.com');

  @override
  void initState() {
    // TODO: implement initState
    getFilters();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    int columnCount = 3;
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Não", style: TextStyle(color: Colors.white)),
      onPressed: () {
        SystemNavigator.pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Sim", style: TextStyle(color: Colors.red)),
      onPressed: () async {
        print(uid);
        await FirebaseFirestore.instance
            .collection('users')
            .doc(uid)
            .update({'status': false});
        await user?.delete();
        await AuthService().signOut();
        await SystemNavigator.pop();
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(
          side: BorderSide(color: Color.fromARGB(255, 204, 171, 123))),
      elevation: 2,
      title: Text("Aviso!", style: TextStyle(color: Colors.white)),
      content: Text(
        "Deseja deletar sua conta?",
        style: TextStyle(color: Colors.white),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Container(
        color: const Color.fromARGB(255, 27, 27, 27),
        child: Scaffold(
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
                  title: 'Msg'),
              const TabItem(
                  activeIcon: Icon(Icons.settings, color: Colors.black),
                  icon: Icon(Icons.settings,
                      color: Color.fromARGB(255, 204, 171, 123)),
                  title: 'Opções'),
            ],
            initialActiveIndex: 4, //optional, default as 0
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
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Container(
                      child: Center(
                          child: Text(
                        'Privacidade',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),
                      )),
                    ),
                  ),
                  AnimationLimiter(
                    child: GridView.count(
                      shrinkWrap: true,
                      childAspectRatio: (200 / 150),
                      crossAxisCount: 2,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                      children: [
                        AnimationConfiguration.staggeredGrid(
                          position: 0,
                          duration: const Duration(milliseconds: 375),
                          columnCount: columnCount,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  _launchUrl();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 204, 171, 123))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.newspaper,
                                          size: 35, color: Colors.white),
                                      Text(
                                        'Termos de Uso',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        AnimationConfiguration.staggeredGrid(
                          position: 0,
                          duration: const Duration(milliseconds: 375),
                          columnCount: columnCount,
                          child: ScaleAnimation(
                            child: FadeInAnimation(
                              child: GestureDetector(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (BuildContext context) {
                                      return alert;
                                    },
                                  );
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 204, 171, 123))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Icon(Icons.person_off,
                                          size: 35, color: Colors.white),
                                      Text(
                                        'Deletar Conta',
                                        style: TextStyle(
                                            fontSize: 18, color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }

  void getFilters() async {
    final filter =
        await FirebaseFirestore.instance.collection('filter').doc(uid).get();

    setState(() {
      _value = double.parse(filter['distance'].toString());
      _startValue = double.parse(filter['age'][0].toString());
      _endValue = double.parse(filter['age'][1].toString());
    });
  }
}
