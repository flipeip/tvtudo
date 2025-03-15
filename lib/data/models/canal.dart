import 'package:hive_flutter/hive_flutter.dart';

import '../enums/categoria.dart';

@HiveType(typeId: 0)
class Channel {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String titulo;

  @HiveField(2)
  final Categoria categoria;

  @HiveField(4)
  final String img;

  @HiveField(5)
  final Uri url;

  const Channel({
    required this.id,
    required this.titulo,
    required this.categoria,
    required this.img,
    required this.url,
  });

  factory Channel.fromJson(Map<String, dynamic> json) {
    return Channel(
      id: json['id'] ?? 0,
      titulo: json['titulo'] as String,
      categoria: Categoria.fromString(json['categoria'] as String),
      img: json['img'] as String,
      url: Uri.parse(json['url'] as String),
    );
  }

  @override
  String toString() => titulo;
}
