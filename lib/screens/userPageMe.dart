import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chamasgemeas/provider/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart' as lat;
import 'package:provider/provider.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:chamasgemeas/api/purchase_api.dart';
import 'package:chamasgemeas/paywall_widget.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import '../paywall_widget.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class UserPageMe extends StatefulWidget {
  const UserPageMe({Key? key}) : super(key: key);

  @override
  State<UserPageMe> createState() => _UserPageMeState();
}

class _UserPageMeState extends State<UserPageMe> {
  int _current = 0;
  final CarouselController _controller = CarouselController();
  String name = '';
  int age = 0;
  double latitude = 0.0;
  double longitude = 0.0;
  String occupation = '';
  String aboutMe = '';
  String city = '';
  String height = '';
  String interested = '';
  String soul = '';
  String zodiac = '';
  List photos = [];
  List listFocus = [];
  List filterPhoto = [];
  String imagemLink = '';

  @override
  void initState() {
    load();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/foto22.png"),
          fit: BoxFit.cover,
        )),
        child: SafeArea(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            bottomNavigationBar: ConvexAppBar(
              color: Colors.black,
              gradient: const LinearGradient(colors: [
                Color.fromARGB(255, 211, 202, 189),
                Color.fromARGB(255, 211, 202, 189),
              ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
              // ignore: prefer_const_literals_to_create_immutables
              items: [
                // ignore: prefer_const_constructors
                TabItem(
                    activeIcon: Container(
                        alignment: Alignment.center,
                        child: FaIcon(FontAwesomeIcons.yinYang,
                            color: Colors.black)),
                    icon: FaIcon(FontAwesomeIcons.yinYang, color: Colors.black),
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
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            ),
            body: photos.length > 0
                ? Container(
                    child: SingleChildScrollView(
                        child: Column(
                      children: [
                        Stack(
                          children: [
                            Align(
                              alignment: Alignment.topCenter,
                              child: Container(
                                height: size.height / 1.74,
                                width: size.width * 0.9,
                                decoration: const BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                      topRight: Radius.circular(30),
                                      topLeft: Radius.circular(30),
                                    ),
                                    color: Colors.transparent),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.only(
                                    topRight: Radius.circular(30),
                                    topLeft: Radius.circular(30),
                                  ),
                                  child: CarouselSlider.builder(
                                    carouselController: _controller,
                                    options: CarouselOptions(
                                        height: size.height,
                                        autoPlay: false,
                                        autoPlayInterval:
                                            const Duration(seconds: 7),
                                        reverse: false,
                                        viewportFraction: 1,
                                        aspectRatio: 2.0,
                                        initialPage: 0,
                                        enableInfiniteScroll: true,
                                        autoPlayAnimationDuration:
                                            const Duration(milliseconds: 800),
                                        autoPlayCurve: Curves.fastOutSlowIn,
                                        scrollDirection: Axis.horizontal,
                                        onPageChanged: (index, reason) {
                                          setState(() {
                                            _current = index;
                                          });
                                        }),
                                    itemCount: filterPhoto.length,
                                    itemBuilder:
                                        (context, itemIndex, realIndex) {
                                      return CachedNetworkImage(
                                        fadeInDuration:
                                            const Duration(milliseconds: 0),
                                        fadeOutDuration:
                                            const Duration(milliseconds: 0),
                                        fit: BoxFit.cover,
                                        imageUrl: filterPhoto[itemIndex]['url'],
                                        width: size.width,
                                        height: size.height,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                            Positioned.fill(
                              top: 20,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: filterPhoto.map((url) {
                                    int index = filterPhoto.indexOf(url);
                                    return Container(
                                      width: 20.0,
                                      height: 10.0,
                                      margin: EdgeInsets.symmetric(
                                          vertical: 4.0, horizontal: 2.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        shape: BoxShape.rectangle,
                                        color: _current == index
                                            ? Color.fromARGB(153, 231, 231, 231)
                                            : Color.fromRGBO(0, 0, 0, 0.4),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 34, vertical: 12),
                              child: Align(
                                alignment: Alignment.centerRight,
                                child: Container(
                                  width: 60.0,
                                  height: 30,
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 2, vertical: 2),
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(255, 248, 222, 162),
                                        borderRadius:
                                            BorderRadius.circular(30)),
                                    child: Center(
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceAround,
                                        children: [
                                          FaIcon(FontAwesomeIcons.locationDot,
                                              size: 14),
                                          Text('0 km',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12)),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          color: Colors.transparent,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 25,
                                ),
                                child: Row(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Text(
                                        '$name,',
                                        style: GoogleFonts.quicksand(
                                          color: Color.fromARGB(
                                              255, 207, 202, 187),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 12,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(top: 15),
                                      child: Text(
                                        '$age',
                                        style: GoogleFonts.quicksand(
                                          color: Color.fromARGB(
                                              255, 207, 202, 187),
                                          fontSize: 22,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 25, vertical: 5),
                                child: Text(
                                  occupation,
                                  style: GoogleFonts.quicksand(
                                    color: Color.fromARGB(255, 194, 180, 129),
                                    fontSize: 22,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 28),
                                child: Divider(
                                    thickness: 2,
                                    color: Color.fromARGB(255, 121, 108, 82)),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  infos(
                                    text: city,
                                    size: size,
                                    icon: const FaIcon(
                                        FontAwesomeIcons.houseChimney,
                                        color:
                                            Color.fromARGB(198, 255, 230, 180)),
                                  ),
                                  Row(
                                    children: [
                                      infos(
                                        text: height.toString() + ' cm',
                                        size: size,
                                        icon: const FaIcon(
                                            FontAwesomeIcons.ruler,
                                            color: Color.fromARGB(
                                                198, 255, 230, 180)),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      infos(
                                        text: zodiac,
                                        size: size,
                                        icon: const FaIcon(
                                            FontAwesomeIcons.starAndCrescent,
                                            color: Color.fromARGB(
                                                198, 255, 230, 180)),
                                      )
                                    ],
                                  ),
                                  infos(
                                    text: interested,
                                    size: size,
                                    icon: const FaIcon(
                                        FontAwesomeIcons.magnifyingGlass,
                                        color:
                                            Color.fromARGB(198, 255, 230, 180)),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 30),
                                    child: Divider(
                                        thickness: 2,
                                        color:
                                            Color.fromARGB(255, 121, 108, 82)),
                                  ),
                                  Row(
                                    children: [
                                      infos3(
                                          size: size,
                                          image: 'assets/images/$imagemLink',
                                          text: soul),
                                    ],
                                  )
                                ],
                              ),
                              const SizedBox(height: 20),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 35, vertical: 15),
                                child: const Text(
                                  'Sobre mim',
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 207, 202, 187),
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 30),
                                child: Container(
                                  width: size.width,
                                  height: 120,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                        color:
                                            Color.fromARGB(197, 254, 235, 197),
                                      ),
                                      borderRadius: BorderRadius.circular(20)),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 25, vertical: 8),
                                  child: Text(
                                    aboutMe,
                                    style: const TextStyle(
                                        letterSpacing: 0.2,
                                        color:
                                            Color.fromARGB(198, 255, 230, 180),
                                        fontSize: 18),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 35),
                                    child: const Text(
                                      'INTERESSES:',
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 207, 202, 187),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    child: ListView.builder(
                                        padding: EdgeInsets.zero,
                                        shrinkWrap: true,
                                        itemCount: listFocus.length,
                                        itemBuilder: (context, index) {
                                          String tex = '';
                                          int valor = listFocus[index];
                                          switch (valor) {
                                            case 0:
                                              tex = '';
                                              break;
                                            case 1:
                                              tex =
                                                  'Com a chama gêmea construir uma FAMÍLIA COM FILHOS!';
                                              break;
                                            case 2:
                                              tex =
                                                  'Com a chama gêmea construir uma FAMÍLIA COM PETS!';
                                              break;
                                            case 3:
                                              tex =
                                                  'CONVERSAR sobre o que ninguém entende!';
                                              break;
                                            case 4:
                                              tex =
                                                  'CURAR O MUNDO com trabalho ativista!';
                                              break;
                                            case 5:
                                              tex =
                                                  'COZINHAR como alquimistas! ';
                                              break;
                                            case 6:
                                              tex =
                                                  'VIAJAR NAS CIDADES da Terra!';
                                              break;
                                            case 7:
                                              tex =
                                                  'VIAJAR NA NATUREZA intocada!';
                                              break;
                                            case 8:
                                              tex =
                                                  'LER sobre os mistérios do Universo!';
                                              break;
                                            case 9:
                                              tex =
                                                  'Assistir FILMES nas noites de tempestade!';
                                              break;
                                            case 10:
                                              tex =
                                                  'Jantar em RESTAURANTES à luz de velas!';
                                              break;
                                            case 11:
                                              tex =
                                                  'Passear com os PETS enquanto conversamos!';
                                              break;
                                            case 12:
                                              tex =
                                                  'Apreciar ARTE nos museus e exposições exclusivas!';
                                              break;
                                            case 13:
                                              tex =
                                                  'Ir a SHOWS DE MÚSICA de bandas fantásticas!';
                                              break;
                                            case 14:
                                              tex =
                                                  'Fazer COMPRAS de cristais, livros e incensos!';
                                              break;
                                            case 15:
                                              tex =
                                                  'CORRER como elementais do vento!';
                                              break;
                                            case 16:
                                              tex =
                                                  'Beber chás de PLANTAS DE PODER!';
                                              break;
                                            case 17:
                                              tex =
                                                  'Passear por PRAIAS desertas!';
                                              break;
                                            case 18:
                                              tex =
                                                  'Jogar JOGOS em realidades alternativas!';
                                              break;
                                            case 19:
                                              tex =
                                                  'MEDITAR e um ashram na Índia!';
                                              break;
                                            case 20:
                                              tex =
                                                  'FOTOGRAFAR com os olhos de um mago!';
                                              break;
                                            case 21:
                                              tex = 'DANÇAR como dervishes!';
                                              break;
                                          }
                                          return Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16, vertical: 6),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                border: Border.all(
                                                    color: Color.fromARGB(
                                                        197, 254, 235, 197)),
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: ListTile(
                                                  title: Text(
                                                    tex,
                                                    style: TextStyle(
                                                        fontSize: 14,
                                                        color: Color.fromARGB(
                                                            255,
                                                            207,
                                                            202,
                                                            187)),
                                                  ),
                                                  onTap: () {}),
                                            ),
                                          );
                                        }),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: Container(
                            height: size.height * 0.46,
                            decoration: BoxDecoration(
                                border: Border.all(
                                    color:
                                        const Color.fromARGB(255, 62, 62, 62)),
                                borderRadius: BorderRadius.circular(8)),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                fadeInDuration: const Duration(milliseconds: 0),
                                fadeOutDuration:
                                    const Duration(milliseconds: 0),
                                fit: BoxFit.cover,
                                imageUrl: photos[0]['url'],
                                width: size.width,
                                height: size.height,
                              ),
                            ),
                          ),
                        ),
                        photos[1]['url'] != 'nulo'
                            ? Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  height: size.height * 0.46,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: Color.fromARGB(255, 0, 0, 0)),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 0),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 0),
                                      fit: BoxFit.cover,
                                      imageUrl: photos[1]['url'],
                                      width: size.width,
                                      height: size.height,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.transparent,
                              ),
                        photos[2]['url'] != 'nulo'
                            ? Padding(
                                padding: const EdgeInsets.all(15),
                                child: Container(
                                  height: size.height * 0.46,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: const Color.fromARGB(
                                              255, 62, 62, 62)),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8),
                                    child: CachedNetworkImage(
                                      fadeInDuration:
                                          const Duration(milliseconds: 0),
                                      fadeOutDuration:
                                          const Duration(milliseconds: 0),
                                      fit: BoxFit.cover,
                                      imageUrl: photos[2]['url'],
                                      width: size.width,
                                      height: size.height,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                color: Colors.transparent,
                              )
                      ],
                    )),
                  )
                : Text(''),
          ),
        ),
      ),
    );
  }

  void load() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;
    String prucura = '';
    List filtrada = [];
    final userList =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();
    for (int i = 0; i < userList['photos'].length; i++) {
      if (userList['photos'][i]['name'] != 'nulo') {
        filtrada.add(userList['photos'][i]);
      }
    }
    userList['typeInterested'] == 0 ? prucura = 'Namoro' : prucura = 'Amizade';

    if (mounted)
      setState(() {
        age = userList['age'];
        name = userList['name'];
        occupation = userList['occupation'];
        aboutMe = userList['aboutMe'];
        city = userList['city'];
        height = userList['height'];
        interested = prucura;
        soul = userList['soul'];
        zodiac = userList['zodiac'];
        photos = userList['photos'];
        listFocus = userList['listFocus'];
        filterPhoto = filtrada;
        imagemLink = userList['soul'] + '.png';

        print(age);
        print(imagemLink);
      });
  }
}

class infos extends StatelessWidget {
  const infos({
    Key? key,
    required this.size,
    required this.icon,
    required this.text,
  }) : super(key: key);

  final Size size;
  final FaIcon icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      width: size.width * 0.5,
      child: Row(
        children: [
          icon,
          const SizedBox(
            width: 10,
          ),
          Flexible(
            child: Text(
              text,
              maxLines: 2,
              style: const TextStyle(
                  color: Color.fromARGB(255, 145, 130, 99), fontSize: 17),
            ),
          ),
        ],
      ),
    );
  }
}

class infos2 extends StatelessWidget {
  const infos2({
    Key? key,
    required this.size,
    required this.image,
    required this.text,
  }) : super(key: key);

  final Size size;
  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      width: size.width * 0.5,
      child: Row(
        children: [
          Image.asset(
            image,
            width: 60,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(
                color: Color.fromARGB(255, 84, 75, 57), fontSize: 18),
          ),
        ],
      ),
    );
  }
}

class infos3 extends StatelessWidget {
  const infos3({
    Key? key,
    required this.size,
    required this.image,
    required this.text,
  }) : super(key: key);

  final Size size;
  final String image;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 9),
      width: size.width * 0.8,
      child: Row(
        children: [
          Image.asset(
            image,
            width: 60,
          ),
          const SizedBox(
            width: 10,
          ),
          Text(
            text,
            style: const TextStyle(
                color: Color.fromARGB(198, 255, 230, 180), fontSize: 18),
          ),
        ],
      ),
    );
  }
}
