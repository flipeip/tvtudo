import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 1)
enum Categoria {
  globo('Globo', Icons.tv),
  canaisAbertos('Canais Abertos', Icons.tv),
  esportes('Esportes', Icons.sports_soccer),
  noticias('Notícias', Icons.newspaper),
  entretenimento('Entretenimento', Icons.movie),
  adultos('Adultos', Icons.visibility_off, hidden: true),
  outros('Outros', Icons.tv, hidden: true);

  final String nome;
  final IconData icone;
  final bool hidden;

  const Categoria(this.nome, this.icone, {this.hidden = false});

  static Categoria fromString(String nome) {
    switch (nome) {
      case 'Globo':
        return Categoria.globo;
      case 'Canais Abertos':
        return Categoria.canaisAbertos;
      case 'Esportes':
        return Categoria.esportes;
      case 'Notícias':
        return Categoria.noticias;
      case 'Entretenimento':
        return Categoria.entretenimento;
      case 'Adultos':
        return Categoria.adultos;
      case _:
        return Categoria.outros;
    }
  }

  static List<Categoria> get notHiddenValues =>
      values.where((Categoria c) => !c.hidden).toList();
}
