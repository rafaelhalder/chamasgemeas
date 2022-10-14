import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:google_fonts/google_fonts.dart';

class RoghtNow extends StatefulWidget {
  @override
  _RoghtNowState createState() => _RoghtNowState();
}

class _RoghtNowState extends State<RoghtNow> {
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
        appBar: AppBar(backgroundColor: Colors.transparent),
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
                            text: 'Dicas de segurança \n',
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
                              text: 'ENCONTROS SEGUROS \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Na jornada em busca da Chama Gêmea, como em qualquer jornada, o planejamento e a segurança são muito importantes. Como em qualquer jornada, conheceremos pessoas extremamente interessantes, mas é necessário tomar certo cuidado com quem ainda não conhecemos perfeitamente.'),
                          TextSpan(
                              text:
                                  '1. Não tenha pressa para um encontro. É comum conversas on-line evoluírem para um encontro real e o encontro real é o objetivo. Entretanto, se dê tempo para conhecer antes a pessoa com quem você vai se encontrar. Poucas semanas de conversa não são suficientes. Quanto mais tempo de conversa melhor. Na conversa criam-se vínculos, entendem-se gostos e a personalidade e é mais fácil descobrir se a pessoa é quem realmente diz ser. 2. Ouça a sua intuição. Se algo parecer errado provavelmente está errado. Se você não se sentir confortável em um encontro, não continue o encontro. Mesmo que a pessoa pareça encantadora ou que você tenha receio de ferir os sentimentos de alguém, preste atenção aos alertas que a sua intuição fornece. 3. Locais públicos. Marque sempre os primeiros encontros em locais públicos e seguros. 4. Conte com a ajuda de alguém de confiança. Avise alguém de confiança onde estará e com quem estará. Compartilhe a localização com a pessoa de confiança se possível. Informe essas precauções com cordialidade à pessoa com quem você está se encontrando. Vivemos em um mundo complicado. Ela irá compreender. 5. Tenha uma "palavra senha" com alguém de confiança para pedir ajuda. Seja para encerrar o encontro através de um telefonema ou seja para informar uma emergência. 6. Esteja sempre no controle do seu meio de transporte. Não peça ou aceite caronas da pessoa com quem se encontra sem conhece-la ainda. 7. Nunca envie dinheiro, seja por pix ou transferência. Mesmo que a pessoa alegue estar em dificuldades ou emergência. Desconfie de pedidos de dinheiro ou doações. 8. Denuncie atitudes inconvenientes como: pedido de dinheiro, usuários menores de idade, comportamento agressivo, mensagens ofensivas e perfis falsos.'),
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
