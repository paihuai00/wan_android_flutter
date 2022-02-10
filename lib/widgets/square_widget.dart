import 'package:flutter/material.dart';
import 'package:wan_android_flutter/models/nav_detail_model.dart';
import 'package:wan_android_flutter/models/system_detail_model.dart';
import 'package:wan_android_flutter/utils/color_utils.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/10 2:21 下午
/// @Description:

class SquareWidget extends StatefulWidget {
  //0:体系，1：导航
  int type = 0;
  SystemDetailItem? systemDetailItem;
  NaviDetailItem? naviDetailItem;
  SquareCallBack? callBack;

  SquareWidget(this.type,
      {Key? key, this.systemDetailItem, this.naviDetailItem, this.callBack})
      : super(key: key);

  @override
  _SquareWidgetState createState() => _SquareWidgetState();
}

class _SquareWidgetState extends State<SquareWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.only(left: 10, right: 10, bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTitle(),
          const SizedBox(
            height: 10,
          ),
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            children: _buildList(),
          ),
        ],
      ),
    );
  }

  _buildTitle() {
    String title = "";
    if (widget.type == 0) {
      title = widget.systemDetailItem!.name!;
    } else {
      title = widget.naviDetailItem!.name!;
    }

    return Text(
      title,
      style: const TextStyle(fontSize: 16, color: Colors.black),
    );
  }

  _buildList() {
    if (widget.type == 0) {
      List<Children> childList = widget.systemDetailItem!.children!;

      return childList
          .map(
            (children) => _getCommonWidget(children.name!, children: children),
          )
          .toList();
    } else {
      List<Articles> articleList = widget.naviDetailItem!.articles!;

      return articleList
          .map(
            (article) => _getCommonWidget(article.title!, article: article),
          )
          .toList();
    }
  }

  Widget _getCommonWidget(String title,
      {Articles? article, Children? children}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: const BoxDecoration(
        color: NormalColors.color_BDBDBD,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {
          _onItemClick(children, article);
        },
        child: Text(
          title,
          style: const TextStyle(fontSize: 12, color: Colors.white),
        ),
        borderRadius: const BorderRadius.all(Radius.circular(10)),
      ),
    );
  }

  ///回调
  _onItemClick(Children? children, Articles? articles) {
    widget.callBack?.call(children, articles);
  }
}

typedef SquareCallBack = Function(Children? children, Articles? articles);
