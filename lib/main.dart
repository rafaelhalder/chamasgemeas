import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/RegisterIAm.dart';
import 'package:chamasgemeas/screens/RegisterISearch.dart';
import 'package:chamasgemeas/screens/chatDetail.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/filterPage.dart';
import 'package:chamasgemeas/screens/likedMePage.dart';
import 'package:chamasgemeas/screens/matchPage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/registerStep3.dart';
import 'package:chamasgemeas/screens/registerStep4.dart';
import 'package:chamasgemeas/screens/registerStep5.dart';
import 'package:chamasgemeas/screens/registerStep6.dart';
import 'package:chamasgemeas/screens/registerStep7.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:chamasgemeas/screens/userPage.dart';
import 'package:chamasgemeas/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'api/purchase_api.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await PurchaseApi.init();
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
        '/userPage': (context) => const UserPage(),
        '/profilePage': (context) => const ProfilePage(),
        '/chats': (context) => const Chats(),
        '/match': (context) => const MatchPage(),
        '/chat': (context) => const ChatDetail(),
        '/superlike': (context) => const SuperLike(),
        '/filter': (context) => const FilterPage(),
        '/likeMe': (context) => const LikedMePage(),
      },
    );
  }
}
