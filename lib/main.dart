import 'package:chamasgemeas/screens/HelpPage.dart';
import 'package:chamasgemeas/provider/card_provider.dart';
import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/LoginPage.dart';
import 'package:chamasgemeas/screens/PrivacidadePage.dart';
import 'package:chamasgemeas/screens/RegisterIAm.dart';
import 'package:chamasgemeas/screens/RegisterISearch.dart';
import 'package:chamasgemeas/screens/chatDetail.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/filterPage.dart';
import 'package:chamasgemeas/screens/likedMePage.dart';
import 'package:chamasgemeas/screens/matchPage.dart';
import 'package:chamasgemeas/screens/matchUsers.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/registerStep3.dart';
import 'package:chamasgemeas/screens/registerStep4.dart';
import 'package:chamasgemeas/screens/registerStep5.dart';
import 'package:chamasgemeas/screens/registerStep6.dart';
import 'package:chamasgemeas/screens/registerStep7.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:chamasgemeas/screens/termsAccept.dart';
import 'package:chamasgemeas/screens/userPage.dart';
import 'package:chamasgemeas/screens/userPageHome.dart';
import 'package:chamasgemeas/services/AuthenticationProvider.dart';
import 'package:chamasgemeas/services/auth_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'api/purchase_api.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // If you're going to use other Firebase services in the background, such as Firestore,
  // make sure you call `initializeApp` before using other Firebase services.
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await FirebaseMessaging.instance.getInitialMessage();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
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

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => CardProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AuthenticationProvider(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (BuildContext context) {
            return context.read<AuthenticationProvider>().authStateChanges;
          },
          initialData: null,
        )
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Chamas Gêmeas',
        themeMode: ThemeMode.dark,
        // darkTheme: ThemeData(
        //     secondaryHeaderColor: Colors.black, brightness: Brightness.dark),
        theme: ThemeData(
            elevatedButtonTheme: ElevatedButtonThemeData(
                style: ElevatedButton.styleFrom(
                    elevation: 8,
                    primary: Colors.white,
                    shape: CircleBorder(),
                    minimumSize: Size.square(80))),
            backgroundColor: Colors.black,
            colorScheme: ColorScheme.fromSwatch().copyWith(
              secondary: Colors.amber, // Your accent color
            ),
            primarySwatch: Colors.amber,
            brightness: Brightness.light),
        home: AuthService().handleAuthState(),
        routes: {
          '/login': (context) => const LoginPage(),
          '/home': (context) => HomePage(),
          '/register': (context) => RegisterIAm(),
          '/registerStep2': (context) => RegisterISearchPage(),
          '/registerStep3': (context) => RegisterStep3(),
          '/registerStep4': (context) => RegisterStep4(),
          '/registerStep5': (context) => RegisterStep5(),
          '/registerStep6': (context) => RegisterStep6Page(),
          '/registerStep7': (context) => RegisterStep7(),
          '/userPage': (context) => const UserPage(),
          '/userHome': (context) => const UserPageHome(),
          '/profilePage': (context) => const ProfilePage(),
          '/chats': (context) => const Chats(),
          '/match': (context) => const MatchPage(),
          '/chat': (context) => const ChatDetail(),
          '/matchScreen': (context) => MatchUsers(),
          '/superlike': (context) => const SuperLike(),
          '/filter': (context) => const FilterPage(),
          '/likeMe': (context) => const LikedMePage(),
          '/preference': (context) => const PreferencePage(),
          '/privacidade': (context) => const PrivacidadePage(),
          '/help': (context) => const HelpPage(),
          '/accept': (context) => TermsAccept(),
        },
      ),
    );
  }
}
