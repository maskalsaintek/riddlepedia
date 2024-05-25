import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/widget/appbar_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebviewScreen extends StatefulWidget {
  final String title;
  final String url;

  const WebviewScreen({super.key, required this.title, required this.url});

  @override
  State<WebviewScreen> createState() => _WebviewScreen();
}

class _WebviewScreen extends State<WebviewScreen> {
  final WebViewController _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000));

  @override
  void initState() {
    super.initState();

    _webViewController.loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: RpAppBar(
                title: widget.title,
                appBarType: RpAppBarType.back,
                onClosePageButtonPressen: () {
                  if (Navigator.canPop(context)) {
                    Navigator.pop(context);
                  } else {
                    SystemNavigator.pop();
                  }
                }),
      body: Padding(
          padding: const EdgeInsets.all(10),
          child: WebViewWidget(controller: _webViewController)),
    ));
  }
}
