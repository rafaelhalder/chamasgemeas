import 'package:cached_network_image/cached_network_image.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:chamasgemeas/screens/chatDetail.dart';
import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:chamasgemeas/states/lib.dart';
import 'package:cupertino_list_tile/cupertino_list_tile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:intl/intl.dart';

class Chats extends StatefulWidget {
  const Chats({Key? key}) : super(key: key);

  @override
  State<Chats> createState() => _ChatsState();
}

class _ChatsState extends State<Chats> {
  @override
  void initState() {
    super.initState();
    chatState.refreshChatsForCurrentUser();
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
    return Container(
      color: const Color.fromARGB(255, 27, 27, 27),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        bottomNavigationBar: ConvexAppBar(
          gradient: const LinearGradient(colors: [
            Color.fromARGB(255, 20, 5, 44),
            Color.fromARGB(255, 2, 1, 3),
          ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
          // ignore: prefer_const_literals_to_create_immutables
          items: [
            // ignore: prefer_const_constructors
            TabItem(
                activeIcon: const Icon(Icons.people, color: Colors.black),
                icon: const Icon(Icons.people,
                    color: Color.fromARGB(255, 204, 171, 123)),
                title: 'Home'),
            const TabItem(
                activeIcon: Icon(Icons.star, color: Colors.black),
                icon:
                    Icon(Icons.star, color: Color.fromARGB(255, 204, 171, 123)),
                title: 'Super like'),
            const TabItem(
                activeIcon: Icon(Icons.person, color: Colors.black),
                icon: Icon(Icons.person,
                    color: Color.fromARGB(255, 204, 171, 123)),
                title: 'Perfil'),
            const TabItem(
                activeIcon: Icon(Icons.message, color: Colors.black),
                icon: Icon(Icons.message,
                    color: Color.fromARGB(255, 204, 171, 123)),
                title: 'Mensagens'),
          ],
          initialActiveIndex: 3, //optional, default as 0
          onTap: (int i) {
            i == 0
                ? Navigator.pushReplacement(
                    context,
                    PageRouteBuilder(
                      pageBuilder: (context, animation1, animation2) =>
                          const HomePage(),
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

            print('click index=$i');
          },
        ),
        body: Observer(
            builder: (BuildContext context) => CustomScrollView(
                  slivers: [
                    const CupertinoSliverNavigationBar(
                      leading: Text(''),
                      backgroundColor: Color.fromARGB(255, 27, 27, 27),
                      largeTitle: Text(
                        "Match",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SliverList(
                        delegate: SliverChildListDelegate(
                            chatState.messages.values.toList().map((data) {
                      String timer = data['time'] != ''
                          ? DateFormat('hh:mm a').format(data['time'].toDate())
                          : '';
                      return CupertinoListTile(
                        leading: CircleAvatar(
                            radius: 25,
                            backgroundColor: const Color(0xffFDCF09),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(50),
                              child: CachedNetworkImage(
                                fadeInDuration: const Duration(milliseconds: 0),
                                fadeOutDuration:
                                    const Duration(milliseconds: 0),
                                fit: BoxFit.cover,
                                imageUrl: data['photo'],
                                width: 100,
                                height: 100,
                              ),
                            )),
                        title: Text(data['friendName'],
                            style: const TextStyle(color: Colors.white)),
                        subtitle: data['msg'] != ''
                            ? Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(data['msg'],
                                      style: const TextStyle(
                                          color: Colors.white, fontSize: 14)),
                                  Text(timer,
                                      style: const TextStyle(
                                          color: Color.fromARGB(
                                              255, 206, 206, 206),
                                          fontSize: 12)),
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
    );
  }
}
