import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:photo_view/photo_view.dart';
import 'package:wan_android_flutter/routers/navigator_util.dart';
import 'package:wan_android_flutter/utils/log_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/3/6 3:40 下午
/// @Description: 实现可拖动的 imageView
class PhotoViewPage extends StatelessWidget {
  final String _TAG = "PhotoViewPage";

  String? imageUrl;

  PhotoViewPage({this.imageUrl, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null && Get.arguments is Map<String, dynamic>) {
      imageUrl = Get.arguments["imageUrl"];
    }

    XLog.d(message: "获取到的图片地址为：${imageUrl ?? ""}", tag: _TAG);

    return Scaffold(
      body: Stack(
        children: [
          Container(
            color: Colors.black26,
            child: PhotoView(
              backgroundDecoration: const BoxDecoration(color: Colors.white38),
              imageProvider: NetworkImage(imageUrl ?? ""),
              minScale: 0.2,
              maxScale: 3.0,
              loadingBuilder: (context, event) {
                return const Center(
                  child: CircularProgressIndicator(
                    color: Colors.black38,
                  ),
                );
              },
            ),
          ),
          Positioned(
            left: 20,
            top: 70,
            child: InkWell(
              onTap: () {
                NavigatorUtil.goBack(context);
              },
              child: const Image(
                image: AssetImage("assets/images/close_fill.png"),
                width: 30,
                height: 30,
              ),
            ),
          )
        ],
      ),
    );
  }
}
