import 'package:chamasgemeas/provider/card_provider.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:chamasgemeas/screens/profilePage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class FilterPage extends StatefulWidget {
  const FilterPage({Key? key}) : super(key: key);

  @override
  State<FilterPage> createState() => _FilterPageState();
}

class _FilterPageState extends State<FilterPage> {
  double _value = 0;
  double _startValue = 0;
  double _endValue = 0;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  @override
  void initState() {
    // TODO: implement initState
    getFilters();
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.black,
        systemNavigationBarIconBrightness: Brightness.light,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
        statusBarColor: Colors.transparent,
      ),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/images/interfacesigno.png"),
          fit: BoxFit.cover,
        )),
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
                  activeIcon: FaIcon(Icons.star, color: Colors.black),
                  icon: FaIcon(Icons.star, color: Colors.black),
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
            initialActiveIndex: 4, //optional, default as 0
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
          body: Padding(
            padding: const EdgeInsets.all(40),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: Text(
                    'FILTRO',
                    style: GoogleFonts.cinzelDecorative(
                        fontSize: 22,
                        color: Color.fromARGB(255, 147, 132, 100),
                        fontWeight: FontWeight.w600),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Text(
                    'Distância máxima ${_value.round()}',
                    style: TextStyle(color: Color.fromARGB(255, 177, 166, 143)),
                  ),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.all(5),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(21, 0, 0, 0),
                      border:
                          Border.all(color: Color.fromARGB(255, 177, 167, 145)),
                      borderRadius: BorderRadius.circular(40)),
                  child: SliderTheme(
                    data: SliderThemeData(
                      overlayShape: SliderComponentShape.noOverlay,
                      disabledInactiveTrackColor: Colors.black12,
                    ),
                    child: Slider(
                      inactiveColor: Colors.transparent,
                      activeColor: Color.fromARGB(255, 165, 150, 118),
                      min: 0.0,
                      max: 2000.0,
                      value: _value,
                      divisions: 200,
                      label: '${_value.round()}',
                      onChanged: (value) {
                        setState(() {
                          _value = value;
                        });
                      },
                      onChangeEnd: (value) async {
                        await FirebaseFirestore.instance
                            .collection('filter')
                            .doc(uid)
                            .update({
                          'distance': [_value]
                        });
                        final provider =
                            Provider.of<CardProvider>(context, listen: false);
                        provider.resetUsers();
                      },
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                Center(
                  child: Text(
                      'Idade entre ${_startValue.round()} e ${_endValue.round()} ',
                      style:
                          TextStyle(color: Color.fromARGB(255, 177, 166, 143))),
                ),
                SizedBox(
                  height: 15,
                ),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 18, vertical: 5),
                  decoration: BoxDecoration(
                      color: Color.fromARGB(21, 0, 0, 0),
                      border:
                          Border.all(color: Color.fromARGB(255, 177, 167, 145)),
                      borderRadius: BorderRadius.circular(40)),
                  child: SliderTheme(
                    data: SliderThemeData(
                      overlayShape: SliderComponentShape.noOverlay,
                      disabledInactiveTrackColor: Colors.black12,
                    ),
                    child: RangeSlider(
                        min: 0.0,
                        max: 99.0,
                        inactiveColor: Colors.transparent,
                        activeColor: Color.fromARGB(255, 165, 150, 118),
                        values: RangeValues(_startValue, _endValue),
                        divisions: 22,
                        labels: RangeLabels(
                          _startValue.round().toString(),
                          _endValue.round().toString(),
                        ),
                        onChanged: (values) {
                          setState(() {
                            _startValue = values.start;
                            _endValue = values.end;
                          });
                        },
                        onChangeEnd: (values) async {
                          await FirebaseFirestore.instance
                              .collection('filter')
                              .doc(uid)
                              .update({
                            'age': [values.start, values.end]
                          });
                          final provider =
                              Provider.of<CardProvider>(context, listen: false);
                          provider.resetUsers();
                        }),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void getFilters() async {
    final filter =
        await FirebaseFirestore.instance.collection('filter').doc(uid).get();

    setState(() {
      String distance = filter['distance'].toString();
      distance = distance.replaceAll("[", ""); // myString is "s t r"
      distance = distance.replaceAll("]", ""); // myString is "s t r"

      double distance_value = double.parse((distance).toString());
      _value = distance_value;
      _startValue = double.parse(filter['age'][0].toString());
      _endValue = double.parse(filter['age'][1].toString());
    });
  }
}
