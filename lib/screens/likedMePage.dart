import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasgemeas/api/purchase_api.dart';
import 'package:chamasgemeas/paywall_widget.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

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
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 27, 27, 27),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 27, 27),
        centerTitle: true,
        title: const Text('Likes'),
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
                                        itemBuilder: (BuildContext ctx, index) {
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

                                              String lat = variable['latitude'];
                                              String lng =
                                                  variable['longitude'];

                                              Navigator.pushNamed(
                                                  context, '/userPage',
                                                  arguments: {
                                                    "uid": data[index]["uid"],
                                                    'name': data[index]["name"],
                                                    'info': data[index]["info"],
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
                                                          imageUrl: data[index]
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
                                  child: Text('Revele quem gostou de você')),
                            ),
                            GestureDetector(
                              onTap: () {
                                fetchOffers();
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.amber,
                                ),
                                height: 40,
                                width: MediaQuery.of(context).size.width * 0.5,
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
                                        itemBuilder: (BuildContext ctx, index) {
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
                                                          imageUrl: data[index]
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
        backgroundColor: Color.fromARGB(231, 0, 0, 0),
        builder: (context) => PaywallWidget(
            packages: packages,
            title: 'Chamas Premium',
            description: 'Veja quem te curtiu.',
            onClickedPackage: (package) async {
              final isSuccess = await PurchaseApi.purchasePackage(package);
              if (isSuccess) {
                await addCoinsPackag2e(package);
              }

              Navigator.pop(context);
            }),
      );

      final offer = offerings.first;
      print('Offer: $offer');
    }
  }

  Future<void> addCoinsPackag2e(Package package) async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .update({'premium': true});
  }

  Future<List> refreshList() async {
    List likedList = [];
    List likedList2 = [];

    // final like =
    //     await FirebaseFirestore.instance.collection('liked_me').doc(uid).get();
    final like = await FirebaseFirestore.instance
        .collection('liked_me')
        .doc(uid)
        // .doc('jMc5joRFQ3hicTIhI9Ti4nfUPqq1')
        .get();

    if (like.exists) {
      likedList = like['id'];

      for (int i = 0; i < likedList.length; i++) {
        var list = await FirebaseFirestore.instance
            .collection('users')
            .doc(likedList[i])
            .get();

        if (list['status'] == true) {
          likedList2.add({
            'photos': list['photos'][0]['url'],
            'name': list['name'],
            'uid': list['uid'],
            'info': list,
          });
        }
      }
    }

    return likedList2;
  }
}
