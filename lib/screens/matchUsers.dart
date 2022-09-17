import 'dart:async';

import 'package:animate_do/animate_do.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:cached_network_image/cached_network_image.dart';

class MatchUsers extends StatefulWidget {
  const MatchUsers({Key? key}) : super(key: key);

  @override
  State<MatchUsers> createState() => _MatchUsersState();
}

class _MatchUsersState extends State<MatchUsers> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    String userList = arguments['userLiked'];
    var photoUserActual = arguments['photo'];
    bool _visible = true;

    return Container(
      decoration: BoxDecoration(
          color: Color.fromARGB(0, 241, 95, 95),
          image: DecorationImage(
            image: AssetImage("assets/images/interfacesigno.png"),
            fit: BoxFit.cover,
          )),
      height: size.height * 0.8,
      child: Stack(
        children: [
          Positioned.fill(
              child: Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: _visible == true ? 1.0 : 0.0,
              duration: const Duration(milliseconds: 2000),
              child: CircleAvatar(
                radius: 120,
                child: Center(
                  child: new ClipRRect(
                    borderRadius: BorderRadius.circular(120),
                    child: new Row(
                      children: <Widget>[
                        Image.network(
                          'https://images.unsplash.com/photo-1535593063927-5c40dee9cb83?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=3bfc6e7c6043924de9c4746bef6dc969&auto=format&fit=crop&w=500&q=60',
                          width: 120.0,
                          height: 240.0,
                          fit: BoxFit.cover,
                        ),
                        ClipRRect(
                          child: Image.network(
                            'https://images.unsplash.com/photo-1535603863228-ded98173a95d?ixlib=rb-0.3.5&ixid=eyJhcHBfaWQiOjEyMDd9&s=78dee486ac6c9bffda623b83a36ecb1f&auto=format&fit=crop&w=500&q=60',
                            width: 120.0,
                            height: 240.0,
                            fit: BoxFit.cover,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )),
          Positioned.fill(
              child: Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              opacity: 0,
              duration: const Duration(milliseconds: 2000),
              child: Image.asset(
                'assets/images/ying.png',
                height: 120,
              ),
            ),
          )),
          Positioned.fill(
              child: Align(
            alignment: Alignment.topCenter,
            child: Image.asset(
              'assets/images/ying.png',
              height: 120,
            ),
          )),
          Center(
              child: Text(
            'userList',
            style: TextStyle(color: Colors.white),
          )),
        ],
      ),
    );
  }
}
