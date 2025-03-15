import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

import 'data/data/canais.dart';
import 'data/providers/hive_service.dart';
import 'pages/video_player_page.dart';
import 'theme.dart';

Future<void> setup() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingletonAsync<HiveService>(HiveService().init);
  await GetIt.I.isReady<HiveService>();
}

void main() async {
  await setup();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  Widget startWithFavorite() {
    final hiveService = GetIt.I<HiveService>();
    final favorites = hiveService.favoritesBox.values.toList();
    final favoriteChannels =
        canais.where((canal) => favorites.contains(canal.id));

    if (favoriteChannels.isNotEmpty) {
      return VideoPlayerPage(
        initialChannel:
            canais.firstWhere((canal) => favorites.contains(canal.id)),
      );
    }

    return VideoPlayerPage();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: theme,
      home: startWithFavorite(),
    );
  }
}
