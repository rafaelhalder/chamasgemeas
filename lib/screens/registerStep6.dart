import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class RegisterStep6Page extends StatefulWidget {
  @override
  _RegisterStep6PageState createState() => _RegisterStep6PageState();
}

class _RegisterStep6PageState extends State<RegisterStep6Page> {
  @override
  void initState() {
    super.initState();
  }

  String selectedIndex = '';
  String selectedIndex2 = '';
  int? typeInterested = 0;
  User? user = FirebaseAuth.instance.currentUser;
  List multipleSelected = [];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
            decoration: const BoxDecoration(
                image: DecorationImage(
              image: AssetImage("assets/images/interfacesigno.png"),
              fit: BoxFit.cover,
            )),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Container(
                      padding: const EdgeInsets.only(top: 20),
                      alignment: Alignment.center,
                      child: RichText(
                        text: const TextSpan(
                          style: TextStyle(
                            fontSize: 19.0,
                            color: Color.fromARGB(255, 238, 238, 238),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    'Escolha até 7 (sete) ATIVIDADES\nque gostaria de fazer com a pessoa\nque o Universo trará a você!'),
                          ],
                        ),
                      )),
                  Container(
                    height: size.height * 0.65,
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: FutureBuilder<dynamic>(
                      future:
                          getData(), // a previously-obtained Future<String> or null
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          List list = snapshot.data;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: list.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        border: Border.all(
                                            color: const Color.fromARGB(
                                                255, 244, 198, 128)),
                                        color: const Color.fromARGB(
                                            157, 92, 64, 22),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    margin:
                                        const EdgeInsets.symmetric(vertical: 3),
                                    child: CheckboxListTile(
                                      activeColor: const Color(0xFFECB461),
                                      controlAffinity:
                                          ListTileControlAffinity.leading,
                                      dense: true,
                                      title: Text(
                                        list[index]['campo'],
                                        style: TextStyle(
                                          fontSize: 14.0,
                                          height: 1.2,
                                          color: multipleSelected
                                                  .contains(list[index]['id'])
                                              ? const Color.fromARGB(
                                                  255, 255, 255, 255)
                                              : const Color.fromARGB(
                                                  255, 211, 211, 211),
                                        ),
                                      ),
                                      value: multipleSelected
                                              .contains(list[index]['id'])
                                          ? true
                                          : false,
                                      onChanged: (value) async {
                                        int item = list[index]['id'];

                                        setState(() {
                                          print(multipleSelected.length);
                                          if (multipleSelected
                                              .contains(list[index]['id'])) {
                                            multipleSelected
                                                .remove(list[index]['id']);
                                          } else {
                                            if (multipleSelected.length < 7) {
                                              multipleSelected
                                                  .add(list[index]['id']);
                                            }
                                          }
                                        });
                                        await FirebaseFirestore.instance
                                            .collection('users')
                                            .doc(user?.uid)
                                            .update({
                                          "listFocus": multipleSelected
                                        });
                                      },
                                    ),
                                  ),
                                );
                              });
                        } else if (snapshot.hasError) {
                          return const Text('error');
                        } else {
                          return Container();
                        }
                      },
                    ),
                  ),
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.topCenter,
                    height: size.height * 0.1,
                    width: double.infinity,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          Navigator.pushNamed(context, '/registerStep7');
                          // await FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(user?.uid)
                          //     .update({
                          //   '': selectedIndex,
                          //   'typeInterested': typeInterested
                          // });

                          // selectedIndex != ""
                          //     ? Navigator.pushNamed(context, '/home')
                          //     : null;
                        },
                        child: Container(
                          alignment: Alignment.topCenter,
                          width: size.width * 0.8,
                          height: size.height * 0.055,
                          decoration: BoxDecoration(
                            border: Border.all(
                                color: const Color.fromARGB(24, 53, 41, 55)),
                            borderRadius: BorderRadius.circular(5),
                            color: multipleSelected.isNotEmpty
                                ? const Color(0xFFECB461)
                                : Colors.white24,
                          ),
                          child: Center(
                            child: Text(
                              'CONTINUAR',
                              style: TextStyle(
                                  color: multipleSelected.isNotEmpty
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
        await FirebaseFirestore.instance.collection('objective').get();
    final allData = querySnapshot.docs.map((doc) => doc.data()).toList();

    return allData;
  }
}
