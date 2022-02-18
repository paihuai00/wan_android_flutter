import 'package:flutter/material.dart';
import 'package:wan_android_flutter/models/article_list_model.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/17 3:31 下午
/// @Description: 文章 item

typedef HomeCardWidgetCallBack = Function(
    ArticleItemData? articleItemData, bool isCollection);

class HomeCardWidget extends StatelessWidget {
  ArticleItemData? item;
  HomeCardWidgetCallBack? callBack;

  HomeCardWidget({Key? key, this.item, this.callBack}) : super(key: key);

  final _normalTextStyle = const TextStyle(fontSize: 14, color: Colors.black);

  final _normalLargeTextStyle =
      const TextStyle(fontSize: 16, color: Colors.black);

  @override
  Widget build(BuildContext context) {
    if (item == null) return const SizedBox();

    String author = item!.author ?? "";
    String niceDate = item!.niceDate ?? "";
    String title = item!.title ?? "";
    String superChapterName = item!.superChapterName ?? "";

    return GestureDetector(
      onTap: () {
        callBack?.call(item, false);
      },
      child: Card(
        margin: const EdgeInsets.all(10),
        elevation: 0.7,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  (item!.prefix == null || item!.prefix!.isEmpty)
                      ? const SizedBox()
                      : Text(
                          item!.prefix!,
                          style: const TextStyle(
                              fontSize: 14, color: Colors.redAccent),
                        ),
                  (item!.prefix == null || item!.prefix!.isEmpty)
                      ? const SizedBox()
                      : const SizedBox(
                          width: 10,
                        ),
                  Text(
                    author,
                    style: _normalTextStyle,
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    niceDate,
                    style: _normalTextStyle,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                title,
                style: _normalLargeTextStyle,
              ),
              const SizedBox(
                height: 20,
              ),
              Row(
                children: [
                  Text(
                    superChapterName,
                    style: _normalLargeTextStyle,
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      callBack?.call(item, true);
                    },
                    child: NormalStyle.getLikeImage(item!.collect ?? false),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
