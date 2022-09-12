import 'package:chamasgemeas/provider/card_provider.dart';
import 'package:flutter/material.dart';
import 'package:chamasgemeas/model/user.dart';
import 'package:provider/provider.dart';

class TinderCard extends StatefulWidget {
  final Users user;
  const TinderCard({Key? key, required this.user}) : super(key: key);

  @override
  State<TinderCard> createState() => _TinderCardState();
}

class _TinderCardState extends State<TinderCard> {
  @override
  Widget build(BuildContext context) => buildFrontCard();

  Widget buildFrontCard() => GestureDetector(
        child: Builder(builder: (context) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          final milliseconds = provider.isDragging ? 0 : 400;
          final position = provider.position;
          return AnimatedContainer(
            curve: Curves.easeInOut,
            duration: Duration(milliseconds: milliseconds),
            transform: Matrix4.identity()..translate(position.dx, position.dy),
            child: buildCard(),
          );
        }),
        onPanStart: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          print('1');
          provider.startPosition(details);
        },
        onPanUpdate: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          print('2');

          provider.updatePosition(details);
        },
        onPanEnd: (details) {
          final provider = Provider.of<CardProvider>(context, listen: false);
          provider.endPosition();
        },
      );

  Widget buildCard() => Container(
        height: MediaQuery.of(context).size.height * 0.65,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(40),
            border: Border.all(color: Color.fromARGB(255, 219, 197, 26))),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(40),
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: NetworkImage(widget.user.urlImage),
                fit: BoxFit.cover,
                //alignment: Alignment(-0.3, 0)
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      colors: [
                        Colors.transparent,
                        Color.fromARGB(255, 225, 200, 140),
                        Color.fromARGB(255, 225, 200, 140),
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      stops: [0.45, 0.85, 1])),
              child: Container(
                padding: EdgeInsets.all(20),
                child: Column(
                  children: [
                    Spacer(),
                    buildName(),
                    SizedBox(
                      height: 8,
                    ),
                    buildStatus(),
                    SizedBox(
                      height: 60,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

  Widget buildName() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.user.name,
            style: TextStyle(
                fontSize: 32, color: Colors.white, fontWeight: FontWeight.bold),
          ),
          SizedBox(
            width: 16,
          ),
          Text(
            '${widget.user.age}',
            style: TextStyle(fontSize: 32, color: Colors.white),
          )
        ],
      );

  Widget buildStatus() => Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            decoration:
                BoxDecoration(shape: BoxShape.circle, color: Colors.green),
            width: 12,
            height: 12,
          ),
          SizedBox(
            width: 8,
          ),
          Text(
            'Recently',
            style: TextStyle(fontSize: 20, color: Colors.white),
          ),
        ],
      );
}
