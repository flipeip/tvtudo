import 'package:hive_flutter/hive_flutter.dart';

enum Boxes {
  favorites('favorites');

  final String name;
  const Boxes(this.name);
}

class HiveService {
  late final Box<int> favoritesBox;

  Future<HiveService> init() async {
    await Hive.initFlutter();
    favoritesBox = await Hive.openBox<int>(Boxes.favorites.name);
    return this;
  }
}
