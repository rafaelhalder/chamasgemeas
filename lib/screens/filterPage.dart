import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Filter"),
          leading: IconButton(
            onPressed: () {
              Navigator.pushNamed(context, '/home');
            },
            icon: const FaIcon(FontAwesomeIcons.arrowLeft),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Center(
                child: Text('Distância máxima ${_value.round()}'),
              ),
              Slider(
                activeColor: Colors.amber,
                min: 0.0,
                max: 200.0,
                value: _value,
                divisions: 20,
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
                },
              ),
              const SizedBox(
                height: 50,
              ),
              Center(
                child: Text(
                    'Idade entre ${_startValue.round()} e ${_endValue.round()} '),
              ),
              RangeSlider(
                  min: 0.0,
                  max: 150.0,
                  activeColor: Colors.amber,
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
                  }),
            ],
          ),
        ),
      ),
    );
  }

  void getFilters() async {
    final filter =
        await FirebaseFirestore.instance.collection('filter').doc(uid).get();

    setState(() {
      _value = double.parse(filter['distance'].toString());
      _startValue = double.parse(filter['age'][0].toString());
      _endValue = double.parse(filter['age'][1].toString());
    });
  }
}
