import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasgemeas/api/purchase_api.dart';
import 'package:chamasgemeas/paywall_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LikedMePage extends StatefulWidget {
  const LikedMePage({Key? key}) : super(key: key);

  @override
  State<LikedMePage> createState() => _LikedMePageState();
}

class _LikedMePageState extends State<LikedMePage> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  bool premium = false;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/interfacesigno.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Color.fromARGB(0, 27, 27, 27),
        appBar: AppBar(
          backgroundColor: Color.fromARGB(0, 27, 27, 27),
          centerTitle: true,
          title: Text(
            'Likes',
            style: GoogleFonts.cinzelDecorative(
                fontSize: 22,
                color: Color.fromARGB(255, 147, 132, 100),
                fontWeight: FontWeight.w600),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: FutureBuilder<bool>(
                future: getPremium(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return snapshot.data == true
                        ? Column(
                            children: [
                              FutureBuilder(
                                  future: refreshList(),
                                  builder: (context, AsyncSnapshot query) {
                                    if (query.hasData) {
                                      List data = query.data;
                                      return GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 200,
                                                  childAspectRatio: 2 / 2,
                                                  crossAxisSpacing: 20,
                                                  mainAxisSpacing: 20),
                                          itemCount: data.length,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return GestureDetector(
                                              onTap: () async {
                                                String? uid = FirebaseAuth
                                                    .instance.currentUser?.uid;

                                                DocumentSnapshot variable =
                                                    await FirebaseFirestore
                                                        .instance
                                                        .collection('users')
                                                        .doc(uid)
                                                        .get();

                                                String lat =
                                                    variable['latitude'];
                                                String lng =
                                                    variable['longitude'];

                                                Navigator.pushNamed(
                                                    context, '/userPage',
                                                    arguments: {
                                                      "uid": data[index]["uid"],
                                                      'name': data[index]
                                                          ["name"],
                                                      'info': data[index]
                                                          ["info"],
                                                      'lat': lat,
                                                      'lng': lng,
                                                    });
                                              },
                                              child: CircleAvatar(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  child: SizedBox(
                                                      width: 140,
                                                      height: 140,
                                                      child: ClipOval(
                                                        child: ClipRRect(
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            fadeOutDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            fit: BoxFit.cover,
                                                            imageUrl:
                                                                data[index]
                                                                    ["photos"],
                                                            width: 140,
                                                            height: 140,
                                                          ),
                                                        ),
                                                      ))),
                                            );
                                          });
                                    }
                                    return Container();
                                  }),
                            ],
                          )
                        : Column(
                            children: [
                              const Padding(
                                padding: EdgeInsets.all(20.0),
                                child: Center(
                                    child: Text(
                                  'Revele quem gostou de você',
                                  style: TextStyle(
                                      color:
                                          Color.fromARGB(255, 147, 132, 100)),
                                )),
                              ),
                              GestureDetector(
                                onTap: () {
                                  fetchOffers();
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(20),
                                    color: Color.fromARGB(255, 147, 132, 100),
                                  ),
                                  height: 40,
                                  width:
                                      MediaQuery.of(context).size.width * 0.5,
                                  child: const Center(
                                    child: Text('Revelar'),
                                  ),
                                ),
                              ),
                              FutureBuilder(
                                  future: refreshList(),
                                  builder: (context, AsyncSnapshot query) {
                                    if (query.hasData) {
                                      List data = query.data;
                                      return GridView.builder(
                                          shrinkWrap: true,
                                          gridDelegate:
                                              const SliverGridDelegateWithMaxCrossAxisExtent(
                                                  maxCrossAxisExtent: 200,
                                                  childAspectRatio: 2 / 2,
                                                  crossAxisSpacing: 20,
                                                  mainAxisSpacing: 20),
                                          itemCount: data.length,
                                          itemBuilder:
                                              (BuildContext ctx, index) {
                                            return CircleAvatar(
                                                backgroundColor:
                                                    Colors.transparent,
                                                child: SizedBox(
                                                    width: 140,
                                                    height: 140,
                                                    child: ClipOval(
                                                      child: ClipRRect(
                                                        child: ImageFiltered(
                                                          imageFilter:
                                                              ImageFilter.blur(
                                                                  sigmaX: 5,
                                                                  sigmaY: 5),
                                                          child:
                                                              CachedNetworkImage(
                                                            fadeInDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            fadeOutDuration:
                                                                const Duration(
                                                                    milliseconds:
                                                                        0),
                                                            fit: BoxFit.cover,
                                                            imageUrl:
                                                                data[index]
                                                                    ["photos"],
                                                            width: 140,
                                                            height: 140,
                                                          ),
                                                        ),
                                                      ),
                                                    )));
                                          });
                                    }
                                    return Container();
                                  }),
                            ],
                          );
                  }
                  return Container(
                    child: Text('ie'),
                  );
                }),
          ),
        ),
      ),
    );
  }

  Future<bool> getPremium() async {
    final foundLikeMe =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    bool premium2 = foundLikeMe['premium'];
    if (mounted) {
      setState(() {});
    }

    return premium2;
  }

  Future fetchOffers() async {
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
            description: 'Veja quem te curtiu.',
            onClickedPackage: (package) async {
              final isSuccess = await PurchaseApi.purchasePackage(package);
              print('Offer: $isSuccess');

              if (isSuccess) {
                await addCoinsPackage(package);
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

  Future<void> addCoinsPackage(Package package) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'premium': true});
  }

  Future<List> refreshList() async {
    List likedList = [];
    List likedListReturn = [];

    final like =
        await FirebaseFirestore.instance.collection('liked_me').doc(uid).get();

    if (like.exists) {
      likedList = like['id'];

      for (int i = 0; i < likedList.length; i++) {
        var list = await FirebaseFirestore.instance
            .collection('users')
            .doc(likedList[i])
            .get();

        likedListReturn.add({
          'photos': list['photos'][0]['url'],
          'name': list['name'],
          'uid': list['uid'],
          'info': list,
        });
      }
    }

    return likedListReturn;
  }
}
