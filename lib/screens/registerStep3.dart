import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterStep3 extends StatefulWidget {
  @override
  _RegisterStep3State createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  String name = '';
  bool finished = false;

  @override
  void initState() {
    super.initState();
    catchDatasUser();
  }

  String selectedIndex = '';
  String typeInterested = '';
  User? user = FirebaseAuth.instance.currentUser;
  final Uri _url = Uri.parse('https://chamasgemeas.com/grupos/');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/interfacesigno.png"),
              fit: BoxFit.cover,
            )),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 20, right: 20),
                    alignment: Alignment.center,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 22.0,
                          color: Color.fromARGB(255, 238, 238, 238),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${name},\n',
                              style: GoogleFonts.cinzelDecorative(
                                  fontSize: 30,
                                  color: Color.fromARGB(255, 147, 132, 100),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text: 'como a sua alma se manifesta?',
                              style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.01,
                  ),
                  Flexible(
                    child: SingleChildScrollView(
                      child: Center(
                        child: StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('souls')
                              .orderBy('id')
                              .snapshots(),
                          builder: (context, querySnapShot) {
                            if (querySnapShot.hasData) {
                              final list = querySnapShot.data?.docs;

                              return ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: list?.length,
                                  itemBuilder: (context, index) {
                                    String nameGender = list?[index]['name'];
                                    return ListTile(
                                        minVerticalPadding: 11,
                                        leading: Image.asset(
                                            'assets/images/$nameGender.png'),
                                        title: Center(
                                          child: Container(
                                            alignment: Alignment.centerLeft,
                                            width: size.width * 0.8,
                                            height: size.height * 0.065,
                                            child: Text(nameGender,
                                                style: TextStyle(
                                                  fontSize: 22,
                                                  color: selectedIndex ==
                                                          index.toString()
                                                      ? Color.fromARGB(
                                                          255, 207, 202, 187)
                                                      : Color.fromARGB(
                                                          77, 255, 255, 255),
                                                  fontWeight: selectedIndex ==
                                                          index.toString()
                                                      ? FontWeight.bold
                                                      : null,
                                                )),
                                          ),
                                        ),
                                        onTap: () {
                                          setState(() {
                                            selectedIndex = index.toString();
                                            typeInterested = nameGender;
                                          });
                                        });
                                  });
                            }
                            if (querySnapShot.hasError) {
                              return const Text('some error');
                            }
                            if (querySnapShot.connectionState ==
                                ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            } else {
                              return Container();
                            }
                          },
                        ),
                      ),
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    height: size.height * 0.1,
                    width: double.infinity,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .update({'soul': typeInterested});

                          if (finished == true) {
                            selectedIndex != ""
                                ? Navigator.pushNamed(context, '/profilePage')
                                : null;
                          } else {
                            selectedIndex != ""
                                ? Navigator.pushNamed(context, '/registerStep4')
                                : null;
                          }
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                              width: size.width * 0.30,
                              child: Text('  '),
                            ),
                            Container(
                              width: size.width * 0.30,
                              height: size.height * 0.035,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(40),
                                color: selectedIndex != ''
                                    ? Color.fromARGB(255, 200, 181, 152)
                                    : Color.fromARGB(0, 108, 90, 64),
                              ),
                              child: Center(
                                child: Text(
                                  'CONFIRMAR',
                                  style: TextStyle(
                                      color: selectedIndex != ''
                                          ? Color.fromARGB(255, 0, 0, 0)
                                          : Color.fromARGB(255, 207, 202, 187),
                                      fontFamily: 'CM Sans Serif',
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchUrl();
                              },
                              child: Container(
                                width: size.width * 0.30,
                                height: size.height * 0.035,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(40),
                                  color: Color.fromARGB(0, 108, 90, 64),
                                ),
                                child: Center(
                                  child: Text(
                                    'SABER MAIS',
                                    style: GoogleFonts.quicksand(
                                        fontSize: 12,
                                        color:
                                            Color.fromARGB(255, 207, 202, 187),
                                        fontWeight: FontWeight.w700),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  void catchDatasUser() async {
    final userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    setState(() {
      name = userInfo['name'];
      finished = userInfo['finished'];
    });
  }

  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
}
