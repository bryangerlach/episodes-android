import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WebViewContainer extends StatefulWidget {
  const WebViewContainer({super.key});

  @override
  State<WebViewContainer> createState() => _WebViewContainerState();
}

class _WebViewContainerState extends State<WebViewContainer> {
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();

  final controller = WebViewController()
    ..setJavaScriptMode(JavaScriptMode.unrestricted);
    //..loadRequest(Uri.parse("https://example.com"));

  Future<void> _refreshData() async {
    controller.reload(); // Reload the webview content
  }

  String _url = ""; // Default URL

  Future<void> _checkForSavedUrl() async {
    final prefs = await SharedPreferences.getInstance();
    _url = prefs.getString('url') ?? ""; // Use empty string if no URL found
    if (_url.isEmpty) {
      await _showUrlInputDialog(); // Show dialog if no URL is saved
    } else {
      controller.loadRequest(Uri.parse(_url));
    }
  }

  Future<void> _showUrlInputDialog() async {
    final urlController = TextEditingController();
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Enter URL'),
        content: TextField(
          controller: urlController,
          decoration: InputDecoration(hintText: 'Enter a valid URL'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              if (Uri.parse(urlController.text).hasAbsolutePath) {
                setState(() {
                  _url = urlController.text;
                });
                controller.loadRequest(Uri.parse(_url));
                _saveUrlToSharedPreferences(_url);
                Navigator.pop(context);
              } else {
                // Show error message for invalid URL
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Invalid URL. Please try again.'),
                  ),
                );
              }
            },
            child: Text('Save'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveUrlToSharedPreferences(String url) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('url', url);
  }

  @override
  void initState() {
    super.initState();
    _checkForSavedUrl();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        if (await controller.canGoBack()) {
          controller.goBack();
          return false;
          // Prevent app from closing
        }
        return true; // Allow app to close
      },
      child: Scaffold(
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: _refreshData,
            child: WebViewWidget(
              controller: controller,
            ),
          ),
        ),
      ),
    );
  }
}
