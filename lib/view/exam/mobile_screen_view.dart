import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class MobileViewScreen extends StatefulWidget {
  final String url;

  const MobileViewScreen({Key? key, required this.url}) : super(key: key);

  @override
  _MobileViewScreenState createState() => _MobileViewScreenState();
}

class _MobileViewScreenState extends State<MobileViewScreen> {
  late WebViewController controller;

  @override
  void initState() {
    super.initState();
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (progress) => print("Loading: $progress%"),
        onPageStarted: (url) => print("Page started: $url"),
        onPageFinished: (url) => print("Page finished: $url"),
        onWebResourceError: (error) => print("Error: ${error.description}"),
        onNavigationRequest: (request) => request.url.startsWith('https://www.youtube.com/') ? NavigationDecision.prevent : NavigationDecision.navigate,
      ))
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    print('MobileViewScreen: ${widget.url}');
    return Scaffold(
      appBar: AppBar(title: const Text('Mobile View')),
      body: WebViewWidget(controller: controller),
    );
  }
}