import 'package:flutter/material.dart';

import 'package:poc_webview_windows_dinamic_tabs_flutter/modules/reader/webview_windows.dart';
import 'dart:io';

class WebViewAll extends StatefulWidget {
  
  final String url;

  const WebViewAll({Key? key, required this.url}) : super(key: key);

  

  @override
  WebViewAllState createState() => WebViewAllState();
}

class WebViewAllState extends State<WebViewAll> {
  var webViewAll;

  late final url = widget.url;

  @override
  Widget build(BuildContext context) {
  //   if (Platform.isWindows) {
  //     webViewAll = GlobalKey<WebViewWindowsState>();      
  //   } else {
  //     webViewAll = GlobalKey<WebViewAndroidIosState>();
  //   }

  //   debugPrint('==================================================================================');
  //   debugPrint('retornando webview ' + Theme.of(context).platform.toString());
  //   return Theme.of(context).platform == TargetPlatform.windows
  //       ? WebViewWindows(key:webViewAll, url:widget.url )
  //       : WebViewAndroidIos(key: webViewAll,url: widget.url);
  // }

  return WebViewWindows(url:widget.url);
}}