import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';

class BirthAndDeathWebViewStack extends StatefulWidget {

  BirthAndDeathWebViewStack({super.key});

  @override
  State<BirthAndDeathWebViewStack> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<BirthAndDeathWebViewStack> {

  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();

    controller = WebViewController()
      ..setNavigationDelegate(NavigationDelegate(
        onPageStarted: (url) {
          setState(() {
            loadingPercentage = 0;
          });
        },
        onProgress: (progress) {
          setState(() {
            loadingPercentage = progress;
          });
        },
        onPageFinished: (url) {
          setState(() {
            loadingPercentage = 100;
          });
        },
      ))
      ..setJavaScriptMode(JavaScriptMode.unrestricted)  // Enable JavaScript
      ..loadRequest(
        //  sPageLink
        Uri.parse('https://dc.crsorgi.gov.in/crs/Auth/general-public'),
       // Uri.parse(sPageLink),
      );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(
          controller: controller,
        ),
        if (loadingPercentage < 100)
          LinearProgressIndicator(
            value: loadingPercentage / 100.0,
          ),
      ],
    );
  }
}
