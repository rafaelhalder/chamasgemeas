import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:google_fonts/google_fonts.dart';

class RegisterStep5 extends StatefulWidget {
  @override
  _RegisterStep5State createState() => _RegisterStep5State();
}

class _RegisterStep5State extends State<RegisterStep5> {
  String name = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    catchDatasUser();
  }

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
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/interfacesigno.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Container(
          width: size.width * 0.35,
          height: size.height * 0.035,
          child: FloatingActionButton(
            backgroundColor: selectedIndex == ''
                ? Color.fromARGB(255, 0, 0, 0)
                : Color.fromARGB(255, 207, 202, 187),
            shape:
                BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
            onPressed: () {
              update();
            },
            child: Text('CONFIRMAR',
                style: TextStyle(
                    color: selectedIndex != ''
                        ? Color.fromARGB(255, 0, 0, 0)
                        : Color.fromARGB(255, 207, 202, 187),
                    fontFamily: 'CM Sans Serif',
                    fontWeight: FontWeight.bold,
                    fontSize: 16)),
          ),
        ),
        backgroundColor: Colors.transparent,
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
                                text: '${name}, \n',
                                style: GoogleFonts.cinzelDecorative(
                                    fontSize: 40,
                                    color: Color.fromARGB(255, 147, 132, 100),
                                    fontWeight: FontWeight.w700)),
                            TextSpan(
                                text: 'Qual é o seu SIGNO?  ',
                                style: GoogleFonts.quicksand(
                                    fontSize: 20,
                                    color: Color.fromARGB(255, 207, 202, 187),
                                    fontWeight: FontWeight.w700)),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: size.height * 0.05,
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        zodiac('assets/images/aries.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Áries'),
                        zodiac('assets/images/touro.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Touro'),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        zodiac('assets/images/gemeos.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Gêmeos'),
                        zodiac('assets/images/cancer.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Câncer'),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        zodiac('assets/images/leao.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Leão'),
                        zodiac('assets/images/virgem.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Virgem'),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        zodiac('assets/images/libra.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Libra'),
                        zodiac('assets/images/escorpiao.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Escorpião'),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        zodiac('assets/images/sagitario.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Sagitário'),
                        zodiac('assets/images/capricornio.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Capricórnio'),
                      ],
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        zodiac('assets/images/aquario.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Aquário'),
                        zodiac('assets/images/peixes.png', 'Gêmeos',
                            '21 Maio-20 Jun', 'Peixes'),
                      ],
                    ),
                    const SizedBox(
                      height: 15,
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

  void update() async {
    if (selectedIndex != "") {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({'zodiac': selectedIndex});
      Navigator.pushNamed(context, '/registerStep6');
    }
  }

  Flexible zodiac(String image, String sign, String date, String number) {
    return Flexible(
      child: GestureDetector(
        onTap: () {
          setState(() {
            selectedIndex = number;
          });
        },
        child: Column(
          children: [
            selectedIndex == number
                ? SimpleShadow(
                    opacity: 1, // Default: 0.5
                    color: const Color.fromARGB(
                        255, 255, 255, 255), // Default: Black
                    offset: const Offset(0.5, 1), // Default: Offset(2, 2)
                    sigma: 6,
                    child: Image.asset(
                      image,
                      width: MediaQuery.of(context).size.width * 0.46,
                    ),
                  )
                : Image.asset(
                    image,
                    width: MediaQuery.of(context).size.width * 0.46,
                  ),
            const SizedBox(
              height: 15,
            ),
          ],
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
    if (selectedIndex != '') {
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

  void catchDatasUser() async {
    final userInfo = await FirebaseFirestore.instance
        .collection('users')
        .doc(user?.uid)
        .get();

    setState(() {
      name = userInfo['name'];
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
