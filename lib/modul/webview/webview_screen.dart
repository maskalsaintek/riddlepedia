import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:riddlepedia/constants/app_bar_type.dart';
import 'package:riddlepedia/constants/app_color.dart';
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
  int _stackToView = 1;

  final WebViewController _webViewController = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted)
    ..setBackgroundColor(const Color(0x00000000));

  @override
  void initState() {
    super.initState();

    _webViewController.loadRequest(Uri.parse(widget.url));
    _webViewController
        .setNavigationDelegate(NavigationDelegate(onPageStarted: (String url) {
      setState(() {
        _stackToView = 1;
      });
    }, onPageFinished: (String url) {
      setState(() {
        _stackToView = 0;
      });
    }));
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
      body: IndexedStack(
        index: _stackToView,
        children: [
          Padding(
              padding: const EdgeInsets.all(10),
              child: WebViewWidget(controller: _webViewController)),
          Center(
              child: SizedBox(
                  width: 100,
                  child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: LoadingAnimationWidget.staggeredDotsWave(
                          color: AppColor.secondaryColor, size: 75))))
        ],
      ),
    ));
  }
}
