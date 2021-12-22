import 'package:flutter/material.dart';
import 'package:poc_webview_windows_dinamic_tabs_flutter/modules/reader/reader_tab.dart';
import 'package:webview_windows/webview_windows.dart';
import 'package:flutter/services.dart';

import 'dart:async';
final navigatorKey = GlobalKey<NavigatorState>();

class WebViewWindows extends StatefulWidget {
  final String url;

  const WebViewWindows({Key? key, required this.url}) : super(key: key);

  @override
  _WebViewWindowsState createState() => _WebViewWindowsState();
}

class _WebViewWindowsState extends State<WebViewWindows> {
  final _controller = WebviewController();
  @override
  void initState() {
    super.initState();
        initPlatformState();

  }

  Future<void> initPlatformState() async {
    // Optionally initialize the webview environment using
    // a custom user data directory
    // and/or a custom browser executable directory
    // and/or custom chromium command line flags
    //await WebviewController.initializeEnvironment(
    //    additionalArguments: '--show-fps-counter');

    await Future.delayed(Duration(seconds: 15));
    await _controller.initialize();

    _controller.url.listen((url) {
      // _textController.text = url;
    });

    await _controller.setBackgroundColor(Colors.transparent);
    await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
    await _controller.loadUrl('https://flutter.dev');

    if (!mounted) return;

    setState(() {});
  }

  @override
  void dispose() {
    debugPrint('foi chamado o overide');
    super.dispose();
  }

  var counter = 0;

  @override
  Widget build(BuildContext context) {
    // super.build(context);

    
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
            child: !_controller.value.isInitialized ? Text('Não inicializado'):Webview(
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
        },
      ),
    );
  }

  // final _controller = WebviewController();
  // final _textController = TextEditingController();
  // bool _isWebviewSuspended = false;

  // @override
  // void initState() {
  //   super.initState();

  //   // initPlatformState();
  //   WidgetsBinding.instance?.addPostFrameCallback((_) async {
  //     debugPrint('addPostFrameCallback_1');

  //     await Future.delayed(Duration(seconds: 10));

  //     await _controller.initialize();

  //     debugPrint('addPostFrameCallback_2');

  //     await Future.delayed(Duration(seconds: 10));

  //     await _controller.loadUrl('https://flutter.dev');

  //     debugPrint('addPostFrameCallback_3');

  //     await Future.delayed(Duration(seconds: 10));

  //     setState(() {});

  //     debugPrint('addPostFrameCallback_4');

  //     // _controller.loadingState.listen((event) async {
  //     //   if (event == LoadingState.navigationCompleted) {
  //     //     debugPrint('pagina carregada');
  //     //     setState(() {});
  //     //   }
  //     // });

  //   });
  // }

  // // @override
  // // void setState(fn) {
  // //   if (mounted) super.setState(fn);
  // // }

  // @override
  // void dispose(){
  //   debugPrint('foi chamado o overide');
  //   super.dispose();
  // }

  // Future<void> initPlatformState() async {
  //   // Optionally initialize the webview environment using
  //   // a custom user data directory
  //   // and/or a custom browser executable directory
  //   // and/or custom chromium command line flags
  //   //await WebviewController.initializeEnvironment(
  //   //    additionalArguments: '--show-fps-counter');

  //   await _controller.initialize();
  //   _controller.url.listen((url) {
  //     _textController.text = url;
  //   });

  //   await _controller.setBackgroundColor(Colors.transparent);
  //   await _controller.setPopupWindowPolicy(WebviewPopupWindowPolicy.deny);
  //   await _controller.loadUrl('https://flutter.dev');

  //   // if (!mounted) return;

  //   // setState(() {});
  // }

  // Widget compositeView() {
  //   // return Stack(
  //   //   children: [
  //   //     Visibility(
  //   //         visible: true,
  //   //         child: Text(
  //   //           'Not Initialized',
  //   //           style: TextStyle(
  //   //             fontSize: 24.0,
  //   //             fontWeight: FontWeight.w900,
  //   //           ),
  //   //         ))
  //   //   ],
  //   // );

  //   // // Visibility(child: Text(
  //   // //     'Not Initialized',
  //   // //     style: TextStyle(
  //   // //       fontSize: 24.0,
  //   // //       fontWeight: FontWeight.w900,
  //   // //     ),
  //   // //   )
  //   // //   );

  //   if (!_controller.value.isInitialized) {
  //     return const Text('Not Initialized',
  //         style: TextStyle(
  //           fontSize: 24.0,
  //           fontWeight: FontWeight.w900,
  //         ));
  //   } else {
  //     return Padding(
  //       padding: EdgeInsets.all(20),
  //       child: Column(
  //         children: [
  //           Card(
  //             elevation: 0,
  //             child: TextField(
  //               decoration: InputDecoration(
  //                   hintText: 'URL',
  //                   contentPadding: EdgeInsets.all(10.0),
  //                   suffixIcon: IconButton(
  //                     icon: Icon(Icons.refresh),
  //                     onPressed: () {
  //                       _controller.reload();
  //                     },
  //                   )),
  //               textAlignVertical: TextAlignVertical.center,
  //               controller: _textController,
  //               onSubmitted: (val) {
  //                 _controller.loadUrl(val);
  //               },
  //             ),
  //           ),
  //           Expanded(
  //               child: Card(
  //                   color: Colors.transparent,
  //                   elevation: 0,
  //                   clipBehavior: Clip.antiAliasWithSaveLayer,
  //                   child: Stack(
  //                     children: [
  //                       Webview(
  //                         _controller,
  //                         permissionRequested: _onPermissionRequested,
  //                       ),
  //                       StreamBuilder<LoadingState>(
  //                           stream: _controller.loadingState,
  //                           builder: (context, snapshot) {
  //                             if (snapshot.hasData &&
  //                                 snapshot.data == LoadingState.loading) {
  //                               return LinearProgressIndicator();
  //                             } else {
  //                               return SizedBox();
  //                             }
  //                           }),
  //                     ],
  //                   ))),
  //         ],
  //       ),
  //     );
  //   }
  // }

  // @override
  // Widget build(BuildContext context) {
  //   return Center(
  //     child: compositeView(),
  //   );

  //   // return
  //   //   Scaffold(
  //   //     // navigatorKey: navigatorKey,
  //   //     floatingActionButton: FloatingActionButton(
  //   //       tooltip: _isWebviewSuspended ? 'Resume webview' : 'Suspend webview',
  //   //       onPressed: () async {
  //   //         if (_isWebviewSuspended) {
  //   //           await _controller.resume();
  //   //         } else {
  //   //           await _controller.suspend();
  //   //         }
  //   //         setState(() {
  //   //           _isWebviewSuspended = !_isWebviewSuspended;
  //   //         });
  //   //       },
  //   //       child: Icon(_isWebviewSuspended ? Icons.play_arrow : Icons.pause),
  //   //     ),
  //   //     appBar: AppBar(
  //   //         title: StreamBuilder<String>(
  //   //       stream: _controller.title,
  //   //       builder: (context, snapshot) {
  //   //         return Text(snapshot.hasData
  //   //             ? snapshot.data!
  //   //             : 'WebView (Windows) Example');
  //   //       },
  //   //     )),
  //   //     body: Center(
  //   //       child: compositeView(),
  //   //     ),

  //   // );
  // }

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
