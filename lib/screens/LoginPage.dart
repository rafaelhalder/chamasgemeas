import 'package:chamasgemeas/services/auth_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';

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
            Padding(
              padding: const EdgeInsets.only(left: 30, right: 30, top: 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Center(
                      child: Container(
                        height: size.height * 0.4,
                        width: size.width * 0.7,
                        decoration: BoxDecoration(boxShadow: [
                          BoxShadow(
                            color: const Color.fromARGB(255, 0, 0, 0)
                                .withOpacity(0.0),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ], borderRadius: BorderRadius.circular(50)),
                        child: Image.asset('assets/images/ads-removebg.png',
                            height: size.height * 0.80),
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
                                  fontSize: 20,
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
                                  fontSize: 20,
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
}
