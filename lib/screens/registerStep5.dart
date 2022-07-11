import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';

class RegisterStep5 extends StatefulWidget {
  @override
  _RegisterStep5State createState() => _RegisterStep5State();
}

class _RegisterStep5State extends State<RegisterStep5> {
  String selectedIndex = '';
  User? user = FirebaseAuth.instance.currentUser;
  int age = 0;
  String height = '';
  String weight = '';
  String occupation = '';
  String city = '';
  String country = '';
  String whatsapp = '';

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    const TextStyle textstyle =
        TextStyle(color: Colors.white, fontWeight: FontWeight.bold);
    const InputDecoration decoration = InputDecoration(
      border: OutlineInputBorder(),
    );

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
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
                                  '${user!.displayName},\nme fale 7 coisas sobre VOCÊ!'),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: size.height * 0.05,
                  ),
                  Row(
                    children: [
                      Flexible(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
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
                                  labelText: 'Idade',
                                  helperText: '27 Anos',
                                  hintText: '27',
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                  errorStyle:
                                      const TextStyle(color: Colors.white),
                                  helperStyle: const TextStyle(
                                      color:
                                          Color.fromARGB(202, 255, 255, 255)),
                                  hintStyle:
                                      const TextStyle(color: Colors.white60),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.red.shade500)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFECB461))),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.0)),
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
                            )
                          ],
                        ),
                      ),
                      Flexible(
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(8.0),
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
                                  labelText: 'Altura',
                                  helperText: 'Altura 1.80',
                                  hintText: '1.80',
                                  labelStyle: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    letterSpacing: 0.5,
                                  ),
                                  errorStyle:
                                      const TextStyle(color: Colors.white),
                                  helperStyle: const TextStyle(
                                      color:
                                          Color.fromARGB(202, 255, 255, 255)),
                                  hintStyle:
                                      const TextStyle(color: Colors.white60),
                                  errorBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: BorderSide(
                                          color: Colors.red.shade500)),
                                  enabledBorder: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8),
                                      borderSide: const BorderSide(
                                          color: Color(0xFFECB461))),
                                  focusedBorder: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Color.fromARGB(
                                              255, 255, 255, 255))),
                                  border: const OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.white, width: 0.0)),
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
                            )
                          ],
                        ),
                      ),
                    ],
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
                          'country': country,
                          'city': city,
                          'occupation': occupation,
                          'whatsapp': whatsapp,
                        });
                        Timer(const Duration(seconds: 1), () {
                          Navigator.pushNamed(context, '/registerStep5');
                        });
                      }
                    },
                    child: Container(
                      width: size.width * 0.9,
                      height: size.height * 0.065,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: activeButtonColor(),
                      ),
                      child: Center(
                        child: Text(
                          'CONFIRMAR',
                          style: TextStyle(
                              color: activeButton(),
                              fontFamily: 'CM Sans Serif',
                              fontSize: 18),
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
    );
  }

  Color activeButton() {
    if (age != 0 &&
        height != '' &&
        weight != '' &&
        country != '' &&
        city != '' &&
        occupation != '' &&
        whatsapp != '') {
      return Colors.white;
    } else {
      return Colors.white24;
    }
  }

  Color activeButtonColor() {
    if (age != 0 &&
        height != '' &&
        weight != '' &&
        country != '' &&
        city != '' &&
        occupation != '' &&
        whatsapp != '') {
      return const Color(0xFFECB461);
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
