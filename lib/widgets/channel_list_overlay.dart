import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import '../data/enums/categoria.dart';
import '../data/models/canal.dart';
import '../data/data/canais.dart';
import '../data/providers/hive_service.dart';
import 'channel_card.dart';

List<Channel> processarCanais(dynamic message) {
  return (message as List).map((e) => Channel.fromJson(e)).toList();
}

class ChannelListOverlay extends StatefulWidget {
  final void Function(Channel) onPlay;
  const ChannelListOverlay({
    super.key,
    required this.onPlay,
  });

  @override
  State<ChannelListOverlay> createState() => _ChannelListOverlayState();
}

class _ChannelListOverlayState extends State<ChannelListOverlay> {
  List<Channel> canaisCategoria = [];
  int selectedIndex = 0;
  FocusNode firstFocus = FocusNode();
  final listScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    setState(() {
      canaisCategoria = canais.where((canal) => isFavorite(canal)).toList();
    });
    firstFocus.requestFocus();
  }

  bool isFavorite(Channel canal) {
    return GetIt.I<HiveService>().favoritesBox.values.contains(canal.id);
  }

  void toggleFavorite(Channel canal, bool isFavorite) {
    final box = GetIt.I<HiveService>().favoritesBox;

    if (isFavorite) {
      box.put(canal.id, canal.id);
    } else {
      box.delete(canal.id);
    }

    if (selectedIndex == 0) {
      setState(() {
        canaisCategoria =
            canaisCategoria.where((element) => element.id != canal.id).toList();
      });
    }
  }

  // Nulo = Favoritos
  void changeCategory(Categoria? categoria) {
    listScrollController.jumpTo(0);
    setState(() {
      firstFocus = FocusNode();
    });
    setState(() {
      selectedIndex = categoria == null
          ? 0
          : Categoria.notHiddenValues.indexOf(categoria) + 1;

      if (categoria == null) {
        canaisCategoria = canais.where((canal) => isFavorite(canal)).toList();
        return;
      }
      canaisCategoria =
          canais.where((canal) => canal.categoria == categoria).toList();
    });

    firstFocus.requestFocus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          NavigationRail(
            extended: true,
            onDestinationSelected: (index) {
              changeCategory(
                  index == 0 ? null : Categoria.notHiddenValues[index - 1]);
            },
            destinations: [
              NavigationRailDestination(
                icon: Icon(Icons.favorite),
                label: Text('Favoritos'),
              ),
              for (final categoria in Categoria.notHiddenValues)
                NavigationRailDestination(
                  icon: Icon(categoria.icone),
                  label: Text(categoria.nome),
                ),
            ],
            selectedIndex: selectedIndex,
          ),
          Expanded(
            child: canais.isEmpty
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : GridView.builder(
                    controller: listScrollController,
                    itemCount: canaisCategoria.length,
                    padding: EdgeInsets.all(24),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        mainAxisExtent: 100),
                    itemBuilder: (_, index) {
                      final canal = canaisCategoria[index];

                      return ChannelCard(
                        canal: canal,
                        focusNode: index == 0 ? firstFocus : null,
                        isFavorite: isFavorite(canal),
                        onFavorite: toggleFavorite,
                        onPlay: widget.onPlay,
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
