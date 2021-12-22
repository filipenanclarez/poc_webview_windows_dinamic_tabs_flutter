import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:poc_webview_windows_dinamic_tabs_flutter/modules/reader/reader_tab.dart';
import 'package:poc_webview_windows_dinamic_tabs_flutter/modules/reader/webview_all.dart';
import 'package:poc_webview_windows_dinamic_tabs_flutter/modules/reader/webview_windows.dart';
import 'package:webview_windows/webview_windows.dart';

class ReaderPage extends StatefulWidget {
  final String indexKey;
  const ReaderPage({Key? key, required this.indexKey}) : super(key: key);

  @override
  _ReaderPageState createState() => _ReaderPageState();
}

class _ReaderPageState extends State<
    ReaderPage> with AutomaticKeepAliveClientMixin<ReaderPage> {
  final _controller = WebviewController();
  // @override
  // void setState(fn) {
  //   if (mounted) super.setState(fn);
  // }

  // @override
  // void didUpdateWidget(ReaderPage oldWidget) {
  //   if (mounted) setState(() {});

  //   super.didUpdateWidget(oldWidget);
  // }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) async {
      await Future.delayed(Duration(seconds: 15));
      if (mounted) {
        initPlatformState();
      }
    });
  }

  Future<void> initPlatformState() async {
    // Optionally initialize the webview environment using
    // a custom user data directory
    // and/or a custom browser executable directory
    // and/or custom chromium command line flags
    //await WebviewController.initializeEnvironment(
    //    additionalArguments: '--show-fps-counter');

    // await Future.delayed(Duration(seconds: 15));
    await _controller.initialize();

    _controller.url.listen((url) {
      // _textController.text = url;
    });

    await _controller.setBackgroundColor(Colors.transparent);
    await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    await _controller.loadUrl('https://flutter.dev');

    if (!mounted) return;

    // await Future.delayed(Duration(seconds: 15));

    setState(() {});
  }

  var counter = 0;

  // final webVieWallKey = GlobalKey<WebViewAllState>();

  // metodo que é chamado quando recebo o evendo dos webviews
  // String evaluateJS({String? script}) {
  //   return webVieWallKey.currentState?.webViewAll.currentState
  //       ?.evaluateJS(script: script);
  // }

  @override
  Widget build(BuildContext context) {
    // super.build(context);
    // return Scaffold(
    //   body: Center(
    //     child: Container(
    //       // child: Text('key: ' + widget.indexKey),
    //       child: Text('Pressionado $counter vezes'),
    //     ),
    //   ),
    //   // body: WebViewWindows(url:'http://uol.com.br' ),
    //   floatingActionButton: FloatingActionButton(
    //     child: Icon(Icons.add),
    //     onPressed: () {
    //       counter ++;
    //       debugPrint('dentro da aba');
    //       setState(() {});
    //     },
    //   ),
    // );

    // return const WebViewAll(
    //   // key: webVieWallKey,
    //   url: 'http://uol.com.br',
    // );

    // return WebViewWindows(url:'http://uol.com.br' );
    // return Container();

    return Scaffold(
      // body: Center(
      //   child: Container(
      //     // child: Text('key: ' + widget.indexKey),
      //     child: Text('Pressionado $counter vezes'),
      //   ),
      // ),

      body: Column(
        children: [
          Text('Pressionado $counter vezes'),
          Expanded(
            child: !_controller.value.isInitialized
                ? Text('Não inicializado')
                : Webview(
                    _controller,
                    permissionRequested: _onPermissionRequested,
                  ),
          ),
        ],
      ),

      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          counter++;
          debugPrint('dentro da aba');
          setState(() {});
          // initPlatformState();
        },
      ),
    );
  }

  Future<WebviewPermissionDecision> _onPermissionRequested(
      String url, WebviewPermissionKind kind, bool isUserInitiated) async {
    final decision = await showDialog<WebviewPermissionDecision>(
      context: navigatorKey.currentContext!,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('WebView permission requested'),
        content: Text('WebView has requested permission \'$kind\''),
        actions: <Widget>[
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.deny),
            child: const Text('Deny'),
          ),
          TextButton(
            onPressed: () =>
                Navigator.pop(context, WebviewPermissionDecision.allow),
            child: const Text('Allow'),
          ),
        ],
      ),
    );

    return decision ?? WebviewPermissionDecision.none;
  }
}
