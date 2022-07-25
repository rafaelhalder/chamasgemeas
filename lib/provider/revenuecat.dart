import 'package:chamasgemeas/api/purchase_api.dart';
import 'package:chamasgemeas/model/entitlement.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:purchases_flutter/models/entitlement_info_wrapper.dart';
import 'package:purchases_flutter/models/purchaser_info_wrapper.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class RevenueCatProvider extends ChangeNotifier {
  RevenueCatProvider() {
    init();
  }

  int coins = 0;
  Entitlement _entitlement = Entitlement.free;
  Entitlement get entitlement => _entitlement;
  Future init() async {
    Purchases.addPurchaserInfoUpdateListener((purchaseInfo) async {
      updatePurchaseStatus();
    });
  }

  void currentCoin() async {
    String? uid = FirebaseAuth.instance.currentUser?.uid;

    final foundLikeMe =
        await FirebaseFirestore.instance.collection('user').doc(uid).get();
  }

  Future updatePurchaseStatus() async {
    final purchaserInfo = await Purchases.getPurchaserInfo();

    final entitlements = purchaserInfo.entitlements.active.values.toList();

    _entitlement =
        entitlements.isEmpty ? Entitlement.free : Entitlement.allCourses;

    notifyListeners();
  }

  void addCoinsPackage(Package package) {
    switch (package.offeringIdentifier) {
      case Coins.idCoins1:
        coins += 10;
        break;
      default:
        break;
    }
    notifyListeners();
  }

  void spend1Coins() {
    coins -= 10;
    notifyListeners();
  }
}
