import 'package:flutter/material.dart';
import 'package:poc_webview_windows_dinamic_tabs_flutter/modules/reader/reader_tab.dart';
import 'package:poc_webview_windows_dinamic_tabs_flutter/modules/reader/webview_windows.dart';

class Reader extends StatefulWidget {
  const Reader({Key? key}) : super(key: key);

  @override
  _ReaderState createState() => _ReaderState();
}

class _ReaderState extends State<Reader> {
  @override
  Widget build(BuildContext context) {
    // debugPrint(Theme.of(context).platform.toString());
    // return Scaffold(
    //   body: SafeArea(child: memodu.ReaderTab()) ,
    // );

    return Scaffold(
      body: ReaderTab()
    ) ;


    // return Scaffold(body: WebViewWindows(url: 'http://uol.com.br'));
  }
}
