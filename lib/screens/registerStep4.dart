import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterStep4 extends StatefulWidget {
  @override
  _RegisterStep4State createState() => _RegisterStep4State();
}

class _RegisterStep4State extends State<RegisterStep4> {
  int age = 2;
  String height = '';
  String occupation = '';
  String city = '';
  bool finished = false;
  String selectedIndex = '';
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  User? user = FirebaseAuth.instance.currentUser;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catchDatasUser();
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const TextStyle textstyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    const InputDecoration decoration = InputDecoration(
      border: OutlineInputBorder(),
    );

    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/interfacesigno.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Center(
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Center(
                      child: RichText(
                        text: TextSpan(
                          style: const TextStyle(
                            fontSize: 22.0,
                            color: Color.fromARGB(255, 238, 238, 238),
                          ),
                          children: <TextSpan>[
                            TextSpan(
                                text:
                                    '${user!.displayName},\nme fale 4 coisas sobre VOCÊ!'),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 3.0, left: 20),
                          child: Text(
                            'Idade',
                            style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Color.fromARGB(255, 207, 202, 187),
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        key: Key(age.toString()), // <- Magic!
                        initialValue: age.toString(),
                        keyboardType: TextInputType.number,
                        maxLength: 2,
                        style: const TextStyle(color: Colors.white),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          focusColor: Colors.white,
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                          errorStyle: const TextStyle(color: Colors.white),
                          helperStyle: const TextStyle(
                              color: Color.fromARGB(202, 255, 255, 255)),
                          hintStyle: const TextStyle(color: Colors.white60),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide:
                                  BorderSide(color: Colors.red.shade500)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 207, 202, 187))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255))),
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo Obrigatório';
                          } else if (int.parse(value) < 18) {
                            return 'Proibido p/ menores';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => setState(() {
                          if (value == "") {
                            value = "0";
                          }
                          age = int.parse(value);
                        }),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 3.0, left: 20),
                          child: Text(
                            'Altura',
                            style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Color.fromARGB(255, 207, 202, 187),
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        key: Key(height.toString()), // <- Magic!
                        initialValue: height.toString(),
                        keyboardType: TextInputType.number,
                        maxLength: 4,
                        style: const TextStyle(color: Colors.white),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                          maskHeight
                        ],
                        decoration: InputDecoration(
                          filled: true,
                          focusColor: Colors.white,
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                          errorStyle: const TextStyle(color: Colors.white),
                          helperStyle: const TextStyle(
                              color: Color.fromARGB(202, 255, 255, 255)),
                          hintStyle: const TextStyle(color: Colors.white60),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide:
                                  BorderSide(color: Colors.red.shade500)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 207, 202, 187))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255))),
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo Obrigatório';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => setState(() {
                          height = value;
                        }),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 3.0, left: 20),
                          child: Text(
                            'Cidade',
                            style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Color.fromARGB(255, 207, 202, 187),
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        key: Key(city.toString()), // <- Magic!
                        initialValue: city.toString(),
                        style: TextStyle(color: Colors.white),
                        keyboardType: TextInputType.text,
                        textCapitalization: TextCapitalization.sentences,
                        maxLength: 25,
                        decoration: InputDecoration(
                          labelStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            letterSpacing: 0.5,
                          ),
                          errorStyle: const TextStyle(color: Colors.white),
                          helperStyle: const TextStyle(
                              color: Color.fromARGB(202, 255, 255, 255)),
                          hintStyle: const TextStyle(color: Colors.white60),
                          errorBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide:
                                  BorderSide(color: Colors.red.shade500)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 207, 202, 187))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255))),
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo Obrigatório';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => setState(() {
                          city = value;
                        }),
                      ),
                    ),
                    Container(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(bottom: 3.0, left: 20),
                          child: Text(
                            'Ocupação',
                            style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Color.fromARGB(255, 207, 202, 187),
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        key: Key(occupation.toString()), // <- Magic!
                        initialValue: occupation.toString(),
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
                              borderSide:
                                  BorderSide(color: Colors.red.shade500)),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: const BorderSide(
                                  color: Color.fromARGB(255, 207, 202, 187))),
                          focusedBorder: const OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color.fromARGB(255, 255, 255, 255))),
                          border: const OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.white, width: 0.0)),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo Obrigatório';
                          } else {
                            return null;
                          }
                        },
                        onChanged: (value) => setState(() {
                          occupation = value;
                        }),
                      ),
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    GestureDetector(
                      onTap: () async {
                        FocusManager.instance.primaryFocus?.unfocus();

                        if (_formKey.currentState!.validate()) {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .update({
                            'age': age,
                            'height': height,
                            'weight': '999',
                            'country': 'Brasil',
                            'city': city,
                            'occupation': occupation,
                            'whatsapp': '9999999999',
                          });
                          Timer(const Duration(seconds: 1), () {
                            finished == true
                                ? Navigator.pushNamed(context, '/profilePage')
                                : Navigator.pushNamed(
                                    context, '/registerStep5');
                          });
                        }
                      },
                      child: Container(
                        width: size.width * 0.35,
                        height: size.height * 0.035,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(40),
                          color: activeButtonColor(),
                        ),
                        child: Center(
                          child: Text(
                            'CONFIRMAR',
                            style: TextStyle(
                                color: activeButton(),
                                fontFamily: 'CM Sans Serif',
                                fontWeight: FontWeight.bold,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Color activeButton() {
    if (age != 0 && height != '' && city != '' && occupation != '') {
      print('bateu meta');
      return Color.fromARGB(255, 0, 0, 0);
    } else {
      print('n bateu meta');

      return Color.fromARGB(255, 207, 202, 187);
    }
  }

  Color activeButtonColor() {
    if (age != 0 && height != '' && city != '' && occupation != '') {
      return const Color.fromARGB(255, 200, 181, 152);
    } else {
      return Color.fromARGB(0, 108, 90, 64);
    }
  }

  Container headerInput(
    String texto,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      alignment: Alignment.centerLeft,
      child: Text(
        texto,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Padding inputField(
    String texto,
    dynamic name,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15),
      child: Container(
        alignment: Alignment.centerLeft,
        decoration: BoxDecoration(
          color: Colors.purple.shade900,
          borderRadius: BorderRadius.circular(10.0),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 6.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        height: 40.0,
        child: TextFormField(
          keyboardType: TextInputType.number,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: 'OpenSans',
          ),
          decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: const EdgeInsets.symmetric(horizontal: 15),
            hintText: texto,
            hintStyle: const TextStyle(
              color: Colors.white54,
              fontFamily: 'OpenSans',
            ),
          ),
          validator: (name) {
            if (name == null || name.isEmpty) {
              return 'Obrigatório';
            }
            return null;
          },
          onChanged: (value) => setState(() {
            name = value;
          }),
        ),
      ),
    );
  }

  void catchDatasUser() async {
    final userInfo =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    setState(() {
      age = userInfo['age'];
      height = userInfo['height'];
      occupation = userInfo['occupation'];
      city = userInfo['city'];
      finished = userInfo['finished'];
      print(finished);
    });
  }

  var maskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var maskHeight = MaskTextInputFormatter(
      mask: '#.##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}
