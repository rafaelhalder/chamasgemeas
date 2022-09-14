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
  String selectedIndex = '';
  User? user = FirebaseAuth.instance.currentUser;
  int age = 0;
  String height = '';
  String weight = '';
  String occupation = '';
  String city = '';

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
                                    '${user!.displayName},\nme fale 5 coisas sobre VOCÊ!'),
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
                            'Peso',
                            style: GoogleFonts.quicksand(
                                fontSize: 18,
                                color: Color.fromARGB(255, 207, 202, 187),
                                fontWeight: FontWeight.w500),
                          )),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        maxLength: 3,
                        style: const TextStyle(color: Colors.white),
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.digitsOnly,
                        ],
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
                          weight = value;
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
                            'weight': weight,
                            'country': 'Brasil',
                            'city': city,
                            'occupation': occupation,
                            'whatsapp': '9999999999',
                          });
                          Timer(const Duration(seconds: 1), () {
                            Navigator.pushNamed(context, '/registerStep5');
                          });
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
    if (age != 0 &&
        height != '' &&
        weight != '' &&
        city != '' &&
        occupation != '') {
      print('bateu meta');
      return Colors.white;
    } else {
      print('n bateu meta');

      return Colors.white24;
    }
  }

  Color activeButtonColor() {
    if (age != 0 &&
        height != '' &&
        weight != '' &&
        city != '' &&
        occupation != '') {
      return const Color.fromARGB(255, 207, 202, 187);
    } else {
      return Colors.black26;
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

  var maskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var maskHeight = MaskTextInputFormatter(
      mask: '#.##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}
