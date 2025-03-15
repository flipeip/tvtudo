import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:svg_image/svg_image.dart';

import '../data/models/canal.dart';
import '../data/providers/hive_service.dart';

class ChannelCard extends StatefulWidget {
  final Channel canal;
  final bool isFavorite;
  final Function(Channel, bool) onFavorite;
  final Function(Channel) onPlay;
  final FocusNode? focusNode;

  const ChannelCard({
    super.key,
    required this.canal,
    required this.isFavorite,
    required this.onFavorite,
    required this.onPlay,
    this.focusNode,
  });

  @override
  State<ChannelCard> createState() => _ChannelCardState();
}

class _ChannelCardState extends State<ChannelCard> {
  bool focused = false;
  bool favorited = false;

  @override
  void initState() {
    setState(() {
      favorited = widget.isFavorite;
    });
    super.initState();
  }

  void toggleFavorite() {
    widget.onFavorite(widget.canal, !widget.isFavorite);
    setState(() {
      favorited = !favorited;
    });
  }

  void play(BuildContext context) {
    widget.onPlay(widget.canal);
  }

  @override
  Widget build(BuildContext context) {
    final isSvg = widget.canal.img.endsWith('.svg');

    return Card.outlined(
      clipBehavior: Clip.antiAlias,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: InkWell(
              onTap: () => play(context),
              focusNode: widget.focusNode,
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(
                    height: double.infinity,
                    width: 75,
                    child: Material(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: isSvg
                            ? SvgImage(
                                widget.canal.img,
                                type: PathType.network,
                              )
                            : CachedNetworkImage(
                                imageUrl: widget.canal.img,
                                placeholder: (context, url) => Center(
                                    child: const CircularProgressIndicator()),
                                errorWidget: (context, url, error) =>
                                    Center(child: const Icon(Icons.error)),
                              ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(widget.canal.titulo),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const VerticalDivider(width: 1),
          InkWell(
            onTap: () => widget.onFavorite(widget.canal, !widget.isFavorite),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ValueListenableBuilder(
                  valueListenable:
                      GetIt.I.get<HiveService>().favoritesBox.listenable(),
                  builder: (_, box, ___) {
                    return Icon(
                      box.values.contains(widget.canal.id)
                          ? Icons.favorite
                          : Icons.favorite_border,
                    );
                  }),
            ),
          ),
        ],
      ),
    );
  }
}
