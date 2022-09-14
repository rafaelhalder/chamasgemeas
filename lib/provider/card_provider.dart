import 'dart:math';

import 'package:flutter/material.dart';
import 'package:chamasgemeas/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

enum CardStatus { like, dislike, superLike }

class CardProvider extends ChangeNotifier {
  List<Users> _users = [];
  List _liked = [];
  bool _isDragging = false;
  bool _match = true;
  double _angle = 0;
  Offset _position = Offset.zero;
  Size _screenSize = Size.zero;
  User? user = FirebaseAuth.instance.currentUser;
  String? uid = FirebaseAuth.instance.currentUser?.uid;
  CollectionReference chats = FirebaseFirestore.instance.collection('chats');
  CollectionReference matchs = FirebaseFirestore.instance.collection('match');

  List<Users> get users => _users;
  List get liked => _liked;
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
  }

  void dislike() {
    _angle = -20;
    _position -= Offset(2 * _screenSize.width, 0);
    _nextCard();

    notifyListeners();
  }

  void like() async {
    _angle = 20;
    _position += Offset(2 * _screenSize.width, 0);
    _liked.add(_users.last.uid);
    updateLike();
    userLiked();
    await _nextCard();
    notifyListeners();
  }

  void updateLike() async {
    await FirebaseFirestore.instance
        .collection('liked')
        .doc(uid)
        .set({"id": _liked});
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

    if (!listLikedMe.contains(uid)) listLikedMe.add(uid);

    await FirebaseFirestore.instance
        .collection('liked_me')
        .doc(users.last.uid)
        .set({"id": listLikedMe});
  }

  void superLike() {
    _angle = 0;
    _position -= Offset(0, _screenSize.height);
    _nextCard();
    notifyListeners();
  }

  Future _nextCard() async {
    if (users.isEmpty) return;

    await Future.delayed(Duration(milliseconds: 200));
    _users.removeLast();
    resetPosition();
  }

  void resetUsers() async {
    final like =
        await FirebaseFirestore.instance.collection('liked').doc(uid).get();

    if (like.exists) {
      _liked = like['id'];
    }

    final QuerySnapshot result = await FirebaseFirestore.instance
        .collection('users')
        .where('status', isEqualTo: true)
        .get();
    final List<DocumentSnapshot> documents = result.docs;

    documents.forEach((snapshot) {
      var teste = (snapshot.data() as Map<String, dynamic>);
      if (teste['photos'][0]['url'] != 'nulo') {
        _users.add(Users(
            age: teste['age'],
            city: teste['city'],
            country: teste['country'],
            height: teste['height'],
            interested: teste['interested'],
            latitude: teste['latitude'],
            longitude: teste['longitude'],
            listFocus: teste['listFocus'],
            soul: teste['soul'],
            uid: teste['uid'],
            zodiac: teste['zodiac'],
            photos: teste['photos'],
            weight: teste['weight'],
            aboutMe: teste['aboutMe'],
            name: teste['name'],
            urlImage: teste['photos'][0]['url']));
      }
    });

    _users = _users.reversed.toList();

    notifyListeners();
  }
}
