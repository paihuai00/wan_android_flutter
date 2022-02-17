import 'package:flutter/material.dart';
import 'package:wan_android_flutter/models/nav_detail_model.dart';
import 'package:wan_android_flutter/models/system_detail_model.dart';
import 'package:wan_android_flutter/utils/normal_colors.dart';

/// @Author: cuishuxiang
/// @Date: 2022/2/10 2:21 下午
/// @Description: 导航

class SquareNavWidget extends StatefulWidget {
  NaviDetailItem? naviDetailItem;
  NavWidgetCallBack? callBack;

  SquareNavWidget({Key? key, this.naviDetailItem, this.callBack})
      : super(key: key);

  @override
  _SquareNavWidgetState createState() => _SquareNavWidgetState();
}

class _SquareNavWidgetState extends State<SquareNavWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      width: double.infinity,
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
    String title = widget.naviDetailItem!.name ?? "";

    return Text(
      title,
      style: const TextStyle(fontSize: 16, color: Colors.black),
    );
  }

  _buildList() {
    List<Articles> articleList = widget.naviDetailItem!.articles!;

    return articleList
        .map(
          (article) => _getCommonWidget(article.title!, article: article),
        )
        .toList();
  }

  Widget _getCommonWidget(String title,
      {Articles? article, Children? children}) {
    return Container(
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.only(left: 10, right: 10, top: 5, bottom: 5),
      decoration: const BoxDecoration(
        color: NormalColor.color_BDBDBD,
        borderRadius: BorderRadius.all(Radius.circular(10)),
      ),
      child: InkWell(
        onTap: () {
          _onItemClick(widget.naviDetailItem, article);
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
  _onItemClick(NaviDetailItem? naviDetailItem, Articles? articles) {
    widget.callBack?.call(naviDetailItem, articles);
  }
}

typedef NavWidgetCallBack = Function(
    NaviDetailItem? naviDetailItem, Articles? articles);
