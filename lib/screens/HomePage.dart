import 'package:chamasgemeas/provider/card_provider.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../widget/tinder_card.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/interfacesigno.png"),
          fit: BoxFit.cover,
        )),
        child: Scaffold(
          appBar: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Color.fromARGB(128, 0, 0, 0),
            leading: Image.asset(
              'assets/images/logo.png',
              height: 45,
            ),
            title: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/likeMe');
              },
              icon:
                  const FaIcon(FontAwesomeIcons.solidHeart, color: Colors.red),
            ),
            centerTitle: true,
            leadingWidth: MediaQuery.of(context).size.width,
            actions: [
              Builder(
                builder: (context) => IconButton(
                  icon: const Icon(Icons.list_outlined),
                  onPressed: () => Navigator.pushNamed(context, '/filter'),
                ),
              )
            ],
          ),
          bottomNavigationBar: ConvexAppBar(
            color: Colors.black,
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 223, 223, 223),
              Color.fromARGB(255, 223, 223, 223),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              // ignore: prefer_const_constructors
              TabItem(
                  activeIcon: Icon(Icons.home, color: Colors.black),
                  icon: Icon(Icons.home, color: Colors.black),
                  title: 'Home'),
              const TabItem(
                  activeIcon: Icon(Icons.star, color: Colors.black),
                  icon: Icon(Icons.star, color: Colors.black),
                  title: 'Super'),
              const TabItem(
                  activeIcon: Icon(Icons.person, color: Colors.black),
                  icon: Icon(Icons.person, color: Colors.black),
                  title: 'Perfil'),
              const TabItem(
                  activeIcon: Icon(Icons.message, color: Colors.black),
                  icon: Icon(Icons.message, color: Colors.black),
                  title: 'Chats'),
              const TabItem(
                  activeIcon: Icon(Icons.settings, color: Colors.black),
                  icon: Icon(Icons.settings, color: Colors.black),
                  title: 'Opções'),
            ],
            initialActiveIndex: 0, //optional, default as 0
            onTap: (int i) {
              i == 0
                  ? Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            HomePage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    )
                  : const Text('');
              i == 1
                  ? Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            SuperLike(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    )
                  : const Text('');
              i == 2
                  ? Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            // Container(),
                            const ProfilePage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    )
                  : const Text('');
              i == 3
                  ? Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            // Container(),
                            const Chats(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    )
                  : const Text('');
              i == 4
                  ? Navigator.pushReplacement(
                      context,
                      PageRouteBuilder(
                        pageBuilder: (context, animation1, animation2) =>
                            const PreferencePage(),
                        transitionDuration: Duration.zero,
                        reverseTransitionDuration: Duration.zero,
                      ),
                    )
                  : const Text('');

              print('click index=$i');
            },
          ),
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  Container(
                      height: MediaQuery.of(context).size.height * 0.70,
                      child: buildCards()),
                  Align(
                      alignment: Alignment.bottomCenter,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 22),
                        child: Container(
                            width: MediaQuery.of(context).size.width * 0.75,
                            padding: EdgeInsets.symmetric(vertical: 5),
                            decoration: BoxDecoration(
                                color: Color.fromARGB(255, 207, 202, 189),
                                borderRadius: BorderRadius.circular(40)),
                            child: buildButtons()),
                      )),
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildCards() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;

    return users.isEmpty
        ? Center(
            child: Text(
              '💔  The End.',
              style: TextStyle(
                fontSize: 42,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          )
        : Stack(
            children: users
                .map((user) => TinderCard(
                      user: user,
                      isFront: users.last == user,
                    ))
                .toList(),
          );
  }

  Widget buildButtons() {
    final provider = Provider.of<CardProvider>(context);
    final users = provider.users;
    final status = provider.getStatus();
    final isLike = status == CardStatus.like;
    final isDislike = status == CardStatus.dislike;
    final isSuperLike = status == CardStatus.superLike;

    return users.isEmpty
        ? ElevatedButton(
            style: ElevatedButton.styleFrom(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: Text(
              'Reiniciar',
              style: TextStyle(color: Colors.black),
            ),
            onPressed: () {
              final provider =
                  Provider.of<CardProvider>(context, listen: false);

              provider.resetUsers();
            },
          )
        : Container(
            height: 70,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        getColor(Colors.white, Colors.white, isDislike),
                    backgroundColor:
                        getColor(Colors.grey, Colors.red, isDislike),
                    side: getBorder(Colors.white, Colors.white, isDislike),
                  ),
                  child: Icon(Icons.clear, size: 46),
                  onPressed: () {
                    final provider =
                        Provider.of<CardProvider>(context, listen: false);
                    provider.dislike();
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        getColor(Colors.white, Colors.white, isSuperLike),
                    backgroundColor:
                        getColor(Colors.amber, Colors.amber, isSuperLike),
                    side: getBorder(Colors.white, Colors.white, isSuperLike),
                  ),
                  child: Icon(Icons.star, size: 40),
                  onPressed: () {
                    final provider =
                        Provider.of<CardProvider>(context, listen: false);

                    provider.superLike();
                  },
                ),
                ElevatedButton(
                  style: ButtonStyle(
                    foregroundColor:
                        getColor(Colors.white, Colors.white, isLike),
                    backgroundColor: getColor(Colors.pink, Colors.pink, isLike),
                    side: getBorder(Colors.white, Colors.white, isLike),
                  ),
                  child: Icon(Icons.favorite, size: 40),
                  onPressed: () {
                    final provider =
                        Provider.of<CardProvider>(context, listen: false);

                    String actualUser = users.last.uid.toString();

                    print(actualUser);
                    provider.like();
                    verifyMatch(actualUser);
                  },
                ),
              ],
            ),
          );
  }

  verifyMatch(actualUser) async {
    List likedMe = [];

    final foundLikeMe =
        await FirebaseFirestore.instance.collection('liked_me').doc(uid).get();
    if (foundLikeMe.exists) {
      likedMe = foundLikeMe['id'];
    }

    if (likedMe.contains(actualUser)) {
      Navigator.pushNamed(context, '/matchScreen');
    }
  }

  MaterialStateProperty<Color> getColor(
      Color color, Color colorPressed, bool force) {
    final getColor = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return colorPressed;
      } else {
        return color;
      }
    };

    return MaterialStateProperty.resolveWith(getColor);
  }

  MaterialStateProperty<BorderSide> getBorder(
      Color color, Color colorPressed, bool force) {
    final getBorder = (Set<MaterialState> states) {
      if (force || states.contains(MaterialState.pressed)) {
        return BorderSide(color: Colors.transparent);
      } else {
        return BorderSide(color: color, width: 2);
      }
    };

    return MaterialStateProperty.resolveWith(getBorder);
  }
}
