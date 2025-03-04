import 'dart:math';

import 'package:flutter/material.dart';
import 'package:chamasgemeas/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:latlong2/latlong.dart' as lati;

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  List<Users> _users = [];
  List<Users> _me = [];
  List _liked = [];
  List _superliked = [];
  double _distanceUser = 0;
  int _agemin = 0;
  int _agemax = 0;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  List<Object?> _disliked = [FirebaseAuth.instance.currentUser?.uid];
  bool _isDragging = false;
  bool _match = true;
  double _angle = 0;
  double _latUser = 0;
  int _coinUser = 0;
  double _lngUser = 0;
  String _photoUser = '';
  String _token = '';
  String _interestedUser = '';
  String _genderUser = '';
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;
  User? user = FirebaseAuth.instance.currentUser;
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference matchs = FirebaseFirestore.instance.collection('match');

  List<Users> get users => _users;
  List<Users> get me => _me;
  List get liked => _liked;
  List get disliked => _disliked;
  double get distanceUser => _distanceUser;
  double get latUser => _latUser;
  int get coinUser => _coinUser;
  int get agemin => _agemin;
  int get agemax => _agemax;
  double get lngUser => _lngUser;

  String get photoUser => _photoUser;
  String get interestedUser => _interestedUser;
  String get genderUser => _genderUser;
  bool get isDragging => _isDragging;
  bool get match => _match;
  Offset get position => _position;
  double get angle => _angle;

  CardProvider() {
    resetUsers();
  }

  void setScreenSize(Size screenSize) => _screenSize = screenSize;

  void startPosition(DragStartDetails details) {
    _isDragging = true;

    notifyListeners();
  }

  void rollback() async {
    List rollbackList = [];

    final disliked =
        await FirebaseFirestore.instance.collection('dislike').doc(uid).get();

    if (disliked.exists) {
      rollbackList = disliked['id'];
    }

    if (rollbackList.isNotEmpty && rollbackList.last != null) {
      String lastUser = rollbackList.last;
      rollbackList.remove(lastUser);

      await FirebaseFirestore.instance
          .collection('dislike')
          .doc(uid)
          .set({"id": rollbackList});

      resetUsers();
      notifyListeners();
    }
  }

  void denunciar() async {
    List rollbackList = [];

    final disliked =
        await FirebaseFirestore.instance.collection('dislike').doc(uid).get();

    if (disliked.exists) {
      rollbackList = disliked['id'];
    }

    dislike();
    resetUsers();
    notifyListeners();
  }

  void textSuperLike(value) {}

  void updatePosition(DragUpdateDetails details) {
    _position += details.delta;

    final x = _position.dx;
    _angle = 45 * x / _screenSize.width;

    notifyListeners();
  }

  void endPosition() {
    _isDragging = false;
    notifyListeners();

    final status = getStatus(force: true);

    switch (status) {
      case CardStatus.like:
        like();
        break;
      case CardStatus.dislike:
        dislike();
        break;
      case CardStatus.superLike:
        superLike();
        break;
      default:
        resetPosition();
    }
  }

  void resetPosition() {
    _isDragging = false;
    _position = Offset.zero;
    _angle = 0;

    notifyListeners();
  }

  double getStatusOpacity() {
    final delta = 100;
    final pos = max(_position.dx.abs(), _position.dy.abs());
    final opacity = pos / delta;

    return min(opacity, 1);
  }

  CardStatus? getStatus({bool force = false}) {
    final x = _position.dx;
    final y = _position.dy;
    final forceSuperLike = x.abs() < 20;

    if (force) {
      final delta = 100;

      if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      } else if (y <= -delta / 2 && forceSuperLike) {
        return CardStatus.superLike;
      }
    } else {
      final delta = 20;

      if (y <= -delta * 2 && forceSuperLike) {
        return CardStatus.superLike;
      } else if (x >= delta) {
        return CardStatus.like;
      } else if (x <= -delta) {
        return CardStatus.dislike;
      }
    }
    return null;
  }

  void dislike() async {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    List listDislikedMe = [];

    final disliked =
        await FirebaseFirestore.instance.collection('dislike').doc(uid).get();

    if (disliked.exists) {
      listDislikedMe = disliked['id'];
    }

    if (!listDislikedMe.contains(users.last.uid))
      listDislikedMe.add(users.last.uid);

    await FirebaseFirestore.instance
        .collection('dislike')
        .doc(uid)
        .set({"id": listDislikedMe});

    _nextCard();

    notifyListeners();
  }

  void updateDislike() async {
    await FirebaseFirestore.instance
        .collection('liked')
        .doc(uid)
        .set({"id": _liked});
  }

  void like() async {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _liked.add(_users.last.uid);
    updateLike();
    userLiked();
    _nextCard();
    notifyListeners();
  }

  void updateSuperLike() async {
    await FirebaseFirestore.instance
        .collection('superliked')
        .doc(uid)
        .set({"id": _superliked});
  }

  void updateLike() async {
    await FirebaseFirestore.instance
        .collection('liked')
        .doc(uid)
        .set({"id": _liked});
  }

  void userSuperLiked() async {
    List listLikedMe = [];

    final likedme = await FirebaseFirestore.instance
        .collection('superlikedme')
        .doc(users.last.uid)
        .get();

    if (likedme.exists) {
      listLikedMe = likedme['id'];
    }

    if (!listLikedMe.contains(uid) && uid != null) listLikedMe.add(uid);
    await FirebaseFirestore.instance
        .collection('superlikedme')
        .doc(users.last.uid)
        .set({"id": listLikedMe});
  }

  void userLiked() async {
    List listLikedMe = [];

    final likedme = await FirebaseFirestore.instance
        .collection('liked_me')
        .doc(users.last.uid)
        .get();

    if (likedme.exists) {
      listLikedMe = likedme['id'];
    }
    if (!listLikedMe.contains(uid) && uid != null) listLikedMe.add(uid);
    await FirebaseFirestore.instance
        .collection('liked_me')
        .doc(users.last.uid)
        .set({"id": listLikedMe});
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _superliked.add(_users.last.uid);
    _liked.add(_users.last.uid);
    updateSuperLike();
    updateLike();
    userSuperLiked();
    userLiked();
    _nextCard();
    notifyListeners();
  }

  void chatsSuper() async {}

  Future _nextCard() async {
    if (users.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    _users.removeLast();
    resetPosition();
    notifyListeners();
  }

  Future _nextCardhome() async {
    if (users.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    _users.removeLast();
  }

  void resetUsers() async {
    _users = [];
    final like =
        await FirebaseFirestore.instance.collection('liked').doc(uid).get();
    List likeTe = [];

    if (like.exists) {
      _liked = like['id'];
      likeTe = like['id'];
    }

    final superlike = await FirebaseFirestore.instance
        .collection('superliked')
        .doc(uid)
        .get();

    if (superlike.exists) {
      _superliked = superlike['id'];
    }

    final distances =
        await FirebaseFirestore.instance.collection('filter').doc(uid).get();

    if (distances.exists) {
      String distance = distances['distance'].toString();
      distance = distance.replaceAll("[", ""); // myString is "s t r"
      distance = distance.replaceAll("]", ""); // myString is "s t r"

      double distance_value = double.parse((distance).toString());

      _agemin = distances['age'][0].round();
      _agemax = distances['age'][1].round();
      _distanceUser = distance_value;
    }

    final userInfo =
        await FirebaseFirestore.instance.collection('users').doc(uid).get();

    if (userInfo.exists) {
      _latUser = double.parse(userInfo['latitude'].toString());
      _lngUser = double.parse(userInfo['longitude'].toString());
      _photoUser = userInfo['photos'][0]['url'];
      _coinUser = userInfo['coin'];
      _interestedUser = userInfo['interested'];
      _genderUser = userInfo['gender'];
    }

    final dislike =
        await FirebaseFirestore.instance.collection('dislike').doc(uid).get();

    List dislikeMe = [];

    if (dislike.exists) {
      _disliked.add(dislike['id']);
      dislikeMe = dislike['id'];
    }
    if (_interestedUser == '7') {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('status', isEqualTo: true)
          .where('finished', isEqualTo: true)
          .where('age', isLessThanOrEqualTo: agemax)
          .where('age', isGreaterThanOrEqualTo: agemin)
          .get();

      final QuerySnapshot resultMe = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      final List<DocumentSnapshot> documentsme = resultMe.docs;
      if (documents.length == 0) {
        _users = [];
      }
      documentsme.forEach((snapshot) {
        var userMe = (snapshot.data() as Map<String, dynamic>);

        if (userMe['uid'] == uid) {
          _me.add(Users(
              age: userMe['age'],
              city: userMe['city'],
              country: userMe['country'],
              height: userMe['height'],
              occupation: userMe['occupation'],
              interested: userMe['interested'],
              latitude: userMe['latitude'],
              longitude: userMe['longitude'],
              listFocus: userMe['listFocus'],
              soul: userMe['soul'],
              token: userMe['token'],
              uid: userMe['uid'],
              zodiac: userMe['zodiac'],
              photos: userMe['photos'],
              weight: userMe['weight'],
              aboutMe: userMe['aboutMe'],
              name: userMe['name'],
              urlImage: userMe['photos'][0]['url']));
        }
      });

      documents.forEach((snapshot) {
        var userLiked = (snapshot.data() as Map<String, dynamic>);

        var distance = const lati.Distance();
        var km = distance.as(
            lati.LengthUnit.Kilometer,
            lati.LatLng(double.parse(userLiked['latitude']),
                double.parse(userLiked['longitude'])),
            lati.LatLng(latUser, lngUser));

        if (userLiked['gender'] == '1' || userLiked['gender'] == '2') {
          if (userLiked['interested'] == genderUser) {
            if (userLiked['photos'][0]['url'] != 'nulo') {
              if (distanceUser >= km) {
                  if (!likeTe.contains(userLiked['uid'])) {
                    userLiked['listFocus'] == null
                        ? userLiked['listFocus'] = [1]
                        : '';
                    if (userLiked['uid'] != uid) {
                      _users.add(Users(
                          age: userLiked['age'],
                          city: userLiked['city'],
                          country: userLiked['country'],
                          height: userLiked['height'],
                          occupation: userLiked['occupation'],
                          interested: userLiked['interested'],
                          latitude: userLiked['latitude'],
                          longitude: userLiked['longitude'],
                          listFocus: userLiked['listFocus'],
                          soul: userLiked['soul'],
                          token: userLiked['token'],
                          uid: userLiked['uid'],
                          zodiac: userLiked['zodiac'],
                          photos: userLiked['photos'],
                          weight: userLiked['weight'],
                          aboutMe: userLiked['aboutMe'],
                          name: userLiked['name'],
                          urlImage: userLiked['photos'][0]['url']));
                    }
                  }
              }
            }
          }
        }
      });

      _users = removeDuplicates(_users);
      _me = removeDuplicates(_me);

      _users = _users.reversed.toList();
      _me = _me.toList();
      notifyListeners();
    } else {
      final QuerySnapshot result = await FirebaseFirestore.instance
          .collection('users')
          .where('status', isEqualTo: true)
          .where('finished', isEqualTo: true)
          .where('gender', isEqualTo: _interestedUser)
          .where('age', isLessThanOrEqualTo: agemax)
          .where('age', isGreaterThanOrEqualTo: agemin)
          .get();

      final QuerySnapshot resultMe = await FirebaseFirestore.instance
          .collection('users')
          .where('uid', isEqualTo: uid)
          .get();

      final List<DocumentSnapshot> documents = result.docs;
      final List<DocumentSnapshot> documentsme = resultMe.docs;

      if (documents.length == 0) {
        _users = [];
      }
      documentsme.forEach((snapshot) {
        var userMe = (snapshot.data() as Map<String, dynamic>);

        if (userMe['uid'] == uid) {
          _me.add(Users(
              age: userMe['age'],
              city: userMe['city'],
              country: userMe['country'],
              height: userMe['height'],
              occupation: userMe['occupation'],
              interested: userMe['interested'],
              latitude: userMe['latitude'],
              longitude: userMe['longitude'],
              listFocus: userMe['listFocus'],
              soul: userMe['soul'],
              token: userMe['token'],
              uid: userMe['uid'],
              zodiac: userMe['zodiac'],
              photos: userMe['photos'],
              weight: userMe['weight'],
              aboutMe: userMe['aboutMe'],
              name: userMe['name'],
              urlImage: userMe['photos'][0]['url']));
        }
      });

      documents.forEach((snapshot) {
        var userLiked = (snapshot.data() as Map<String, dynamic>);

        var distance = const lati.Distance();
        var km = distance.as(
            lati.LengthUnit.Kilometer,
            lati.LatLng(double.parse(userLiked['latitude']),
                double.parse(userLiked['longitude'])),
            lati.LatLng(latUser, lngUser));
        if (userLiked['interested'] == '7') {
          userLiked['interested'] = genderUser;
        }

        if (userLiked['interested'] == genderUser) {
          if (userLiked['photos'][0]['url'] != 'nulo') {
            if (distanceUser >= km) {
                if (!likeTe.contains(userLiked['uid'])) {
                  userLiked['listFocus'] == null
                      ? userLiked['listFocus'] = [1]
                      : '';
                  if (userLiked['uid'] != uid) {
                    _users.add(Users(
                        age: userLiked['age'],
                        city: userLiked['city'],
                        country: userLiked['country'],
                        height: userLiked['height'],
                        occupation: userLiked['occupation'],
                        interested: userLiked['interested'],
                        latitude: userLiked['latitude'],
                        longitude: userLiked['longitude'],
                        listFocus: userLiked['listFocus'],
                        soul: userLiked['soul'],
                        token: userLiked['token'],
                        uid: userLiked['uid'],
                        zodiac: userLiked['zodiac'],
                        photos: userLiked['photos'],
                        weight: userLiked['weight'],
                        aboutMe: userLiked['aboutMe'],
                        name: userLiked['name'],
                        urlImage: userLiked['photos'][0]['url']));
                  }
                }
              }
          }
        }
      });

      _users = removeDuplicates(_users);
      _me = removeDuplicates(_me);

      _users = _users.reversed.toList();
      _me = _me.toList();
      notifyListeners();
    }
  }

  List<Users> removeDuplicates(List<Users> items) {
    List<Users> uniqueItems = []; // uniqueList
    var uniqueIDs =
        items.map((e) => e.uid).toSet(); //list if UniqueID to remove duplicates
    uniqueIDs.forEach((e) {
      uniqueItems.add(items.firstWhere((i) => i.uid == e));
    }); // populate uniqueItems with equivalent original Batch items
    return uniqueItems; //send back the unique items list
  }
}
