import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.orange,
        title: const Text('Code Factory'),
        centerTitle: true,
      ),
      body: const WebView(
        initialUrl: 'https://blog.codefactory.ai',
        javascriptMode: JavascriptMode.unrestricted,
      ),
    );
  }
}
