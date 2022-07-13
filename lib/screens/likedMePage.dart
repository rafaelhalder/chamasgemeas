import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class LikedMePage extends StatefulWidget {
  const LikedMePage({Key? key}) : super(key: key);

  @override
  State<LikedMePage> createState() => _LikedMePageState();
}

class _LikedMePageState extends State<LikedMePage> {
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Likes'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            children: [
              const Padding(
                padding: EdgeInsets.all(20.0),
                child: Center(child: Text('Revele quem gostou de você')),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.amber,
                ),
                height: 40,
                width: MediaQuery.of(context).size.width * 0.5,
                child: GestureDetector(
                  onTap: () {},
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
                                backgroundColor: Colors.transparent,
                                child: SizedBox(
                                    width: 140,
                                    height: 140,
                                    child: ClipOval(
                                      child: ClipRRect(
                                        child: ImageFiltered(
                                          imageFilter: ImageFilter.blur(
                                              sigmaX: 5, sigmaY: 5),
                                          child: CachedNetworkImage(
                                            fadeInDuration:
                                                const Duration(milliseconds: 0),
                                            fadeOutDuration:
                                                const Duration(milliseconds: 0),
                                            fit: BoxFit.cover,
                                            imageUrl: data[index]["photos"],
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
          ),
        ),
      ),
    );
  }

  Future<List> refreshList() async {
    List likedList = [];
    List likedList2 = [];

    final like =
        await FirebaseFirestore.instance.collection('liked_me').doc(uid).get();

    likedList = like['id'];

    for (int i = 0; i < likedList.length; i++) {
      var list = await FirebaseFirestore.instance
          .collection('users')
          .doc(likedList[i])
          .get();
      likedList2.add({
        'photos': list['photos'][0]['url'],
        'name': list['name'],
      });
    }

    return likedList2;
  }
}
