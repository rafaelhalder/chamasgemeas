import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:toggle_switch/toggle_switch.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterISearchPage extends StatefulWidget {
  @override
  _RegisterISearchPageState createState() => _RegisterISearchPageState();
}

class _RegisterISearchPageState extends State<RegisterISearchPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  String selectedIndex = '';
  int? typeInterested = 0;
  User? user = FirebaseAuth.instance.currentUser;

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
                    padding: const EdgeInsets.only(left: 50),
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 22.0,
                          color: Color.fromARGB(255, 238, 238, 238),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${user?.displayName}, \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 40,
                                  color: Color.fromARGB(255, 147, 132, 100),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text: 'como a sua alma se manifesta?',
                              style: GoogleFonts.quicksand(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.45,
                    child: Center(
                      child: StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('genders')
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

                                  if (selectedIndex == '0' ||
                                      selectedIndex == '1') {
                                    if (index.toString() == '3' ||
                                        index.toString() == '4' ||
                                        index.toString() == '5') {
                                      return Container();
                                    }
                                  }
                                  if (index.toString() == '3' ||
                                      index.toString() == '4' ||
                                      index.toString() == '5') {
                                    if (index.toString() == '3' ||
                                        index.toString() == '4' ||
                                        index.toString() == '5') {
                                      return ListTile(
                                          title: Center(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 0),
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        255, 147, 132, 100)),
                                                borderRadius:
                                                    BorderRadius.circular(40),
                                                color: selectedIndex !=
                                                        index.toString()
                                                    ? Color.fromARGB(
                                                        0, 108, 90, 64)
                                                    : Color.fromARGB(
                                                        255, 147, 132, 100),
                                              ),
                                              alignment: Alignment.center,
                                              width: size.width * 0.4,
                                              height: size.height * 0.045,
                                              child: Text(nameGender,
                                                  style: TextStyle(
                                                    color: selectedIndex ==
                                                            index.toString()
                                                        ? Color.fromARGB(
                                                            255, 0, 0, 0)
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
                                            });
                                          });
                                    }
                                  }

                                  print(selectedIndex);
                                  return ListTile(
                                      title: Center(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: Color.fromARGB(
                                                    255, 147, 132, 100)),
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: selectedIndex !=
                                                    index.toString()
                                                ? Color.fromARGB(0, 108, 90, 64)
                                                : Color.fromARGB(
                                                    255, 147, 132, 100),
                                          ),
                                          alignment: Alignment.center,
                                          width: size.width * 0.8,
                                          height: size.height * 0.055,
                                          child: Text(nameGender,
                                              style: TextStyle(
                                                color: selectedIndex ==
                                                        index.toString()
                                                    ? Color.fromARGB(
                                                        255, 0, 0, 0)
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
                    margin: const EdgeInsets.only(bottom: 25, top: 20),
                    child: ToggleSwitch(
                      minWidth: 130.0,
                      initialLabelIndex: typeInterested,
                      cornerRadius: 15.0,
                      activeFgColor: Colors.white,
                      inactiveBgColor: Colors.white24,
                      inactiveFgColor: Colors.white,
                      totalSwitches: 2,
                      labels: const ['Namoro', ' Amizade'],
                      icons: const [
                        FontAwesomeIcons.heart,
                        FontAwesomeIcons.peopleGroup
                      ],
                      activeBgColors: const [
                        [Color.fromARGB(255, 147, 132, 100)],
                        [Color.fromARGB(255, 147, 132, 100)]
                      ],
                      onToggle: (index) {
                        typeInterested = index;
                        print('switched to: $index');
                      },
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
                              .update({
                            'interested': selectedIndex,
                            'typeInterested': typeInterested
                          });

                          selectedIndex != ""
                              ? Navigator.pushNamed(context, '/registerStep3')
                              : null;
                        },
                        child: Container(
                          width: size.width * 0.35,
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
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }
}
