import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterIAm extends StatefulWidget {
  @override
  _RegisterIAmState createState() => _RegisterIAmState();
}

class _RegisterIAmState extends State<RegisterIAm> {
  @override
  String selectedIndex = '';
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
          height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.black,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 60, left: 50),
                    alignment: Alignment.bottomLeft,
                    child: const Text(
                      'Eu sou',
                      style: TextStyle(
                        color: Colors.white,
                        fontFamily: 'CM Sans Serif',
                        fontSize: 35.0,
                        height: 1.5,
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.5,
                    child: Center(
                      child: FutureBuilder<dynamic>(
                        future: getData(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List list = snapshot.data;
        
                            return ListView.builder(
                                shrinkWrap: true,
                                itemCount: list.length,
                                itemBuilder: (context, index) {
                                  return ListTile(
                                      tileColor:
                                          selectedIndex == index.toString()
                                              ? Colors.red
                                              : null,
                                      title: Center(
                                        child: Container(
                                          margin: const EdgeInsets.symmetric(
                                              vertical: 5),
                                          decoration: BoxDecoration(
                                            border: Border.all(
                                                color: const Color.fromARGB(
                                                    24, 53, 41, 55)),
                                            borderRadius:
                                                BorderRadius.circular(40),
                                            color: selectedIndex !=
                                                    index.toString()
                                                ? Color.fromARGB(255, 108, 90, 64)
                                                : const Color.fromARGB(255, 204, 171, 123),
                                          ),
                                          alignment: Alignment.center,
                                          width: size.width * 0.8,
                                          height: size.height * 0.055,
                                          child: Text(list[index]['name'],
                                              style: TextStyle(
                                                color: selectedIndex ==
                                                        index.toString()
                                                    ? Colors.white
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
                          if (snapshot.hasError) {
                            return const Text('some error');
                          }
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const CircularProgressIndicator();
                          }
                          return Container();
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
                              .update({'gender': selectedIndex});
        
                          selectedIndex != ""
                              ? Navigator.pushNamed(context, '/registerStep2')
                              : null;
                        },
                        child: Container(
                          width: size.width * 0.7,
                          height: size.height * 0.055,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: selectedIndex != ''
                                ? const Color.fromARGB(255, 204, 171, 123)
                                : const Color.fromARGB(255, 108, 90, 64),
                          ),
                          child: Center(
                            child: Text(
                              'CONFIRMAR',
                              style: TextStyle(
                                  color: selectedIndex != ''
                                      ? Colors.white
                                      : Colors.white24,
                                  fontFamily: 'CM Sans Serif',
                                  fontSize: 18),
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

  Future<List> getData() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('genders').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }
}
