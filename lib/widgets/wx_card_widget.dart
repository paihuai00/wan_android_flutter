import 'package:flutter/material.dart';
import 'package:wan_android_flutter/models/wx_detail_model.dart';
import 'package:wan_android_flutter/utils/normal_style_util.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/9 4:11 下午
/// @Description: wx card 封装

typedef WxCardViewWidgetCallBack = Function(WxDetailItem wxItem);

class WxCardViewWidget extends StatefulWidget {
  WxDetailItem wxDetailItem;

  WxCardViewWidgetCallBack? callBack;

  WxCardViewWidget(this.wxDetailItem, {Key? key, this.callBack})
      : super(key: key);

  @override
  _WxCardViewWidgetState createState() => _WxCardViewWidgetState();
}

class _WxCardViewWidgetState extends State<WxCardViewWidget> {
  late WxDetailItem wxDetailItem = widget.wxDetailItem;

  String author = "";
  String title = "";
  String subTitle = "";
  String time = "";
  bool isLike = false;

  @override
  void initState() {
    super.initState();

    if (wxDetailItem.author != null) {
      author = wxDetailItem.author!;
    }
    if (wxDetailItem.title != null) {
      title = wxDetailItem.title!;
    }
    if (wxDetailItem.desc != null) {
      subTitle = wxDetailItem.desc!;
    }
    if (wxDetailItem.niceShareDate != null) {
      time = wxDetailItem.niceShareDate!;
    }
    if (wxDetailItem.collect != null) {
      isLike = wxDetailItem.collect!;
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        widget.callBack?.call(wxDetailItem);
      },
      child: Card(
        margin: _getNormalEdge(),
        child: Container(
          padding: _getNormalEdge(),
          child: Row(
            children: [
              Expanded(
                  child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    author,
                    style: NormalStyle.getTimeTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    title,
                    style: NormalStyle.getTitleTextStyle(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(
                    height: subTitle.isEmpty ? 0 : 10,
                  ),
                  subTitle.isEmpty
                      ? const SizedBox()
                      : Text(
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
