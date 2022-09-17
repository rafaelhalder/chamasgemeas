import 'package:flutter/material.dart';

class MatchPage extends StatelessWidget {
  const MatchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Map arguments = ModalRoute.of(context)?.settings.arguments as Map;
    print(arguments);
    print('arguments');
    String userList = arguments['userLiked'];
    print(userList);
    return Container(
      height: size.height * 0.8,
      color: Color.fromARGB(0, 241, 95, 95),
      child: Center(
          child: Text(
        userList,
        style: TextStyle(color: Colors.white),
      )),
    );
  }
}
