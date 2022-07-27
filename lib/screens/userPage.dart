import 'package:cached_network_image/cached_network_image.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:latlong2/latlong.dart' as lat;

class UserPage extends StatefulWidget {
  const UserPage({Key? key}) : super(key: key);

  @override
  State<UserPage> createState() => _UserPageState();
}

class _UserPageState extends State<UserPage> {
  int _current = 0;
  final CarouselController _controller = CarouselController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    var userList = arguments['info'];
    String name = userList['name'];
    String imagemLink = userList['soul'] + '.png';
    int typeInte = userList['typeInterested'];
    String interested = '';
    typeInte == 0 ? interested = 'Namoro' : interested = 'Amizade';
    double lati = double.parse(arguments['lat']);
    double latitude = double.parse(userList['latitude']);
    double long = double.parse(arguments['lng']);
    double longitude = double.parse(userList['longitude']);
    String occupation = userList['occupation'];
    String aboutMe = userList['aboutMe'];
    print(userList);
    int age = userList['age'];
    List photos = userList['photos'];
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
      child: Container(
        color: Colors.red,
        child: Scaffold(
          // floatingActionButton:
          //     Column(mainAxisAlignment: MainAxisAlignment.end, children: [
          //   FloatingActionButton(
          //     backgroundColor: const Color.fromARGB(255, 204, 171, 123),
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
          //     backgroundColor: const Color.fromARGB(255, 204, 171, 123),
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
            centerTitle: true,
            title: Text('${arguments['name']}',
                style: TextStyle(color: Colors.white)),
            leading: Container(
                decoration: BoxDecoration(
                    color: const Color.fromARGB(42, 86, 86, 86),
                    borderRadius: BorderRadius.circular(40)),
                child: const BackButton()),
            actions: const [],
          ),
          body: SingleChildScrollView(
            child: Container(
              color: const Color.fromARGB(255, 27, 27, 27),
              child: Column(children: [
                ClipPath(
                  clipper: CustomClipPath(),
                  child: Container(
                    height: size.height / 1.74,
                    width: size.width,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(10),
                          topLeft: Radius.circular(10),
                        ),
                        color: Color.fromARGB(255, 27, 27, 27)),
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topRight: Radius.circular(10),
                        topLeft: Radius.circular(10),
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
                            fadeInDuration: const Duration(milliseconds: 0),
                            fadeOutDuration: const Duration(milliseconds: 0),
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
                Container(
                  alignment: Alignment.centerLeft,
                  color: const Color.fromARGB(255, 27, 27, 27),
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
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 236, 200, 144),
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            const SizedBox(
                              width: 12,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(top: 15),
                              child: Text(
                                '$age',
                                style: const TextStyle(
                                    color: Color.fromARGB(255, 236, 200, 144),
                                    fontSize: 26,
                                    fontWeight: FontWeight.bold),
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
                          style: const TextStyle(
                              color: Color.fromARGB(255, 175, 147, 106),
                              fontSize: 20),
                        ),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Column(
                        children: [
                          Row(
                            children: [
                              infos(
                                text: userList['city'],
                                size: size,
                                icon: const FaIcon(
                                    FontAwesomeIcons.houseChimney,
                                    color: Color.fromARGB(255, 204, 171, 123)),
                              ),
                              infos(
                                text: '$km km',
                                size: size,
                                icon: const FaIcon(FontAwesomeIcons.locationDot,
                                    color: Color.fromARGB(255, 204, 171, 123)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              infos(
                                text: userList['height'].toString() + ' cm',
                                size: size,
                                icon: const FaIcon(FontAwesomeIcons.ruler,
                                    color: Color.fromARGB(255, 204, 171, 123)),
                              ),
                              infos(
                                text: userList['country'],
                                size: size,
                                icon: const FaIcon(FontAwesomeIcons.fontAwesome,
                                    color: Color.fromARGB(255, 204, 171, 123)),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              infos(
                                text: userList['zodiac'],
                                size: size,
                                icon: const FaIcon(
                                    FontAwesomeIcons.starAndCrescent,
                                    color: Color.fromARGB(255, 204, 171, 123)),
                              )
                            ],
                          ),
                          Row(
                            children: [
                              infos(
                                text: interested,
                                size: size,
                                icon: const FaIcon(
                                    FontAwesomeIcons.magnifyingGlass,
                                    color: Color.fromARGB(255, 204, 171, 123)),
                              )
                            ],
                          ),
                          const SizedBox(
                            height: 40,
                          ),
                          Row(
                            children: [
                              infos3(
                                  size: size,
                                  image: 'assets/images/$imagemLink',
                                  text: userList['soul']),
                            ],
                          )
                        ],
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 15),
                        child: Center(
                          child: const Text(
                            'Sobre mim',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 25, vertical: 8),
                        child: Text(
                          aboutMe,
                          style: const TextStyle(
                              letterSpacing: 0.2,
                              color: Color.fromARGB(255, 204, 171, 123),
                              fontSize: 20),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Column(
                        children: [
                          Container(
                            child: const Text(
                              'Meus Objetivos',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          const SizedBox(height: 20),
                          Container(
                            child: ListView.builder(
                                padding: EdgeInsets.zero,
                                shrinkWrap: true,
                                itemCount: userList['listFocus']?.length,
                                itemBuilder: (context, index) {
                                  String tex = '';
                                  int valor = userList['listFocus'][index];
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
                                      tex = 'CORRER como elementais do vento!';
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
                                  return ListTile(
                                      title: Text(
                                        tex,
                                        style: TextStyle(
                                            color: Color.fromARGB(
                                                255, 204, 171, 123)),
                                      ),
                                      onTap: () {});
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: Flexible(
                    child: Text(
                      'Proximidades de ${arguments['name']}',
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
                                  color: const Color.fromARGB(255, 62, 62, 62)),
                              borderRadius: BorderRadius.circular(8)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 0),
                              fadeOutDuration: const Duration(milliseconds: 0),
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
                                  color: const Color.fromARGB(255, 62, 62, 62)),
                              borderRadius: BorderRadius.circular(8)),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedNetworkImage(
                              fadeInDuration: const Duration(milliseconds: 0),
                              fadeOutDuration: const Duration(milliseconds: 0),
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
                  color: Color.fromARGB(255, 204, 171, 123), fontSize: 18),
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
                color: Color.fromARGB(255, 204, 171, 123), fontSize: 18),
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
                color: Color.fromARGB(255, 204, 171, 123), fontSize: 18),
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
