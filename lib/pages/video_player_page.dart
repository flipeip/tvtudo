import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get_it/get_it.dart';
import 'package:tvtudo/data/data/canais.dart';
import 'package:tvtudo/data/models/canal.dart';
import 'package:tvtudo/data/providers/hive_service.dart';
import 'package:tvtudo/widgets/channel_list_overlay.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_android/webview_flutter_android.dart';
import 'package:webview_flutter_platform_interface/webview_flutter_platform_interface.dart';

class VideoPlayerPage extends StatefulWidget {
  final Channel? initialChannel;
  VideoPlayerPage({
    super.key,
    this.initialChannel,
  });

  final webViewController = AndroidWebViewController(
    AndroidWebViewControllerCreationParams(),
  );

  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  bool loaded = false;
  bool isChannelListVisible = false;
  late final _approvedUrls = [];
  late Channel nextChannel;
  late Channel previousChannel;

  FutureOr<NavigationDecision> onNavigationRequest(NavigationRequest request) {
    if (_approvedUrls.contains(request.url)) {
      return NavigationDecision.navigate;
    }

    return NavigationDecision.prevent;
  }

  void performMediaInitSetup() async {
    final controller = widget.webViewController;
    controller.runJavaScript('jwplayer("player").setControls(false);');
    controller.runJavaScript('jwplayer("player").play();');
  }

  void loadChannel(Channel canal) async {
    setState(() {
      loaded = true;
    });
    prepareCloseChannels(canal);
    final request = Dio().getUri(canal.url);
    final response = await request;
    String? iframeUrl;

    if (response.statusCode == 200) {
      final match =
          RegExp(r'<iframe src="(.*)"  ').firstMatch(response.data.toString());
      final matchStr = match?.group(1);
      if (matchStr != null && matchStr.isNotEmpty) {
        iframeUrl = matchStr;
      }
    }

    if (iframeUrl != null) {
      final iframeRequest = Dio().get(iframeUrl);
      final iframeResponse = (await iframeRequest);
      final match = RegExp(r'<iframe src="(.*)"  ')
          .firstMatch(iframeResponse.data.toString());
      final matchStr = match?.group(1);
      if (matchStr != null) {
        setState(() {
          _approvedUrls.add(matchStr);
        });
        final params = LoadRequestParams(uri: Uri.parse(matchStr), headers: {
          'Referer': 'https://reidoscanais.tv/',
          'Sec-Fetch-Dest': 'iframe',
          'Sec-Fetch-Mode': 'navigate',
          'Sec-Fetch-Site': 'cross-site',
          'Sec-Ch-Ua':
              '"Chromium";v="132", "Google Chrome";v="132", ";Not A Brand";v="132"',
          'User-Agent':
              'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/132.0.4324.104 Safari/537.36',
        });
        widget.webViewController.loadRequest(params);
      }
    }
  }

  void prepareCloseChannels(Channel canal) {
    final hiveService = GetIt.I<HiveService>();
    final favorites = hiveService.favoritesBox.values.toList();

    if (favorites.contains(canal.id)) {
      final index = favorites.indexOf(canal.id);
      if (index > 0 && index < favorites.length - 1) {
        setState(() {
          previousChannel =
              canais.firstWhere((canal) => canal.id == favorites[index - 1]);
          nextChannel =
              canais.firstWhere((canal) => canal.id == favorites[index + 1]);
        });
      } else if (index == 0) {
        setState(() {
          previousChannel =
              canais.firstWhere((canal) => canal.id == favorites.last);
          nextChannel =
              canais.firstWhere((canal) => canal.id == favorites[index + 1]);
        });
      } else {
        setState(() {
          previousChannel =
              canais.firstWhere((canal) => canal.id == favorites[index - 1]);
          nextChannel =
              canais.firstWhere((canal) => canal.id == favorites.first);
        });
      }
    }
  }

  @override
  void initState() {
    final controller = widget.webViewController;
    controller.setJavaScriptMode(JavaScriptMode.unrestricted);
    controller.setPlatformNavigationDelegate(NavigationDelegate(
      onNavigationRequest: onNavigationRequest,
      onPageFinished: (_) => performMediaInitSetup(),
    ).platform as AndroidNavigationDelegate);
    controller.setMediaPlaybackRequiresUserGesture(false);
    super.initState();
    if (widget.initialChannel != null) {
      setState(() {
        loaded = true;
      });
      loadChannel(widget.initialChannel!);
    }
  }

  void toggleChannelList(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => ChannelListOverlay(
        onPlay: (Channel canal) {
          loadChannel(canal);
          Navigator.of(context).pop();
        },
      ),
    );
  }

  void nextChannelAction() {
    final sb = SnackBar(content: Text(nextChannel.titulo));
    ScaffoldMessenger.of(context).showSnackBar(sb);
    loadChannel(nextChannel);
  }

  void previousChannelAction() {
    final sb = SnackBar(content: Text(previousChannel.titulo));
    ScaffoldMessenger.of(context).showSnackBar(sb);
    loadChannel(previousChannel);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (_, __) => toggleChannelList(context),
      child: Shortcuts(
        shortcuts: {
          LogicalKeySet(LogicalKeyboardKey.select):
              VoidCallbackIntent(() => toggleChannelList(context)),
          LogicalKeySet(LogicalKeyboardKey.arrowUp):
              VoidCallbackIntent(() => nextChannelAction()),
          LogicalKeySet(LogicalKeyboardKey.arrowDown):
              VoidCallbackIntent(() => previousChannelAction()),
        },
        child: Scaffold(
          body: loaded
              ? PlatformWebViewWidget(
                  PlatformWebViewWidgetCreationParams(
                      controller: widget.webViewController),
                ).build(context)
              : const Center(
                  child: Text(
                  'Clique no botão "Voltar" para abrir a lista de canais.',
                  style: TextStyle(fontSize: 24),
                )),
        ),
      ),
    );
  }

  @override
  void dispose() {
    widget.webViewController.clearCache();
    widget.webViewController.clearLocalStorage();
    super.dispose();
  }
}
