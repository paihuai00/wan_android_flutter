import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/1 8:51 下午
/// @Description:

///缓存的 图片 加载

class XImage {
  static Widget load(
    String url, {
    double width = double.infinity,
    double height = 200,
    BoxFit fit = BoxFit.cover,
  }) {
    if (url.isEmpty) {
      return const Icon(Icons.error);
    }

    if (width != 0 && height != 0) {
      return CachedNetworkImage(
        width: width,
        height: height,
        fit: fit,
        imageUrl: url,
        placeholder: (
          BuildContext context,
          String url,
        ) {
          return Image.asset("assets/images/ic_placeholder.png");
        },
        errorWidget: (
          BuildContext context,
          String url,
          dynamic error,
        ) {
          return const Icon(Icons.error);
        },
      );
    } else {
      return CachedNetworkImage(
        fit: fit,
        imageUrl: url,
        placeholder: (
          BuildContext context,
          String url,
        ) {
          return Image.asset("assets/images/ic_placeholder.png");
        },
        errorWidget: (
          BuildContext context,
          String url,
          dynamic error,
        ) {
          return const Icon(Icons.error);
        },
      );
    }
  }
}
