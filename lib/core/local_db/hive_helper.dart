import 'package:hive_flutter/hive_flutter.dart';

import '../../features/cart/data/models/cart_item_model.dart';
import 'hive_constants.dart';

class HiveHelper {
  static Future<void> init() async {
    await Hive.initFlutter();
    // ── Register Adapters ─────────────────────────
    Hive.registerAdapter(CartItemModelAdapter());

    // ── Open Boxes ────────────────────────────────
    await Hive.openBox<CartItemModel>(HiveConstants.cartBox);
    await Hive.openBox(HiveConstants.favoritesBox);
    await Hive.openBox(HiveConstants.userBox);
  }

  static Future<Box<T>> openBox<T>(String boxName) async {
    if (!Hive.isBoxOpen(boxName)) {
      return await Hive.openBox<T>(boxName);
    }
    return Hive.box<T>(boxName);
  }

  static Box<T> getBox<T>(String boxName) {
    return Hive.box<T>(boxName);
  }

  static Future<void> closeBox(String boxName) async {
    await Hive.box(boxName).close();
  }

  static Future<void> clearBox(String boxName) async {
    await Hive.box(boxName).clear();
  }
}
