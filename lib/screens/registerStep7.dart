import 'dart:io';
import 'dart:async';
import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class RegisterStep7 extends StatefulWidget {
  @override
  _RegisterStep7State createState() => _RegisterStep7State();
}

class _RegisterStep7State extends State<RegisterStep7> {
  String selectedIndex = '';
  int? typeInterested = 0;
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;

  String teste = FirebaseAuth.instance.currentUser!.photoURL!;
  late String teste2;
  List multipleSelected = [];
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    loadImage();
    super.initState();
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    final croppedFile = await ImageCropper()
        .cropImage(sourcePath: pickedFile!.path, compressQuality: 100,
            //cropStyle: CropStyle.circle,
            aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.ratio3x2,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
          CropAspectRatioPreset.ratio16x9
        ], uiSettings: [
      AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.original,
          lockAspectRatio: false),
      IOSUiSettings(
        title: 'Cropper',
      ),
    ]);

    setState(() {
      if (croppedFile != null) {
        _photo = File(croppedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future imgFromCamera() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _photo = File(pickedFile.path);
        uploadFile();
      } else {
        print('No image selected.');
      }
    });
  }

  Future uploadFile() async {
    if (_photo == null) return;
    // final fileName = basename(_photo!.path);
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    List listPhotos = variable['photos'];
    String oldPhoto = listPhotos[0]['name'];
    String name = DateTime.now().toString();
    print(listPhotos);

    try {
      final ref = storage.ref('images/user/$uid').child(name);
      listPhotos[0]['name'] = name;

      print(listPhotos);

      await ref.putFile(_photo!);

      firebase_storage.Reference refs = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/user/$uid')
          .child(listPhotos[0]['name']);

      var url = await refs.getDownloadURL();
      listPhotos[0]['url'] = url;

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user?.uid)
          .update({"photos": listPhotos});

      firebase_storage.Reference refsOld = firebase_storage
          .FirebaseStorage.instance
          .ref()
          .child('images/user/$uid')
          .child(oldPhoto);

      refsOld.delete();
    } catch (e) {
      print(e);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle.light,
        child: Container(
            decoration: const BoxDecoration(
              color: Colors.black,
            ),
            child: SafeArea(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 50, top: 20),
                    alignment: Alignment.bottomLeft,
                    child: Text(
                      '${user!.displayName},\nSelecion sua foto de perfil!',
                      style: const TextStyle(
                        color: Colors.white,
                        fontFamily: 'CM Sans Serif',
                        fontSize: 25.0,
                        height: 1.5,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.zero,
                    child: FutureBuilder<dynamic>(
                        future: loadImage(),
                        builder:
                            (BuildContext context, AsyncSnapshot snapshot) {
                          return Center(
                            child: GestureDetector(
                              onTap: () {
                                _showPicker(context);
                              },
                              child: CircleAvatar(
                                radius: 80,
                                backgroundColor: const Color(0xffFDCF09),
                                child: snapshot.data != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(80),
                                        child: Image.network(
                                          snapshot.data,
                                          width: 160,
                                          height: 160,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(80)),
                                        width: 160,
                                        height: 160,
                                        child: Icon(
                                          Icons.camera_alt,
                                          color: Colors.grey[800],
                                        ),
                                      ),
                              ),
                            ),
                          );
                        }),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      onChanged: (value) async {
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .update({'aboutMe': value});
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 4,
                      cursorColor: Colors.pink,
                      maxLength: 144,
                      style: const TextStyle(color: Colors.white),
                      decoration: const InputDecoration(
                        hintText: 'Escreva uma FRASE que revela tua essência!',
                        hintStyle: TextStyle(color: Colors.white70),
                        fillColor: Colors.white24,
                        filled: true,
                        labelText: 'Sua essência!',
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 244, 238, 252),
                        ),
                        helperText: 'Limite',
                        helperStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFFECB461)),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 32,
                  ),
                  Container(
                    color: Colors.transparent,
                    alignment: Alignment.center,
                    height: size.height * 0.1,
                    width: double.infinity,
                    child: Center(
                      child: GestureDetector(
                        onTap: () async {
                          await FirebaseFirestore.instance
                              .collection('users')
                              .doc(user?.uid)
                              .update({"finished": true}).then((value) =>
                                  Navigator.pushNamed(context, '/home'));

                          // await FirebaseFirestore.instance
                          //     .collection('users')
                          //     .doc(user?.uid)
                          //     .update({
                          //   'interested': selectedIndex,
                          //   'typeInterested': typeInterested
                          // });

                          // selectedIndex != ""
                          //     ? Navigator.pushNamed(context, '/home')
                          //     : null;
                        },
                        child: Container(
                          width: size.width * 0.7,
                          height: size.height * 0.055,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: selectedIndex.length > 5
                                ? const Color(0xFFECB461)
                                : Colors.black38,
                          ),
                          child: Center(
                            child: Text(
                              'CONFIRMAR',
                              style: TextStyle(
                                  color: selectedIndex.length > 5
                                      ? Colors.white
                                      : Colors.white24,
                                  fontFamily: 'CM Sans Serif',
                                  fontSize: 18),
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            )),
      ),
    );
  }

  Future<String> loadImage() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    List fileName = variable['photos'];

    if (fileName[0]['name'] == 'first') {
      // firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
      //     .ref()
      //     .child('images/default')
      //     .child('person_blank.png');
      // var url = await ref.getDownloadURL();
      var url2 =
          'https://firebasestorage.googleapis.com/v0/b/chamas-gemeas.appspot.com/o/images%2Fdefault%2Fperson_blank.png?alt=media&token=a48cac17-1f89-4aed-a0b2-ba38699d516f';
      return url2;
    }

    firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
        .ref()
        .child('images/user/$uid')
        .child(fileName[0]['name']);

    var url = await ref.getDownloadURL();

    return url;
  }

  void _showPicker(context) {
    showModalBottomSheet(
        context: context,
        builder: (BuildContext bc) {
          return SafeArea(
            child: Container(
              color: const Color.fromARGB(16, 255, 255, 255),
              child: Wrap(
                children: <Widget>[
                  ListTile(
                      leading: const Icon(Icons.photo_library),
                      title: const Text('Gallery'),
                      onTap: () {
                        imgFromGallery();
                        Navigator.of(context).pop();
                      }),
                  ListTile(
                    leading: const Icon(Icons.photo_camera),
                    title: const Text('Camera'),
                    onTap: () {
                      imgFromCamera();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ),
          );
        });
  }

  static const _chars =
      'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
  final Random _rnd = Random();
  String getRandomString(int length) => String.fromCharCodes(Iterable.generate(
      length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
}
