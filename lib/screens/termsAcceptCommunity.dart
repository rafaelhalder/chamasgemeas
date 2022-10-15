import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import 'package:simple_shadow/simple_shadow.dart';
import 'package:google_fonts/google_fonts.dart';

class Community extends StatefulWidget {
  @override
  _CommunityState createState() => _CommunityState();
}

class _CommunityState extends State<Community> {
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
                            text: 'Comunidade \n',
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
                              text: 'Regras da comunidade \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Bem-vindo à comunidade Chamas Gêmeas. Você não chegou aqui por acaso. Tenha sempre em mente de que tudo o que fazemos nessa vida ecoará pela eternidade. Nossa comunidade é orientada por caráter e valores.'),
                          TextSpan(
                              text:
                                  'Esperamos daqueles que fazem parte dessa comunidade o respeito mútuo, honestidade nas atitudes, educação na comunicação e veracidade nas informações. Atitudes anti-sociais, preconceitos de qualquer tipo, ofensas, assédio ou qualquer comportamento que viole as leis, dentro e fora do aplicativo (sim, fora do aplicativo também!), pode levar ao cancelamento da conta. Lembre-se da regra de ouro “faça aos outros apenas aquilo que gostaria que fizessem a você”. Não estamos nos relacionando apenas com corpos e avatares na internet. Estamos nos relacionando com almas! Almas em uma jornada de evolução, com sonhos, aspirações e sentimentos. Desejamos que todos tenham maturidade e responsabilidade emocional. O objetivo do aplicativo é construir relações reais. De superficialidade o mundo está cheio. Permita-se ter uma relação profunda, fazer algo diferente e trazer luz e amor verdadeiro ao mundo.'),
                          TextSpan(
                              text:
                                  'Veremos a seguir as nossas políticas de comunidade. Se você violar qualquer uma dessas políticas, poderá ser banido do Chamas Gêmeas.  Recomendamos que você denuncie qualquer comportamento que viole as nossas políticas, além de estar atento às nossas Dicas de Segurança.'),
                          TextSpan(
                              text: '\n O Chama Gêmea não permite \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 16,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text: 'Nudez e Conteúdo Sexual \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Pedimos que não seja incluído no aplicativo nudez e conteúdo sexual explícito, seja por imagens ou seja por textos no aplicativo. '),
                          TextSpan(
                              text: '\n Assédio \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'Não será tolerado o envio de conteúdos sexuais não solicitados. Não será tolerada qualquer atitude que envolva ameaça, perseguição, coação ou intimidação.'),
                          TextSpan(
                              text: '\n Prostituição e tráfico \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 14,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text:
                                  'A conta será banida se constatado o uso do aplicativo para prostituição, serviços sexuais comerciais, tráfico humano e atos sexuais não consensuais. Violência e agressão física Não será tolerado atitudes violentas ou de incitação à violência, seja por textos ou imagens. Também é proibido qualquer material relacionado a violência a si mesmo, como conteúdos que promovam o suicídio ou auto-mutilação. Atividades Ilegais Será banido do aplicativo o uso do mesmo para atividades ilegais no país. Discurso de ódio Não será tolerado qualquer conteúdo que promova, defenda ou incentive o ódio ou a violência contra indivíduos ou grupos com base em fatores como a orientação sexual, identidade de gênero, raça, etnia, religião, deficiência, sexo, idade e nacionalidade. Divulgação de informações privadas Proteja a sua privacidade de golpes. Não publique informações privadas, suas ou de terceiros. Não divulgue números de RG, CPF, previdência, cartões de débito/crédito, passaportes, senhas, informações financeiras ou informações de contato não listadas, tais como números de telefone, endereços de e-mail ou endereço residencial e comercial. Publicidade não autorizada Não toleraremos perfis falsos que estão no aplicativo com o objetivo de propaganda e direcionamento a páginas, redes sociais ou links externos. Perfis com outras intenções Não use o aplicativo para objetivos aos quais não se destina. Não toleraremos perfis que usam a plataforma para campanhas políticas, publicidade de organizações com ou sem fim lucrativos, pesquisas de opinião pública ou para propaganda de produtos e serviços. Golpistas A conta será banida de qualquer um que tente obter informações privadas de outros usuários por meio de atividades fraudulentas ou ilegais. Não é permitido também aos usuários do aplicativo compartilhamento de suas próprias informações de contas financeiras (Conta Corrente, Pix, PayPal, etc) com a finalidade de receber dinheiro de outros usuários.'),
                          TextSpan(
                              text:
                                  'Falsificação de identidade Não é permitido o uso de identidades falsas e fotos de terceiros como se fossem as suas, mesmo que com fins humorísticos. Menores de 18 anos Você deve ter no mínimo 18 anos de idade para usar o Chamas Gêmeas. Não é permitido imagens de menores desacompanhados. Se você quiser postar fotos dos seus filhos, certifique-se de aparecer na foto também. Se você vir um perfil com fotos de um menor desacompanhado, que promova atos de violência contra menores ou que os apresente de maneira sexual ou sugestiva, denuncie imediatamente. Violações de direitos autorais e marcas comerciais Não é permitido incluir qualquer imagem protegida por direitos autorais. Não a publique, a menos que tenha permissão para fazê-lo. Isso inclui qualquer material protegido por direitos autorais. Compartilhamento de contas As contas são pessoais. Não são permitidas contas com vários donos, como contas de casais, familiares ou de parceiros. Aplicativos de terceiros O uso de quaisquer aplicativos criados por terceiros que prometem oferecer os nossos serviços ou desbloquear recursos especiais do Chamas Gêmeas não é permitido. Inatividade de conta Mantenha sua conta ativa. Se sua conta não for utilizada por 2 (dois) anos, poderemos excluí-la. DENUNCIAS No Chamas Gêmeas Comportamentos que firam nossos termos de uso podem ser denunciados AQUI. Fora do Chamas Gêmeas: Se necessário, entre em contato com a polícia local e, em seguida, entre em contato conosco AQUI.. CLIQUE AQUI PARA OBTER DICAS SOBRE ENCONTROS SEGUROS.'),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                )
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
