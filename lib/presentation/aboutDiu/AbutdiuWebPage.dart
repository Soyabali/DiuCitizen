import 'package:webview_flutter/webview_flutter.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class AbutDiuWebPage extends StatefulWidget {
  final String webPage;
  const AbutDiuWebPage(this.webPage, {super.key});

  @override
  State<AbutDiuWebPage> createState() => _WebViewStackState();
}

class _WebViewStackState extends State<AbutDiuWebPage> {
  var loadingPercentage = 0;
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    debugPrint("🌐 Opening WebPage: ${widget.webPage}");

    controller = WebViewController()
      ..setNavigationDelegate(
        NavigationDelegate(
          onNavigationRequest: (request) {
            String url = request.url;
            debugPrint("🔗 Navigating to: $url");

            // ✅ Handle UPI and wallet deep links
            if (_isUpiUrl(url)) {
              _launchUpiIntent(url);
              return NavigationDecision.prevent; // stop webview navigation
            }
            return NavigationDecision.navigate;
          },
          onPageStarted: (url) {
            setState(() => loadingPercentage = 0);
          },
          onProgress: (progress) {
            setState(() => loadingPercentage = progress);
          },
          onPageFinished: (url) {
            setState(() => loadingPercentage = 100);
          },
        ),
      )
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse(widget.webPage));
  }

  /// ✅ Check if URL is a UPI deep link
  bool _isUpiUrl(String url) {
    return url.startsWith("upi://") ||
        url.startsWith("tez://") ||
        url.startsWith("phonepe://") ||
        url.startsWith("paytmmp://") ||
        url.startsWith("bhim://");
  }

  /// ✅ Open UPI Intent (Google Pay, PhonePe, Paytm, etc.)
  Future<void> _launchUpiIntent(String upiUrl) async {
    try {
      Uri uri = Uri.parse(upiUrl);

      if (await canLaunchUrl(uri)) {
        await launchUrl(
          uri,
          mode: LaunchMode.externalApplication, // ensures UPI apps open
        );
      } else {
        _showSnack("⚠️ No UPI app found. Please install Google Pay / PhonePe / Paytm.");
      }
    } catch (e) {
      debugPrint("❌ Error launching UPI: $e");
      _showSnack("Failed to open UPI app. Try again.");
    }
  }

  /// ✅ Helper to show snack messages safely
  void _showSnack(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        WebViewWidget(controller: controller),
        if (loadingPercentage < 100)
          LinearProgressIndicator(value: loadingPercentage / 100.0),
      ],
    );
  }
}
