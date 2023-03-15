import 'package:flutter/material.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';

class WebViewPage extends StatefulWidget {
  final String url;
  final Function() onSuccess;
  final Function() onFailure;

  WebViewPage({
    required this.url,
    required this.onSuccess,
    required this.onFailure,
  });

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final flutterWebViewPlugin = FlutterWebviewPlugin();

  @override
  void initState() {
    super.initState();
    flutterWebViewPlugin.onUrlChanged.listen((String url) {
      if (url.contains("success")) {
        widget.onSuccess();
        Navigator.of(context).pop();
      } else if (url.contains("failure")) {
        widget.onFailure();
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    flutterWebViewPlugin.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WebviewScaffold(
      url: widget.url,
      withZoom: true,
      withLocalStorage: true,
      hidden: true,
      appBar: AppBar(
        title: Image.asset('assets/images/ic_cpr_connect.png',
            fit: BoxFit.cover, height: 70),
        backgroundColor: Colors.black,
      ),
    );
  }
}
