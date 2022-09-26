import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:chamasgemeas/provider/card_provider.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart' as lat;
import 'package:provider/provider.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:google_fonts/google_fonts.dart';

import 'HomePage.dart';

class UserPageHome extends StatefulWidget {
  const UserPageHome({Key? key}) : super(key: key);

  @override
  State<UserPageHome> createState() => _UserPageHomeState();
}

class _UserPageHomeState extends State<UserPageHome> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final provider = Provider.of<CardProvider>(context);
    final userData = provider.users.last;
    print(userData.zodiac);
    String name = userData.name.toUpperCase();
    String imagemLink = userData.soul + '.png';
    int typeInte = int.parse(userData.interested);
    String aboutMe = userData.aboutMe;
    String occupation = userData.occupation;
    int age = userData.age;
    List photos = userData.photos;
    double lati = provider.latUser;
    double long = provider.lngUser;
    double latitude = double.parse(userData.latitude);
    double longitude = double.parse(userData.longitude);

    String interested = '';
    typeInte == 0 ? interested = 'Namoro' : interested = 'Amizade';

    List filterPhoto = [];
    var distance = const lat.Distance();

    // km = 423
    final km = distance.as(lat.LengthUnit.Kilometer, lat.LatLng(lati, long),
        lat.LatLng(latitude, longitude));

    for (int i = 0; i < photos.length; i++) {
      if (photos[i]['name'] != 'nulo') {
        filterPhoto.add(photos[i]);
      }
    }
    var circleMarkers = <CircleMarker>[
      CircleMarker(
          point: lat.LatLng(latitude, longitude),
          color: Colors.blue.withOpacity(0.4),
          borderColor: const Color.fromARGB(255, 8, 133, 236),
          borderStrokeWidth: 1,
          useRadiusInMeter: true,
          radius: 1400 // 2000 meters | 2 km
          ),
    ];

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: SafeArea(
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
            image: AssetImage("assets/images/interfacesigno.png"),
            fit: BoxFit.cover,
          )),
          child: Scaffold(
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
            // floatingActionButton:
            //     Column(mainAxisAlignment: MainAxisAlignment.end, children: [
            //   FloatingActionButton(
            //     backgroundColor: const Color.fromARGB(255, 207, 202, 187),
            //     onPressed: () {
            //       //...
            //     },
            //     heroTag: null,
            //     child: const Icon(
            //       Icons.star,
            //       color: Colors.white,
            //     ),
            //   ),
            //   const SizedBox(
            //     height: 10,
            //   ),
            //   FloatingActionButton(
            //     backgroundColor: const Color.fromARGB(255, 207, 202, 187),
            //     onPressed: () {},
            //     heroTag: null,
            //     child: const FaIcon(
            //       FontAwesomeIcons.solidHeart,
            //       color: Colors.red,
            //     ),
            //   )
            // ]),
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              elevation: 0,
              backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 15),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image: AssetImage("assets/images/interfacesigno.png"),
                  fit: BoxFit.cover,
                )),
                child: Column(children: [
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
                                  autoPlayInterval: const Duration(seconds: 7),
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
                              itemBuilder: (context, itemIndex, realIndex) {
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
                        bottom: 10,
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
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
                            width: 68.0,
                            height: 30,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 2, vertical: 2),
                              decoration: BoxDecoration(
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  borderRadius: BorderRadius.circular(30)),
                              child: Center(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    FaIcon(FontAwesomeIcons.locationDot,
                                        size: 16),
                                    Text('$km km',
                                        style: TextStyle(color: Colors.black)),
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
                                    color: Color.fromARGB(255, 207, 202, 187),
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
                                    color: Color.fromARGB(255, 207, 202, 187),
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
                          padding: const EdgeInsets.symmetric(horizontal: 28),
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
                              text: userData.city,
                              size: size,
                              icon: const FaIcon(FontAwesomeIcons.houseChimney,
                                  color: Color.fromARGB(198, 255, 230, 180)),
                            ),
                            Row(
                              children: [
                                infos(
                                  text: userData.height.toString() + ' cm',
                                  size: size,
                                  icon: const FaIcon(FontAwesomeIcons.ruler,
                                      color:
                                          Color.fromARGB(198, 255, 230, 180)),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                infos(
                                  text: userData.zodiac,
                                  size: size,
                                  icon: const FaIcon(
                                      FontAwesomeIcons.starAndCrescent,
                                      color:
                                          Color.fromARGB(198, 255, 230, 180)),
                                )
                              ],
                            ),
                            infos(
                              text: interested,
                              size: size,
                              icon: const FaIcon(
                                  FontAwesomeIcons.magnifyingGlass,
                                  color: Color.fromARGB(198, 255, 230, 180)),
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 30),
                              child: Divider(
                                  thickness: 2,
                                  color: Color.fromARGB(255, 121, 108, 82)),
                            ),
                            Row(
                              children: [
                                infos3(
                                    size: size,
                                    image: 'assets/images/$imagemLink',
                                    text: userData.soul),
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
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 30),
                          child: Container(
                            width: size.width,
                            height: 120,
                            decoration: BoxDecoration(
                                border: Border.all(
                                  color: Color.fromARGB(197, 254, 235, 197),
                                ),
                                borderRadius: BorderRadius.circular(20)),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 8),
                            child: Text(
                              aboutMe,
                              style: const TextStyle(
                                  letterSpacing: 0.2,
                                  color: Color.fromARGB(198, 255, 230, 180),
                                  fontSize: 18),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 35),
                              child: const Text(
                                'INTERESSES:',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(height: 10),
                            Container(
                              child: ListView.builder(
                                  padding: EdgeInsets.zero,
                                  shrinkWrap: true,
                                  itemCount: userData.listFocus?.length,
                                  itemBuilder: (context, index) {
                                    String tex = '';
                                    int valor = userData.listFocus[index];
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
                                        tex = 'COZINHAR como alquimistas! ';
                                        break;
                                      case 6:
                                        tex = 'VIAJAR NAS CIDADES da Terra!';
                                        break;
                                      case 7:
                                        tex = 'VIAJAR NA NATUREZA intocada!';
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
                                        tex = 'Beber chás de PLANTAS DE PODER!';
                                        break;
                                      case 17:
                                        tex = 'Passear por PRAIAS desertas!';
                                        break;
                                      case 18:
                                        tex =
                                            'Jogar JOGOS em realidades alternativas!';
                                        break;
                                      case 19:
                                        tex = 'MEDITAR e um ashram na Índia!';
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
                                                      255, 207, 202, 187)),
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
                              color: const Color.fromARGB(255, 62, 62, 62)),
                          borderRadius: BorderRadius.circular(8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: CachedNetworkImage(
                          fadeInDuration: const Duration(milliseconds: 0),
                          fadeOutDuration: const Duration(milliseconds: 0),
                          fit: BoxFit.cover,
                          imageUrl: photos[0]['url'],
                          width: size.width,
                          height: size.height,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 10),
                    child: Flexible(
                      child: Text(
                        'Proximidades de ${userData.name}',
                        style: const TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(15),
                    child: Container(
                      height: size.height * 0.25,
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: const Color.fromARGB(255, 62, 62, 62)),
                          borderRadius: BorderRadius.circular(8)),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: FlutterMap(
                          options: MapOptions(
                            center: lat.LatLng(latitude, longitude),
                            zoom: 12.0,
                          ),
                          layers: [
                            TileLayerOptions(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: ['a', 'b', 'c']),
                            CircleLayerOptions(circles: circleMarkers)
                          ],
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
                                imageUrl: photos[1]['url'],
                                width: size.width,
                                height: size.height,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                  photos[2]['url'] != 'nulo'
                      ? Padding(
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
                                imageUrl: photos[2]['url'],
                                width: size.width,
                                height: size.height,
                              ),
                            ),
                          ),
                        )
                      : Container(),
                ]),
              ),
            ),
          ),
        ),
      ),
    );
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

class CustomClipPath extends CustomClipper<Path> {
  bool reverse;

  CustomClipPath({this.reverse = false});

  final int _coefficient = 16;
  double get _minStep => 1 / _coefficient;
  double get _preCenter => _minStep * (_coefficient / 2 - 1);
  double get _postCenter => _minStep * (_coefficient / 2 + 1);
  double get _preEnd => _minStep * (_coefficient - 2);

  @override
  Path getClip(Size size) {
    var path = Path();
    if (!reverse) {
      path.lineTo(0.0, size.height - 20);

      var firstControlPoint = Offset(size.width / 4, size.height);
      var firstEndPoint = Offset(size.width / 2.25, size.height - 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint =
          Offset(size.width - (size.width / 3.25), size.height - 65);
      var secondEndPoint = Offset(size.width, size.height - 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height - 40);
      path.lineTo(size.width, 0.0);
      path.close();
    } else {
      path.lineTo(0.0, 20);

      var firstControlPoint = Offset(size.width / 4, 0.0);
      var firstEndPoint = Offset(size.width / 2.25, 30.0);
      path.quadraticBezierTo(firstControlPoint.dx, firstControlPoint.dy,
          firstEndPoint.dx, firstEndPoint.dy);

      var secondControlPoint = Offset(size.width - (size.width / 3.25), 65);
      var secondEndPoint = Offset(size.width, 40);
      path.quadraticBezierTo(secondControlPoint.dx, secondControlPoint.dy,
          secondEndPoint.dx, secondEndPoint.dy);

      path.lineTo(size.width, size.height);
      path.lineTo(0.0, size.height);
      path.close();
    }

    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
