import 'dart:io';
import 'dart:async';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:chamasgemeas/screens/preferencePage.dart';
import 'package:convex_bottom_bar/convex_bottom_bar.dart';
import 'package:chamasgemeas/screens/chats.dart';
import 'package:chamasgemeas/screens/HomePage.dart';
import 'package:chamasgemeas/screens/superLikePage.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:reorderable_grid_view/reorderable_grid_view.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:latlong2/latlong.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String occupation = '';
  String zodiac = '';
  String aboutMe = '';
  String gender = '';
  String city = '';
  String country = '';
  String weight = '';

  dynamic loadData() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return variable['aboutMe'];
  }

  dynamic loadProf() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return variable['occupation'];
  }

  dynamic loadHeight() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return variable['height'];
  }

  dynamic loadAge() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return variable['age'];
  }

  dynamic loadCity() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return variable['city'];
  }

  dynamic loadCountry() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return variable['country'];
  }

  dynamic loadWeight() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    return variable['weight'];
  }

  dynamic loadGenero() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (variable['gender'] == '1') {
      return 'Mulher';
    }

    if (variable['gender'] == '2') {
      return 'Homem';
    }

    if (variable['gender'] == '3') {
      return 'LGBT';
    }
  }

  final List<String> data = [];
  List startedList = [1, 2, 3, 4, 5, 6, 7, 8, 9];
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  List listPhoto = [];
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  Future imgFromGallery(String id) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          compressQuality: 100,
          maxHeight: 640,
          maxWidth: 480);

      setState(() {
        if (croppedFile != null) {
          _photo = File(croppedFile.path);
          uploadFile(id);
        } else {
          print('No image selected.');
        }
      });
    }
  }

  Future imgFromCamera(String id) async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile(id);
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile(String id) async {
    if (_photo == null) return;
    // final fileName = basename(_photo!.path);
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    List listPhotos = variable['photos'];
    String name = DateTime.now().toString();
    int oldId = int.parse(id);

    try {
      final ref = storage.ref('images/user/$uid').child(name);

      await ref.putFile(_photo!);

      firebase_storage.Reference refs = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/user/$uid')
          .child(name);

      var url = await refs.getDownloadURL();

      String oldPhoto = '';
      for (int i = 0; i < listPhotos.length; i++) {
        if (oldId == int.parse(listPhotos[i]['id'])) {
          oldPhoto = listPhotos[i]['name'];
          listPhotos[i]['name'] = name;
          listPhotos[i]['url'] = url;
        }
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({"photos": listPhotos});

      if (oldPhoto != 'nulo') {
        print('excluindo foto $oldPhoto');
        firebase_storage.Reference refsOld = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/user/$uid')
            .child(oldPhoto);
        refsOld.delete();
      }
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    var distance = const Distance();

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
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
          backgroundColor: Color.fromARGB(0, 27, 27, 27),
          bottomNavigationBar: ConvexAppBar(
            color: Colors.black,
            gradient: const LinearGradient(colors: [
              Color.fromARGB(255, 223, 223, 223),
              Color.fromARGB(255, 223, 223, 223),
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter),
            // ignore: prefer_const_literals_to_create_immutables
            items: [
              // ignore: prefer_const_constructors
              TabItem(
                  activeIcon: Icon(Icons.home, color: Colors.black),
                  icon: Icon(Icons.home, color: Colors.black),
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
            initialActiveIndex: 2, //optional, default as 0
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
          appBar: AppBar(
            elevation: 0,
            backgroundColor: const Color.fromARGB(0, 0, 0, 0),
            centerTitle: true,
            title: const Text('Editar Perfil'),
            leading: const Text(''),
            actions: const [],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.only(top: 12.0, left: 12.0, right: 12.0),
                  child: Center(
                    child: FutureBuilder<dynamic>(
                        future: loadImage(),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            List images = snapshot.data;
                            return ReorderableGridView.count(
                              shrinkWrap: true,
                              crossAxisSpacing: 15,
                              mainAxisSpacing: 15,
                              crossAxisCount: 3,
                              childAspectRatio: 0.75,
                              children: images.map((dynamic path) {
                                return GestureDetector(
                                  onTap: () {
                                    print(path);
                                    _showPicker(context, path['id']);
                                  },
                                  key: ValueKey(path),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(4)),
                                    child: path['url'] != 'nulo'
                                        ? ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            child: CachedNetworkImage(
                                              fadeInDuration: const Duration(
                                                  milliseconds: 0),
                                              fadeOutDuration: const Duration(
                                                  milliseconds: 0),
                                              fit: BoxFit.cover,
                                              imageUrl: path['url'],
                                            ))
                                        : Container(
                                            decoration: BoxDecoration(
                                                color: Color.fromARGB(
                                                    255, 223, 223, 223)),
                                            child: DottedBorder(
                                              color: Colors.transparent,
                                              borderType: BorderType.Rect,
                                              dashPattern: const [8, 4],
                                              strokeWidth: 2,
                                              child: Center(
                                                  child: Icon(
                                                size: 40,
                                                Icons.image,
                                                color: Color.fromARGB(
                                                    255, 147, 132, 100),
                                              )),
                                            ),
                                          ),
                                  ),
                                );
                              }).toList(),
                              onReorder: (oldIndex, newIndex) async {
                                dynamic oldId = images[oldIndex];
                                dynamic newId = images[newIndex];
                                if (oldId['name'] != 'nulo' &&
                                    newId['name'] != 'nulo') {
                                  dynamic paths = images.removeAt(oldIndex);
                                  images.insert(newIndex, paths);
                                  setState(() {});
                                  print(images);
                                  await FirebaseFirestore.instance
                                      .collection('users')
                                      .doc(uid)
                                      .update({"photos": images});
                                }
                              },
                            );
                          }
                          return GridView.count(
                            shrinkWrap: true,
                            crossAxisSpacing: 15,
                            mainAxisSpacing: 15,
                            crossAxisCount: 3,
                            childAspectRatio: 0.75,
                            children: const <Widget>[
                              beforeLoad(),
                              beforeLoad(),
                              beforeLoad(),
                              beforeLoad(),
                              beforeLoad(),
                              beforeLoad(),
                              beforeLoad(),
                              beforeLoad(),
                              beforeLoad(),
                            ],
                          );
                        }),
                  ),
                ),
                Container(
                  child: const Center(
                    child: Padding(
                      padding: EdgeInsets.only(top: 14.0),
                      child: Text(
                        'Clique para editar ou arraste para reordenar',
                        style: TextStyle(
                            color: Color.fromARGB(139, 255, 255, 255)),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.center,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 15),
                  child: const Text(
                    'Sobre mim',
                    style: TextStyle(
                        color: Color.fromARGB(120, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder<dynamic>(
                    future: loadData(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(40)),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 8),
                          child: TextFormField(
                            onChanged: (value) {
                              FirebaseFirestore.instance
                                  .collection('users')
                                  .doc(user?.uid)
                                  .update({"aboutMe": value});
                            },
                            initialValue: snapshot.data,
                            keyboardType: TextInputType.multiline,
                            maxLines: 4,
                            cursorColor: Colors.white,
                            maxLength: 144,
                            style: const TextStyle(
                                color: Color.fromARGB(255, 84, 75, 57)),
                            decoration: const InputDecoration(
                              hintText: 'Escreva algo sobre você',
                              hintStyle: TextStyle(color: Colors.white70),
                              fillColor: Color.fromARGB(255, 223, 223, 223),
                              filled: true,
                              helperText: 'Limite',
                              helperStyle: TextStyle(color: Colors.white),
                              enabledBorder: OutlineInputBorder(
                                borderSide: BorderSide(
                                    color: Color.fromARGB(255, 184, 184, 184)),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: const Text(
                    'Profissional',
                    style: TextStyle(
                        color: Color.fromARGB(120, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                FutureBuilder<dynamic>(
                    future: loadProf(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 10),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(context, '/registerStep4');
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Color.fromARGB(255, 223, 223, 223),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        const Icon(Icons.edit_note,
                                            color: Color.fromARGB(
                                                255, 84, 75, 57)),
                                        const SizedBox(
                                          width: 95,
                                        ),
                                        const Text(
                                          'Ocupação:',
                                          style: TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                        const SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          snapshot.data,
                                          style: const TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                      return Container();
                    }),
                const SizedBox(height: 20),
                Container(
                  alignment: Alignment.centerLeft,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: const Text(
                    'Informações pessoais',
                    style: TextStyle(
                        color: Color.fromARGB(120, 255, 255, 255),
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/registerStep4');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 223, 223, 223),
                      ),
                      child: FutureBuilder<dynamic>(
                          future: loadHeight(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.edit_note,
                                            color: Color.fromARGB(
                                                255, 84, 75, 57)),
                                        const SizedBox(
                                          width: 95,
                                        ),
                                        Text(
                                          'Altura: ',
                                          style: TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                        Text(
                                          snapshot.data,
                                          style: const TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/registerStep4');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 223, 223, 223),
                      ),
                      child: FutureBuilder<dynamic>(
                          future: loadAge(),
                          builder: (context, snapshot) {
                            return Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      const Icon(Icons.edit_note,
                                          color:
                                              Color.fromARGB(255, 84, 75, 57)),
                                      const SizedBox(
                                        width: 95,
                                      ),
                                      const Text(
                                        'Idade: ',
                                        style: TextStyle(
                                            letterSpacing: 0.2,
                                            color:
                                                Color.fromARGB(255, 84, 75, 57),
                                            fontSize: 16),
                                      ),
                                      Text(
                                        snapshot.data.toString(),
                                        style: const TextStyle(
                                            letterSpacing: 0.2,
                                            color:
                                                Color.fromARGB(255, 84, 75, 57),
                                            fontSize: 16),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/registerStep4');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 223, 223, 223),
                      ),
                      child: FutureBuilder<dynamic>(
                          future: loadCity(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.edit_note,
                                            color: Color.fromARGB(
                                                255, 84, 75, 57)),
                                        const SizedBox(
                                          width: 95,
                                        ),
                                        const Text(
                                          'Cidade: ',
                                          style: TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                        Text(
                                          snapshot.data,
                                          style: const TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/registerStep4');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 223, 223, 223),
                      ),
                      child: FutureBuilder<dynamic>(
                          future: loadCountry(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.edit_note,
                                            color: Color.fromARGB(
                                                255, 84, 75, 57)),
                                        const SizedBox(
                                          width: 95,
                                        ),
                                        const Text(
                                          'Pais: ',
                                          style: TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                        Text(
                                          snapshot.data,
                                          style: const TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/registerStep4');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 223, 223, 223),
                      ),
                      child: FutureBuilder<dynamic>(
                          future: loadWeight(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.edit_note,
                                            color: Color.fromARGB(
                                                255, 84, 75, 57)),
                                        const SizedBox(
                                          width: 95,
                                        ),
                                        const Text(
                                          'Peso: ',
                                          style: TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                        Text(
                                          snapshot.data,
                                          style: const TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                ),
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/register');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        color: Color.fromARGB(255, 223, 223, 223),
                      ),
                      child: FutureBuilder<dynamic>(
                          future: loadGenero(),
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Row(
                                      children: [
                                        const Icon(Icons.edit_note,
                                            color: Color.fromARGB(
                                                255, 84, 75, 57)),
                                        const SizedBox(
                                          width: 95,
                                        ),
                                        const Text(
                                          'Genero: ',
                                          style: TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                        Text(
                                          snapshot.data,
                                          style: const TextStyle(
                                              letterSpacing: 0.2,
                                              color: Color.fromARGB(
                                                  255, 84, 75, 57),
                                              fontSize: 16),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              );
                            }
                            return Container();
                          }),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 100,
                  child: Center(
                      child: Text('Chamas Gêmeas',
                          style: TextStyle(color: Colors.white54))),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<List> loadImage() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    List fileName = variable['photos'];
    // return fileName;
    for (int i = 0; i < fileName.length; i++) {
      if (fileName[i]['name'] != 'nulo') {
        firebase_storage.Reference ref = firebase_storage
            .FirebaseStorage.instance
            .ref()
            .child('images/user/$uid')
            .child(fileName[i]['name']);
        var url = await ref.getDownloadURL();
        // ignore: unnecessary_string_interpolations
        fileName[i]['url'] = '$url';
      }
    }

    return fileName;
  }

  Future<void> _showPicker(context, data) async {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return Container(
            color: Colors.black87,
            child: SafeArea(
              child: Container(
                color: Colors.black87,
                child: Wrap(
                  children: <Widget>[
                    ListTile(
                        leading: const Icon(
                          Icons.photo_library,
                          color: Colors.white,
                        ),
                        title: const Text('Gallery',
                            style: TextStyle(color: Colors.white)),
                        onTap: () {
                          imgFromGallery(data);
                          Navigator.of(context).pop();
                        }),
                    ListTile(
                      leading: const Icon(
                        Icons.photo_camera,
                        color: Colors.white,
                      ),
                      title: const Text('Camera',
                          style: TextStyle(color: Colors.white)),
                      onTap: () {
                        imgFromCamera(data);
                        Navigator.of(context).pop();
                      },
                    ),
                  ],
                ),
              ),
            ),
          );
        });
  }
}

class beforeLoad extends StatelessWidget {
  const beforeLoad({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color.fromARGB(255, 43, 43, 43),
      ),
      child: DottedBorder(
        color: Colors.white,
        borderType: BorderType.Rect,
        dashPattern: const [8, 4],
        strokeWidth: 2,
        child: const Text(''),
      ),
    );
  }
}
