import 'dart:io';

import 'package:chamasgemeas/services/AuthenticationProvider.dart';
import 'package:chamasgemeas/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:video_player/video_player.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controller = VideoPlayerController.asset("assets/videos/chamas.mp4")
      ..initialize().then((_) {
        // Once the video has been loaded we play the video and set looping to true.
        _controller.play();
        _controller.setLooping(true);
        // Ensure the first frame is shown after the video is initialized.
        setState(() {});
      });
  }

  // TODO 8: Override the dipose() method to cleanup the video controller.
  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Scaffold(
        // TODO 6: Create a Stack Widget
        body: Stack(
          children: <Widget>[
            // TODO 7: Add a SizedBox to contain our video.
            SizedBox.expand(
              child: FittedBox(
                // If your background video doesn't look right, try changing the BoxFit property.
                // BoxFit.fill created the look I was going for.
                fit: BoxFit.cover,
                child: SizedBox(
                  width: _controller.value.size.width,
                  height: _controller.value.size.height,
                  child: VideoPlayer(_controller),
                ),
              ),
            ),
            if (Platform.isIOS)
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 30, vertical: 270),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Container(
                        height: size.height * 0.06,
                        width: size.width * 1,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(50)),
                        child: TextButton(
                          onPressed: () {
                            try {
                              context
                                  .read<AuthenticationProvider>()
                                  .signInWithApple();
                              if (FirebaseAuth.instance.currentUser?.uid !=
                                  null) {
                                Navigator.popAndPushNamed(context, '/home');
                              }
                            } catch (e) {
                              if (e is FirebaseAuthException) {
                                print(e);
                              }
                            }
                          },
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(
                                Color.fromARGB(18, 0, 0, 0)),
                            textStyle: MaterialStateProperty.all<TextStyle?>(
                                GoogleFonts.montserrat(
                                    color: Colors.pink,
                                    fontWeight: FontWeight.w500)),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24.0),
                                side: const BorderSide(color: Colors.white54),
                              ),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Image.asset('assets/images/apple-logo.png'),
                              Text(
                                'Entrar com o Apple',
                                style: GoogleFonts.quicksand(
                                    fontSize: 18,
                                    color: Color.fromARGB(218, 255, 255, 255),
                                    fontWeight: FontWeight.w600),
                              ),
                              const SizedBox(
                                width: 32,
                              )
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 200),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: size.height * 0.06,
                      width: size.width * 1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: TextButton(
                        onPressed: () {
                          try {
                            AuthService().signInWithGoogle();
                          } catch (e) {
                            if (e is FirebaseAuthException) {
                              print(e);
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(18, 0, 0, 0)),
                          textStyle: MaterialStateProperty.all<TextStyle?>(
                              GoogleFonts.montserrat(
                                  color: Colors.pink,
                                  fontWeight: FontWeight.w500)),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              side: const BorderSide(color: Colors.white54),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/google.png'),
                            Text(
                              'Entrar com o Google',
                              style: GoogleFonts.quicksand(
                                  fontSize: 18,
                                  color: Color.fromARGB(218, 255, 255, 255),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 32,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 30, vertical: 130),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Container(
                      height: size.height * 0.06,
                      width: size.width * 1,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(50)),
                      child: TextButton(
                        onPressed: () {
                          try {
                            AuthService().signInWithFacebook();
                          } catch (e) {
                            if (e is FirebaseAuthException) {
                              print(e);
                            }
                          }
                        },
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(
                              Color.fromARGB(51, 0, 0, 0)),
                          textStyle: MaterialStateProperty.all<TextStyle?>(
                            GoogleFonts.quicksand(
                                color: const Color.fromARGB(255, 255, 255, 255),
                                fontWeight: FontWeight.w500),
                          ),
                          shape:
                              MaterialStateProperty.all<RoundedRectangleBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(24.0),
                              side: const BorderSide(color: Colors.white54),
                            ),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Image.asset('assets/images/facebook.png'),
                            Text(
                              'Entrar com o Facebook',
                              style: GoogleFonts.quicksand(
                                  fontSize: 17,
                                  color: Color.fromARGB(218, 255, 255, 255),
                                  fontWeight: FontWeight.w600),
                            ),
                            const SizedBox(
                              width: 32,
                            )
                          ],
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  void doSignInApple() async {
    late ParseResponse parseResponse;
    try {
      //Set Scope
      final credential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
      );

      //https://docs.parseplatform.org/parse-server/guide/#apple-authdata
      //According to the documentation, we must send a Map with user authentication data.
      //Make sign in with Apple
      parseResponse = await ParseUser.loginWith('apple',
          apple(credential.identityToken!, credential.userIdentifier!));

      if (parseResponse.success) {
        final ParseUser parseUser = await ParseUser.currentUser() as ParseUser;

        //Additional Information in User
        if (credential.email != null) {
          parseUser.emailAddress = credential.email;
        }
        if (credential.givenName != null && credential.familyName != null) {
          parseUser.set<String>(
              'name', '${credential.givenName} ${credential.familyName}');
        }
        parseResponse = await parseUser.save();
        if (parseResponse.success) {
        } else {}
      } else {}
    } on Exception catch (e) {
      print(e.toString());
    }
  }
}
