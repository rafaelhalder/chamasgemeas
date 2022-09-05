import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:introduction_screen/introduction_screen.dart';

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
            text: const TextSpan(
              style: TextStyle(
                fontSize: 22.0,
                color: Color.fromARGB(255, 238, 238, 238),
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'Relacionamento de ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'Alma',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
              ],
            ),
          ),
          bodyWidget: Center(
              child: Text(
            "Não aceite relacionamentos rasos se você tem sentimentos profundos.",
            style: TextStyle(
                fontStyle: FontStyle.italic,
                fontSize: 20,
                color: Color.fromARGB(255, 207, 202, 187)),
          )),
          footer: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 238, 238, 238),
              ),
              children: <TextSpan>[
                TextSpan(
                    text:
                        'O Chamas Gêmeas é um caminho para você que já tem a consciência da tua '),
                TextSpan(
                    text: 'jornada espiritual ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
                TextSpan(
                    text:
                        'e que sabe que existe outra pessoa, na mesma jornada, procurando por você! Uma pessoa de '),
                TextSpan(
                    text: 'valor ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
                TextSpan(
                    text:
                        'que caminhará ao teu lado, que pode ler teus pensamentos, adivinhar teus desejos, pois apesar do tempo e do espaço, jamais esteve separarada em pensamento e sentimento! Essa é a tua '),
                TextSpan(
                    text: 'Chama Gêmea, ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
                TextSpan(
                    text:
                        'a tua alma espelho, que nesse exato momento busca também por '),
                TextSpan(
                    text: 'você!',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
              ],
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Color.fromARGB(0, 0, 0, 0),
          )),
      PageViewModel(
          titleWidget: Text(
            'Semelhante atrai Semelhante',
            style: TextStyle(
                fontSize: 22, color: Color.fromARGB(255, 207, 202, 187)),
          ),
          bodyWidget: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'O Universo não entende palavras, entende ',
                    style: const TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(
                    text: 'frequências.',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 204, 171, 123))),
              ],
            ),
          ),
          footer: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 19.0,
                color: Color.fromARGB(255, 238, 238, 238),
              ),
              children: <TextSpan>[
                TextSpan(text: 'No Universo  '),
                TextSpan(
                    text: 'semelhantes  ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
                TextSpan(text: 'se atraem.'),
                TextSpan(
                    text:
                        'A atração é por semelhança de interesses, gostos, pensamentos, atitudes e sentimentos. Se o destino te trouxe até aqui, certamente trouxe também quem está na mesma'),
                TextSpan(
                    text: 'frequência  ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
                TextSpan(text: 'que você, no mesmo momento de busca pela '),
                TextSpan(
                    text: 'Chama Gêmea, ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
                TextSpan(
                    text:
                        'com o mesmo sentimento inexplicável de saudedes de alguém que não conhece. Mas que na verdade, apenas não encontrou ainda nessa vida.'),
              ],
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Color.fromARGB(0, 0, 0, 0),
          )),
      PageViewModel(
          titleWidget: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 22.0,
                color: Color.fromARGB(255, 238, 238, 238),
              ),
              children: <TextSpan>[
                TextSpan(text: 'Ajude o Destino'),
              ],
            ),
          ),
          bodyWidget: RichText(
            text: TextSpan(
              style: const TextStyle(
                fontSize: 20.0,
                color: Color.fromARGB(255, 255, 255, 255),
              ),
              children: <TextSpan>[
                TextSpan(
                    text: 'O HOJE é o tempo certo para ',
                    style: const TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(
                    text: 'começar ',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 204, 171, 123))),
                TextSpan(
                    text: 'ou ',
                    style: const TextStyle(fontStyle: FontStyle.italic)),
                TextSpan(
                    text: 'recomeçar.',
                    style: const TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 204, 171, 123))),
              ],
            ),
          ),
          footer: RichText(
            text: const TextSpan(
              style: TextStyle(
                fontSize: 19.0,
                color: Color.fromARGB(255, 238, 238, 238),
              ),
              children: <TextSpan>[
                TextSpan(
                    text:
                        'Não deixe para depois o que você pode resolver no aqui e agora! No Chamas Gêmeas você encontrará uma '),
                TextSpan(
                    text: 'comunidade ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
                TextSpan(text: 'se atraem.'),
                TextSpan(
                    text:
                        'de pessoas com os mesmos interesses, que entendem o objetivo da vida e que dão valor aos '),
                TextSpan(
                    text: 'relacionamentos de alma. ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
                TextSpan(
                    text:
                        'Seja para um relacionamento ou amizade, aqui você poderá expressar livremente a tua '),
                TextSpan(
                    text: 'centelha divina ',
                    style:
                        TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
                TextSpan(
                    text:
                        'e encontrar pessoas que te valorizam pelo que você sabe e pelo que você é!'),
              ],
            ),
          ),
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
            globalBackgroundColor: Colors.transparent,
            pages: getPages(),
            showNextButton: true,
            next: Text('Avançar',
                style: TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
            showBackButton: true,
            back: Text("Voltar",
                style: TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
            done: Text("Concluir",
                style: TextStyle(color: Color.fromARGB(255, 204, 171, 123))),
            onDone: () async {
              Future<bool> result = _determinePosition();
              await result == true
                  ? Navigator.popAndPushNamed(context, '/register')
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
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
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
