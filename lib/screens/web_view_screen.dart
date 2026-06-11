import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// In-app browser that renders a website without leaving the app.
class WebViewScreen extends StatefulWidget {
  final String url;
  final String title;
  final Color color;

  const WebViewScreen({
    super.key,
    required this.url,
    required this.title,
    required this.color,
  });

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late final WebViewController _controller;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          // Only allow secure HTTPS navigation. Block javascript:, file:,
          // intent:, data: and any cleartext redirects.
          onNavigationRequest: (request) {
            final uri = Uri.tryParse(request.url);
            return (uri != null && uri.scheme == 'https')
                ? NavigationDecision.navigate
                : NavigationDecision.prevent;
          },
          onPageStarted: (_) {
            if (mounted) setState(() => _loading = true);
          },
          onPageFinished: (_) {
            if (mounted) setState(() => _loading = false);
          },
        ),
      )
      ..loadRequest(Uri.parse(widget.url));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: widget.color,
        foregroundColor: Colors.white,
        systemOverlayStyle: SystemUiOverlayStyle.light,
        title: Text(widget.title),
        elevation: 0,
      ),
      body: Stack(
        children: [
          WebViewWidget(controller: _controller),
          if (_loading)
            LinearProgressIndicator(
              color: widget.color,
              backgroundColor: widget.color.withValues(alpha: 0.2),
            ),
        ],
      ),
    );
  }
}
