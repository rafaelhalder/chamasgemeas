import 'package:chamasgemeas/provider/card_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class RegisterIAm extends StatefulWidget {
  @override
  _RegisterIAmState createState() => _RegisterIAmState();
}

class _RegisterIAmState extends State<RegisterIAm> {
  @override
  String selectedIndex = '';
  User? user = FirebaseAuth.instance.currentUser;
  bool finished = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catchDatasUser();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/interfacesigno.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
            backgroundColor: Color.fromARGB(0, 27, 27, 27),
            leading: finished == false
                ? Text('')
                : IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () {
                      Navigator.pushNamed(context, '/profilePage');
                    },
                    tooltip:
                        MaterialLocalizations.of(context).openAppDrawerTooltip,
                  )),
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: SingleChildScrollView(
            child: Container(
                child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.only(top: 10, left: 50),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      'SOBRE MIM',
                      style: GoogleFonts.cinzelDecorative(
                          fontSize: 36,
                          color: Color.fromARGB(255, 147, 132, 100),
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                  SizedBox(
                    height: 15,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Nome',
                      style: GoogleFonts.quicksand(
                          fontSize: 20,
                          color: Color.fromARGB(255, 147, 132, 100),
                          fontWeight: FontWeight.w700),
                      textAlign: TextAlign.left,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.only(left: 40, right: 40, top: 20),
                    alignment: Alignment.bottomLeft,
                    child: TextFormField(
                      // key: Key(occupation.toString()), // <- Magic!
                      // initialValue: occupation.toString(),
                      style: TextStyle(color: Colors.white),
                      keyboardType: TextInputType.text,
                      textCapitalization: TextCapitalization.sentences,
                      maxLength: 25,
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        errorStyle: const TextStyle(color: Colors.white),
                        helperStyle: const TextStyle(
                            color: Color.fromARGB(202, 255, 255, 255)),
                        hintStyle: const TextStyle(color: Colors.white60),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: BorderSide(color: Colors.red.shade500)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(40),
                            borderSide: const BorderSide(
                                color: Color.fromARGB(255, 147, 132, 100))),
                        focusedBorder: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 147, 132, 100))),
                        border: const OutlineInputBorder(
                            borderSide: BorderSide(
                                color: Color.fromARGB(255, 147, 132, 100),
                                width: 0.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Campo Obrigatório';
                        } else {
                          return null;
                        }
                      },
                      onChanged: (value) async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .update({'name': value});
                      },
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
                                  if (selectedIndex == '' ||
                                      selectedIndex == '0' ||
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
                                          tileColor:
                                              selectedIndex == index.toString()
                                                  ? Colors.transparent
                                                  : null,
                                          title: Center(
                                            child: Container(
                                              margin:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 5),
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
                                              height: size.height * 0.055,
                                              child: Text(list[index]['name'],
                                                  style: TextStyle(
                                                    color: selectedIndex ==
                                                            index.toString()
                                                        ? Colors.black
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

                                  return ListTile(
                                      tileColor:
                                          selectedIndex == index.toString()
                                              ? Colors.transparent
                                              : null,
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
                                          child: Text(list[index]['name'],
                                              style: TextStyle(
                                                color: selectedIndex ==
                                                        index.toString()
                                                    ? Colors.black
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
                          if (selectedIndex != '') {
                            int numero = int.parse(selectedIndex);
                            numero = numero + 1;
                            String retornoString = numero.toString();
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user?.uid)
                                .update({'gender': retornoString});

                            if (finished == true) {
                              final provider = Provider.of<CardProvider>(
                                  context,
                                  listen: false);
                              provider.resetUsers();
                              selectedIndex != ""
                                  ? Navigator.pushNamed(context, '/profilePage')
                                  : null;
                            } else {
                              selectedIndex != ""
                                  ? Navigator.pushNamed(
                                      context, '/registerStep2')
                                  : null;
                            }
                          }
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
        ),
      ),
    );
  }

  Future<List> getData() async {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('genders')
        .orderBy('id')
        .get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }

  void catchDatasUser() async {
    final userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    setState(() {
      finished = userInfo['finished'];
      print(finished);
    });
  }
}
