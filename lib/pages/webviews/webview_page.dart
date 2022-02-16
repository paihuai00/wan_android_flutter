import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/16 2:42 下午
/// @Description:

class WebViewPage extends StatefulWidget {
  const WebViewPage({Key? key}) : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final String _TAG = "WebViewPage";

  // Completer<WebViewController> _controller = Completer<WebViewController>();
  // late WebViewController _webViewController;
  late String title = Get.arguments["title"];

  late String url = Get.arguments["url"];

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          title,
          style: const TextStyle(fontSize: 14, color: Colors.white),
        ),
        elevation: 0,
      ),
      body: WebView(
        initialUrl: url,
        javascriptMode: JavascriptMode.unrestricted,
        onWebViewCreated: (WebViewController webViewController) async {
          XLog.d(message: "onWebViewCreated：$url", tag: _TAG);

          // _controller.complete(webViewController);
          // _webViewController = webViewController;
        },
        onProgress: (int progress) {
          XLog.d(message: "加载进度：$progress", tag: _TAG);
        },
        javascriptChannels: <JavascriptChannel>{},
        navigationDelegate: (NavigationRequest request) {
          return NavigationDecision.navigate;
        },
        onPageStarted: (String url) async {
          XLog.d(message: "onPageStarted：$url", tag: _TAG);

          // String? title = await _webViewController.getTitle();
          // if (title?.length != null) {
          //   print('title: $title');
          //   setState(() {
          //     this.title = title!;
          //   });
          // }
        },
        onPageFinished: (String url) {
          XLog.d(message: "onPageFinished：$url", tag: _TAG);
        },
        gestureNavigationEnabled: false,
      ),
    );
  }
}
