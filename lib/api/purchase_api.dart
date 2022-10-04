import 'dart:io';

import 'package:flutter/services.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

class Coins {
  static const idCoins1 = 'coins';
  static const idCoins2 = 'coin_chamas_1';
  static const idCoins3 = 'chamas_10';
  static const idCoins4 = 'chamas_100';
  static const idCoins5 = 'coin_1_chamas';
  static const idCoins6 = 'coin_10_chamas';
  static const idCoins7 = 'coin_50_chamas';
  static const idCoins8 = 'coin_100_chamas';

  static const allIds = [idCoins1];
}

class PurchaseApi {
  static Future init() async {
    await Purchases.setDebugLogsEnabled(true);
    Platform.isIOS
        ? await Purchases.setup('appl_wrsVIhZDJSwSbXVTjrBwQBzrYbW')
        : await Purchases.setup('goog_FccwpagdaFLZlMkVbnsNqeqTdEa');
  }

  static Future<List<Offering>> fetchOffersByIds(List<String> ids) async {
    final offers = await fetchOffers();

    return offers.where((offer) => ids.contains(offer.identifier)).toList();
  }

  static Future<List<Offering>> fetchOffers({bool all = true}) async {
    try {
      final offerings = await Purchases.getOfferings();

      if (!all) {
        final current = offerings.current;

        return current == null ? [] : [current];
      } else {
        return offerings.all.values.toList();
      }
    } on PlatformException catch (e) {
      print(e);
      return [];
    }
  }

  static Future<bool> purchasePackage(Package package) async {
    try {
      await Purchases.purchasePackage(package);
      return true;
    } catch (e) {
      return false;
    }
  }
}
