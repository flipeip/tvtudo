import 'dart:io';

import 'package:dio/dio.dart';

void main(List<String> args) {
  final canais = generateList();
  saveFile(canais);
}

Future<List<dynamic>> generateList() async {
  final response =
      await Dio().get('https://reidoscanais.tv/canais/canais.json');
  final canais = response.data;
  return canais;
}

void saveFile(Future<List<dynamic>> canais) {
  final file = File('lib/data/data/canais.dart');
  final sink = file.openWrite();
  sink.write('import \'../enums/categoria.dart\';\n');
  sink.write('import \'../models/canal.dart\';\n\n');
  sink.write('final canais = [\n');
  canais.then((value) {
    for (int i = 0; i < value.length; i++) {
      buildCanal(sink, value[i], i);
    }
    sink.write('];\n');
    sink.close();
  });
}

void buildCanal(IOSink sink, dynamic canal, int index) {
  final img = replaceImg(canal['img'], canal['titulo']);
  sink.write('  Channel(\n');
  sink.write('    id: $index,\n');
  sink.write('    titulo: \'${canal['titulo']}\',\n');
  sink.write('    url: Uri.parse(\'${canal['url']}\'),\n');
  sink.write(
      '    categoria: Categoria.${formatCategoria(canal['categoria'])},\n');
  sink.write('    img: \'$img\',\n');
  sink.write('  ),\n');
}

String replaceImg(String img, String canal) {
  if (canal.startsWith('Eleven')) {
    return 'https://upload.wikimedia.org/wikipedia/commons/d/d6/Logo_Eleven_Sports_2020.png';
  }
  if (canal == 'USA') {
    return 'https://upload.wikimedia.org/wikipedia/commons/d/d7/USA_Network_logo_%282016%29.svg';
  }
  if (canal == 'Canal Rural') {
    return 'https://upload.wikimedia.org/wikipedia/pt/3/38/Canalrural.png';
  }
  if (canal == 'UFC Fight Pass') {
    return 'https://upload.wikimedia.org/wikipedia/commons/9/99/UFC_Fight_Pass_Logo.svg';
  }

  return img;
}

String formatCategoria(String categoria) {
  if (categoria == 'Adulto') {
    return 'adultos';
  }

  return categoria
      .replaceFirst(categoria[0], categoria[0].toLowerCase())
      .replaceAll(' ', '')
      .replaceAll('(', '')
      .replaceAll(')', '');
}
