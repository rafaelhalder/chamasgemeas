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
import 'package:google_fonts/google_fonts.dart';

class RegisterStep7 extends StatefulWidget {
  @override
  _RegisterStep7State createState() => _RegisterStep7State();
}

class _RegisterStep7State extends State<RegisterStep7> {
  String selectedIndex = '';
  int? typeInterested = 0;
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  String testes = '';
  String teste = FirebaseAuth.instance.currentUser!.photoURL!;
  late String teste2;
  List multipleSelected = [];
  firebase_storage.FirebaseStorage storage =
      firebase_storage.FirebaseStorage.instance;
  File? _photo;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    loadImage();
  }

  Future imgFromGallery() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper().cropImage(
          sourcePath: pickedFile.path,
          compressQuality: 100,
          maxHeight: 640,
          maxWidth: 480,
          //cropStyle: CropStyle.circle,
          aspectRatioPresets: [
            CropAspectRatioPreset.square,
            CropAspectRatioPreset.ratio3x2,
            CropAspectRatioPreset.original,
            CropAspectRatioPreset.ratio4x3,
            CropAspectRatioPreset.ratio16x9
          ],
          uiSettings: [
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

      // firebase_storage.Reference refsOld = firebase_storage
      //     .FirebaseStorage.instance
      //     .ref()
      //     .child('images/user/$uid')
      //     .child(oldPhoto);

      // refsOld.delete();
    } catch (e) {
      print(e);
    }
    setState(() {
      testes = listPhotos[0]['name'];
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/images/interfacesigno.png"),
        fit: BoxFit.cover,
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: AnnotatedRegion<SystemUiOverlayStyle>(
          value: SystemUiOverlayStyle.light,
          child: Container(
              child: SafeArea(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Container(
                    padding: const EdgeInsets.only(left: 50, top: 20),
                    alignment: Alignment.bottomLeft,
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 20.0,
                          color: Color.fromARGB(255, 238, 238, 238),
                        ),
                        children: <TextSpan>[
                          TextSpan(
                              text: '${user?.displayName}, \n',
                              style: GoogleFonts.quicksand(
                                  fontSize: 27,
                                  color: Color.fromARGB(255, 147, 132, 100),
                                  fontWeight: FontWeight.w700)),
                          TextSpan(
                              text: 'SELECIONE A SUA \n FOTO DE PERFIL',
                              style: GoogleFonts.quicksand(
                                  fontSize: 20,
                                  color: Color.fromARGB(255, 207, 202, 187),
                                  fontWeight: FontWeight.w700)),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 25,
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
                                radius: 90,
                                backgroundColor: Colors.transparent,
                                child: snapshot.data != null
                                    ? ClipRRect(
                                        borderRadius: BorderRadius.circular(90),
                                        child: Image.network(
                                          snapshot.data,
                                          width: 180,
                                          height: 180,
                                          fit: BoxFit.cover,
                                        ),
                                      )
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey[200],
                                            borderRadius:
                                                BorderRadius.circular(90)),
                                        width: 180,
                                        height: 180,
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
                  SizedBox(
                    height: 50,
                  ),
                  Container(
                    alignment: Alignment.centerLeft,
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: RichText(
                      text: TextSpan(
                        style: const TextStyle(
                          fontSize: 18.0,
                          color: Color.fromARGB(255, 238, 238, 238),
                        ),
                        children: <TextSpan>[
                          TextSpan(text: 'Sobre você:'),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    child: TextField(
                      onChanged: (value) async {
                        value = value.toLowerCase();
                        value = value.replaceAll(' Bicha ', '***');
                        value = value.replaceAll(' Buceta ', '***');
                        value = value.replaceAll(' bosta ', '***');
                        value = value.replaceAll(' Cagar ', '***');
                        value = value.replaceAll('caralho ', '***');
                        value = value.replaceAll(' cu ', '***');
                        value = value.replaceAll('fodase', '***');
                        value = value.replaceAll('foda-se', '***');
                        value = value.replaceAll('foder', '***');
                        value = value.replaceAll('porra', '***');
                        value = value.replaceAll('puta', '***');
                        value = value.replaceAll('merda', '***');
                        value = value.replaceAll('viado', '***');
                        value = value.replaceAll('Boquete', '***');
                        value = value.replaceAll(' Pau ', '***');
                        value = value.replaceAll(' Pica', '***');
                        value = value.replaceAll('Punheta', '***');
                        value = value.replaceAll('Xoxota', '***');
                        value = value.replaceAll('Siririca', '***');
                        value = value.replaceAll('Cacete', '***');
                        value = value.replaceAll('Boiola', '***');
                        value = value.replaceAll('Arrombado', '***');
                        value = value.replaceAll('Vagabund', '***');
                        value = value.replaceAll('Corno', '***');
                        value = value.replaceAll('Boiola', '***');
                        value = value.replaceAll('Trouxa', '***');
                        await FirebaseFirestore.instance
                            .collection('users')
                            .doc(user?.uid)
                            .update({'aboutMe': value});
                        setState(() {
                          selectedIndex = value;
                        });
                      },
                      keyboardType: TextInputType.multiline,
                      maxLines: 1,
                      cursorColor: Colors.white,
                      maxLength: 144,
                      style: TextStyle(color: Colors.white),
                      decoration: InputDecoration(
                        focusColor: Colors.white,
                        hoverColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(40.0),
                        ),
                        hintStyle: TextStyle(color: Colors.white70),
                        fillColor: Color.fromARGB(0, 255, 255, 255),
                        filled: true,
                        labelStyle: TextStyle(
                          color: Color.fromARGB(255, 244, 238, 252),
                        ),
                        helperStyle: TextStyle(color: Colors.white),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(40.0)),
                          borderSide: BorderSide(
                              color: Color.fromARGB(255, 207, 202, 187)),
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
                          print(selectedIndex);
                          print(testes);
                          if (selectedIndex.length > 5 && testes != '') {
                            await FirebaseFirestore.instance
                                .collection('users')
                                .doc(user?.uid)
                                .update({"finished": true}).then((value) =>
                                    Navigator.pushNamed(context, '/home'));
                          }

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
                          width: size.width * 0.35,
                          height: size.height * 0.035,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(40),
                            color: selectedIndex.length > 5
                                ? Color.fromARGB(255, 200, 181, 152)
                                : Color.fromARGB(0, 108, 90, 64),
                          ),
                          child: Center(
                            child: Text(
                              'CONFIRMAR',
                              style: TextStyle(
                                  color: selectedIndex.length > 5
                                      ? Colors.black
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
            ),
          )),
        ),
      ),
    );
  }

  Future<String> loadImage() async {
    DocumentSnapshot variable =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    List fileName = variable['photos'];

    if (fileName[0]['name'] == 'nulo') {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/default')
          .child('person_blank.png');

      var url = await ref.getDownloadURL();

      return url;
    }

    try {
      firebase_storage.Reference ref = firebase_storage.FirebaseStorage.instance
          .ref()
          .child('images/user/$uid')
          .child(fileName[0]['name']);

      var url = await ref.getDownloadURL();

      return url;
    } catch (e) {
      var url =
          'https://firebasestorage.googleapis.com/v0/b/chamas-gemeas.appspot.com/o/images%2Fdefault%2Fperson_blank.png?alt=media&token=a48cac17-1f89-4aed-a0b2-ba38699d516f';

      return url;
    }
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
