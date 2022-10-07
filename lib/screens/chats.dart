import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:chamasgemeas/screens/chatDetail.dart';
import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:chamasgemeas/states/lib.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  var currentUser = FirebaseAuth.instance.currentUser?.uid;
  List available = [];

  @override
  void initState() {
    chatState.refreshChatsForCurrentUser();
    teste();
    super.initState();
  }

  void callChatDetailScreen(
      BuildContext context, String friendUid, String name) {
    Navigator.push(
        context,
        CupertinoPageRoute(
            builder: (context) =>
                ChatDetail(friendUid: friendUid, friendName: name)));
  }

  @override
  Widget build(BuildContext context) {
    String defaultPhoto =
        'https://firebasestorage.googleapis.com/v0/b/chamas-gemeas.appspot.com/o/images%2Fdefault%2Fperson_blank.png?alt=media&token=a48cac17-1f89-4aed-a0b2-ba38699d516f';
    print(chatState);

    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/interfacesigno.png"),
        fit: BoxFit.cover,
      )),
      child: WillPopScope(
        onWillPop: () async => false,
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
            initialActiveIndex: 3, //optional, default as 0
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
                            const SuperLike(),
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
          body: Observer(
              builder: (BuildContext context) => CustomScrollView(
                    slivers: [
                      CupertinoSliverNavigationBar(
                        leading: Text(''),
                        backgroundColor: Colors.transparent,
                        largeTitle: Text(
                          'Chamas Gêmeas',
                          style: GoogleFonts.cinzelDecorative(
                              fontSize: 25,
                              color: Color.fromARGB(255, 147, 132, 100),
                              fontWeight: FontWeight.w600),
                        ),
                      ),
                      SliverList(
                          delegate: SliverChildListDelegate(
                              chatState.messages.values.toList().map((data) {
                        String idChat = data['docid'];
                        String timer = data['time'] != ''
                            ? DateFormat('hh:mm a')
                                .format(data['time'].toDate())
                            : '';

                        if (mounted) {
                          // teste();
                        }
                        // print(chatState.messages);
                        if (!available.contains(idChat)) return Container();

                        if (data['photo'] == '') {
                          data['photo'] = defaultPhoto;
                        }
                        return ListTile(
                          contentPadding: EdgeInsets.all(20),
                          minVerticalPadding: 13,
                          dense: true,
                          visualDensity: VisualDensity(vertical: 4), // to
                          leading: CircleAvatar(
                              radius: 33,
                              backgroundColor: const Color(0xffFDCF09),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(200),
                                child: CachedNetworkImage(
                                  fadeInDuration:
                                      const Duration(milliseconds: 0),
                                  fadeOutDuration:
                                      const Duration(milliseconds: 0),
                                  fit: BoxFit.cover,
                                  imageUrl: data['photo'],
                                  width: 100,
                                  height: 100,
                                ),
                              )),
                          title: Text(data['friendName'],
                              style: const TextStyle(
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontSize: 16)),
                          subtitle: data['msg'] != ''
                              ? Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(data['msg'],
                                        style: const TextStyle(
                                            color: Color.fromARGB(
                                                255, 147, 132, 100),
                                            fontSize: 16))
                                  ],
                                )
                              : Text(
                                  'Diga um oi',
                                  style: TextStyle(color: Colors.grey.shade600),
                                ),
                          onTap: () => callChatDetailScreen(
                              context, data['friendUid'], data['friendName']),
                        );
                      }).toList()))
                    ],
                  )),
        ),
      ),
    );
  }

  void teste() async {
    List likedMe = [];

    final foundLikeMe = await FirebaseFirestore.instance
        .collection('chats')
        .where('users.$currentUser', isEqualTo: 1)
        .get();

    foundLikeMe.docs.forEach((element) {
      likedMe.add(element.id);
    });

    print('-----------------');
    print(available);
    print('-----------------');

    setState(() {
      available = likedMe;
    });
  }
}
