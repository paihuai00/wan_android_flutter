import 'package:flutter/material.dart';
import 'package:wan_android_flutter/models/collection_article_model.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/16 4:46 下午
/// @Description:
///
typedef CollectionWidgetCallBack = Function(
    CollectionItemData data, bool isUnCollection);

class CollectionItemWidget extends StatefulWidget {
  CollectionItemData itemData;
  CollectionWidgetCallBack? onTap;

  CollectionItemWidget(this.itemData, {Key? key, this.onTap}) : super(key: key);

  @override
  _CollectionItemWidgetState createState() => _CollectionItemWidgetState();
}

class _CollectionItemWidgetState extends State<CollectionItemWidget> {
  final grayStyle = const TextStyle(fontSize: 14, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.onTap?.call(widget.itemData, false);
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
                  Text(
                    widget.itemData.author ?? "",
                    style: grayStyle,
                  ),
                  const Expanded(child: SizedBox()),
                  Text(
                    widget.itemData.niceDate ?? "",
                    style: grayStyle,
                  ),
                ],
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.itemData.title ?? "",
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.itemData.desc ?? "",
                style: const TextStyle(fontSize: 16, color: Colors.black),
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                children: [
                  Text(
                    widget.itemData.chapterName ?? "",
                    style: grayStyle,
                  ),
                  const Expanded(child: SizedBox()),
                  InkWell(
                    onTap: () {
                      widget.onTap?.call(widget.itemData, true);
                    },
                    child: NormalStyle.getLikeImage(true),
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
