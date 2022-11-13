import 'dart:math';

import 'package:chamasgemeas/provider/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:chamasgemeas/model/user.dart';
import 'package:chamasgemeas/api/purchase_api.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:latlong2/latlong.dart' as lati;
import '../paywall_widget.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:fluttertoast/fluttertoast.dart';

class TinderCard extends StatefulWidget {
  final Users user;
  final bool isFront;

  const TinderCard({
    Key? key,
    required this.user,
    required this.isFront,
  }) : super(key: key);

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  double lat = 0;
  double lng = 0;

  @override
  void initState() {
    super.initState();
    LatLng();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final size = MediaQuery.of(context).size;

      final provider = Provider.of<CardProvider>(context, listen: false);
      provider.setScreenSize(size);
    });
  }

  @override
  Widget build(BuildContext context) => SizedBox.expand(
        child: widget.isFront ? buildFrontCard() : null,
      );
  void LatLng() async {
    final list =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (list.exists) {
      setState(() {
        lat = double.parse(list['latitude']);
        lng = double.parse(list['longitude']);
      });
    }
  }

  Widget buildFrontCard() => GestureDetector(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final provider = Provider.of<CardProvider>(context);
            final position = provider.position;
            final milliseconds = provider.isDragging ? 0 : 400;

            final center = constraints.smallest.center(Offset.zero);
            final angle = provider.angle * pi / 180;
            final rotatedMatrix = Matrix4.identity()
              ..translate(center.dx, center.dy)
              ..rotateZ(angle)
              ..translate(-center.dx, -center.dy);

            return AnimatedContainer(
              curve: Curves.easeInOut,
              duration: Duration(milliseconds: milliseconds),
              transform: rotatedMatrix..translate(position.dx, position.dy),
              child: Stack(
                children: [
                  buildCard(),
                  buildStamps(),
                ],
              ),
            );
          },
        ),
        onTap: () {
          Navigator.pushNamed(context, '/userHome');
        },
        // onPanStart: (details) {
        //   final provider = Provider.of<CardProvider>(context, listen: false);

        //   provider.startPosition(details);
        // },
        // onPanUpdate: (details) {
        //   final provider = Provider.of<CardProvider>(context, listen: false);

        //   provider.updatePosition(details);
        // },
        // onPanEnd: (details) {
        //   final provider = Provider.of<CardProvider>(context, listen: false);

        //   provider.endPosition();
        // },
      );

  Widget buildCard() => buildCardShadow(
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.user.urlImage),
                fit: BoxFit.cover,
                alignment: Alignment(-0.3, 0),
              ),
            ),
            child: Container(
              alignment: Alignment.bottomCenter,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.transparent,
                    Color.fromARGB(218, 218, 193, 136),
                    Color.fromARGB(218, 218, 193, 136),
                    Color.fromARGB(236, 218, 193, 136)
                  ],
                  begin: Alignment.center,
                  end: Alignment.bottomCenter,
                  stops: [0.2, 0.41, 0.55, 1],
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 80),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  buildName(),
                  buildOccupation(),
                ],
              ),
            ),
          ),
        ),
      );

  Widget buildCardShadow({required Widget child}) => ClipRRect(
        borderRadius: BorderRadius.circular(22),
        child: Container(
          padding: EdgeInsets.all(2),
          decoration: BoxDecoration(
            boxShadow: [
              BoxShadow(
                blurRadius: 20,
                color: Colors.white12,
              ),
            ],
          ),
          child: child,
        ),
      );

  Widget buildStamps() {
    final provider = Provider.of<CardProvider>(context);
    final status = provider.getStatus();
    final opacity = provider.getStatusOpacity();
    var distance = const lati.Distance();

    final km = distance.as(
        lati.LengthUnit.Kilometer,
        lati.LatLng(double.parse(widget.user.latitude),
            double.parse(widget.user.longitude)),
        lati.LatLng(lat, lng));

    switch (status) {
      case CardStatus.like:
        final child = buildStamp(
          angle: -0.5,
          color: Colors.green,
          text: 'LIKE',
          opacity: opacity,
        );

        return Positioned(top: 64, left: 50, child: child);
      case CardStatus.dislike:
        final child = buildStamp(
          angle: 0.5,
          color: Colors.red,
          text: 'NOPE',
          opacity: opacity,
        );

        return Positioned(top: 64, right: 50, child: child);
      case CardStatus.superLike:
        final child = Center(
          child: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                    color: Colors.blue.shade100.withOpacity(0.8),
                    blurRadius: 8,
                    spreadRadius: 8)
              ],
            ),
            child: buildStamp(
              color: Colors.blue,
              text: 'SUPER\nLIKE',
              opacity: opacity,
            ),
          ),
        );

        return Positioned(bottom: 128, right: 0, left: 0, child: child);
      default:
        return Container(
          padding: EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CircleAvatar(
                  radius: 15,
                  child: GestureDetector(
                      child: Icon(Icons.settings_backup_restore),
                      onTap: () {
                        fetchOffersPremium(uid);
                        print('clicked');
                      })),
              Container(
                padding: EdgeInsets.only(left: 20),
                child: GestureDetector(
                    child: Icon(
                      Icons.info,
                      color: Color.fromARGB(255, 248, 222, 162),
                    ),
                    onTap: () => showMaterialModalBottomSheet(
                          context: context,
                          builder: (context) => Container(
                            color: Color.fromARGB(108, 0, 0, 0),
                            height: MediaQuery.of(context).size.height * 0.15,
                            child: Container(
                              padding: EdgeInsets.all(5),
                              color: Colors.black87,
                              child: Wrap(
                                children: [
                                  TextButton(
                                    style: ElevatedButton.styleFrom(
                                      minimumSize: Size.fromHeight(50),
                                      textStyle: TextStyle(fontSize: 20),
                                    ),
                                    child: Text(
                                      'Reportar',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onPressed: () => sendEmail(
                                      name: widget.user.name,
                                      email: 'contato@chamasgemeas.com',
                                      subject: 'controllerSubject.text',
                                      message: 'controllerMessage.text',
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        )),
              ),
              Container(
                child: Center(
                    child: Text('$km km', style: TextStyle(fontSize: 11))),
                decoration: BoxDecoration(
                    color: Color.fromARGB(255, 248, 222, 162),
                    borderRadius: BorderRadius.circular(30)),
                height: 30,
                width: 70,
              )
            ],
          ),
        );
    }
  }

  Future sendEmail({
    required String name,
    required String email,
    required String subject,
    required String message,
  }) async {
    final serviceId = 'service_veh5s9i';
    final templateId = 'template_c5epiyk';
    final userId = 'xDYWDYgAVAzkk3hQ1';

    final url = Uri.parse('https://api.emailjs.com/api/v1.0/email/send');
    final response = await http.post(
      url,
      headers: {
        'origin': 'http://localhost',
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'service_id': serviceId,
        'template_id': templateId,
        'user_id': userId,
        'template_params': {
          'user_name': name,
          'user_email': email,
          'user_subject': widget.user.uid,
          'user_message': message,
        },
      }),
    );

    if (response.statusCode == 200) {
      Navigator.pop(context);
      final provider = Provider.of<CardProvider>(context, listen: false);

      provider.dislike();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            'Denuncia enviada com sucesso!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text(
            'Falha no envio da denuncia!',
            style: TextStyle(fontSize: 20),
          ),
        ),
      );
    }
  }

  Future fetchOffersPremium(user) async {
    final foundLikeMe =
        await FirebaseFirestore.instance.collection('users').doc(user).get();
    final provider = Provider.of<CardProvider>(context, listen: false);

    bool premium2 = foundLikeMe['premium'];

    if (premium2 == true) {
      provider.rollback();
      print('clicked2');
    } else {
      final offerings = await PurchaseApi.fetchOffers(all: false);

      if (offerings.isEmpty) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('No Plans Found')));
      } else {
        final packages = offerings
            .map((offer) => offer.availablePackages)
            .expand((pair) => pair)
            .toList();

        showMaterialModalBottomSheet(
          expand: false,
          context: context,
          backgroundColor: Color.fromARGB(231, 255, 255, 255),
          builder: (context) => PaywallWidget(
              packages: packages,
              title: 'Chamas Premium',
              description:
                  'Veja quem te curtiu e de uma segunda chance a quem não curtiu!.',
              onClickedPackage: (package) async {
                final isSuccess = await PurchaseApi.purchasePackage(package);
                if (isSuccess) {
                  await addCoinsPackag2ePremium(package);
                  await Fluttertoast.showToast(
                      msg: "Compra realizada com sucesso.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                      fontSize: 16.0);
                } else {
                  await Fluttertoast.showToast(
                      msg: "Falha na compra.",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 2,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }

                Navigator.pop(context);
              }),
        );

        final offer = offerings.first;
        print('Offer: $offer');
      }
    }
  }

  Future fetchOffers() async {
    final offerings = await PurchaseApi.fetchOffersByIds(Coins.allIds);

    if (offerings.isEmpty) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('No Plans Found')));
    } else {
      final packages = offerings
          .map((offer) => offer.availablePackages)
          .expand((pair) => pair)
          .toList();

      showMaterialModalBottomSheet(
        expand: false,
        context: context,
        backgroundColor: Color.fromARGB(231, 255, 255, 255),
        builder: (context) => PaywallWidget(
            packages: packages,
            title: 'Chamas Premium',
            description: 'Seja Premium para obter essa funcionalidade',
            onClickedPackage: (package) async {
              final isSuccess = await PurchaseApi.purchasePackage(package);

              if (isSuccess) {
                await addCoinsPackag2e(package);
                await Fluttertoast.showToast(
                    msg: "Compra realizada com sucesso.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.green,
                    textColor: Colors.white,
                    fontSize: 16.0);
              } else {
                await Fluttertoast.showToast(
                    msg: "Falha na compra.",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.CENTER,
                    timeInSecForIosWeb: 2,
                    backgroundColor: Colors.red,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

              Navigator.pop(context);
            }),
      );

      final offer = offerings.first;
      print('Offer: $offer');
    }
  }

  Future<void> addCoinsPackag2ePremium(Package package) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    print('>>>>>>>>');
    print(package.offeringIdentifier);
    print('<<<<<<<<<');
    print('>>>>>@@>>>');
    print(package.product.identifier);
    print('<<<<@@<<<<<');
    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'premium': true});
  }

  Future<void> addCoinsPackag2e(Package package) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    final foundLikeMe =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    int coins = foundLikeMe['coin'];

    print('>>>>>>>>');
    print(package.offeringIdentifier);
    print('<<<<<<<<<');
    switch (package.offeringIdentifier) {
      case Coins.idCoins1:
        coins += 1;
        break;
      default:
        break;
    }

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'coin': coins});
  }

  Widget buildStamp({
    double angle = 0,
    required Color color,
    required String text,
    required double opacity,
  }) {
    return Opacity(
      opacity: opacity,
      child: Transform.rotate(
        angle: angle,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color, width: 4),
          ),
          child: Text(
            text,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: color,
              fontSize: 48,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  Widget buildActive() => Row(
        children: [
          Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green,
            ),
            width: 12,
            height: 12,
          ),
          const SizedBox(width: 8),
          Text(
            'Recently Active',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      );

  Widget buildName() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.user.name,
            style: GoogleFonts.cinzelDecorative(
              fontSize: 23,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            ', ${widget.user.age}',
            style: GoogleFonts.cinzelDecorative(
                fontSize: 24, color: Colors.black, fontWeight: FontWeight.bold),
          ),
        ],
      );

  Widget buildOccupation() => Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.user.occupation,
            style: GoogleFonts.cinzelDecorative(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      );
}
