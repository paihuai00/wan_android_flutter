import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:get/get.dart';
import 'package:wan_android_flutter/base/base_state.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/routers/router_config.dart';
import 'package:wan_android_flutter/utils/log_util.dart';
import 'package:wan_android_flutter/utils/toast_util.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/16 2:42 下午
/// @Description:

class WebViewPage extends StatefulWidget {
  String? title;
  String? url;
  bool? isOpenFromHome = false;

  WebViewPage({this.title, this.url, this.isOpenFromHome, Key? key})
      : super(key: key);

  @override
  _WebViewPageState createState() => _WebViewPageState();
}

class _WebViewPageState extends BaseState<WebViewPage> {
  final String _TAG = "WebViewPage";

  // final WebViewController _controller = WebViewController();
  late WebViewController _webViewController;
  String title = "";

  String url = "";

  int progress = 0;

  @override
  void initState() {
    super.initState();

    if (Platform.isAndroid) {
      WebView.platform = SurfaceAndroidWebView();
    }

    if (Get.arguments != null) {
      title = Get.arguments["title"];
      url = Get.arguments["url"];
    }

    title = title.isEmpty ? (widget.title ?? "") : title;
    url = url.isEmpty ? (widget.url ?? "") : url;
  }

  @override
  void onBuildFinish() {
    if (!(widget.isOpenFromHome ?? false)) {
      XToast.show("双击图片，可查看大图");
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return (widget.isOpenFromHome ?? false)
        ? _buildBodyWidget()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: Html(
                data: title ?? "",
                style: {"*": Style(color: Colors.white)},
              ),
              elevation: 0,
            ),
            body: _buildBodyWidget(),
          );
  }

  _buildBodyWidget() {
    return GestureDetector(
      onDoubleTapDown: (details) {
        XLog.d(
            message:
                "onDoubleTapDown： x = ${details.localPosition.dx} , y = ${details.localPosition.dy} ",
            tag: _TAG);
        String imgUrl =
            'document.elementFromPoint(${details.localPosition.dx}, ${details.localPosition.dy}).src';
        _webViewController.evaluateJavascript(imgUrl).then((value) async {
          if (value.startsWith("\"")) {
            //兼容
            value = value.substring(1, value.length);
          }

          if (value.endsWith("\"")) {
            //兼容
            value = value.substring(0, value.length - 1);
          }

          if (value.isEmpty || !value.startsWith("http")) {
            XLog.d(
                message: "onDoubleTapDown： 双击 未找到资源 value  = $value ",
                tag: _TAG);

            return;
          }
          XLog.d(message: "onDoubleTapDown：图片地址为:  = $value ", tag: _TAG);

          NavigatorUtil.jump(RouterConfig.photoViewPage,
              arguments: {"imageUrl": value});
        });
      },
      onDoubleTap: () {},
      child: Column(
        children: [
          progress >= 99
              ? const SizedBox()
              : LinearProgressIndicator(
                  value: progress / 100,
                  color: Colors.blue,
                  backgroundColor: Colors.white12,
                ),
          Expanded(
              child: WebView(
            initialUrl: url ?? "",
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) async {
              XLog.d(message: "onWebViewCreated：$url", tag: _TAG);

              // _controller.complete(webViewController);
              _webViewController = webViewController;
              XLog.d(message: "onWebViewCreated：$url", tag: _TAG);
            },
            onProgress: (int progress) {
              XLog.d(message: "加载进度：$progress", tag: _TAG);
              setState(() {
                this.progress = progress;
              });
            },
            javascriptChannels: <JavascriptChannel>{},
            // navigationDelegate: (NavigationRequest request) {
            //   return NavigationDecision.navigate;
            // },
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
          ))
        ],
      ),
    );
  }
}
