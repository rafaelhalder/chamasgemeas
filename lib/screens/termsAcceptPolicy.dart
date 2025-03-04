import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:google_fonts/google_fonts.dart';

class Policy extends StatefulWidget {
  @override
  _PolicyState createState() => _PolicyState();
}

class _PolicyState extends State<Policy> {
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
        appBar: AppBar(
          backgroundColor: Colors.transparent,
        ),
        backgroundColor: Colors.transparent,
        body: SafeArea(
            child: SingleChildScrollView(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            child: Column(
              children: [
                Center(
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 20.0,
                        color: Color.fromARGB(255, 238, 238, 238),
                      ),
                      children: <TextSpan>[
                        TextSpan(
                            text: 'POLITICA DE PRIVACIDADE \n',
                            style: GoogleFonts.quicksand(
                                fontSize: 27,
                                color: Color.fromARGB(255, 147, 132, 100),
                                fontWeight: FontWeight.w700)),
                      ],
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(10),
                  width: size.width * 0.9,
                  height: size.height * 0.75,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white)),
                  child: SingleChildScrollView(
                    child: RichText(
                      text: TextSpan(
                        style: GoogleFonts.quicksand(
                            fontSize: 13,
                            color: Color.fromARGB(255, 168, 164, 151),
                            fontWeight: FontWeight.w400),
                        children: <TextSpan>[
                          TextSpan(
                              text: 'POLITICA DE PRIVACIDADE \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Esta política de privacidade tem o objetivo de informá-lo sobre a utilização dos seus dados pessoais pelo Chamas Gêmeas. Para o correto funcionamento e objetivo do aplicativo, que é o de conectar pessoas com os mesmos interesses, são coletados os seguintes dados:'),
                          TextSpan(
                              text:
                                  '\n\n • Nome\n • Endereço\n • Cidade\n • Profissão\n • Altura\n • Idade\n • Signo\n • Gênero\n • Interesse de relacionamento (namoro ou amizade)\n • Texto digitado no campo sobre mim\n • E-mail\n • Mensagens do chat do aplicativo\n • Fotos carregadas no aplicativo\n • Atividades que gosta de realizar\n • Filosofia esotérica com a qual tem afinidade\n • Geolocalização (solicitando permissão do usuário) \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 140, 137, 127),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Para atingir o objetivo do aplicativo de conectar pessoas interessantes com interesses em comum, são tornados públicos os seguintes dados às pessoas que acessam o seu perfil dentro do aplicativo:'),
                          TextSpan(
                              text:
                                  '\n\n • Nome\n • Profissão\n • Cidade\n • Altura\n • Idade\n • Signo\n • Gênero\n • Interesse de relacionamento (namoro ou amizade)\n • Texto digitado no campo sobre mim\n • Fotos carregadas no aplicativo\n • Atividades que gosta de realizar\n • Filosofia esotérica com a qual tem afinidade \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 13,
                                  color: Color.fromARGB(255, 140, 137, 127),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Dados gerenciados por Terceiros\n São gerenciadas por terceiros as informações das seguintes atividades:\n Meios de autenticação\n • Google\n • Facebook\n • Apple\n Meio de pagamento\n As informações de pagamento são avaliadas e gerenciadas pelas empresas listadas abaixo, de acordo com o Sistema Operacional do Usuário.\n • Google Pay (Android)\n • Apple Pay (iOS)\n Os dados gerenciados pelo App Chamas Gêmeas estão armazenados na nuvem da empresa Google (Firebase) e Apple, sendo assim utilizando sua infra-estrutura e segurança.'),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        )),
      ),
    );
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

  var maskFormatter = MaskTextInputFormatter(
      mask: '(##) #####-####',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);

  var maskHeight = MaskTextInputFormatter(
      mask: '#.##',
      filter: {"#": RegExp(r'[0-9]')},
      type: MaskAutoCompletionType.lazy);
}
