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
                    text: 'Ativar Localização.\n\n',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text:
                        'Você precisa permitir a localização para usar o tinder',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'Conheça pessoas perto de você',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text:
                        'Sua localização será usada para mostrar Matches em potencial perto de você',
                    style:
                        TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
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
                    text: 'Ativar Localização.\n\n',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text:
                        'Você precisa permitir a localização para usar o tinder',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text: 'Conheça pessoas perto de você',
                    style:
                        TextStyle(color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text:
                        'Sua localização será usada para mostrar Matches em potencial perto de você',
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
            next: Text('Conte mais',
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
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    try {
      var teste = await Geolocator.getCurrentPosition();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'latitude': teste.latitude.toString(),
        'longitude': teste.longitude.toString()
      });
    } catch (e) {
      print(e);
    }
    return true;
  }
}
