import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/RegisterIAm.dart';
import 'package:chamasgemeas/screens/RegisterISearch.dart';
import 'package:chamasgemeas/screens/registerStep3.dart';
import 'package:chamasgemeas/screens/registerStep4.dart';
import 'package:chamasgemeas/screens/registerStep5.dart';
import 'package:chamasgemeas/screens/registerStep6.dart';
import 'package:chamasgemeas/screens/registerStep7.dart';
import 'package:chamasgemeas/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent, // transparent status bar
    ));
    return MaterialApp(
      title: 'Chamas Gêmeas',
      theme: ThemeData.dark(),
      home: AuthService().handleAuthState(),
      routes: {
        '/home': (context) => const HomePage(),
        '/register': (context) => RegisterIAm(),
        '/registerStep2': (context) => RegisterISearchPage(),
        '/registerStep3': (context) => RegisterStep3(),
        '/registerStep4': (context) => RegisterStep4(),
        '/registerStep5': (context) => RegisterStep5(),
        '/registerStep6': (context) => RegisterStep6Page(),
        '/registerStep7': (context) => RegisterStep7(),
      },
    );
  }
}
