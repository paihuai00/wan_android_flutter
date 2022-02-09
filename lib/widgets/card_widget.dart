import 'package:flutter/material.dart';
import 'package:wan_android_flutter/models/project_detail_model.dart';
import 'package:wan_android_flutter/utils/image_utils.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/9 4:11 下午
/// @Description: 项目 card 封装

typedef CardViewWidgetCallBack = Function(ProjectDetailItem projectDetailItem);

class CardViewWidget extends StatefulWidget {
  ProjectDetailItem projectDetailItem;

  CardViewWidgetCallBack? callBack;

  CardViewWidget(this.projectDetailItem, {Key? key, this.callBack})
      : super(key: key);

  @override
  _CardViewWidgetState createState() => _CardViewWidgetState();
}

class _CardViewWidgetState extends State<CardViewWidget> {
  late ProjectDetailItem projectDetailItem = widget.projectDetailItem;

  String imageUrl = "";
  String title = "";
  String subTitle = "";
  String time = "";
  bool isLike = false;

  @override
  void initState() {
    super.initState();

    if (projectDetailItem.envelopePic != null) {
      imageUrl = projectDetailItem.envelopePic!;
    }
    if (projectDetailItem.title != null) {
      title = projectDetailItem.title!;
    }
    if (projectDetailItem.desc != null) {
      subTitle = projectDetailItem.desc!;
    }
    if (projectDetailItem.niceShareDate != null) {
      time = projectDetailItem.niceShareDate!;
    }
    if (projectDetailItem.collect != null) {
      isLike = projectDetailItem.collect!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callBack?.call(projectDetailItem);
      },
      child: Card(
        margin: _getNormalEdge(),
        child: Container(
          padding: _getNormalEdge(),
          child: Row(
            children: [
              XImage.load(imageUrl, height: 100, width: 100),
              const SizedBox(
                width: 10,
              ),
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: NormalStyle.getTitleTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    subTitle,
                    style: NormalStyle.getSubTitleTextStyle(),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Text(
                        time,
                        style: NormalStyle.getTimeTextStyle(),
                      ),
                      const Expanded(child: SizedBox()),
                      NormalStyle.getLikeImage(isLike)
                    ],
                  )
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }

  _getNormalEdge() {
    return const EdgeInsets.all(10);
  }
}
