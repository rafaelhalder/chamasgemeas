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
          titleWidget: Padding(
            padding: const EdgeInsets.all(50.0),
            child: Image.asset(
              'assets/images/ico.png',
              color: Color.fromARGB(62, 238, 238, 238),
              width: 200,
              height: 200,
              scale: 0.6,
            ),
          ),
          bodyWidget: Center(
              child: RichText(
            textAlign: TextAlign.center,
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
                        fontSize: 26,
                        color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text:
                        'Você precisa permitir a localização para usar o Chamas Gêmeas.',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 147, 132, 100))),
              ],
            ),
          )),
          footer: GestureDetector(
            onTap: () async {
              bool teste = await _determinePosition();
              if (teste == true) {
                print('saved position');
                Navigator.pushNamed(context, '/register');
              }
            },
            child: Container(
              height: 50,
              width: 300,
              child: Container(
                width: 300,
                height: 50,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    color: Color.fromARGB(255, 200, 181, 152)),
                child: Center(
                  child: Text(
                    'ATIVAR LOCALIZAÇÃO',
                    style: TextStyle(
                        color: Color.fromARGB(255, 0, 0, 0),
                        fontFamily: 'CM Sans Serif',
                        fontWeight: FontWeight.bold,
                        fontSize: 16),
                  ),
                ),
              ),
              decoration: BoxDecoration(
                  color: Colors.blue, borderRadius: BorderRadius.circular(30)),
            ),
          ),
          decoration: const PageDecoration(
            pageColor: Color.fromARGB(0, 0, 0, 0),
          )),
      PageViewModel(
          titleWidget: Text(''),
          footer: Center(
              child: RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: GoogleFonts.quicksand(
                  fontSize: 18,
                  color: Color.fromARGB(255, 207, 202, 187),
                  fontWeight: FontWeight.w700),
              children: <TextSpan>[
                TextSpan(
                    text: 'Conheça pessoas perto de você.\n',
                    style: TextStyle(
                        fontStyle: FontStyle.italic,
                        fontSize: 24,
                        color: Color.fromARGB(255, 207, 202, 187))),
                TextSpan(
                    text:
                        'Sua localização será usada para mostrar Matches em potencial para você.',
                    style: TextStyle(
                        fontSize: 20,
                        color: Color.fromARGB(255, 147, 132, 100))),
              ],
            ),
          )),
          bodyWidget: GestureDetector(
            onTap: () async {
              bool teste = await _determinePosition();
              if (teste == true) {
                print('saved position');
                Navigator.pushNamed(context, '/register');
              }
            },
            child: Padding(
              padding: const EdgeInsets.all(50.0),
              child: Container(
                height: 50,
                width: 300,
                child: Container(
                  width: 300,
                  height: 50,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color.fromARGB(255, 200, 181, 152)),
                  child: Center(
                    child: Text(
                      'ATIVAR LOCALIZAÇÃO',
                      style: TextStyle(
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontFamily: 'CM Sans Serif',
                          fontWeight: FontWeight.bold,
                          fontSize: 16),
                    ),
                  ),
                ),
                decoration: BoxDecoration(
                    color: Colors.blue,
                    borderRadius: BorderRadius.circular(30)),
              ),
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
            dotsDecorator: DotsDecorator(
              activeColor: Color.fromARGB(255, 147, 132, 100),
              color: Color.fromARGB(255, 207, 202, 187),
            ),
            globalBackgroundColor: Colors.transparent,
            pages: getPages(),
            showNextButton: true,
            next: Text('Conte mais',
                style: TextStyle(
                    fontSize: 17, color: Color.fromARGB(255, 147, 132, 100))),
            showBackButton: true,
            back: Text("Voltar",
                style: TextStyle(color: Color.fromARGB(255, 147, 132, 100))),
            done: Text(''),
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
    permission = await Geolocator.checkPermission();
    permission = await Geolocator.requestPermission();

    try {
      var teste = await Geolocator.getCurrentPosition();

      await FirebaseFirestore.instance.collection('users').doc(uid).update({
        'latitude': teste.latitude.toString(),
        'longitude': teste.longitude.toString()
      });
    } catch (e) {
      return false;
    }
    return true;
  }
}
