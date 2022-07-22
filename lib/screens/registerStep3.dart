import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

class RegisterStep3 extends StatefulWidget {
  @override
  _RegisterStep3State createState() => _RegisterStep3State();
}

class _RegisterStep3State extends State<RegisterStep3> {
  @override
  void initState() {
    super.initState();
  }

  String selectedIndex = '';
  String typeInterested = '';
  User? user = FirebaseAuth.instance.currentUser;
  final Uri _url = Uri.parse('https://chamasgemeas.com');

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
            decoration: BoxDecoration(
              color: Colors.black,
            ),
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
                          TextSpan(text: '${user?.displayName} '),
                          const TextSpan(text: 'como a sua alma se manifesta?'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  SizedBox(
                    height: size.height * 0.60,
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
                                      minVerticalPadding: 15,
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
                                                    ? Color(0xFFECB461)
                                                    : Colors.white60,
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

                          selectedIndex != ""
                              ? Navigator.pushNamed(context, '/registerStep4')
                              : null;
                        },
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              width: size.width * 0.7,
                              height: size.height * 0.055,
                              child: Center(
                                child: Text(
                                  'CONFIRMAR',
                                  style: TextStyle(
                                      color: selectedIndex != ''
                                          ? Color(0xFFECB461)
                                          : Colors.white24,
                                      fontFamily: 'CM Sans Serif',
                                      fontSize: 18),
                                ),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _launchUrl();
                              },
                              child: Container(
                                child: Text(
                                  'Saber Mais',
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: 'CM Sans Serif',
                                      fontSize: 12),
                                ),
                              ),
                            ),
                            SizedBox(
                              width: 3,
                            )
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

  void _launchUrl() async {
    if (!await launchUrl(_url)) throw 'Could not launch $_url';
  }
}
