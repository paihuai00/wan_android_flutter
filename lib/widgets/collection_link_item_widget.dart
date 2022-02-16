import 'package:flutter/material.dart';
import 'package:wan_android_flutter/models/collection_link_model.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/16 4:46 下午
/// @Description:
///
typedef CollectionLinkWidgetCallBack = Function(
    CollectionLinkData data, bool isUnCollection);

class CollectionLinkItemWidget extends StatefulWidget {
  CollectionLinkData itemData;
  CollectionLinkWidgetCallBack? onTap;

  CollectionLinkItemWidget(this.itemData, {Key? key, this.onTap})
      : super(key: key);

  @override
  _CollectionLinkItemWidgetState createState() =>
      _CollectionLinkItemWidgetState();
}

class _CollectionLinkItemWidgetState extends State<CollectionLinkItemWidget> {
  final grayStyle = const TextStyle(fontSize: 14, color: Colors.grey);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          widget.onTap?.call(widget.itemData, false);
        },
        child: Container(
          color: Colors.white,
          width: double.infinity,
          child: Row(
            children: [
              const SizedBox(
                width: 20,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.itemData.name ?? "",
                    style: const TextStyle(fontSize: 16, color: Colors.black),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Text(
                    widget.itemData.link ?? "",
                    style: grayStyle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              )),
              const SizedBox(
                height: 8,
              ),
              InkWell(
                onTap: () {
                  widget.onTap?.call(widget.itemData, true);
                },
                child: NormalStyle.getLikeImage(true),
              ),
              const SizedBox(
                width: 20,
              ),
            ],
          ),
        ));
  }
}
