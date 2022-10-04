import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({Key? key}) : super(key: key);

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  List<PageViewModel> getPages() {
    return [
      PageViewModel(
          titleWidget: RichText(
            text: TextSpan(
              style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: Color.fromARGB(255, 207, 202, 187),
                  fontWeight: FontWeight.w700),
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Não aceite relacionamentos rasos se você tem sentimentos profundos.\n\n',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text:
                        'O Chamas Gêmeas é um caminho para você que já tem a consciência da tua',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: ' jornada espiritual',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
                TextSpan(
                    text:
                        ' e que sabe que existe outra pessoa, na mesma jornada, procurando por você!',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
              ],
            ),
          ),
          bodyWidget: Center(
              child: RichText(
            text: TextSpan(
              style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: Color.fromARGB(255, 207, 202, 187),
                  fontWeight: FontWeight.w700),
              children: <TextSpan>[
                TextSpan(
                    text: 'Uma pessoa de ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'valor ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
                TextSpan(
                    text:
                        'que caminhará ao teu lado, que pode ler teus pensamentos, adivinhar teus desejos, pois apesar do tempo e do espaço, jamais esteve separarada em pensamento e sentimento!\n\n',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'Essa é a tua ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'Chama Gêmea, ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
                TextSpan(
                    text:
                        'tua alma espelho, que nesse exato momento busca também por ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'você!',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
              ],
            ),
          )),
          footer: Text(''),
          decoration: const PageDecoration(
            pageColor: Color.fromARGB(0, 0, 0, 0),
          )),
      PageViewModel(
          titleWidget: RichText(
            text: TextSpan(
              style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: Color.fromARGB(255, 207, 202, 187),
                  fontWeight: FontWeight.w700),
              children: <TextSpan>[
                TextSpan(
                    text: 'O Universo não entende palavras, entende ',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'frequências.',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
              ],
            ),
          ),
          bodyWidget: RichText(
            text: TextSpan(
              style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: Color.fromARGB(255, 207, 202, 187),
                  fontWeight: FontWeight.w700),
              children: <TextSpan>[
                TextSpan(
                    text: 'No Universo ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'semelhantes ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
                TextSpan(
                    text:
                        'se atraem. A atração é por semelhança de interesses, gostos, pensamentos, atitudes e sentimentos. Se o destino te trouxe até aqui, certamente trouxe também quem está na mesma ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'frequência. ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
              ],
            ),
          ),
          footer: Text(''),
          decoration: const PageDecoration(
            pageColor: Color.fromARGB(0, 0, 0, 0),
          )),
      PageViewModel(
          titleWidget: RichText(
            text: TextSpan(
              style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: Color.fromARGB(255, 207, 202, 187),
                  fontWeight: FontWeight.w700),
              children: <TextSpan>[
                TextSpan(
                    text: 'O HOJE é o tempo certo para ',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'começar',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
                TextSpan(
                    text: ' ou ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'recomeçar.',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
              ],
            ),
          ),
          bodyWidget: RichText(
            text: TextSpan(
              style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: Color.fromARGB(255, 207, 202, 187),
                  fontWeight: FontWeight.w700),
              children: <TextSpan>[
                TextSpan(
                    text: 'No Chamas Gêmeas você encontrará uma ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'comunidade ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
                TextSpan(
                    text:
                        'e pessoas com os mesmos interesses, que entendem o objetivo da vida e que dão valor aos ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'relacionamentos de alma.\n\n',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
                TextSpan(
                    text:
                        'Seja para um relacionamento ou amizade, aqui você poderá encontrar pessoas que te valorizam pelo que você sabe e pelo que você é!',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
              ],
            ),
          ),
          footer: Text(''),
          decoration: const PageDecoration(
            pageColor: Color.fromARGB(0, 0, 0, 0),
          )),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          Image.asset(
            "assets/images/interfacesigno.png",
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            fit: BoxFit.cover,
          ),
          IntroductionScreen(
            dotsDecorator: DotsDecorator(
              activeColor: Color.fromARGB(255, 147, 132, 100),
              color: Color.fromARGB(255, 207, 202, 187),
            ),
            globalBackgroundColor: Colors.transparent,
            pages: getPages(),
            showNextButton: true,
            next: Text('Avançar',
                style: TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
            showBackButton: true,
            back: Text("Voltar",
                style: TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
            done: Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                  color: Color.fromARGB(255, 147, 132, 100),
                  borderRadius: BorderRadius.circular(40)),
              child: Text("Concluir",
                  style: TextStyle(
                      fontSize: 16, color: Color.fromARGB(255, 207, 202, 187))),
            ),
            onDone: () async {
              Future<bool> result = _determinePosition();
              await result == true
                  ? Navigator.popAndPushNamed(context, '/accept')
                  : null;
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      print('serviceEnabled11111');
      return false;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        print('serviceEnable2222222');

        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      print('serviceEnable3333333');

      return false;
    }

    var teste = await Geolocator.getCurrentPosition();

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'latitude': teste.latitude.toString(),
      'longitude': teste.longitude.toString()
    });

    return true;
  }
}
