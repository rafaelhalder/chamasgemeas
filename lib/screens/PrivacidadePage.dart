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
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
    Widget okButton = TextButton(
      child: Text("Ok", style: TextStyle(color: Colors.white)),
      onPressed: () async {
        await AuthService().signOut();
        SystemNavigator.pop();
      },
    );

    Widget continueButton = TextButton(
      child: Text("Sim", style: TextStyle(color: Colors.red)),
      onPressed: () async {
        print(uid);
        try {
          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'status': false});
          await FirebaseAuth.instance.userChanges();
          await FirebaseAuth.instance.currentUser?.delete();
          await AuthService().signOut();
          await SystemNavigator.pop();
        } on FirebaseAuthException catch (e, s) {
          if (e.code == 'requires-recent-login') {
            await Fluttertoast.showToast(
                msg:
                    "Por gentileza fazer login novamente, para realizar a exclusão.",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.CENTER,
                timeInSecForIosWeb: 2,
                backgroundColor: Colors.red,
                textColor: Colors.white,
                fontSize: 16.0);
            print(
                'The user must reauthenticate before this operation can be executed.');

            await AuthService().signOut();
          } else {
            print('Firebase auth delete account error:\n$e');
            print('============stack=========\n$s');
          }
        } catch (e, s) {
          print('Firebase auth delete account error:\n$e');
          print('============stack=========\n$s');
        }
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.black,
      shape: RoundedRectangleBorder(side: BorderSide(color: Colors.black)),
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
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/interfacesigno.png"),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
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
            initialActiveIndex: 4, //optional, default as 0
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
                        style: GoogleFonts.cinzelDecorative(
                            fontSize: 22,
                            color: Color.fromARGB(255, 147, 132, 100),
                            fontWeight: FontWeight.w600),
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
                                  Navigator.popAndPushNamed(context, '/acc');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 207, 202, 187))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.newspaper,
                                          size: 60,
                                          color: Color.fromARGB(
                                              255, 207, 202, 187)),
                                      Text(
                                        'Termos de Uso',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 207, 202, 187)),
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
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 207, 202, 187))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.person_off,
                                          size: 60,
                                          color: Color.fromARGB(
                                              255, 207, 202, 187)),
                                      Text(
                                        'Deletar Conta',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 207, 202, 187)),
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
                                  Navigator.pushNamed(context, '/policy');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 207, 202, 187))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.book_rounded,
                                          size: 60,
                                          color: Color.fromARGB(
                                              255, 207, 202, 187)),
                                      Text(
                                        'Politica de Privacidade',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 207, 202, 187)),
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
                                  Navigator.pushNamed(context, '/community');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 207, 202, 187))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.people_alt_sharp,
                                          size: 60,
                                          color: Color.fromARGB(
                                              255, 207, 202, 187)),
                                      Text(
                                        'Regra da comunidade',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 207, 202, 187)),
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
                                  Navigator.popAndPushNamed(
                                      context, '/roghtow');
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(25),
                                      color: Colors.transparent,
                                      border: Border.all(
                                          color: Color.fromARGB(
                                              255, 207, 202, 187))),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 15),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Icon(Icons.shield_moon_outlined,
                                          size: 60,
                                          color: Color.fromARGB(
                                              255, 207, 202, 187)),
                                      Text(
                                        'Dicas de segurança',
                                        style: TextStyle(
                                            fontSize: 16,
                                            color: Color.fromARGB(
                                                255, 207, 202, 187)),
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
}
